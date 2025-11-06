# Package index

## Model Generators

Functions that will generate models

- [`create_model_spec()`](https://www.spsanderson.com/tidyaml/reference/create_model_spec.md)
  :

  Generate Model Specification calls to `parsnip`

- [`fast_classification()`](https://www.spsanderson.com/tidyaml/reference/fast_classification.md)
  :

  Generate Model Specification calls to `parsnip`

- [`fast_regression()`](https://www.spsanderson.com/tidyaml/reference/fast_regression.md)
  :

  Generate Model Specification calls to `parsnip`

## Extractors

Functions that extract parts of a model spec tibble

- [`extract_model_spec()`](https://www.spsanderson.com/tidyaml/reference/extract_model_spec.md)
  : Extract A Model Specification
- [`extract_regression_residuals()`](https://www.spsanderson.com/tidyaml/reference/extract_regression_residuals.md)
  : Extract Residuals from Fast Regression Models
- [`extract_tunable_params()`](https://www.spsanderson.com/tidyaml/reference/extract_tunable_params.md)
  : Extract Tunable Parameters from Model Specifications
- [`extract_wflw()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw.md)
  : Extract A Model Workflow
- [`extract_wflw_fit()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_fit.md)
  : Extract A Model Fitted Workflow
- [`extract_wflw_pred()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_pred.md)
  : Extract A Model Workflow Predictions
- [`get_model()`](https://www.spsanderson.com/tidyaml/reference/get_model.md)
  : Get a Model

## Utility Functions

Utility/Internal Functions and Helpers

- [`check_duplicate_rows()`](https://www.spsanderson.com/tidyaml/reference/check_duplicate_rows.md)
  : Check for Duplicate Rows in a Data Frame

- [`core_packages()`](https://www.spsanderson.com/tidyaml/reference/core_packages.md)
  : Functions to Install all Core Libraries

- [`create_splits()`](https://www.spsanderson.com/tidyaml/reference/create_splits.md)
  : Utility Create Splits Object

- [`create_workflow_set()`](https://www.spsanderson.com/tidyaml/reference/create_workflow_set.md)
  : Create a Workflow Set Object

- [`fast_classification_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_classification_parsnip_spec_tbl.md)
  :

  Utility Classification call to `parsnip`

- [`fast_regression_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_regression_parsnip_spec_tbl.md)
  :

  Utility Regression call to `parsnip`

- [`full_internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/full_internal_make_wflw.md)
  : Full Internal Workflow for Model and Recipe

- [`install_deps()`](https://www.spsanderson.com/tidyaml/reference/install_deps.md)
  : Functions to Install all Core Libraries

- [`load_deps()`](https://www.spsanderson.com/tidyaml/reference/load_deps.md)
  : Functions to Install all Core Libraries

- [`match_args()`](https://www.spsanderson.com/tidyaml/reference/match_args.md)
  : Match function arguments

- [`quantile_normalize()`](https://www.spsanderson.com/tidyaml/reference/quantile_normalize.md)
  : Perform quantile normalization on a numeric matrix/data.frame

## Plotting

Functions that plot model information

- [`plot_regression_predictions()`](https://www.spsanderson.com/tidyaml/reference/plot_regression_predictions.md)
  : Create ggplot2 plot of regression predictions
- [`plot_regression_residuals()`](https://www.spsanderson.com/tidyaml/reference/plot_regression_residuals.md)
  : Create ggplot2 plot of regression residuals

## Internals

Internal/Helper functions

- [`internal_make_fitted_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_fitted_wflw.md)
  : Internals Safely Make a Fitted Workflow from Model Spec tibble
- [`internal_make_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/internal_make_spec_tbl.md)
  : Internals Make a Model Spec tibble
- [`internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw.md)
  : Internals Safely Make Workflow from Model Spec tibble
- [`internal_make_wflw_gee_lin_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_gee_lin_reg.md)
  : Internals Safely Make Workflow for GEE Linear Regression
- [`internal_make_wflw_predictions()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_predictions.md)
  : Internals Safely Make Predictions on a Fitted Workflow from Model
  Spec tibble
- [`earth_classification_bag_mars()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`earth_classification_mars()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`earth_classification_discrim_flexible()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`dbarts_classification_bart()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`mass_classification_discrim_linear()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`mda_classification_discrim_linear()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`sda_classification_discrim_linear()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`sparsediscrim_classification_discrim_linear()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`mass_classification_discrim_quad()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`sparsediscrim_classification_discrim_quad()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`klaR_classification_discrim_regularized()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`mgcv_classification_gen_additive_mod()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`brulee_classification_logistic_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`gee_classification_logistic_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`glm_classification_logistic_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`glmer_classification_logistic_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`glmnet_classification_logistic_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`liblinear_classification_logistic_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`brulee_classification_mlp()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`nnet_classification_mlp()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`brulee_classification_multinom_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`glmnet_classification_multinom_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`nnet_classification_multinom_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`klar_classification_naive_bayes()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`kknn_classification_nearest_neighbor()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`xrf_classification_rule_fit()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`kernlab_classification_svm_linear()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`liblinear_classification_svm_linear()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`kernlab_classification_svm_poly()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`kernlab_classification_svm_rbf()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  [`liquidsvm_classification_svm_rbf()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md)
  : Internal Model Builders for Classification
- [`lm_regression_linear_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`brulee_regression_linear_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`gee_regression_linear_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`glm_regression_linear_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`glmer_regression_linear_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`glmnet_regression_linear_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`gls_regression_linear_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`lme_regression_linear_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`lmer_regression_linear_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`stan_regression_linear_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`stan_glmer_regression_linear_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`cubist_regression_cubist_rules()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`glm_regression_poisson_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`gee_regression_poisson_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`glmer_regression_poisson_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`glmnet_regression_poisson_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`hurdle_regression_poisson_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`stan_regression_poisson_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`stan_glmer_regression_poisson_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`zeroinfl_regression_poisson_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`earth_regression_bag_mars()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`earth_regression_mars()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`rpart_regression_bag_tree()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`rpart_regression_decision_tree()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`partykit_regression_decision_tree()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`dbarts_regression_bart()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`xgboost_regression_boost_tree()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`lightgbm_regression_boost_tree()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`mgcv_regression_gen_additive_mod()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`nnet_regression_mlp()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`brulee_regression_mlp()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`kknn_regression_nearest_neighbor()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`ranger_regression_rand_forest()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`randomforest_regression_rand_forest()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`xrf_regression_rule_fit()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`liblinear_regression_svm_linear()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`kernlab_regression_svm_linear()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`kernlab_regression_svm_poly()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  [`kernlab_regression_svm_rbf()`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md)
  : Internal Model Builders for Regression
- [`internal_set_args_to_tune()`](https://www.spsanderson.com/tidyaml/reference/internal_set_args_to_tune.md)
  : Internals Make a Tunable Model Specification
- [`make_classification_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_classification_base_tbl.md)
  : Internals Make Base Classification Tibble
- [`make_regression_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_regression_base_tbl.md)
  : Internals Make Base Regression Tibble
