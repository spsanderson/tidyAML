#' Generate Model Specification calls to `parsnip`
#'
#' @family Model_Generator
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details With this function you can generate a tibble output of any regression
#' model specification and it's fitted `workflow` object.
#'
#' @description Creates a list/tibble of parsnip model specifications.
#'
#' @param .data The data being passed to the function for the regression problem
#' @param .rec_obj The recipe object being passed.
#' @param .parsnip_fns The default is 'all' which will create all possible
#' regression model specifications supported.
#' @param .parsnip_eng the default is 'all' which will create all possible
#' regression model specifications supported.
#' @param .split_type The default is 'initial_split', you can pass any type of
#' split supported by `rsample`
#' @param .split_args The default is NULL, when NULL then the default parameters
#' of the split type will be executed for the rsample split type.
#'
#' @examples
#' library(recipes)
#' library(dplyr)
#'
#' rec_obj <- recipe(mpg ~ ., data = mtcars)
#' frt_tbl <- fast_regression(mtcars, rec_obj, .parsnip_eng = c("lm","glm"))
#' glimpse(frt_tbl)
#'
#' @return
#' A list or a tibble.
#'
#' @name fast_regression
NULL

#' @export
#' @rdname fast_regression

fast_regression <- function(.data, .rec_obj, .parsnip_fns = "all",
                            .parsnip_eng = "all", .split_type = "initial_split",
                            .split_args = NULL){

  # Tidy Eval ----
  call <- list(.parsnip_fns) %>%
    purrr::flatten_chr()
  engine <- list(.parsnip_eng) %>%
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
  mod_spec_tbl <- fast_regression_parsnip_spec_tbl(
    .parsnip_fns = call,
    .parsnip_eng = engine
  )

  mod_rec_tbl <- mod_spec_tbl %>%
    dplyr::mutate(.model_recipe = list(rec_obj))

  mod_tbl <- mod_rec_tbl %>%
    dplyr::mutate(
      .wflw = list(
        workflows::workflow() %>%
          workflows::add_recipe(.model_recipe[[1]]) %>%
          workflows::add_model(.model_spec[[1]])
      )
    ) %>%
    dplyr::mutate(
      .fitted_wflw = list(
        parsnip::fit(.wflw[[1]], data = rsample::training(splits_obj$splits))
      )
    ) %>%
    dplyr::mutate(
      .pred_wflw = list(
        predict(.fitted_wflw[[1]], new_data = rsample::testing(splits_obj$splits))
      )
    )

  # Return ----
  class(mod_tbl) <- c("fst_reg_tbl", class(mod_tbl))
  attr(mod_tbl, ".parsnip_engines") <- .parsnip_eng
  attr(mod_tbl, ".parsnip_functions") <- .parsnip_fns
  attr(mod_tbl, ".split_type") <- .split_type
  attr(mod_tbl, ".split_args") <- .split_args
  return(mod_tbl)
}
