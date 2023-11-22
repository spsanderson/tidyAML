#' Utility Regression call to `parsnip`
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details Creates a tibble of parsnip regression model specifications. This will
#' create a tibble of 46 different regression model specifications which can be
#' filtered. The model specs are created first and then filtered out. This will
#' only create models for __regression__ problems. To find all of the supported
#' models in this package you can visit \url{https://www.tidymodels.org/find/parsnip/}
#'
#' @description Creates a tibble of parsnip regression model specifications.
#'
#' @param .parsnip_fns The default for this is set to `all`. This means that all
#' of the parsnip __linear regression__ functions will be used, for example `linear_reg()`,
#' or `cubist_rules`. You can also choose to pass a c() vector like `c("linear_reg","cubist_rules")`
#' @param .parsnip_eng The default for this is set to `all`. This means that all
#' of the parsnip __linear regression engines__ will be used, for example `lm`, or
#' `glm`. You can also choose to pass a c() vector like `c('lm', 'glm')`
#'
#' @examples
#' fast_regression_parsnip_spec_tbl(.parsnip_fns = "linear_reg")
#' fast_regression_parsnip_spec_tbl(.parsnip_eng = c("lm","glm"))
#'
#' @return
#' A tibble with an added class of 'fst_reg_spec_tbl'
#'
#' @importFrom parsnip linear_reg cubist_rules poisson_reg survival_reg
#'
#' @name fast_regression_parsnip_spec_tbl
NULL

#' @export
#' @rdname fast_regression_parsnip_spec_tbl

fast_regression_parsnip_spec_tbl <- function(.parsnip_fns = "all",
                                             .parsnip_eng = "all") {

  # Thank you https://stackoverflow.com/questions/74691333/build-a-tibble-of-parsnip-model-calls-with-match-fun/74691529#74691529
  # Tidyeval ----
  call <- list(.parsnip_fns) |>
    purrr::flatten_chr()
  engine <- list(.parsnip_eng) |>
    purrr::flatten_chr()

  # Make tibble
  mod_tbl <- make_regression_base_tbl()

  # Filter ----
  if (!"all" %in% engine){
    mod_tbl <- mod_tbl |>
      dplyr::filter(.parsnip_engine %in% engine)
  }

  if (!"all" %in% call){
    mod_tbl <- mod_tbl |>
      dplyr::filter(.parsnip_fns %in% call)
  }

  mod_filtered_tbl <- mod_tbl

  mod_spec_tbl <- mod_filtered_tbl |>
    internal_make_spec_tbl()

  # Return ----
  class(mod_spec_tbl) <- c("fst_reg_spec_tbl", class(mod_spec_tbl))
  class(mod_spec_tbl) <- c("tidyaml_mod_spec_tbl", class(mod_spec_tbl))
  attr(mod_spec_tbl, ".parsnip_engines") <- .parsnip_eng
  attr(mod_spec_tbl, ".parsnip_functions") <- .parsnip_fns

  return(mod_spec_tbl)

}
