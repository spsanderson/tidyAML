# Get a Model

Get a model from a tidyAML model tibble.

## Usage

``` r
get_model(.data, .model_id = NULL)
```

## Arguments

- .data:

  The model table that must have the class `tidyaml_mod_spec_tbl`.

- .model_id:

  The model number that you want to select, Must be an integer or
  sequence of integers, ie. `1` or `c(1,3,5)` or `1:2`

## Value

A tibble with the chosen models.

## Details

This function allows you to get a model or models from a tibble with a
class of "tidyaml_mod_spec_tbl". It allows you to select the model by
the `.model_id` column. You can call the model id's by an integer or a
sequence of integers.

## See also

Other Extractor:
[`extract_model_spec()`](https://www.spsanderson.com/tidyaml/reference/extract_model_spec.md),
[`extract_regression_residuals()`](https://www.spsanderson.com/tidyaml/reference/extract_regression_residuals.md),
[`extract_tunable_params()`](https://www.spsanderson.com/tidyaml/reference/extract_tunable_params.md),
[`extract_wflw()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw.md),
[`extract_wflw_fit()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_fit.md),
[`extract_wflw_pred()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_pred.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
library(recipes)

rec_obj <- recipe(mpg ~ ., data = mtcars)
spec_tbl <- fast_regression_parsnip_spec_tbl(
  .parsnip_fns = "linear_reg",
  .parsnip_eng = c("lm","glm")
)

get_model(spec_tbl, 1)
#> # A tibble: 1 × 5
#>   .model_id .parsnip_engine .parsnip_mode .parsnip_fns model_spec
#>       <int> <chr>           <chr>         <chr>        <list>    
#> 1         1 lm              regression    linear_reg   <spec[+]> 
get_model(spec_tbl, 1:2)
#> # A tibble: 2 × 5
#>   .model_id .parsnip_engine .parsnip_mode .parsnip_fns model_spec
#>       <int> <chr>           <chr>         <chr>        <list>    
#> 1         1 lm              regression    linear_reg   <spec[+]> 
#> 2         2 glm             regression    linear_reg   <spec[+]> 
```
