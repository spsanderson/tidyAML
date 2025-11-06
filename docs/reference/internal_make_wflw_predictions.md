# Internals Safely Make Predictions on a Fitted Workflow from Model Spec tibble

Safely Make predictions on a fitted workflow from a model spec tibble.

## Usage

``` r
internal_make_wflw_predictions(.model_tbl, .splits_obj)
```

## Arguments

- .model_tbl:

  The model table that is generated from a function like
  [`fast_regression_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_regression_parsnip_spec_tbl.md),
  must have a class of "tidyaml_mod_spec_tbl". This is meant to be used
  after the function
  [`internal_make_fitted_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_fitted_wflw.md)
  has been run and the tibble has been saved.

- .splits_obj:

  The splits object from the auto_ml function. It is internal to the
  `auto_ml_` function.

## Value

A list object tibble of the outcome variable and it's values along with
the testing and training predictions in a single tibble.

|                |            |        |
|----------------|------------|--------|
| .data_category | .data_type | .value |
| actual         | actual     | 21.0   |
| actual         | actual     | 21.0   |
| actual         | actual     | 22.8   |
| ...            | ...        | ...    |
| predicted      | training   | 21.0   |
| ...            | ...        | ...    |
| predicted      | training   | 21.0   |

## Details

Create predictions on a fitted `parnsip` model from a `workflow` object.

## See also

Other Internals:
[`internal_make_fitted_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_fitted_wflw.md),
[`internal_make_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/internal_make_spec_tbl.md),
[`internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw.md),
[`internal_make_wflw_gee_lin_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_gee_lin_reg.md),
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

mod_fitted_tbl <- mod_tbl |>
  mutate(fitted_wflw = internal_make_fitted_wflw(mod_tbl, splits_obj))

internal_make_wflw_predictions(mod_fitted_tbl, splits_obj)
#> [[1]]
#> # A tibble: 64 × 3
#>    .data_category .data_type .value
#>    <chr>          <chr>       <dbl>
#>  1 actual         actual       30.4
#>  2 actual         actual       10.4
#>  3 actual         actual       15.2
#>  4 actual         actual       17.3
#>  5 actual         actual       21.5
#>  6 actual         actual       22.8
#>  7 actual         actual       15.5
#>  8 actual         actual       21  
#>  9 actual         actual       21  
#> 10 actual         actual       19.7
#> # ℹ 54 more rows
#> 
#> [[2]]
#> # A tibble: 64 × 3
#>    .data_category .data_type .value
#>    <chr>          <chr>       <dbl>
#>  1 actual         actual       30.4
#>  2 actual         actual       10.4
#>  3 actual         actual       15.2
#>  4 actual         actual       17.3
#>  5 actual         actual       21.5
#>  6 actual         actual       22.8
#>  7 actual         actual       15.5
#>  8 actual         actual       21  
#>  9 actual         actual       21  
#> 10 actual         actual       19.7
#> # ℹ 54 more rows
#> 
```
