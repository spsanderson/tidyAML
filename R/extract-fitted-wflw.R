#' Extract A Model Fitted Workflow
#'
#' @family Extractor
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Extract a model fitted workflow from a tidyAML model tibble.
#'
#' @details This function allows you to get a model fitted workflow or more from
#' a tibble with a class of "tidyaml_mod_spec_tbl". It allows you to select the
#' model by the `.model_id` column. You can call the model id's by an integer
#' or a sequence of integers.
#'
#' @param .data The model table that must have the class `tidyaml_mod_spec_tbl`.
#' @param .model_id The model number that you want to select, Must be an integer
#' or sequence of integers, ie. `1` or `c(1,3,5)` or `1:2`
#'
#' @examples
#' library(recipes)
#'
#' rec_obj <- recipe(mpg ~ ., data = mtcars)
#' frt_tbl <- fast_regression(mtcars, rec_obj, .parsnip_eng = c("lm","glm"),
#'                                            .parsnip_fns = "linear_reg")
#'
#' extract_wflw_fit(frt_tbl, 1)
#' extract_wflw_fit(frt_tbl, 1:2)
#'
#' @return
#' A tibble with the chosen model workflow(s).
#'
#' @name extract_wflw_fit
NULL

#' @export
#' @rdname extract_wflw_fit

extract_wflw_fit <- function(.data, .model_id = NULL){

  mod_id <- as.integer(.model_id)
  mod_tbl <- .data

  # Checks ----
  if (!is.integer(mod_id) | is.null(mod_id) | any(mod_id < 1)){
    rlang::abort(
      message = "'.model_id' must be an integer like 1",
      use_cli_format = TRUE
    )
  }

  if (!inherits(mod_tbl, "tidyaml_mod_spec_tbl")){
    rlang::abort(
      message = "'.data' must have calss of 'tidyaml_mod_spec_tbl'.",
      use_cli_format = TRUE
    )
  }

  if (!"fitted_wflw" %in% names(mod_tbl)){
    rlang::abort(
      message = "'.data' must be a class of tidyaml_mod_spec_tbl at least passed
      through `internal_make_fitted_wflw()`.",
      use_cli_format = TRUE
    )
  }

  # Pull it out
  mod_tbl[mod_id, ] |>
    dplyr::pull(fitted_wflw)

}
