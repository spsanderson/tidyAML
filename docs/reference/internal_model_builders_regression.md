# Internal Model Builders for Regression

Internal functions that build pre-configured parsnip model
specifications for regression models. Each function returns a parsnip
model specification with the mode and engine pre-set.

## Usage

``` r
lm_regression_linear_reg()

brulee_regression_linear_reg()

gee_regression_linear_reg()

glm_regression_linear_reg()

glmer_regression_linear_reg()

glmnet_regression_linear_reg()

gls_regression_linear_reg()

lme_regression_linear_reg()

lmer_regression_linear_reg()

stan_regression_linear_reg()

stan_glmer_regression_linear_reg()

cubist_regression_cubist_rules()

glm_regression_poisson_reg()

gee_regression_poisson_reg()

glmer_regression_poisson_reg()

glmnet_regression_poisson_reg()

hurdle_regression_poisson_reg()

stan_regression_poisson_reg()

stan_glmer_regression_poisson_reg()

zeroinfl_regression_poisson_reg()

earth_regression_bag_mars()

earth_regression_mars()

rpart_regression_bag_tree()

rpart_regression_decision_tree()

partykit_regression_decision_tree()

dbarts_regression_bart()

xgboost_regression_boost_tree()

lightgbm_regression_boost_tree()

mgcv_regression_gen_additive_mod()

nnet_regression_mlp()

brulee_regression_mlp()

kknn_regression_nearest_neighbor()

ranger_regression_rand_forest()

randomforest_regression_rand_forest()

xrf_regression_rule_fit()

liblinear_regression_svm_linear()

kernlab_regression_svm_linear()

kernlab_regression_svm_poly()

kernlab_regression_svm_rbf()
```

## Value

A parsnip model specification object

## Details

These functions are used internally by
[`internal_make_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/internal_make_spec_tbl.md)
to create model specifications. Each function follows the naming
pattern: `{engine}_{mode}_{parsnip_function}()`

## See also

Other Internals:
[`internal_make_fitted_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_fitted_wflw.md),
[`internal_make_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/internal_make_spec_tbl.md),
[`internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw.md),
[`internal_make_wflw_gee_lin_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_gee_lin_reg.md),
[`internal_make_wflw_predictions()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_predictions.md),
[`internal_model_builders_classification`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md),
[`internal_set_args_to_tune()`](https://www.spsanderson.com/tidyaml/reference/internal_set_args_to_tune.md),
[`make_classification_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_classification_base_tbl.md),
[`make_regression_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_regression_base_tbl.md)

## Author

Steven P. Sanderson II, MPH
