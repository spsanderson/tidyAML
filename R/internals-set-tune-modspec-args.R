#' Internals Make a Tunable Model Specification
#'
#' @family Internals
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Make a tuned model specification object.
#'
#' @details This will take a model specification that is created from a function
#' like [tidyAML::fast_regression_parsnip_spec_tbl()] and update the __model_spec__
#' `args` to `tune::tune()`. This is done dynamically, meaning you do not need
#' to know the names of the parameters inside of the model specification.
#'
#' @param .model_tbl The model table that is generated from a function like
#' `fast_regression_parsnip_spec_tbl()`, must have a class of "tidyaml_mod_spec_tbl".
#'
#' @examples
#' library(dplyr)
#'
#' mod_tbl <- fast_regression_parsnip_spec_tbl()
#' mod_tbl$model_spec[[1]]
#'
#' updated_mod_tbl <- mod_tbl |>
#'   mutate(model_spec = internal_set_args_to_tune(mod_tbl))
#' updated_mod_tbl$model_spec[[1]]
#'
#' @return
#' A list object of workflows.
#'
#' @name internal_set_args_to_tune
NULL

#' @export
#' @rdname internal_set_args_to_tune

internal_set_args_to_tune <- function(.model_tbl){

  # Tidyeval
  model_tbl <- .model_tbl

  # Checks ----
  if (!inherits(model_tbl, "tidyaml_mod_spec_tbl")){
    rlang::abort(
      message = "'.model_tbl' must inherit a class of 'tidyaml_mod_spec_tbl",
      use_cli_format = TRUE
    )
  }

  model_tbl_with_params <- model_tbl |>
    dplyr::mutate(
      model_params = purrr::pmap(
        #dplyr::cur_data(),
        dplyr::pick(dplyr::everything()),
        ~ list(formalArgs(..4))
      )
    )

  models_list_new <- model_tbl_with_params |>
    dplyr::group_split(.model_id)

  tuned_params_list <- models_list_new |>
    purrr::imap(
      .f = function(obj, id){

        # Pull the model params
        mod_params <- obj |> dplyr::pull(6) |> purrr::pluck(1) # change to pull(6)
        mod_params_list <- unlist(mod_params) |> as.list()
        #param_names <- unlist(mod_params)
        names(mod_params_list) <- unlist(mod_params)

        # Set mode and engine
        p_mode <- obj |> dplyr::pull(3) |> purrr::pluck(1)
        p_engine <- obj |> dplyr::pull(2) |> purrr::pluck(1)
        me_list <- list(
          mode = paste0("mode = ", p_mode),
          engine = paste0("engine = ", p_engine)
        )

        # Get all other params
        me_vec <- c("mode","engine")
        pv <- unlist(mod_params)
        params_to_modify <- pv[!pv %in% me_vec] |> as.list()
        names(params_to_modify) <- unlist(params_to_modify)

        # Set each item equal to .x = tune::tune()
        tuned_params_list <- purrr::map(
          params_to_modify,
          ~ paste0("tune::tune()")
        )

        # use modifyList()
        res <- utils::modifyList(mod_params_list, tuned_params_list)
        res <- utils::modifyList(res, me_list)

        # Return
        return(res)

      }
    )

  models_with_params_list <- purrr::map2(
    .x = tuned_params_list,
    .y = models_list_new,
    ~ {.y$model_params <- list(.x[.y$model_params[[1]][[1]]]);.y}
  )

  new_mod_obj <- models_with_params_list |>
    purrr::imap(
      .f = function(obj, id){

        # Get Model Specification
        mod_spec <- obj |>
          dplyr::pull(5) |>
          purrr::pluck(1)

        # Get the tuned params
        new_mod_args <- obj |>
          dplyr::pull(6) |>
          purrr::pluck(1)

        # Drop the ones we don't need to set
        new_mod_args <- new_mod_args |>
          unlist() |>
          subset(!names(new_mod_args) %in% c('mode','engine')) |>
          as.list()

        # Set the new model arguments
        mod_spec$args <- new_mod_args

        # Return the newly modified model specification
        return(mod_spec)
      }
    )

  return(new_mod_obj)

}
