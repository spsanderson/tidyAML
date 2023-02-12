#' Get a Model
#'
#' @family Extractor
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Get a model from a tidyAML model tibble.
#'
#' @details This function allows you to get a model or models from a tibble with
#' a class of "tidyaml_mod_spec_tbl". It allows you to select the model by the
#' `.model_id` column. You can call the model id's by an integer or a sequence
#' of integers.
#'
#' @param .data The model table that must have the class `tidyaml_mod_spec_tbl`.
#' @param .model_id The model number that you want to select, Must be an integer
#' or sequence of integers, ie. `1` or `c(1,3,5)` or `1:2`
#'
#' @examples
#' library(recipes)
#'
#' rec_obj <- recipe(mpg ~ ., data = mtcars)
#' spec_tbl <- fast_regression_parsnip_spec_tbl(
#'   .parsnip_fns = "linear_reg",
#'   .parsnip_eng = c("lm","glm")
#' )
#'
#' get_model(spec_tbl, 1)
#' get_model(spec_tbl, 1:2)
#'
#' @return
#' A tibble with the chosen models.
#'
#' @name get_model
NULL

#' @export
#' @rdname get_model

get_model <- function(.data, .model_id = NULL){

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

  mod_tbl[mod_id,]

}
