# Internals Make Base Regression Tibble

Creates a base tibble to create parsnip regression model specifications.

## Usage

``` r
make_regression_base_tbl()
```

## Value

A tibble

## Details

Creates a base tibble to create parsnip regression model specifications.

## See also

Other Internals:
[`internal_make_fitted_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_fitted_wflw.md),
[`internal_make_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/internal_make_spec_tbl.md),
[`internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw.md),
[`internal_make_wflw_gee_lin_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_gee_lin_reg.md),
[`internal_make_wflw_predictions()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_predictions.md),
[`internal_model_builders_classification`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md),
[`internal_model_builders_regression`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md),
[`internal_set_args_to_tune()`](https://www.spsanderson.com/tidyaml/reference/internal_set_args_to_tune.md),
[`make_classification_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_classification_base_tbl.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
make_regression_base_tbl()
#> # A tibble: 39 × 3
#>    .parsnip_engine .parsnip_mode .parsnip_fns
#>    <chr>           <chr>         <chr>       
#>  1 lm              regression    linear_reg  
#>  2 brulee          regression    linear_reg  
#>  3 gee             regression    linear_reg  
#>  4 glm             regression    linear_reg  
#>  5 glmer           regression    linear_reg  
#>  6 glmnet          regression    linear_reg  
#>  7 gls             regression    linear_reg  
#>  8 lme             regression    linear_reg  
#>  9 lmer            regression    linear_reg  
#> 10 stan            regression    linear_reg  
#> # ℹ 29 more rows
```
