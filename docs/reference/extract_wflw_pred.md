# Extract A Model Workflow Predictions

Extract a model workflow predictions from a tidyAML model tibble.

## Usage

``` r
extract_wflw_pred(.data, .model_id = NULL)
```

## Arguments

- .data:

  The model table that must have the class `tidyaml_mod_spec_tbl`.

- .model_id:

  The model number that you want to select, Must be an integer or
  sequence of integers, ie. `1` or `c(1,3,5)` or `1:2`

## Value

A tibble with the chosen model workflow(s).

## Details

This function allows you to get a model workflow predictions or more
from a tibble with a class of "tidyaml_mod_spec_tbl". It allows you to
select the model by the `.model_id` column. You can call the model id's
by an integer or a sequence of integers.

## See also

Other Extractor:
[`extract_model_spec()`](https://www.spsanderson.com/tidyaml/reference/extract_model_spec.md),
[`extract_regression_residuals()`](https://www.spsanderson.com/tidyaml/reference/extract_regression_residuals.md),
[`extract_tunable_params()`](https://www.spsanderson.com/tidyaml/reference/extract_tunable_params.md),
[`extract_wflw()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw.md),
[`extract_wflw_fit()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_fit.md),
[`get_model()`](https://www.spsanderson.com/tidyaml/reference/get_model.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
library(recipes)

rec_obj <- recipe(mpg ~ ., data = mtcars)
frt_tbl <- fast_regression(mtcars, rec_obj, .parsnip_eng = c("lm","glm"),
                                           .parsnip_fns = "linear_reg")

extract_wflw_pred(frt_tbl, 1)
#> # A tibble: 64 × 4
#>    .model_type     .data_category .data_type .value
#>    <chr>           <chr>          <chr>       <dbl>
#>  1 lm - linear_reg actual         actual       21  
#>  2 lm - linear_reg actual         actual       22.8
#>  3 lm - linear_reg actual         actual       32.4
#>  4 lm - linear_reg actual         actual       30.4
#>  5 lm - linear_reg actual         actual       16.4
#>  6 lm - linear_reg actual         actual       15.8
#>  7 lm - linear_reg actual         actual       14.7
#>  8 lm - linear_reg actual         actual       19.2
#>  9 lm - linear_reg actual         actual       30.4
#> 10 lm - linear_reg actual         actual       17.3
#> # ℹ 54 more rows
extract_wflw_pred(frt_tbl, 1:2)
#> # A tibble: 128 × 4
#>    .model_type     .data_category .data_type .value
#>    <chr>           <chr>          <chr>       <dbl>
#>  1 lm - linear_reg actual         actual       21  
#>  2 lm - linear_reg actual         actual       22.8
#>  3 lm - linear_reg actual         actual       32.4
#>  4 lm - linear_reg actual         actual       30.4
#>  5 lm - linear_reg actual         actual       16.4
#>  6 lm - linear_reg actual         actual       15.8
#>  7 lm - linear_reg actual         actual       14.7
#>  8 lm - linear_reg actual         actual       19.2
#>  9 lm - linear_reg actual         actual       30.4
#> 10 lm - linear_reg actual         actual       17.3
#> # ℹ 118 more rows
```
