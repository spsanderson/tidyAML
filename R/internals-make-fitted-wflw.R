#' Internals Safely Make a Fitted Workflow from Model Spec tibble
#'
#' @family Internals
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Safely Make a fitted workflow from a model spec tibble.
#'
#' @details Create a fitted `parnsip` model from a `workflow` object.
#'
#' @param .model_tbl The model table that is generated from a function like
#' `fast_regression_parsnip_spec_tbl()`, must have a class of "tidyaml_mod_spec_tbl".
#' This is meant to be used after the function `internal_make_wflw()` has been
#' run and the tibble has been saved.
#' @param .splits_obj The splits object from the auto_ml function. It is internal
#' to the `auto_ml_` function.
#'
#' @examples
#' library(recipes, quietly = TRUE)
#' library(dplyr, quietly = TRUE)
#'
#' mod_spec_tbl <- fast_regression_parsnip_spec_tbl(
#'   .parsnip_eng = c("lm","glm","gee"),
#'   .parsnip_fns = "linear_reg"
#' )
#'
#' rec_obj <- recipe(mpg ~ ., data = mtcars)
#' splits_obj <- create_splits(mtcars, "initial_split")
#'
#' mod_tbl <- mod_spec_tbl %>%
#'   mutate(wflw = internal_make_wflw(mod_spec_tbl, rec_obj))
#'
#' internal_make_fitted_wflw(mod_tbl, splits_obj)
#'
#' @return
#' A list object of workflows.
#'
#' @name internal_make_fitted_wflw
NULL

#' @export
#' @rdname internal_make_fitted_wflw

# Safely make fitted workflow
internal_make_fitted_wflw <- function(.model_tbl, .splits_obj){

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

  if (!"wflw" %in% col_nms){
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
  models_list <- model_tbl %>%
    dplyr::group_split(.model_id)

  # Make the fitted workflow object using purrr imap
  fitted_wflw_list <- models_list %>%
    purrr::imap(
      .f = function(obj, id){

        # Pull the workflow column and then pluck it
        wflw <- obj %>% dplyr::pull(6) %>% purrr::pluck(1)

        # Create a safe parsnip::fit function
        safe_parsnip_fit <- purrr::safely(
          parsnip::fit,
          otherwise = NULL,
          quiet = TRUE
        )

        # Return the fitted workflow
        ret <- safe_parsnip_fit(
          wflw, data = rsample::training(splits_obj$splits)
        )

        res <- ret %>% purrr::pluck("result")

        if (!is.null(ret$error)) message(stringr::str_glue("{ret$error}"))

        return(res)
      }
    )

  return(fitted_wflw_list)

}
