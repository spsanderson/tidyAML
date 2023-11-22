#' Internals Make a Model Spec tibble
#'
#' @family Internals
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Make a Model Spec tibble.
#'
#' @details Make a Model Spec tibble.
#'
#' @param .model_tbl This is the data that should be coming from inside of the
#' regression/classification to parsnip spec functions.
#'
#' @examples
#' make_regression_base_tbl() |>
#'   internal_make_spec_tbl()
#'
#' make_classification_base_tbl() |>
#'   internal_make_spec_tbl()
#'
#' @return
#' A model spec tbl.
#'
#' @name internal_make_spec_tbl
NULL

#' @export
#' @rdname internal_make_spec_tbl

internal_make_spec_tbl <- function(.model_tbl){

  # Tidyeval ----
  model_tbl <- .model_tbl

  # Checks ----
  if (!inherits(model_tbl, "tidyaml_base_tbl")){
    rlang::abort(
      message = "The model tibble must come from the make base tbl function.",
      use_cli_format = TRUE
    )
  }

  # Manipulation
  model_factor_tbl <- model_tbl |>
    dplyr::mutate(.model_id = dplyr::row_number() |>
                    forcats::as_factor()) |>
    dplyr::select(.model_id, dplyr::everything())

  # Make a group split object list
  models_list <- model_factor_tbl |>
    dplyr::group_split(.model_id)

  # Make the Workflow Object using purrr imap
  model_spec <- models_list |>
    purrr::imap(
      .f = function(obj, id){

        # Pull the model column and then pluck the model
        pe <- obj |> dplyr::pull(2) |> purrr::pluck(1)
        pm <- obj |> dplyr::pull(3) |> purrr::pluck(1)
        pf <- obj |> dplyr::pull(4) |> purrr::pluck(1)

        ret <- match.fun(pf)(mode = pm, engine = pe)

        # Add parsnip engine and fns as class
        # class(ret) <- c(
        #   class(ret),
        #   paste0(base::tolower(pe), "_", base::tolower(pf))
        # )

        # Return the result
        attributes(ret)$.tidyaml_mod_class <- paste0(base::tolower(pe), "_", base::tolower(pf))
        return(ret)
      }
    )

  # Return
  # Make sure to return as a tibble
  model_spec_ret <- model_factor_tbl |>
    dplyr::mutate(model_spec = model_spec)  |>
    dplyr::mutate(.model_id = as.integer(.model_id))

  return(model_spec_ret)
}
