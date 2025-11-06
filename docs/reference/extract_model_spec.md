# Extract A Model Specification

Extract a model specification from a tidyAML model tibble.

## Usage

``` r
extract_model_spec(.data, .model_id = NULL)
```

## Arguments

- .data:

  The model table that must have the class `tidyaml_mod_spec_tbl`.

- .model_id:

  The model number that you want to select, Must be an integer or
  sequence of integers, ie. `1` or `c(1,3,5)` or `1:2`

## Value

A tibble with the chosen model specification(s).

## Details

This function allows you to get a model specification or more from a
tibble with a class of "tidyaml_mod_spec_tbl". It allows you to select
the model by the `.model_id` column. You can call the model id's by an
integer or a sequence of integers.

## See also

Other Extractor:
[`extract_regression_residuals()`](https://www.spsanderson.com/tidyaml/reference/extract_regression_residuals.md),
[`extract_tunable_params()`](https://www.spsanderson.com/tidyaml/reference/extract_tunable_params.md),
[`extract_wflw()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw.md),
[`extract_wflw_fit()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_fit.md),
[`extract_wflw_pred()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_pred.md),
[`get_model()`](https://www.spsanderson.com/tidyaml/reference/get_model.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
spec_tbl <- fast_regression_parsnip_spec_tbl(
  .parsnip_fns = "linear_reg",
  .parsnip_eng = c("lm","glm")
)

extract_model_spec(spec_tbl, 1)
#> [[1]]
#> Linear Regression Model Specification (regression)
#> 
#> Computational engine: lm 
#> 
#> 
extract_model_spec(spec_tbl, 1:2)
#> [[1]]
#> Linear Regression Model Specification (regression)
#> 
#> Computational engine: lm 
#> 
#> 
#> [[2]]
#> Linear Regression Model Specification (regression)
#> 
#> Computational engine: glm 
#> 
#> 
```
