#' Audit Engine Selection Across Datasets
#'
#' @param .datasets_list A named list of at least two regression data frames.
#' @param .outcome_var The numeric outcome column name shared by all datasets.
#' @param .parsnip_eng,.parsnip_fns Engine and model filters for fast regression.
#' @param .split_args Arguments passed to each dataset's initial split.
#'
#' @return A tibble with one row per held-out dataset, the selected model,
#'   selection RMSE, held-out RMSE, and their difference. The
#'   `dataset_scores` attribute contains individual model scores.
#' @details Within each dataset, all models share the same test split. Selection
#'   uses mean test RMSE over the other datasets and requires complete scores on
#'   those datasets. Ties break by model identifier. A missing held-out score or
#'   the absence of an eligible model produces missing values for that fold.
#'   RMSE comparisons across datasets assume comparable outcome units and scales.
#' @export
lodo_engine_audit <- function(.datasets_list, .outcome_var,
                              .parsnip_eng = c("glm", "glmnet", "ranger"),
                              .parsnip_fns = "all", .split_args = NULL) {
  datasets <- names(.datasets_list)
  if (!is.list(.datasets_list) || is.data.frame(.datasets_list) ||
      length(.datasets_list) < 2L || is.null(datasets) ||
      anyNA(datasets) || any(!nzchar(datasets)) || anyDuplicated(datasets)) {
    rlang::abort("'.datasets_list' must name at least two datasets uniquely.")
  }
  for (data in .datasets_list) check_regression_outcome(data, .outcome_var)
  scores <- purrr::imap_dfr(.datasets_list, function(data, dataset) {
    rec <- recipes::recipe(regression_formula(.outcome_var), data = data)
    fits <- fast_regression(data, rec, .parsnip_fns, .parsnip_eng,
                            .split_args = .split_args, .drop_na = FALSE)
    losses <- vapply(fits$pred_wflw, function(pred) {
      pair <- validation_prediction_pair(pred)
      validation_rmse(pair$truth, pair$estimate)
    }, numeric(1))
    model <- paste(fits$.parsnip_engine, fits$.parsnip_fns, sep = " - ")
    dplyr::tibble(dataset = rep(dataset, length(losses)), model = model, loss = losses)
  })

  audit <- purrr::map_dfr(datasets, function(held_out) {
    selection <- scores |>
      dplyr::filter(.data$dataset != held_out, is.finite(.data$loss)) |>
      dplyr::group_by(.data$model) |>
      dplyr::summarise(selection_loss = mean(.data$loss),
                       n = dplyr::n_distinct(.data$dataset), .groups = "drop") |>
      dplyr::filter(.data$n == length(datasets) - 1L) |>
      dplyr::arrange(.data$selection_loss, .data$model)
    model <- selection$model[1L]
    selection_loss <- selection$selection_loss[1L]
    held_out_loss <- scores$loss[which(scores$dataset == held_out & scores$model == model)][1L]
    dplyr::tibble(
      held_out_dataset = held_out, selected_model = model,
      selection_loss = selection_loss, held_out_loss = held_out_loss,
      generalization_gap = held_out_loss - selection_loss
    )
  })
  attr(audit, "dataset_scores") <- scores
  audit
}

