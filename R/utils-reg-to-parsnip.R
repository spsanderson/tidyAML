#' Utility Regression call to `parsnip`
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details Creates a tibble of parsnip regression model specifications.
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
  pf <- list(.parsnip_fns) %>%
    purrr::flatten_chr()
  pe <- list(.parsnip_eng) %>%
    purrr::flatten_chr()

  # Make tibble
  mod_tbl <- dplyr::tibble(
    .parsnip_engine = c(
      "lm",
      "brulee",
      "gee",
      "glm",
      "glmer",
      "glmnet",
      "gls",
      "h2o",
      "keras",
      "lme",
      "lmer",
      "spark",
      "stan",
      "stan_glmer",
      "Cubist",
      "glm",
      "gee",
      "glmer",
      "glmnet",
      "h2o",
      "hurdle",
      "stan",
      "stan_glmer",
      "zeroinfl",
      "survival",
      "flexsurv",
      "flexsurvspline"
    ),
    .parsnip_mode = c(
      rep("regression", 24),
      rep("censored regression", 3)
    ),
    .parsnip_fns = c(
      rep("linear_reg", 14),
      "cubist_rules",
      rep("poisson_reg",9),
      rep("survival_reg", 3)
    )
  )

  # Filter ----
  if (!"all" %in% pe){
    mod_tbl <- mod_tbl %>%
      dplyr::filter(.parsnip_engine %in% pe)
  }

  if (!"all" %in% pf){
    mod_tbl <- mod_tbl %>%
      dplyr::filter(.parsnip_fns %in% pf)
  }

  mod_filtered_tbl <- mod_tbl

  mod_spec_tbl <- mod_filtered_tbl %>%
    dplyr::mutate(
      .model_spec = purrr::pmap(
        dplyr::cur_data(),
        ~ match.fun(..3)(mode = ..2, engine = ..1)
        #~ get(..3)(mode = ..2, engine = ..1)
      )
    )

  # Return ----
  class(mod_spec_tbl) <- c("fst_reg_spec_tbl", class(mod_spec_tbl))
  attr(mod_spec_tbl, ".parsnip_engines") <- .parsnip_eng
  attr(mod_spec_tbl, ".parsnip_functions") <- .parsnip_fns

  return(mod_spec_tbl)

}
