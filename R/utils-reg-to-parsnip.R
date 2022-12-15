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
#' @seealso \url{https://parsnip.tidymodels.org/reference/linear_reg.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/cubist_rules.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/survival_reg.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/poisson_reg.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/bag_mars.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/bag_tree.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/bart.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/boost_tree.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/decision_tree.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/gen_additive_mod.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/mars.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/mlp.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/nearest_neighbor.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/pls.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/rand_forest.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/rule_fit.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/svm_linear.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/svm_poly.html}
#' @seealso \url{https://parsnip.tidymodels.org/reference/svm_rbf.html}
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
  call <- list(.parsnip_fns) %>%
    purrr::flatten_chr()
  engine <- list(.parsnip_eng) %>%
    purrr::flatten_chr()

  # Make tibble
  mod_tbl <- tibble::tribble(
    ~.parsnip_engine, ~.parsnip_mode, ~.parsnip_fns,
    "lm", "regression", "linear_reg",
    "brulee", "regression", "linear_reg",
    "gee", "regression", "linear_reg",
    "glm","regression","linear_reg",
    "glmer","regression","linear_reg",
    "glmnet","regression","linear_reg",
    "gls","regression","linear_reg",
    "lme","regression","linear_reg",
    "lmer","regression","linear_reg",
    "stan","regression","linear_reg",
    "stan_glmer","regression","linear_reg",
    "Cubist","regression","cubist_rules",
    "glm","regression","poisson_reg",
    "gee","regression","poisson_reg",
    "glmer","regression","poisson_reg",
    "glmnet","regression","poisson_reg",
    "hurdle","regression","poisson_reg",
    "stan","regression","poisson_reg",
    "stan_glmer","regression","poisson_reg",
    "zeroinfl","regression","poisson_reg",
    "survival","censored regression","survival_reg",
    "flexsurv","censored regression","survival_reg",
    "slexsurvspline","censored regression","survival_reg",
    "earth","regression","bag_mars",
    "rpart","regression","bag_mars",
    "dbarts","regression","bart",
    "xgboost","regression","boost_tree",
    "lightgbm","regression","boost_tree",
    "mboost","censored regression","boost_tree",
    "rpart","regression","decision_tree",
    "partykit","regression","decision_tree",
    "mgcv","regression","gen_additive_mod",
    "earth","regression","mars",
    "nnet","regression","mlp",
    "brulee","regression","mlp",
    "kknn","regression","nearest_neighbor",
    "mixOmics","regression","pls",
    "ranger","regression","rand_forest",
    "randomForest","regression","rand_forest",
    "partykit","censored regression","rand_forest",
    "aorsf","censored regression","rand_forest",
    "xrf","regression","rule_fit",
    "LiblineaR","regression","svm_linear",
    "kernlab","regression","svm_linear",
    "kernlab","regression","svm_poly",
    "kernlab","regression","svm_rbf"
  )

  # Filter ----
  if (!"all" %in% engine){
    mod_tbl <- mod_tbl %>%
      dplyr::filter(.parsnip_engine %in% engine)
  }

  if (!"all" %in% call){
    mod_tbl <- mod_tbl %>%
      dplyr::filter(.parsnip_fns %in% call)
  }

  mod_filtered_tbl <- mod_tbl

  mod_spec_tbl <- mod_filtered_tbl %>%
    dplyr::mutate(
      model_spec = purrr::pmap(
        dplyr::cur_data(),
        ~ match.fun(..3)(mode = ..2, engine = ..1)
        #~ get(..3)(mode = ..2, engine = ..1)
      )
    ) %>%
    # add .model_id column
    dplyr::mutate(.model_id = dplyr::row_number()) %>%
    dplyr::select(.model_id, dplyr::everything())

  # Return ----
  class(mod_spec_tbl) <- c("fst_reg_spec_tbl", class(mod_spec_tbl))
  class(mod_spec_tbl) <- c("tidyaml_mod_spec_tbl", class(mod_spec_tbl))
  attr(mod_spec_tbl, ".parsnip_engines") <- .parsnip_eng
  attr(mod_spec_tbl, ".parsnip_functions") <- .parsnip_fns

  return(mod_spec_tbl)

}
