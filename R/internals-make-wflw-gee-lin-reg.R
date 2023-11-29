#' Internals Safely Make Workflow for GEE Linear Regression
#'
#' @family Internals
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Safely Make a workflow from a model spec tibble.
#'
#' @details Create a model specification tibble that has a [workflows::workflow()]
#' list column.
#'
#' @param .model_tbl The model table that is generated from a function like
#'   `fast_regression_parsnip_spec_tbl()`, must have a class of "tidyaml_mod_spec_tbl".
#' @param .rec_obj The recipe object that is going to be used to make the workflow
#'   object.
#'
#' @examples
#' library(dplyr)
#' library(recipes)
#' library(multilevelmod)
#'
#' mod_tbl <- make_regression_base_tbl()
#' mod_tbl <- mod_tbl |>
#'   filter(
#'   .parsnip_engine %in% c("gee") &
#'   .parsnip_fns == "linear_reg"
#'   )
#'
#' class(mod_tbl) <- c("tidyaml_mod_spec_tbl", class(mod_tbl))
#' mod_spec_tbl <- internal_make_spec_tbl(mod_tbl)
#' rec_obj <- recipe(mpg ~ ., data = mtcars)
#'
#' internal_make_wflw_gee_lin_reg(mod_spec_tbl, rec_obj)
#'
#' @return
#' A list object of workflows.
#'
#' @name internal_make_wflw_gee_lin_reg
NULL

#' @export
#' @rdname internal_make_wflw_gee_lin_reg

internal_make_wflw_gee_lin_reg <- function(.model_tbl, .rec_obj){

  # Tidyeval ----
  model_tbl <- .model_tbl
  rec_obj <- .rec_obj

  # Checks ----
  if (!inherits(model_tbl, "tidyaml_mod_spec_tbl")){
    rlang::abort(
      message = "'.model_tbl' must inherit a class of 'tidyaml_mod_spec_tbl",
      use_cli_format = TRUE
    )
  }

  # Manipulation
  model_factor_tbl <- model_tbl |>
    dplyr::mutate(.model_id = forcats::as_factor(.model_id)) |>
    dplyr::mutate(rec_obj = list(rec_obj))

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
        rec_obj <- obj |> dplyr::pull(6) |> purrr::pluck(1)

        # Make New formula
        # Make a formula
        my_formula <- stats::formula(recipes::prep(rec_obj))
        predictor_vars <- rec_obj$var_info |>
          dplyr::filter(role == "predictor") |>
          dplyr::pull(variable)
        var_to_replace <- rec_obj$var_info |>
          dplyr::filter(role == "predictor") |>
          dplyr::slice(1) |>
          dplyr::pull(variable)
        outcome_var <- rec_obj$var_info |>
          dplyr::filter(role == "outcome") |>
          dplyr::pull(variable)

        new_terms <-  paste0("id_var(", var_to_replace, ")")
        new_terms1 <- paste(new_terms, collapse = "+")
        new_formula <- do.call(
          "substitute",
          list(
            my_formula,
            stats::setNames(
              list(
                str2lang(new_terms1)
              ),
              var_to_replace
            )
          )
        )
        new_formula <- stats::as.formula(new_formula)

        # Create a safe add_model function
        safe_add_model <- purrr::safely(
          workflows::add_model,
          otherwise = NULL,
          quiet = TRUE
        )

        # Return the workflow object with recipe and model
        ret <- workflows::workflow() |>
          workflows::add_variables(
            outcomes = outcome_var,
            predictors = predictor_vars
          ) |>
          safe_add_model(mod, formula = new_formula)

        # Pluck the result
        res <- ret |> purrr::pluck("result")

        if (!is.null(ret$error)) message(stringr::str_glue("{ret$error}"))

        # Return the result
        return(res)
      }
    )

  # Return
  return(wflw_list)
}
