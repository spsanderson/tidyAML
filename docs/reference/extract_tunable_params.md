# Extract Tunable Parameters from Model Specifications

Extract a list of tunable parameters from the `.model_spec` column of a
`tidyaml_mod_spec_tbl`.

## Usage

``` r
extract_tunable_params(.model_tbl)
```

## Arguments

- .model_tbl:

  A model table with a class of `tidyaml_mod_spec_tbl`.

## Value

A list of tibbles, each containing the tunable parameters for a model.

## Details

This function iterates over the `.model_spec` column of a model table
and extracts tunable parameters for each model using
[`tunable()`](https://generics.r-lib.org/reference/tunable.html). The
result is a list that can be further processed into a tibble if needed.

## See also

Other Extractor:
[`extract_model_spec()`](https://www.spsanderson.com/tidyaml/reference/extract_model_spec.md),
[`extract_regression_residuals()`](https://www.spsanderson.com/tidyaml/reference/extract_regression_residuals.md),
[`extract_wflw()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw.md),
[`extract_wflw_fit()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_fit.md),
[`extract_wflw_pred()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_pred.md),
[`get_model()`](https://www.spsanderson.com/tidyaml/reference/get_model.md)

## Examples

``` r
library(dplyr)
mods <- fast_regression_parsnip_spec_tbl(
  .parsnip_fns = "linear_reg",
  .parsnip_eng = c("lm","glmnet")
  )
extract_tunable_params(mods)
#> [[1]]
#> # A tibble: 0 × 5
#> # ℹ 5 variables: name <chr>, call_info <list>, source <chr>, component <chr>,
#> #   component_id <chr>
#> 
#> [[2]]
#> # A tibble: 2 × 5
#>   name    call_info        source     component  component_id
#>   <chr>   <list>           <chr>      <chr>      <chr>       
#> 1 penalty <named list [2]> model_spec linear_reg main        
#> 2 mixture <named list [3]> model_spec linear_reg main        
#> 
```
