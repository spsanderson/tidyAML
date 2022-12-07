#' Utility Regression call to `parsnip`
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details Creates a tibble of parsnip regression model specifications. This will
#' create a tibble of 61 different regression model specifications which can be
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
  mod_tbl <- dplyr::tibble(
    .parsnip_engine = c(
      # linear_reg
      "lm", "brulee", "gee", "glm", "glmer", "glmnet", "gls", "h2o", "keras",
      "lme", "lmer", "spark", "stan", "stan_glmer",
      # cubist_rules
      "Cubist",
      # possion_reg
      "glm", "gee", "glmer", "glmnet", "h2o", "hurdle", "stan", "stan_glmer",
      "zeroinfl",
      # survival_reg
      "survival", "flexsurv", "flexsurvspline",
      # bag_mars
      "earth",
      # bag_tree
      "rpart", "C5.0",
      # bart
      "dbart",
      # boost_tree
      "xgboost", "C5.0","h2o","lightgbm","mboost","spark",
      # decision_tree
      "rpart","C5.0","partykit","spark",
      # gen_additive_mod
      "mgcv",
      # mars
      "earth",
      # mlp
      "nnet","brulee","h2o","keras",
      # nearest_neighbor
      "kknn",
      # pls
      "mixOmics",
      # rand_forest
      "ranger","aorsf","h2o","randomforest","spark","partykit",
      # rule_fit
      "xrf","h2o",
      # svm_linear
      "LibLineaR","kernlab",
      # svm_poly
      "kernlab",
      # svm_rbf
      "kernlab"
    ),
    .parsnip_mode = c(
      rep("regression", 24),
      rep("censored regression", 3),
      rep("regression", 12),
      rep("censored regression", 1),
      rep("regression", 14),
      "censored regression",
      rep("regression", 6)
    ),
    .parsnip_fns = c(
      rep("linear_reg", 14),
      "cubist_rules",
      rep("poisson_reg",9),
      rep("survival_reg", 3),
      "bag_mars",
      rep("bag_tree",2),
      "bart",
      rep("boost_tree",6),
      rep("decision_tree", 4),
      "gen_additive_mod",
      "mars",
      rep("mlp", 4),
      "nearest_neighbor",
      "pls",
      rep("rand_forest",6),
      rep("rule_fit",2),
      rep("svm_linear", 2),
      "svm_poly",
      "svm_rbf"
    )
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
