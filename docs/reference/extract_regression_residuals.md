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
#>  1 lm - linear_reg    15         13.9  1.12  
#>  2 lm - linear_reg    21         21.6 -0.608 
#>  3 lm - linear_reg    18.1       19.7 -1.62  
#>  4 lm - linear_reg    21         21.5 -0.533 
#>  5 lm - linear_reg    30.4       30.4  0.0351
#>  6 lm - linear_reg    15.2       17.1 -1.93  
#>  7 lm - linear_reg    21.4       23.0 -1.55  
#>  8 lm - linear_reg    19.2       16.1  3.05  
#>  9 lm - linear_reg    10.4       11.4 -1.02  
#> 10 lm - linear_reg    32.4       27.6  4.81  
#> # ℹ 22 more rows
#> 
#> [[2]]
#> # A tibble: 32 × 4
#>    .model_type      .actual .predicted  .resid
#>    <chr>              <dbl>      <dbl>   <dbl>
#>  1 glm - linear_reg    15         13.9  1.12  
#>  2 glm - linear_reg    21         21.6 -0.608 
#>  3 glm - linear_reg    18.1       19.7 -1.62  
#>  4 glm - linear_reg    21         21.5 -0.533 
#>  5 glm - linear_reg    30.4       30.4  0.0351
#>  6 glm - linear_reg    15.2       17.1 -1.93  
#>  7 glm - linear_reg    21.4       23.0 -1.55  
#>  8 glm - linear_reg    19.2       16.1  3.05  
#>  9 glm - linear_reg    10.4       11.4 -1.02  
#> 10 glm - linear_reg    32.4       27.6  4.81  
#> # ℹ 22 more rows
#> 
extract_regression_residuals(fr_tbl, .pivot_long = TRUE)
#> [[1]]
#> # A tibble: 96 × 3
#>    .model_type     name        value
#>    <chr>           <chr>       <dbl>
#>  1 lm - linear_reg .actual    15    
#>  2 lm - linear_reg .predicted 13.9  
#>  3 lm - linear_reg .resid      1.12 
#>  4 lm - linear_reg .actual    21    
#>  5 lm - linear_reg .predicted 21.6  
#>  6 lm - linear_reg .resid     -0.608
#>  7 lm - linear_reg .actual    18.1  
#>  8 lm - linear_reg .predicted 19.7  
#>  9 lm - linear_reg .resid     -1.62 
#> 10 lm - linear_reg .actual    21    
#> # ℹ 86 more rows
#> 
#> [[2]]
#> # A tibble: 96 × 3
#>    .model_type      name        value
#>    <chr>            <chr>       <dbl>
#>  1 glm - linear_reg .actual    15    
#>  2 glm - linear_reg .predicted 13.9  
#>  3 glm - linear_reg .resid      1.12 
#>  4 glm - linear_reg .actual    21    
#>  5 glm - linear_reg .predicted 21.6  
#>  6 glm - linear_reg .resid     -0.608
#>  7 glm - linear_reg .actual    18.1  
#>  8 glm - linear_reg .predicted 19.7  
#>  9 glm - linear_reg .resid     -1.62 
#> 10 glm - linear_reg .actual    21    
#> # ℹ 86 more rows
#> 
```
