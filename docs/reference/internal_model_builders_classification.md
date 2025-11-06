# Internal Model Builders for Classification

Internal functions that build pre-configured parsnip model
specifications for classification models. Each function returns a
parsnip model specification with the mode and engine pre-set.

## Usage

``` r
earth_classification_bag_mars()

earth_classification_mars()

earth_classification_discrim_flexible()

dbarts_classification_bart()

mass_classification_discrim_linear()

mda_classification_discrim_linear()

sda_classification_discrim_linear()

sparsediscrim_classification_discrim_linear()

mass_classification_discrim_quad()

sparsediscrim_classification_discrim_quad()

klaR_classification_discrim_regularized()

mgcv_classification_gen_additive_mod()

brulee_classification_logistic_reg()

gee_classification_logistic_reg()

glm_classification_logistic_reg()

glmer_classification_logistic_reg()

glmnet_classification_logistic_reg()

liblinear_classification_logistic_reg()

brulee_classification_mlp()

nnet_classification_mlp()

brulee_classification_multinom_reg()

glmnet_classification_multinom_reg()

nnet_classification_multinom_reg()

klar_classification_naive_bayes()

kknn_classification_nearest_neighbor()

xrf_classification_rule_fit()

kernlab_classification_svm_linear()

liblinear_classification_svm_linear()

kernlab_classification_svm_poly()

kernlab_classification_svm_rbf()

liquidsvm_classification_svm_rbf()
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
[`internal_model_builders_regression`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md),
[`internal_set_args_to_tune()`](https://www.spsanderson.com/tidyaml/reference/internal_set_args_to_tune.md),
[`make_classification_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_classification_base_tbl.md),
[`make_regression_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_regression_base_tbl.md)

## Author

Steven P. Sanderson II, MPH
