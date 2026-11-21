#' Make a LightTAR-Style Regression Recipe
#'
#' @param .data A data frame with a numeric outcome and numeric embeddings.
#' @param .outcome_var The outcome column name.
#' @param .emb_cols Character vector of embedding column names.
#' @param .u_pca Number of PCA components to request.
#' @param .s_pls Number of PLS components to request. Use zero for PCA only.
#'
#' @return An untrained recipe. Other predictors pass through unchanged.
#' @details Standardized embeddings feed both projections. PLS retains the
#'   embeddings for the PCA step, which replaces them with PCA components.
#'   The PLS step penalizes high-variance directions with strength 60/n, 
#'   where n is the number of rows used to train the recipe.
#' @export
make_lighttar_recipe <- function(.data, .outcome_var, .emb_cols,
                                 .u_pca = 30L, .s_pls = 5L) {
  check_regression_outcome(.data, .outcome_var)
  check_positive_integer(.u_pca, ".u_pca")
  check_positive_integer(.s_pls, ".s_pls", minimum = 0L)
  if (!is.character(.emb_cols) || !length(.emb_cols) || anyDuplicated(.emb_cols) ||
      !all(.emb_cols %in% setdiff(names(.data), .outcome_var)) ||
      !all(vapply(.data[, .emb_cols, drop = FALSE], is.numeric, logical(1)))) {
    rlang::abort("'.emb_cols' must contain distinct numeric predictor names.")
  }

  rec <- recipes::recipe(regression_formula(.outcome_var), data = .data)
  rec <- recipes::step_normalize(rec, dplyr::all_of(.emb_cols))
  if (.s_pls > 0L) {
    rec <- step_lighttar_pls(rec, .emb_cols, .outcome_var, .s_pls)
  }
  recipes::step_pca(rec, dplyr::all_of(.emb_cols),
                    num_comp = min(.u_pca, length(.emb_cols)), prefix = "pca_")
}

#' Gate PCA and PLS Preprocessing Before Fast Regression
#'
#' @inheritParams make_lighttar_recipe
#' @param .gate_eng Engine used to compare the recipes.
#' @param .gate_fns Optional parsnip model function for the gate engine. Required
#'   when the engine has multiple regression specifications.
#' @param .v Number of inner cross-validation folds.
#' @param .parsnip_eng,.parsnip_fns Engine and model filters for the final run.
#' @param .split_args Arguments passed to the outer initial split.
#'
#' @return A `fast_regression()` model table with a `lighttar_gate` attribute.
#'   The attribute contains the selected recipe name, paired fold RMSEs and
#'   any fold errors.
#' @details The gate compares mean inner-fold RMSE. Ties and failed PLS fits
#'   select PCA. PCA must score successfully on every inner fold. Final testing
#'   uses the outer assessment rows, which are held back from the recipe choice.
#' @export
gated_fast_regression <- function(.data, .outcome_var, .emb_cols,
                                  .gate_eng = "xgboost", .u_pca = 30L,
                                  .s_pls = 5L, .v = 5L, .parsnip_eng = "all",
                                  .parsnip_fns = "all", .gate_fns = "all",
                                  .split_args = NULL) {
  check_positive_integer(.v, ".v", minimum = 2L)
  check_positive_integer(.s_pls, ".s_pls")
  .data <- dplyr::as_tibble(.data)
  outer <- create_splits(.data, .split_args = .split_args)
  training <- rsample::training(outer$splits)
  if (.v > nrow(training)) rlang::abort("'.v' exceeds the outer training row count.")
  pca <- make_lighttar_recipe(training, .outcome_var, .emb_cols, .u_pca, 0L)
  tar <- make_lighttar_recipe(training, .outcome_var, .emb_cols, .u_pca, .s_pls)
  spec <- fast_regression_parsnip_spec_tbl(.gate_fns, .gate_eng)
  if (nrow(spec) != 1L) {
    rlang::abort("Select exactly one gate model with '.gate_eng' and '.gate_fns'.")
  }
  folds <- rsample::vfold_cv(training, v = .v)
  score_recipe <- function(rec, label) {
    workflow <- full_internal_make_wflw(spec, rec)[[1L]]
    scores <- lapply(folds$splits, function(split) {
      tryCatch({
        fit <- parsnip::fit(workflow, data = rsample::analysis(split))
        held <- rsample::assessment(split)
        estimate <- stats::predict(fit, new_data = held)$.pred
        rmse <- validation_rmse(held[[.outcome_var]], estimate)
        if (!is.finite(rmse)) rlang::abort("Non-finite validation RMSE.")
        list(rmse = rmse, error = NA_character_)
      }, error = function(e) list(rmse = NA_real_, error = conditionMessage(e)))
    })
    dplyr::tibble(
      fold = folds$id, recipe = label,
      rmse = vapply(scores, function(x) x$rmse, numeric(1)),
      error = vapply(scores, function(x) x$error, character(1))
    )
  }
  pca_scores <- score_recipe(pca, "pca")
  if (anyNA(pca_scores$rmse)) {
    rlang::abort(paste("The PCA gate model failed:", pca_scores$error[which(is.na(pca_scores$rmse))[1L]]))
  }
  tar_scores <- score_recipe(tar, "pca_pls")
  use_tar <- !anyNA(tar_scores$rmse) && mean(tar_scores$rmse) < mean(pca_scores$rmse)
  result <- fit_fast_regression(
    if (use_tar) tar else pca, .parsnip_fns, .parsnip_eng,
    outer, .split_args, .drop_na = TRUE
  )
  attr(result, "lighttar_gate") <- list(
    selected_recipe = if (use_tar) "pca_pls" else "pca",
    metrics = dplyr::bind_rows(pca_scores, tar_scores)
  )
  result
}

check_regression_outcome <- function(data, outcome) {
  if (!is.data.frame(data) || !is.character(outcome) || length(outcome) != 1L ||
      !(outcome %in% names(data)) || !is.numeric(data[[outcome]])) {
    rlang::abort("Supply a data frame and a numeric outcome column name.")
  }
}

regression_formula <- function(outcome) {
  stats::as.formula(call("~", as.name(outcome), quote(.)), env = parent.frame())
}

