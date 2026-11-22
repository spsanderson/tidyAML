#' Check classification validation rank stability
#'
#' Score fitted binary classifiers on their shared testing split, then measure
#' how well their score rankings survive a paired bootstrap. Each draw samples
#' testing rows with replacement within outcome classes and uses those same
#' rows for all models. Models are not refitted.
#'
#' @param .model_tbl A fitted table from [fast_classification()]. Use models
#'   fitted and evaluated on the same split. Unfitted entries are ignored.
#' @param .metric_fn A binary probability metric with the interface of
#'   [yardstick::roc_auc()], returning one numeric `.estimate`.
#' @param .n_boot A positive integer giving the number of bootstrap draws.
#' @param .event_level `"first"` or `"second"`: the outcome factor level whose
#'   predicted probability is supplied to `.metric_fn`.
#' @param .seed Optional integer seed. A supplied seed leaves the caller's RNG
#'   state unchanged.
#'
#' @return A numeric scalar: the mean Spearman correlation of the full testing
#'   scores with the bootstrap scores. Undefined draws are omitted. Returns
#'   `NA_real_` when stability cannot be estimated, including when there are
#'   fewer than two fitted models, either class is absent, or all full-sample
#'   scores are tied. A non-finite full-sample metric or invalid testing
#'   probabilities also make the result unavailable.
#' @seealso [vgc_gate()]
#' @examples
#' data <- transform(mtcars, am = factor(am))
#' rec <- recipes::recipe(am ~ mpg + hp, data = data)
#' models <- withr::with_seed(1L, fast_classification(data, rec, .parsnip_eng = c("lm","glm")))
#' check_validation_stability(models) # One model cannot establish a ranking.
#' @export
check_validation_stability <- function(.model_tbl, .metric_fn = yardstick::roc_auc,
                                       .n_boot = 25L, .event_level = "first",
                                       .seed = NULL) {
  if (!inherits(.model_tbl, "fst_class_tbl") || !"fitted_wflw" %in% names(.model_tbl)) {
    rlang::abort("`.model_tbl` must be from `fast_classification()`.")
  }
  if (!is.function(.metric_fn)) {
    rlang::abort("`.metric_fn` must be a binary probability metric function.")
  }
  check_audit_number(.n_boot, ".n_boot", min = 1, integer = TRUE)
  if (!is.null(.seed)) {
    check_audit_number(.seed, ".seed", integer = TRUE)
  }
  .event_level <- rlang::arg_match(.event_level, c("first", "second"))

  fits <- purrr::keep(.model_tbl$fitted_wflw, ~ inherits(.x, "workflow"))
  if (length(fits) < 2L) {
    return(NA_real_)
  }
  validation <- attr(.model_tbl, ".validation_data", exact = TRUE)
  if (is.null(validation)) {
    rlang::abort("No testing data were saved. Refit `.model_tbl` with `fast_classification()`.")
  }
  outcomes <- purrr::map(fits, ~ workflows::extract_mold(.x)$outcomes)
  outcome <- names(outcomes[[1L]])
  outcome_levels <- levels(outcomes[[1L]][[1L]])
  if (length(outcome) != 1L || length(outcome_levels) != 2L ||
    !all(purrr::map_lgl(outcomes, ~ identical(names(.x), outcome) &&
      identical(levels(.x[[1L]]), outcome_levels)))) {
    rlang::abort("All models must have the same binary factor outcome and level order.")
  }
  truth <- factor(validation[[outcome]], levels = outcome_levels)
  strata <- split(seq_along(truth), truth)
  if (anyNA(truth) || any(lengths(strata) == 0L)) {
    return(NA_real_)
  }
  event <- outcome_levels[match(.event_level, c("first", "second"))]
  probabilities <- purrr::map(fits, function(fit) {
    stats::predict(fit, new_data = validation, type = "prob")[[paste0(".pred_", event)]]
  })
  valid <- purrr::map_lgl(probabilities, ~ length(.x) == length(truth) &&
    all(is.finite(.x) & .x >= 0 & .x <= 1))
  if (!all(valid)) {
    return(NA_real_)
  }

  scores <- function(rows) {
    purrr::map_dbl(probabilities, function(prob) {
      result <- .metric_fn(
        dplyr::tibble(truth = truth[rows], prob = prob[rows]),
        truth = truth, prob, event_level = .event_level
      )
      value <- result$.estimate
      if (!is.numeric(value) || length(value) != 1L) {
        rlang::abort("`.metric_fn` must return one numeric `.estimate`.")
      }
      value
    })
  }
  observed <- scores(seq_along(truth))
  if (any(!is.finite(observed)) || length(unique(observed)) < 2L) {
    return(NA_real_)
  }
  bootstrap <- function() {
    purrr::map_dbl(seq_len(.n_boot), function(i) {
      rows <- unlist(lapply(strata, function(x) x[sample.int(length(x), replace = TRUE)]),
        use.names = FALSE
      )
      resampled <- scores(rows)
      if (any(!is.finite(resampled)) || length(unique(resampled)) < 2L) {
        return(NA_real_)
      }
      stats::cor(observed, resampled, method = "spearman")
    })
  }
  correlations <- if (is.null(.seed)) bootstrap() else withr::with_seed(.seed, bootstrap())
  if (all(is.na(correlations))) NA_real_ else mean(correlations, na.rm = TRUE)
}
