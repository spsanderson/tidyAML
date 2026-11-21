#' Check Validation Rank Stability
#'
#' @param .model_tbl A fitted tidyAML model table with saved predictions.
#' @param .metric_fn A yardstick vector metric or a function accepting truth and
#'   predictions and returning one number. Defaults to RMSE for numeric
#'   outcomes and accuracy for class labels.
#' @param .n_boot Number of paired bootstrap draws.
#' @param .validation_data Optional shared validation data with the outcome.
#'   When supplied, predictions are computed from the fitted workflows.
#' @param .outcome_var Outcome column name when supplying validation data.
#' @param .prediction_type Prediction type. Use `"prob"` with a probability metric.
#' @param .event_level Event level for binary probability predictions.
#'
#' @return Mean Spearman rank correlation for usable draws. Returns `NA_real_`
#'   when ranking is undefined, or 1 for a single model with a valid score.
#' @details The same validation rows are sampled for every model. Rows with
#'   missing truths or predictions are removed jointly before scoring. Draws
#'   with invalid metrics or entirely tied ranks are skipped. For binary ROC AUC,
#'   use `yardstick::roc_auc_vec` and supply independent validation data because
#'   the standard classification result stores labels. Set the metric's event
#'   level to match the event level used for predictions.
#' @export
check_validation_stability <- function(.model_tbl, .metric_fn = NULL,
                                       .n_boot = 25L, .validation_data = NULL,
                                       .outcome_var = NULL, .prediction_type = NULL,
                                       .event_level = c("first", "second")) {
  check_positive_integer(.n_boot, ".n_boot")
  .event_level <- match.arg(.event_level)
  if (!inherits(.model_tbl, "tidyaml_mod_spec_tbl") ||
      !("pred_wflw" %in% names(.model_tbl))) {
    rlang::abort("Supply a fitted tidyAML model table with saved predictions.")
  }
  if (nrow(.model_tbl) == 0L) return(NA_real_)

  if (is.null(.validation_data)) {
    if (identical(.prediction_type, "prob")) {
      rlang::abort("Probability metrics require '.validation_data'.")
    }
    pairs <- lapply(.model_tbl$pred_wflw, validation_prediction_pair)
    if (any(vapply(pairs, is.null, logical(1)))) return(NA_real_)
    truth <- pairs[[1L]]$truth
    if (!all(vapply(pairs, function(pair) identical(pair$truth, truth), logical(1)))) {
      rlang::abort("All models must use the same validation rows in the same order.")
    }
    predictions <- lapply(pairs, function(pair) pair$estimate)
  } else {
    if (!is.character(.outcome_var) || length(.outcome_var) != 1L ||
        !(.outcome_var %in% names(.validation_data))) {
      rlang::abort("Supply the outcome column name in '.outcome_var'.")
    }
    truth <- .validation_data[[.outcome_var]]
    if (is.null(.prediction_type)) {
      .prediction_type <- if (is.numeric(truth)) "numeric" else "class"
    }
    .prediction_type <- match.arg(.prediction_type, c("numeric", "class", "prob"))
    if (.prediction_type == "prob" &&
        (!is.factor(truth) || nlevels(truth) != 2L || !is.function(.metric_fn))) {
      rlang::abort("Probability scoring requires a binary factor outcome and a vector metric.")
    }
    if (!("fitted_wflw" %in% names(.model_tbl)) ||
        any(vapply(.model_tbl$fitted_wflw, is.null, logical(1)))) return(NA_real_)
    predictions <- lapply(.model_tbl$fitted_wflw, function(fit) {
      pred <- stats::predict(fit, new_data = .validation_data, type = .prediction_type)
      if (.prediction_type == "prob") {
        event <- levels(truth)[match(.event_level, c("first", "second"))]
        return(pred[[paste0(".pred_", event)]])
      }
      pred[[1L]]
    })
  }

  if (is.null(.metric_fn)) {
    .metric_fn <- if (is.numeric(truth)) validation_rmse else function(truth, estimate) {
      mean(as.character(truth) == as.character(estimate))
    }
  }
  if (!is.function(.metric_fn)) rlang::abort("'.metric_fn' must be a function.")
  if (any(lengths(predictions) != length(truth))) {
    rlang::abort("Each model must have one prediction per validation row.")
  }
  rows <- which(stats::complete.cases(truth, do.call(cbind, predictions)))
  if (!length(rows)) return(NA_real_)
  score <- function(ids) {
    if (identical(.prediction_type, "prob") && length(unique(truth[ids])) < 2L) {
      return(rep(NA_real_, length(predictions)))
    }
    vapply(predictions, function(estimate) {
      value <- .metric_fn(truth[ids], estimate[ids])
      if (!is.numeric(value) || length(value) != 1L) {
        rlang::abort("'.metric_fn' must return one numeric score.")
      }
      value
    }, numeric(1))
  }
  baseline <- score(rows)
  if (!all(is.finite(baseline))) return(NA_real_)
  if (length(baseline) == 1L) return(1)
  if (length(unique(baseline)) == 1L) return(NA_real_)

  # Draw offsets so that a single surviving row is sampled correctly.
  correlations <- replicate(.n_boot, {
    boot <- score(rows[sample.int(length(rows), replace = TRUE)])
    if (!all(is.finite(boot)) || length(unique(boot)) == 1L) {
      NA_real_
    } else {
      stats::cor(baseline, boot, method = "spearman")
    }
  })
  if (all(is.na(correlations))) return(NA_real_)
  mean(correlations, na.rm = TRUE)
}

#' Gate a Candidate by Validation Stability
#'
#' @param .incumbent_score,.candidate_score Numeric validation scores.
#' @param .rho_hat Validation rank stability from -1 to 1.
#' @param .tau_min,.tau_max Nonnegative tolerance bounds in score units.
#' @param .min_rho Minimum rank stability from 0 to 1.
#' @param .direction Whether to maximize a score or minimize a loss.
#'
#' @return A logical value. Missing or non-finite evidence returns `FALSE`.
#' @export
vgc_gate <- function(.incumbent_score, .candidate_score, .rho_hat,
                     .tau_min = 0.002, .tau_max = 0.02, .min_rho = 0.6,
                     .direction = c("maximize", "minimize")) {
  .direction <- match.arg(.direction)
  numeric_scalar <- function(x) is.numeric(x) && length(x) == 1L
  if (!all(vapply(list(.incumbent_score, .candidate_score, .rho_hat,
                       .tau_min, .tau_max, .min_rho), numeric_scalar, logical(1)))) {
    rlang::abort("Scores, stability, and tolerances must be numeric scalars.")
  }
  if (!all(is.finite(c(.tau_min, .tau_max, .min_rho))) ||
      .tau_min < 0 || .tau_max < .tau_min || .min_rho < 0 || .min_rho > 1) {
    rlang::abort("Require 0 <= tau_min <= tau_max and 0 <= min_rho <= 1.")
  }
  if (!all(is.finite(c(.incumbent_score, .candidate_score, .rho_hat)))) return(FALSE)
  if (abs(.rho_hat) > 1) rlang::abort("'.rho_hat' must be between -1 and 1.")
  if (.rho_hat < .min_rho) return(FALSE)
  tolerance <- .tau_min + (1 - .rho_hat) * (.tau_max - .tau_min)
  loss <- .incumbent_score - .candidate_score
  if (.direction == "minimize") loss <- -loss
  loss <= tolerance
}

check_positive_integer <- function(value, name, minimum = 1L) {
  if (!is.numeric(value) || length(value) != 1L || !is.finite(value) ||
      value < minimum || value > .Machine$integer.max || value != floor(value)) {
    rlang::abort(paste0("'", name, "' must be a whole number >= ", minimum, "."))
  }
}

validation_prediction_pair <- function(pred) {
  if (is.null(pred)) return(NULL)
  type <- pred$.data_type
  actual <- pred$.value[type == "actual"]
  train_n <- sum(type == "training")
  test <- pred$.value[type == "testing"]
  if (!length(test) || train_n + length(test) != length(actual)) return(NULL)
  list(truth = actual[train_n + seq_along(test)], estimate = test)
}

validation_rmse <- function(truth, estimate) {
  if (!length(truth) || length(truth) != length(estimate) ||
      !all(is.finite(truth)) || !all(is.finite(estimate))) return(NA_real_)
  sqrt(mean((truth - estimate)^2))
}

