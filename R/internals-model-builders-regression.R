#' Internal Model Builders for Regression
#'
#' @family Internals
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' Internal functions that build pre-configured parsnip model specifications
#' for regression models. Each function returns a parsnip model specification
#' with the mode and engine pre-set.
#'
#' @details
#' These functions are used internally by `internal_make_spec_tbl()` to create
#' model specifications. Each function follows the naming pattern:
#' `{engine}_{mode}_{parsnip_function}()`
#'
#' @return A parsnip model specification object
#'
#' @name internal_model_builders_regression
NULL

# Linear Regression Models ----
#' @rdname internal_model_builders_regression
lm_regression_linear_reg <- function() {
  parsnip::linear_reg(mode = "regression", engine = "lm")
}

#' @rdname internal_model_builders_regression
brulee_regression_linear_reg <- function() {
  parsnip::linear_reg(mode = "regression", engine = "brulee")
}

#' @rdname internal_model_builders_regression
gee_regression_linear_reg <- function() {
  parsnip::linear_reg(mode = "regression", engine = "gee")
}

#' @rdname internal_model_builders_regression
glm_regression_linear_reg <- function() {
  parsnip::linear_reg(mode = "regression", engine = "glm")
}

#' @rdname internal_model_builders_regression
glmer_regression_linear_reg <- function() {
  parsnip::linear_reg(mode = "regression", engine = "glmer")
}

#' @rdname internal_model_builders_regression
glmnet_regression_linear_reg <- function() {
  parsnip::linear_reg(mode = "regression", engine = "glmnet")
}

#' @rdname internal_model_builders_regression
gls_regression_linear_reg <- function() {
  parsnip::linear_reg(mode = "regression", engine = "gls")
}

#' @rdname internal_model_builders_regression
lme_regression_linear_reg <- function() {
  parsnip::linear_reg(mode = "regression", engine = "lme")
}

#' @rdname internal_model_builders_regression
lmer_regression_linear_reg <- function() {
  parsnip::linear_reg(mode = "regression", engine = "lmer")
}

#' @rdname internal_model_builders_regression
stan_regression_linear_reg <- function() {
  parsnip::linear_reg(mode = "regression", engine = "stan")
}

#' @rdname internal_model_builders_regression
stan_glmer_regression_linear_reg <- function() {
  parsnip::linear_reg(mode = "regression", engine = "stan_glmer")
}

# Cubist Rules ----
#' @rdname internal_model_builders_regression
cubist_regression_cubist_rules <- function() {
  parsnip::cubist_rules(mode = "regression", engine = "Cubist")
}

# Poisson Regression Models ----
#' @rdname internal_model_builders_regression
glm_regression_poisson_reg <- function() {
  parsnip::poisson_reg(mode = "regression", engine = "glm")
}

#' @rdname internal_model_builders_regression
gee_regression_poisson_reg <- function() {
  parsnip::poisson_reg(mode = "regression", engine = "gee")
}

#' @rdname internal_model_builders_regression
glmer_regression_poisson_reg <- function() {
  parsnip::poisson_reg(mode = "regression", engine = "glmer")
}

#' @rdname internal_model_builders_regression
glmnet_regression_poisson_reg <- function() {
  parsnip::poisson_reg(mode = "regression", engine = "glmnet")
}

#' @rdname internal_model_builders_regression
hurdle_regression_poisson_reg <- function() {
  parsnip::poisson_reg(mode = "regression", engine = "hurdle")
}

#' @rdname internal_model_builders_regression
stan_regression_poisson_reg <- function() {
  parsnip::poisson_reg(mode = "regression", engine = "stan")
}

#' @rdname internal_model_builders_regression
stan_glmer_regression_poisson_reg <- function() {
  parsnip::poisson_reg(mode = "regression", engine = "stan_glmer")
}

#' @rdname internal_model_builders_regression
zeroinfl_regression_poisson_reg <- function() {
  parsnip::poisson_reg(mode = "regression", engine = "zeroinfl")
}

# MARS Models ----
#' @rdname internal_model_builders_regression
earth_regression_bag_mars <- function() {
  parsnip::bag_mars(mode = "regression", engine = "earth")
}

#' @rdname internal_model_builders_regression
earth_regression_mars <- function() {
  parsnip::mars(mode = "regression", engine = "earth")
}

# Tree Models ----
#' @rdname internal_model_builders_regression
rpart_regression_bag_tree <- function() {
  parsnip::bag_tree(mode = "regression", engine = "rpart")
}

#' @rdname internal_model_builders_regression
rpart_regression_decision_tree <- function() {
  parsnip::decision_tree(mode = "regression", engine = "rpart")
}

#' @rdname internal_model_builders_regression
partykit_regression_decision_tree <- function() {
  parsnip::decision_tree(mode = "regression", engine = "partykit")
}

# BART Models ----
#' @rdname internal_model_builders_regression
dbarts_regression_bart <- function() {
  parsnip::bart(mode = "regression", engine = "dbarts")
}

# Boosted Tree Models ----
#' @rdname internal_model_builders_regression
xgboost_regression_boost_tree <- function() {
  parsnip::boost_tree(mode = "regression", engine = "xgboost")
}

#' @rdname internal_model_builders_regression
lightgbm_regression_boost_tree <- function() {
  parsnip::boost_tree(mode = "regression", engine = "lightgbm")
}

# GAM Models ----
#' @rdname internal_model_builders_regression
mgcv_regression_gen_additive_mod <- function() {
  parsnip::gen_additive_mod(mode = "regression", engine = "mgcv")
}

# Neural Network Models ----
#' @rdname internal_model_builders_regression
nnet_regression_mlp <- function() {
  parsnip::mlp(mode = "regression", engine = "nnet")
}

#' @rdname internal_model_builders_regression
brulee_regression_mlp <- function() {
  parsnip::mlp(mode = "regression", engine = "brulee")
}

# Nearest Neighbor Models ----
#' @rdname internal_model_builders_regression
kknn_regression_nearest_neighbor <- function() {
  parsnip::nearest_neighbor(mode = "regression", engine = "kknn")
}

# Random Forest Models ----
#' @rdname internal_model_builders_regression
ranger_regression_rand_forest <- function() {
  parsnip::rand_forest(mode = "regression", engine = "ranger")
}

#' @rdname internal_model_builders_regression
randomforest_regression_rand_forest <- function() {
  parsnip::rand_forest(mode = "regression", engine = "randomForest")
}

# Rule Fit Models ----
#' @rdname internal_model_builders_regression
xrf_regression_rule_fit <- function() {
  parsnip::rule_fit(mode = "regression", engine = "xrf")
}

# SVM Models ----
#' @rdname internal_model_builders_regression
liblinear_regression_svm_linear <- function() {
  parsnip::svm_linear(mode = "regression", engine = "LiblineaR")
}

#' @rdname internal_model_builders_regression
kernlab_regression_svm_linear <- function() {
  parsnip::svm_linear(mode = "regression", engine = "kernlab")
}

#' @rdname internal_model_builders_regression
kernlab_regression_svm_poly <- function() {
  parsnip::svm_poly(mode = "regression", engine = "kernlab")
}

#' @rdname internal_model_builders_regression
kernlab_regression_svm_rbf <- function() {
  parsnip::svm_rbf(mode = "regression", engine = "kernlab")
}
