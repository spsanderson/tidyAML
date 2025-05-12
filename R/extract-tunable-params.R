#' Extract Tunable Parameters from Model Specifications
#'
#' @family Extractor
#'
#' @description Extract a list of tunable parameters from the `.model_spec` column
#' of a `tidyaml_mod_spec_tbl`.
#'
#' @details This function iterates over the `.model_spec` column of a model table
#' and extracts tunable parameters for each model using `tunable()`. The result
#' is a list that can be further processed into a tibble if needed.
#'
#' @param .model_tbl A model table with a class of `tidyaml_mod_spec_tbl`.
#'
#' @return A list of tibbles, each containing the tunable parameters for a model.
#'
#' @examples
#' library(dplyr)
#' mods <- fast_regression_parsnip_spec_tbl(
#'   .parsnip_fns = "linear_reg",
#'   .parsnip_eng = c("lm","glmnet")
#'   )
#' extract_tunable_params(mods)
#'
#' @export
extract_tunable_params <- function(.model_tbl) {

  # Tidyeval ----
  model_tbl <- .model_tbl
  model_tbl_class <- class(model_tbl)

  # Checks ----
  if (!inherits(model_tbl, "tidyaml_mod_spec_tbl")){
    rlang::abort(
      message = paste0(
        "'.model_tbl' must inherit a class of 'tidyaml_mod_spec_tbl \n'",
        "The current class is: ",
        class(model_tbl)
      ),
      use_cli_format = TRUE
    )
  }

  # Manipulation
  model_factor_tbl <- model_tbl |>
    dplyr::mutate(.model_id = forcats::as_factor(.model_id))

  # Make a group split object list
  models_list <- model_factor_tbl |>
    dplyr::group_split(.model_id)

  # Extract tunable parameters using purrr imap
  tunable_params_list <- models_list |>
    purrr::imap(
      .f = function(obj, id) {

        # Pull the model_spec column and then pluck the model_spec
        mod <- obj |> dplyr::pull(5) |> purrr::pluck(1)

        # Extract tunable parameters
        ret <- tune::tunable(mod)

        # Return the result
        return(ret)
      }
    )

  # Return
  return(tunable_params_list)
}
