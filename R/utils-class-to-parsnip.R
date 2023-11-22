#' Utility Classification call to `parsnip`
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details Creates a tibble of parsnip classification model specifications. This will
#' create a tibble of 32 different classification model specifications which can be
#' filtered. The model specs are created first and then filtered out. This will
#' only create models for __classification__ problems. To find all of the supported
#' models in this package you can visit \url{https://www.tidymodels.org/find/parsnip/}
#'
#' @description Creates a tibble of parsnip classification model specifications.
#'
#' @param .parsnip_fns The default for this is set to `all`. This means that all
#' of the parsnip __classification__ functions will be used, for example `bag_mars()`,
#' or `bart()`. You can also choose to pass a c() vector like `c("barg_mars","bart")`
#' @param .parsnip_eng The default for this is set to `all`. This means that all
#' of the parsnip __classification engines__ will be used, for example `earth`, or
#' `dbarts`. You can also choose to pass a c() vector like `c('earth', 'dbarts')`
#'
#' @examples
#' fast_classification_parsnip_spec_tbl(.parsnip_fns = "logistic_reg")
#' fast_classification_parsnip_spec_tbl(.parsnip_eng = c("earth","dbarts"))
#'
#' @return
#' A tibble with an added class of 'fst_class_spec_tbl'
#'
#' @importFrom parsnip linear_reg cubist_rules poisson_reg survival_reg
#'
#' @name fast_classification_parsnip_spec_tbl
NULL

#' @export
#' @rdname fast_classification_parsnip_spec_tbl

fast_classification_parsnip_spec_tbl <- function(.parsnip_fns = "all",
                                                 .parsnip_eng = "all") {

  # Thank you https://stackoverflow.com/questions/74691333/build-a-tibble-of-parsnip-model-calls-with-match-fun/74691529#74691529
  # Tidyeval ----
  call <- list(.parsnip_fns) |>
    purrr::flatten_chr()
  engine <- list(.parsnip_eng) |>
    purrr::flatten_chr()

  # Make tibble
  mod_tbl <- make_classification_base_tbl()

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
  class(mod_spec_tbl) <- c("fst_class_spec_tbl", class(mod_spec_tbl))
  class(mod_spec_tbl) <- c("tidyaml_mod_spec_tbl", class(mod_spec_tbl))
  attr(mod_spec_tbl, ".parsnip_engines") <- .parsnip_eng
  attr(mod_spec_tbl, ".parsnip_functions") <- .parsnip_fns

  return(mod_spec_tbl)

}
