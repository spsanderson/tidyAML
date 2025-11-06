# Internals Safely Make a Fitted Workflow from Model Spec tibble

Safely Make a fitted workflow from a model spec tibble.

## Usage

``` r
internal_make_fitted_wflw(.model_tbl, .splits_obj)
```

## Arguments

- .model_tbl:

  The model table that is generated from a function like
  [`fast_regression_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_regression_parsnip_spec_tbl.md),
  must have a class of "tidyaml_mod_spec_tbl". This is meant to be used
  after the function
  [`internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw.md)
  has been run and the tibble has been saved.

- .splits_obj:

  The splits object from the auto_ml function. It is internal to the
  `auto_ml_` function.

## Value

A list object of workflows.

## Details

Create a fitted `parnsip` model from a `workflow` object.

## See also

Other Internals:
[`internal_make_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/internal_make_spec_tbl.md),
[`internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw.md),
[`internal_make_wflw_gee_lin_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_gee_lin_reg.md),
[`internal_make_wflw_predictions()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_predictions.md),
[`internal_model_builders_classification`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md),
[`internal_model_builders_regression`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md),
[`internal_set_args_to_tune()`](https://www.spsanderson.com/tidyaml/reference/internal_set_args_to_tune.md),
[`make_classification_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_classification_base_tbl.md),
[`make_regression_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_regression_base_tbl.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
library(recipes, quietly = TRUE)

mod_spec_tbl <- fast_regression_parsnip_spec_tbl(
  .parsnip_eng = c("lm","glm"),
  .parsnip_fns = "linear_reg"
)

rec_obj <- recipe(mpg ~ ., data = mtcars)
splits_obj <- create_splits(mtcars, "initial_split")

mod_tbl <- mod_spec_tbl |>
  mutate(wflw = full_internal_make_wflw(mod_spec_tbl, rec_obj))

internal_make_fitted_wflw(mod_tbl, splits_obj)
#> [[1]]
#> ══ Workflow [trained] ══════════════════════════════════════════════════════════
#> Preprocessor: Recipe
#> Model: linear_reg()
#> 
#> ── Preprocessor ────────────────────────────────────────────────────────────────
#> 0 Recipe Steps
#> 
#> ── Model ───────────────────────────────────────────────────────────────────────
#> 
#> Call:
#> stats::lm(formula = ..y ~ ., data = data)
#> 
#> Coefficients:
#> (Intercept)          cyl         disp           hp         drat           wt  
#>    16.51837     -0.50076      0.01985     -0.03085      0.49398     -2.51001  
#>        qsec           vs           am         gear         carb  
#>     0.59043      1.69088      4.26327      0.18528     -0.07205  
#> 
#> 
#> [[2]]
#> ══ Workflow [trained] ══════════════════════════════════════════════════════════
#> Preprocessor: Recipe
#> Model: linear_reg()
#> 
#> ── Preprocessor ────────────────────────────────────────────────────────────────
#> 0 Recipe Steps
#> 
#> ── Model ───────────────────────────────────────────────────────────────────────
#> 
#> Call:  stats::glm(formula = ..y ~ ., family = stats::gaussian, data = data)
#> 
#> Coefficients:
#> (Intercept)          cyl         disp           hp         drat           wt  
#>    16.51837     -0.50076      0.01985     -0.03085      0.49398     -2.51001  
#>        qsec           vs           am         gear         carb  
#>     0.59043      1.69088      4.26327      0.18528     -0.07205  
#> 
#> Degrees of Freedom: 23 Total (i.e. Null);  13 Residual
#> Null Deviance:       802.4 
#> Residual Deviance: 118.2     AIC: 130.4
#> 
```
