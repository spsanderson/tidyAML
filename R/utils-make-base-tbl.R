#' Internals Make Base Regression Tibble
#'
#' @family Internals
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details Creates a base tibble to create parsnip regression model specifications.
#'
#' @description Creates a base tibble to create parsnip regression model specifications.
#'
#' @examples
#' make_regression_base_tbl()
#'
#' @return
#' A tibble
#'
#' @name make_regression_base_tbl
NULL

#' @export
#' @rdname make_regression_base_tbl

make_regression_base_tbl <- function(){

  # Make the regression tribble
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
    "earth","regression","bag_mars",
    "rpart","regression","bag_tree",
    "dbarts","regression","bart",
    "xgboost","regression","boost_tree",
    "lightgbm","regression","boost_tree",
    "rpart","regression","decision_tree",
    "partykit","regression","decision_tree",
    "mgcv","regression","gen_additive_mod",
    "earth","regression","mars",
    "nnet","regression","mlp",
    "brulee","regression","mlp",
    "kknn","regression","nearest_neighbor",
    "ranger","regression","rand_forest",
    "randomForest","regression","rand_forest",
    "xrf","regression","rule_fit",
    "LiblineaR","regression","svm_linear",
    "kernlab","regression","svm_linear",
    "kernlab","regression","svm_poly",
    "kernlab","regression","svm_rbf"
  )

  # Return
  class(mod_tbl) <- c("tidyaml_base_tbl", class(mod_tbl))
  return(mod_tbl)
}

#' Internals Make Base Classification Tibble
#'
#' @family Internals
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details Creates a base tibble to create parsnip classification model specifications.
#'
#' @description Creates a base tibble to create parsnip classification model specifications.
#'
#' @examples
#' make_classification_base_tbl()
#'
#' @return
#' A tibble
#'
#' @name make_classification_base_tbl
NULL

#' @export
#' @rdname make_classification_base_tbl

make_classification_base_tbl <- function(){

  # Make the regression tribble
  # Make tibble
  mod_tbl <- tibble::tribble(
    ~.parsnip_engine, ~.parsnip_mode, ~.parsnip_fns,
    "earth","classification","bag_mars",
    "earth","classification","discrim_flexible",
    "dbarts","classification","bart",
    "MASS","classification","discrim_linear",
    "mda","classification","discrim_linear",
    "sda","classification","discrim_linear",
    "sparsediscrim","classification","discrim_linear",
    "MASS","classification","discrim_quad",
    "sparsediscrim","classification","discrim_quad",
    "klaR","classification","discrim_regularized",
    "mgcv","classification","gen_additive_mod",
    "brulee","classification","logistic_reg",
    "gee","classification","logistic_reg",
    "glm","classification","logistic_reg",
    "glmer","classification","logistic_reg",
    "glmnet","classification","logistic_reg",
    "LiblineaR","classification","logistic_reg",
    "earth","classification","mars",
    "brulee","classification","mlp",
    "nnet","classification","mlp",
    "brulee","classification","multinom_reg",
    "glmnet","classification","multinom_reg",
    "nnet","classification","multinom_reg",
    "klaR","classification","naive_Bayes",
    "kknn","classification","nearest_neighbor",
    "xrf","classification","rule_fit",
    "kernlab","classification","svm_linear",
    "LiblineaR","classification","svm_linear",
    "kernlab","classification","svm_poly",
    "kernlab","classification","svm_rbf",
    "liquidSVM","classification","svm_rbf"
  )

  # Return
  class(mod_tbl) <- c("tidyaml_base_tbl", class(mod_tbl))
  return(mod_tbl)
}
