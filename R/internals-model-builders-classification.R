#' Internal Model Builders for Classification
#'
#' @family Internals
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' Internal functions that build pre-configured parsnip model specifications
#' for classification models. Each function returns a parsnip model specification
#' with the mode and engine pre-set.
#'
#' @details
#' These functions are used internally by `internal_make_spec_tbl()` to create
#' model specifications. Each function follows the naming pattern:
#' `{engine}_{mode}_{parsnip_function}()`
#'
#' @return A parsnip model specification object
#'
#' @name internal_model_builders_classification
NULL

# MARS Models ----
#' @rdname internal_model_builders_classification
earth_classification_bag_mars <- function() {
  parsnip::bag_mars(mode = "classification", engine = "earth")
}

#' @rdname internal_model_builders_classification
earth_classification_mars <- function() {
  parsnip::mars(mode = "classification", engine = "earth")
}

#' @rdname internal_model_builders_classification
earth_classification_discrim_flexible <- function() {
  parsnip::discrim_flexible(mode = "classification", engine = "earth")
}

# BART Models ----
#' @rdname internal_model_builders_classification
dbarts_classification_bart <- function() {
  parsnip::bart(mode = "classification", engine = "dbarts")
}

# Linear Discriminant Analysis ----
#' @rdname internal_model_builders_classification
mass_classification_discrim_linear <- function() {
  parsnip::discrim_linear(mode = "classification", engine = "MASS")
}

#' @rdname internal_model_builders_classification
mda_classification_discrim_linear <- function() {
  parsnip::discrim_linear(mode = "classification", engine = "mda")
}

#' @rdname internal_model_builders_classification
sda_classification_discrim_linear <- function() {
  parsnip::discrim_linear(mode = "classification", engine = "sda")
}

#' @rdname internal_model_builders_classification
sparsediscrim_classification_discrim_linear <- function() {
  parsnip::discrim_linear(mode = "classification", engine = "sparsediscrim")
}

# Quadratic Discriminant Analysis ----
#' @rdname internal_model_builders_classification
mass_classification_discrim_quad <- function() {
  parsnip::discrim_quad(mode = "classification", engine = "MASS")
}

#' @rdname internal_model_builders_classification
sparsediscrim_classification_discrim_quad <- function() {
  parsnip::discrim_quad(mode = "classification", engine = "sparsediscrim")
}

# Regularized Discriminant Analysis ----
#' @rdname internal_model_builders_classification
klar_classification_discrim_regularized <- function() {
  parsnip::discrim_regularized(mode = "classification", engine = "klaR")
}

# GAM Models ----
#' @rdname internal_model_builders_classification
mgcv_classification_gen_additive_mod <- function() {
  parsnip::gen_additive_mod(mode = "classification", engine = "mgcv")
}

# Logistic Regression Models ----
#' @rdname internal_model_builders_classification
brulee_classification_logistic_reg <- function() {
  parsnip::logistic_reg(mode = "classification", engine = "brulee")
}

#' @rdname internal_model_builders_classification
gee_classification_logistic_reg <- function() {
  parsnip::logistic_reg(mode = "classification", engine = "gee")
}

#' @rdname internal_model_builders_classification
glm_classification_logistic_reg <- function() {
  parsnip::logistic_reg(mode = "classification", engine = "glm")
}

#' @rdname internal_model_builders_classification
glmer_classification_logistic_reg <- function() {
  parsnip::logistic_reg(mode = "classification", engine = "glmer")
}

#' @rdname internal_model_builders_classification
glmnet_classification_logistic_reg <- function() {
  parsnip::logistic_reg(mode = "classification", engine = "glmnet")
}

#' @rdname internal_model_builders_classification
liblinear_classification_logistic_reg <- function() {
  parsnip::logistic_reg(mode = "classification", engine = "LiblineaR")
}

# Neural Network Models ----
#' @rdname internal_model_builders_classification
brulee_classification_mlp <- function() {
  parsnip::mlp(mode = "classification", engine = "brulee")
}

#' @rdname internal_model_builders_classification
nnet_classification_mlp <- function() {
  parsnip::mlp(mode = "classification", engine = "nnet")
}

# Multinomial Regression Models ----
#' @rdname internal_model_builders_classification
brulee_classification_multinom_reg <- function() {
  parsnip::multinom_reg(mode = "classification", engine = "brulee")
}

#' @rdname internal_model_builders_classification
glmnet_classification_multinom_reg <- function() {
  parsnip::multinom_reg(mode = "classification", engine = "glmnet")
}

#' @rdname internal_model_builders_classification
nnet_classification_multinom_reg <- function() {
  parsnip::multinom_reg(mode = "classification", engine = "nnet")
}

# Naive Bayes Models ----
#' @rdname internal_model_builders_classification
klar_classification_naive_bayes <- function() {
  parsnip::naive_Bayes(mode = "classification", engine = "klaR")
}

# Nearest Neighbor Models ----
#' @rdname internal_model_builders_classification
kknn_classification_nearest_neighbor <- function() {
  parsnip::nearest_neighbor(mode = "classification", engine = "kknn")
}

# Rule Fit Models ----
#' @rdname internal_model_builders_classification
xrf_classification_rule_fit <- function() {
  parsnip::rule_fit(mode = "classification", engine = "xrf")
}

# SVM Models ----
#' @rdname internal_model_builders_classification
kernlab_classification_svm_linear <- function() {
  parsnip::svm_linear(mode = "classification", engine = "kernlab")
}

#' @rdname internal_model_builders_classification
liblinear_classification_svm_linear <- function() {
  parsnip::svm_linear(mode = "classification", engine = "LiblineaR")
}

#' @rdname internal_model_builders_classification
kernlab_classification_svm_poly <- function() {
  parsnip::svm_poly(mode = "classification", engine = "kernlab")
}

#' @rdname internal_model_builders_classification
kernlab_classification_svm_rbf <- function() {
  parsnip::svm_rbf(mode = "classification", engine = "kernlab")
}

#' @rdname internal_model_builders_classification
liquidsvm_classification_svm_rbf <- function() {
  parsnip::svm_rbf(mode = "classification", engine = "liquidSVM")
}
