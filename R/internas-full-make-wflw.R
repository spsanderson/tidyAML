#' Full Internal Workflow for Model and Recipe
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description This function creates a full internal workflow for a model and
#' recipe combination.
#'
#' @details The function checks if the input model specification table inherits
#' the class 'tidyaml_mod_spec_tbl'. It then manipulates the input table, making
#' adjustments for factors and creating a list of grouped models. For each
#' model-recipe pair, it uses the appropriate internal function based on the
#' model type to create a workflow object. The specific internal function is
#' selected using a switch statement based on the class of the model.
#'
#' @param .model_tbl A model specification table (`tidyaml_mod_spec_tbl`).
#' @param .rec_obj A recipe object.
#'
#' @examples
#' library(dplyr)
#' library(recipes)
#'
#' rec_obj <- recipe(mpg ~ ., data = mtcars)
#'
#' mod_tbl <- make_regression_base_tbl()
#' mod_tbl <- mod_tbl |>
#'   filter(
#'     .parsnip_engine %in% c("lm", "glm", "gee") &
#'     .parsnip_fns == "linear_reg"
#'     )
#' class(mod_tbl) <- c("tidyaml_mod_spec_tbl", class(mod_tbl))
#' mod_spec_tbl <- internal_make_spec_tbl(mod_tbl)
#' result <- full_internal_make_wflw(mod_spec_tbl, rec_obj)
#' result
#'
#' @return
#' The function returns a workflow object for the first model-recipe pair based on the internal function selected.
#'
#' @name full_internal_make_wflw
NULL

#' @export
#' @rdname full_internal_make_wflw

full_internal_make_wflw <- function(.model_tbl, .rec_obj){

  # Tidyeval ----
  model_tbl <- .model_tbl
  rec_obj <- .rec_obj
  model_tbl_class <- class(model_tbl)

  # Checks ----
  if (!inherits(model_tbl, "tidyaml_mod_spec_tbl")){
    rlang::abort(
      message = "'.model_tbl' must inherit a class of 'tidyaml_mod_spec_tbl",
      use_cli_format = TRUE
    )
  }

  # Manipulation
  model_factor_tbl <- model_tbl |>
    dplyr::mutate(.model_id = forcats::as_factor(.model_id))
  #dplyr::mutate(rec_obj = list(rec_obj))

  # Make a group split object list
  models_list <- model_factor_tbl |>
    dplyr::group_split(.model_id)

  # Make the Workflow Object using purrr imap
  wflw_list <- models_list |>
    purrr::imap(
      .f = function(obj, id){

        # Pull the model column and then pluck the model
        mod <- obj |> dplyr::pull(5) |> purrr::pluck(1)

        # PUll the recipe column and then pluck the recipe
        #rec_obj <- obj |> dplyr::pull(6) |> purrr::pluck(1)

        # Switch Statement
        # First get attributes of the model
        mod_attr <- attributes(mod)$.tidyaml_mod_class
        class(obj) <- c("tidyaml_mod_spec_tbl", class(obj))

        # Switch on the class of the model
        if (mod_attr == "gee_linear_reg"){
          ret <- internal_make_wflw_gee_lin_reg(obj, rec_obj)[[1]]
        }

        if (!mod_attr == "gee_linear_reg"){
          ret <- internal_make_wflw(obj, rec_obj)[[1]]
        }

        # Return Result
        return(ret)
      }
    )

  # Return
  return(wflw_list)
}
