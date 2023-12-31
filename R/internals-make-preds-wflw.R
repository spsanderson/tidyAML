#' Internals Safely Make Predictions on a Fitted Workflow from Model Spec tibble
#'
#' @family Internals
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Safely Make predictions on a fitted workflow from a model spec tibble.
#'
#' @details Create predictions on a fitted `parnsip` model from a `workflow` object.
#'
#' @param .model_tbl The model table that is generated from a function like
#' `fast_regression_parsnip_spec_tbl()`, must have a class of "tidyaml_mod_spec_tbl".
#' This is meant to be used after the function `internal_make_fitted_wflw()` has been
#' run and the tibble has been saved.
#' @param .splits_obj The splits object from the auto_ml function. It is internal
#' to the `auto_ml_` function.
#'
#' @examples
#' library(recipes, quietly = TRUE)
#'
#' mod_spec_tbl <- fast_regression_parsnip_spec_tbl(
#'   .parsnip_eng = c("lm","glm"),
#'   .parsnip_fns = "linear_reg"
#' )
#'
#' rec_obj <- recipe(mpg ~ ., data = mtcars)
#' splits_obj <- create_splits(mtcars, "initial_split")
#'
#' mod_tbl <- mod_spec_tbl |>
#'   mutate(wflw = full_internal_make_wflw(mod_spec_tbl, rec_obj))
#'
#' mod_fitted_tbl <- mod_tbl |>
#'   mutate(fitted_wflw = internal_make_fitted_wflw(mod_tbl, splits_obj))
#'
#' internal_make_wflw_predictions(mod_fitted_tbl, splits_obj)
#'
#' @return
#' A list object tibble of the outcome variable and it's values along with the
#' testing and training predictions in a single tibble.
#'
#' | .data_category | .data_type | .value |
#' |----------------|------------|--------|
#' | actual         | actual     | 21.0   |
#' | actual         | actual     | 21.0   |
#' | actual         | actual     | 22.8   |
#' | ...            | ...        | ...    |
#' | predicted      | training   | 21.0   |
#' | ...            | ...        | ...    |
#' | predicted      | training   | 21.0   |
#'
#' @name internal_make_wflw_predictions
NULL

#' @export
#' @rdname internal_make_wflw_predictions

# Safely make predictions on fitted workflow
internal_make_wflw_predictions <- function(.model_tbl, .splits_obj){

  # Tidyeval ----
  model_tbl <- .model_tbl
  splits_obj <- .splits_obj
  col_nms <- colnames(model_tbl)

  # Checks ----
  if (!inherits(model_tbl, "tidyaml_mod_spec_tbl")){
    rlang::abort(
      message = "'.model_tbl' must inherit a class of 'tidyaml_mod_spec_tbl",
      use_cli_format = TRUE
    )
  }

  if (!"fitted_wflw" %in% col_nms){
    rlang::abort(
      message = "Missing the column 'wflw'",
      use_cli_format = TRUE
    )
  }

  if (!".model_id" %in% col_nms){
    rlang::abort(
      message = "Missing the column '.model_id'",
      use_cli_format = TRUE
    )
  }

  # Manipulation
  # Make a group split object list
  model_factor_tbl <- model_tbl |>
    dplyr::mutate(.model_id = forcats::as_factor(.model_id))

  models_list <- model_factor_tbl |>
    dplyr::group_split(.model_id)

  # Make the predictions on the fitted workflow object using purrr imap
  wflw_preds_list <- models_list |>
    purrr::imap(
      .f = function(obj, id){

        # Pull the fitted workflow column and then pluck it
        fitted_wflw = obj |> dplyr::pull(7) |> purrr::pluck(1)

        # Get rec_obj
        # rec_obj <- workflows::extract_preprocessor(fitted_wflw)

        # Create a safe stats::predict
        safe_stats_predict <- purrr::safely(
          stats::predict,
          otherwise = NULL,
          quiet = TRUE
        )

        # Return the predictions
        ret <- safe_stats_predict(
          fitted_wflw,
          new_data = rsample::testing(splits_obj$splits)
        )

        if (!is.null(ret$error)) {
          message(stringr::str_glue("{ret$error}"))
          res <- NULL
          return(res)
        }

        # Get testing predictions
        test_res <- ret |> purrr::pluck("result")
        pred_col_nm <- names(test_res)
        test_res <- test_res |>
          dplyr::mutate(.data_type = "testing") |>
          dplyr::select(.data_type, !!pred_col_nm) |>
          purrr::set_names(c(".data_type", ".value"))

        # Get training predictions
        train_res <- fitted_wflw |>
          broom::augment(new_data = rsample::training(splits_obj$splits)) |>
          dplyr::mutate(.data_type = "training") |>
          dplyr::select(.data_type, !!pred_col_nm) |>
          purrr::set_names(c(".data_type", ".value"))

        # Get actual outcome values
        pred_y <- names(fitted_wflw[["pre"]][["mold"]][["outcomes"]])
        train_act <- rsample::training(splits_obj$splits)[,pred_y] |>
          dplyr::as_tibble() |>
          purrr::set_names(pred_y)
        test_act <- rsample::testing(splits_obj$splits)[,pred_y] |>
          dplyr::as_tibble() |>
          purrr::set_names(pred_y)
        actual_res <- rbind(train_act, test_act) |>
          dplyr::mutate(.data_type = "actual") |>
          purrr::set_names("value", ".data_type") |>
          dplyr::select(.data_type, value) |>
          purrr::set_names(c(".data_type", ".value"))

        res <- base::rbind(actual_res, train_res, test_res) |>
          dplyr::mutate(.data_category = ifelse(.data_type == "actual", "actual", "predicted")) |>
          dplyr::select(.data_category, .data_type, .value)

        return(res)
      }
    )

  return(wflw_preds_list)
}
