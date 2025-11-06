# Internals Make Base Classification Tibble

Creates a base tibble to create parsnip classification model
specifications.

## Usage

``` r
make_classification_base_tbl()
```

## Value

A tibble

## Details

Creates a base tibble to create parsnip classification model
specifications.

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
[`make_regression_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_regression_base_tbl.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
make_classification_base_tbl()
#> # A tibble: 31 × 3
#>    .parsnip_engine .parsnip_mode  .parsnip_fns       
#>    <chr>           <chr>          <chr>              
#>  1 earth           classification bag_mars           
#>  2 earth           classification discrim_flexible   
#>  3 dbarts          classification bart               
#>  4 MASS            classification discrim_linear     
#>  5 mda             classification discrim_linear     
#>  6 sda             classification discrim_linear     
#>  7 sparsediscrim   classification discrim_linear     
#>  8 MASS            classification discrim_quad       
#>  9 sparsediscrim   classification discrim_quad       
#> 10 klaR            classification discrim_regularized
#> # ℹ 21 more rows
```
