# Extract Residuals from Fast Regression Models

This function extracts residuals from a fast regression model table
([`fast_regression()`](https://www.spsanderson.com/tidyaml/reference/fast_regression.md)).

## Usage

``` r
extract_regression_residuals(.model_tbl, .pivot_long = FALSE)
```

## Arguments

- .model_tbl:

  A fast regression model specification table (`fst_reg_spec_tbl`).

- .pivot_long:

  A logical value indicating if the output should be pivoted. The
  default is `FALSE`.

## Value

The function returns a list of data frames, each containing residuals,
actual values, and predicted values for a specific model.

## Details

The function checks if the input model specification table inherits the
class 'fst_reg_spec_tbl' and if it contains the column 'pred_wflw'. It
then manipulates the data, grouping it by model, and extracts residuals
for each model. The result is a list of data frames, each containing
residuals, actual values, and predicted values for a specific model.

## See also

Other Extractor:
[`extract_model_spec()`](https://www.spsanderson.com/tidyaml/reference/extract_model_spec.md),
[`extract_tunable_params()`](https://www.spsanderson.com/tidyaml/reference/extract_tunable_params.md),
[`extract_wflw()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw.md),
[`extract_wflw_fit()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_fit.md),
[`extract_wflw_pred()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_pred.md),
[`get_model()`](https://www.spsanderson.com/tidyaml/reference/get_model.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
library(recipes, quietly = TRUE)

rec_obj <- recipe(mpg ~ ., data = mtcars)

fr_tbl <- fast_regression(mtcars, rec_obj, .parsnip_eng = c("lm","glm"),
.parsnip_fns = "linear_reg")

extract_regression_residuals(fr_tbl)
#> [[1]]
#> # A tibble: 32 × 4
#>    .model_type     .actual .predicted  .resid
#>    <chr>             <dbl>      <dbl>   <dbl>
#>  1 lm - linear_reg    21.5       23.5 -1.97  
#>  2 lm - linear_reg    18.1       19.6 -1.54  
#>  3 lm - linear_reg    22.8       24.2 -1.43  
#>  4 lm - linear_reg    15.5       16.3 -0.815 
#>  5 lm - linear_reg    19.2       19.2  0.0490
#>  6 lm - linear_reg    21.4       23.0 -1.64  
#>  7 lm - linear_reg    21         21.2 -0.244 
#>  8 lm - linear_reg    14.7       10.0  4.66  
#>  9 lm - linear_reg    33.9       28.5  5.43  
#> 10 lm - linear_reg    15.8       18.4 -2.60  
#> # ℹ 22 more rows
#> 
#> [[2]]
#> # A tibble: 32 × 4
#>    .model_type      .actual .predicted  .resid
#>    <chr>              <dbl>      <dbl>   <dbl>
#>  1 glm - linear_reg    21.5       23.5 -1.97  
#>  2 glm - linear_reg    18.1       19.6 -1.54  
#>  3 glm - linear_reg    22.8       24.2 -1.43  
#>  4 glm - linear_reg    15.5       16.3 -0.815 
#>  5 glm - linear_reg    19.2       19.2  0.0490
#>  6 glm - linear_reg    21.4       23.0 -1.64  
#>  7 glm - linear_reg    21         21.2 -0.244 
#>  8 glm - linear_reg    14.7       10.0  4.66  
#>  9 glm - linear_reg    33.9       28.5  5.43  
#> 10 glm - linear_reg    15.8       18.4 -2.60  
#> # ℹ 22 more rows
#> 
extract_regression_residuals(fr_tbl, .pivot_long = TRUE)
#> [[1]]
#> # A tibble: 96 × 3
#>    .model_type     name       value
#>    <chr>           <chr>      <dbl>
#>  1 lm - linear_reg .actual    21.5 
#>  2 lm - linear_reg .predicted 23.5 
#>  3 lm - linear_reg .resid     -1.97
#>  4 lm - linear_reg .actual    18.1 
#>  5 lm - linear_reg .predicted 19.6 
#>  6 lm - linear_reg .resid     -1.54
#>  7 lm - linear_reg .actual    22.8 
#>  8 lm - linear_reg .predicted 24.2 
#>  9 lm - linear_reg .resid     -1.43
#> 10 lm - linear_reg .actual    15.5 
#> # ℹ 86 more rows
#> 
#> [[2]]
#> # A tibble: 96 × 3
#>    .model_type      name       value
#>    <chr>            <chr>      <dbl>
#>  1 glm - linear_reg .actual    21.5 
#>  2 glm - linear_reg .predicted 23.5 
#>  3 glm - linear_reg .resid     -1.97
#>  4 glm - linear_reg .actual    18.1 
#>  5 glm - linear_reg .predicted 19.6 
#>  6 glm - linear_reg .resid     -1.54
#>  7 glm - linear_reg .actual    22.8 
#>  8 glm - linear_reg .predicted 24.2 
#>  9 glm - linear_reg .resid     -1.43
#> 10 glm - linear_reg .actual    15.5 
#> # ℹ 86 more rows
#> 
```
