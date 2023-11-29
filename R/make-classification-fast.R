#' Generate Model Specification calls to `parsnip`
#'
#' @family Model_Generator
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details With this function you can generate a tibble output of any classification
#' model specification and it's fitted `workflow` object. Per recipes documentation
#' explicitly with `step_string2factor()` it is encouraged to mutate your predictor
#' into a factor before you create your recipe.
#'
#' @description Creates a list/tibble of parsnip model specifications.
#'
#' @param .data The data being passed to the function for the classification problem
#' @param .rec_obj The recipe object being passed.
#' @param .parsnip_fns The default is 'all' which will create all possible
#' classification model specifications supported.
#' @param .parsnip_eng the default is 'all' which will create all possible
#' classification model specifications supported.
#' @param .split_type The default is 'initial_split', you can pass any type of
#' split supported by `rsample`
#' @param .split_args The default is NULL, when NULL then the default parameters
#' of the split type will be executed for the rsample split type.
#'
#' @examples
#' library(recipes, quietly = TRUE)
#' library(dplyr, quietly = TRUE)
#'
#' df <- mtcars |> mutate(cyl = as.factor(cyl))
#' rec_obj <- recipe(cyl ~ ., data = df)
#'
#' fct_tbl <- fast_classification(
#'   .data = df,
#'   .rec_obj = rec_obj,
#'   .parsnip_eng = c("glm","LiblineaR"))
#'
#' glimpse(fct_tbl)
#'
#' @return
#' A list or a tibble.
#'
#' @name fast_classification
NULL

#' @export
#' @rdname fast_classification
#'

fast_classification <- function(.data, .rec_obj, .parsnip_fns = "all",
                                .parsnip_eng = "all", .split_type = "initial_split",
                                .split_args = NULL){

  # Tidy Eval ----
  call <- list(.parsnip_fns) |>
    purrr::flatten_chr()
  engine <- list(.parsnip_eng) |>
    purrr::flatten_chr()

  rec_obj <- .rec_obj
  split_type <- .split_type
  split_args <- .split_args

  # Checks ----

  # Get data splits
  df <- dplyr::as_tibble(.data)
  splits_obj <- create_splits(
    .data = df,
    .split_type = split_type,
    .split_args = split_args
  )

  # Generate Model Spec Tbl
  mod_spec_tbl <- fast_classification_parsnip_spec_tbl(
    .parsnip_fns = call,
    .parsnip_eng = engine
  )

  # Generate Workflow object
  mod_tbl <- mod_spec_tbl |>
    dplyr::mutate(
      wflw = full_internal_make_wflw(mod_spec_tbl, .rec_obj = rec_obj)
    )

  mod_fitted_tbl <- mod_tbl |>
    dplyr::mutate(
      fitted_wflw = internal_make_fitted_wflw(mod_tbl, splits_obj)
    )

  mod_pred_tbl <- mod_fitted_tbl |>
    dplyr::mutate(
      pred_wflw = internal_make_wflw_predictions(mod_fitted_tbl, splits_obj)
    )


  # Return ----
  class(mod_tbl) <- c("fst_reg_tbl", class(mod_tbl))
  attr(mod_tbl, ".parsnip_engines") <- .parsnip_eng
  attr(mod_tbl, ".parsnip_functions") <- .parsnip_fns
  attr(mod_tbl, ".split_type") <- .split_type
  attr(mod_tbl, ".split_args") <- .split_args

  return(mod_pred_tbl)
}
