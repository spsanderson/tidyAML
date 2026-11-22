#' Select a LightTAR recipe before running fast regression
#'
#' Compare PCA-only and PCA-plus-PLS preprocessing with a single regression
#' model on shared inner cross-validation folds. Choose LightTAR only when it
#' improves mean fold RMSE. Fit the final model grid to the whole outer training
#' split and use its untouched testing split for prediction.
#'
#' @inheritParams make_lighttar_recipe
#' @inheritParams fast_regression
#' @param .gate_eng One `parsnip` engine for the inner comparison. The default
#'   `"xgboost"` requires the `xgboost` package; `"lm"` is a lightweight option.
#' @param .gate_fn Optional `parsnip` model name for the gate, required if
#'   `.gate_eng` matches more than one regression specification.
#' @param .v Number of inner cross-validation folds (at least two).
#' @param .split_args Optional arguments for [rsample::initial_split()], the
#'   outer split. The outer split must leave enough rows for `.v` folds.
#' @param .seed Optional integer seed for splitting and fitting. A supplied
#'   seed leaves the caller's R RNG state unchanged.
#'
#' @details The outcome must be numeric and finite. Ties (including numerical
#' differences close to zero) favor PCA. If any LightTAR fold fails, a warning
#' is issued and PCA is used. If PCA cannot be scored on every fold, the
#' function stops instead of making an unverified choice. The final grid uses
#' the model filters from [fast_regression()]; if no fit produces predictions,
#' the function stops.
#' @return A [fast_regression()] model table (`fst_reg_tbl`) with an attribute
#'   `.lighttar_selected` (`"pca"` or `"lighttar"`) and `.lighttar_gate`, a
#'   tibble with `fold`, `recipe`, and `rmse` columns (failed folds have `NA`).
#' @seealso [make_lighttar_recipe()]
#' @examples
#' models <- gated_fast_regression(
#'   mtcars, "mpg", c("disp", "hp", "wt"),
#'   .gate_eng = "lm",
#'   .u_pca = 1, .s_pls = 1, .parsnip_eng = "lm", .seed = 280L
#' )
#' attr(models, ".lighttar_gate")
#' @export
gated_fast_regression <- function(.data, .outcome_var, .emb_cols, .gate_eng = "xgboost",
                                  .u_pca = 30L, .s_pls = 5L, .m = 60, .v = 5L,
                                  .parsnip_fns = "all", .parsnip_eng = "all",
                                  .gate_fn = NULL, .split_args = NULL, .seed = NULL) {
  outcome <- check_audit_outcome(.data, .outcome_var, regression = TRUE)
  if (any(!is.finite(outcome))) {
    rlang::abort("The outcome must contain only finite values.")
  }
  check_audit_number(.v, ".v", min = 2, integer = TRUE)
  if (!unique_audit_names(.gate_eng) || length(.gate_eng) != 1L || .gate_eng == "all") {
    rlang::abort("`.gate_eng` must name one regression engine.")
  }
  if (.gate_eng == "xgboost" && !requireNamespace("xgboost", quietly = TRUE)) {
    rlang::abort(c(
      "The `xgboost` gate engine requires the xgboost package.",
      i = "Install it with `install.packages('xgboost')` or set `.gate_eng = 'lm'`."
    ))
  }
  if (!is.null(.gate_fn) && (!unique_audit_names(.gate_fn) || length(.gate_fn) != 1L)) {
    rlang::abort("`.gate_fn` must name one regression model function.")
  }
  gate_spec <- fast_regression_parsnip_spec_tbl(
    .parsnip_fns = if (is.null(.gate_fn)) "all" else .gate_fn,
    .parsnip_eng = .gate_eng
  )
  if (nrow(gate_spec) != 1L) {
    rlang::abort("The gate needs a single model specification; set `.gate_eng` and `.gate_fn`.")
  }

  with_audit_seed(.seed, {
    outer <- create_splits(dplyr::as_tibble(.data), "initial_split", .split_args)
    train <- rsample::analysis(outer$splits)
    if (nrow(train) < .v || nrow(train) - ceiling(nrow(train) / .v) < 2L ||
      nrow(rsample::assessment(outer$splits)) == 0L) {
      rlang::abort("The outer split is too small for the requested inner folds and testing rows.")
    }
    inner <- rsample::vfold_cv(train, v = .v)
    recs <- list(
      pca = make_lighttar_recipe(train, .outcome_var, .emb_cols, .u_pca, 0L, .m),
      lighttar = make_lighttar_recipe(train, .outcome_var, .emb_cols, .u_pca, .s_pls, .m)
    )
    scores <- purrr::imap(recs, function(rec, arm) {
      workflow <- full_internal_make_wflw(gate_spec, rec)[[1L]]
      score_gate_folds(workflow, inner, .outcome_var, arm)
    })
    losses <- purrr::map_dbl(scores, ~ mean(.x$rmse))
    # Do not let floating-point noise prefer the more complex recipe.
    tie_tol <- sqrt(.Machine$double.eps) * max(1, abs(losses[["pca"]]))
    chosen <- if (is.finite(losses[["lighttar"]]) &&
      losses[["lighttar"]] < losses[["pca"]] - tie_tol) {
      "lighttar"
    } else {
      "pca"
    }
    result <- fast_regression_from_split(
      recs[[chosen]], .parsnip_fns, .parsnip_eng, outer, .split_args,
      .drop_na = TRUE
    )
    if (nrow(result) == 0L) {
      rlang::abort(c(
        "No final regression model could be fitted and scored.",
        i = "Check the model filters and data."
      ))
    }
    attr(result, ".lighttar_selected") <- chosen
    attr(result, ".lighttar_gate") <- dplyr::bind_rows(scores)
    result
  })
}

score_gate_folds <- function(workflow, inner, outcome, arm) {
  score <- purrr::safely(regression_split_rmse)
  runs <- purrr::map(inner$splits, ~ score(workflow, .x, outcome))
  failed <- which(purrr::map_lgl(runs, ~ !is.null(.x$error)))
  if (length(failed) > 0L) {
    first <- failed[[1L]]
    msg <- paste0("The ", arm, " gate could not score ", inner$id[first], ".")
    parent <- runs[[first]]$error
    if (arm == "pca") {
      rlang::abort(msg, parent = parent)
    }
    rlang::warn(paste(msg, "Using PCA instead."), parent = parent)
  }
  dplyr::tibble(
    fold = inner$id, recipe = arm,
    rmse = purrr::map_dbl(runs, ~ if (is.null(.x$result)) NA_real_ else .x$result)
  )
}

# Fit preprocessing and the model strictly on the analysis rows.
regression_split_rmse <- function(workflow, split, outcome) {
  fit <- parsnip::fit(workflow, data = rsample::analysis(split))
  assessment <- rsample::assessment(split)
  predicted <- stats::predict(fit, new_data = assessment)$.pred
  truth <- assessment[[outcome]]
  if (!is.numeric(predicted) || length(predicted) != length(truth) ||
    length(truth) == 0L || any(!is.finite(predicted) | !is.finite(truth))) {
    rlang::abort("Expected one finite prediction for every assessment outcome.")
  }
  loss <- yardstick::rmse_vec(truth, predicted, na_rm = FALSE)
  if (!is.finite(loss)) {
    rlang::abort("Assessment RMSE was not finite.")
  }
  loss
}
