#' Extract A Model Specification
#'
#' @family Extractor
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Extract a model specification from a tidyAML model tibble.
#'
#' @details This function allows you to get a model specification or more from
#' a tibble with a class of "tidyaml_mod_spec_tbl". It allows you to select the
#' model by the `.model_id` column. You can call the model id's by an integer
#' or a sequence of integers.
#'
#' @param .data The model table that must have the class `tidyaml_mod_spec_tbl`.
#' @param .model_id The model number that you want to select, Must be an integer
#' or sequence of integers, ie. `1` or `c(1,3,5)` or `1:2`
#'
#' @examples
#' spec_tbl <- fast_regression_parsnip_spec_tbl(
#'   .parsnip_fns = "linear_reg",
#'   .parsnip_eng = c("lm","glm")
#' )
#'
#' extract_model_spec(spec_tbl, 1)
#' extract_model_spec(spec_tbl, 1:2)
#'
#' @return
#' A tibble with the chosen model specification(s).
#'
#' @name extract_model_spec
NULL

#' @export
#' @rdname extract_model_spec

extract_model_spec <- function(.data, .model_id = NULL){

  mod_id <- as.integer(.model_id)
  mod_tbl <- .data

  # Checks ----
  if (!is.numeric(mod_id) | is.null(mod_id) | any(mod_id < 1)){
    rlang::abort(
      message = "'.model_id' must be an integer like 1",
      use_cli_format = TRUE
    )
  }

  if (!inherits(mod_tbl, "tidyaml_mod_spec_tbl")){
    if(!inherits(mod_tbl, "create_mod_spec_tbl")){
      rlang::abort(
        message = "'.data' must have class of 'tidyaml_mod_spec_tbl/create_mod_spec_tbl'.",
        use_cli_format = TRUE
      )
    }
  }

  # if (!inherits(mod_tbl, "tidyaml_mod_spec_tbl")){
  #   rlang::abort(
  #     message = "'.data' must have class of 'tidyaml_mod_spec_tbl'.",
  #     use_cli_format = TRUE
  #   )
  # }

  # Get model_spec(s)
  if (inherits(mod_tbl, "tidyaml_mod_spec_tbl")){
    mod_tbl[mod_id,] |>
      dplyr::pull(model_spec)
  } else {
    mod_tbl[mod_id,] |>
      dplyr::pull(.model_spec)
  }

}
