#' Extract Residuals from Fast Regression Models
#'
#' @family Extractor
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description This function extracts residuals from a fast regression model
#' table (`fast_regression()`).
#'
#' @details
#' The function checks if the input model specification table inherits the class
#' 'fst_reg_spec_tbl' and if it contains the column 'pred_wflw'. It then
#' manipulates the data, grouping it by model, and extracts residuals for each model.
#' The result is a list of data frames, each containing residuals, actual values,
#' and predicted values for a specific model.
#'
#' @param .model_tbl A fast regression model specification table (`fst_reg_spec_tbl`).
#' @param .pivot_long A logical value indicating if the output should be pivoted.
#' The default is `FALSE`.
#'
#' @examples
#' library(recipes, quietly = TRUE)
#'
#' rec_obj <- recipe(mpg ~ ., data = mtcars)
#'
#' fr_tbl <- fast_regression(mtcars, rec_obj, .parsnip_eng = c("lm","glm"),
#' .parsnip_fns = "linear_reg")
#'
#' extract_regression_residuals(fr_tbl)
#' extract_regression_residuals(fr_tbl, .pivot_long = TRUE)
#'
#' @return
#' The function returns a list of data frames, each containing residuals,
#' actual values, and predicted values for a specific model.
#'
#' @name extract_regression_residuals
NULL

#' @export
#' @rdname extract_regression_residuals

extract_regression_residuals <- function(.model_tbl, .pivot_long = FALSE) {

  # Checks
  if (!inherits(.model_tbl, "fst_reg_spec_tbl")) {
    rlang::abort(
      message = "Input must be from fast regression.",
      use_last = TRUE
    )
  }

  if (!"pred_wflw" %in% names(.model_tbl)) {
    rlang::abort(
      message = "Input must be from fast regression.",
      use_last = TRUE
    )
  }

  # Manipulation
  model_factor_tbl <- .model_tbl |>
    dplyr::mutate(.model_id = forcats::as_factor(.model_id))

  models_list <- model_factor_tbl |>
    dplyr::group_split(.model_id)

  # Extract residuals
  residuals_list <- models_list |>
    purrr::imap(.f = function(obj, id){

      # Get model type
      pe <- obj |> dplyr::pull(.parsnip_engine) |> purrr::pluck(1)
      pf <- obj |> dplyr::pull(.parsnip_fns) |> purrr::pluck(1)
      pfe <- paste0(pe, " - ", pf)

      # Extract actual and predicted values
      ap_tbl <- obj |>
        dplyr::pull(pred_wflw) |>
        purrr::pluck(1) |>
        dplyr::select(-.data_type) |>
        tidyr::pivot_wider(
          names_from = .data_category,
          values_from = .value,
          values_fn = list) |>
        tidyr::unnest(cols = dplyr::everything()) |>
        dplyr::mutate(
          .resid = actual - predicted,
          .model_type = pfe
        ) |>
        dplyr::select(.model_type, actual, predicted, .resid) |>
        purrr::set_names(c(".model_type", ".actual", ".predicted", ".resid"))

      if (.pivot_long) {
        ap_tbl <- ap_tbl |>
          tidyr::pivot_longer(
            cols = -.model_type
          )
      }

      return(ap_tbl)
    })

  return(residuals_list)

}
