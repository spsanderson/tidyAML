# Extract A Model Workflow

Extract a model workflow from a tidyAML model tibble.

## Usage

``` r
extract_wflw(.data, .model_id = NULL)
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

This function allows you to get a model workflow or more from a tibble
with a class of "tidyaml_mod_spec_tbl". It allows you to select the
model by the `.model_id` column. You can call the model id's by an
integer or a sequence of integers.

## See also

Other Extractor:
[`extract_model_spec()`](https://www.spsanderson.com/tidyaml/reference/extract_model_spec.md),
[`extract_regression_residuals()`](https://www.spsanderson.com/tidyaml/reference/extract_regression_residuals.md),
[`extract_tunable_params()`](https://www.spsanderson.com/tidyaml/reference/extract_tunable_params.md),
[`extract_wflw_fit()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_fit.md),
[`extract_wflw_pred()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_pred.md),
[`get_model()`](https://www.spsanderson.com/tidyaml/reference/get_model.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
library(recipes)

rec_obj <- recipe(mpg ~ ., data = mtcars)
frt_tbl <- fast_regression(mtcars, rec_obj, .parsnip_eng = c("lm","glm"),
                                           .parsnip_fns = "linear_reg")

extract_wflw(frt_tbl, 1)
#> [[1]]
#> ══ Workflow ════════════════════════════════════════════════════════════════════
#> Preprocessor: Recipe
#> Model: linear_reg()
#> 
#> ── Preprocessor ────────────────────────────────────────────────────────────────
#> 0 Recipe Steps
#> 
#> ── Model ───────────────────────────────────────────────────────────────────────
#> Linear Regression Model Specification (regression)
#> 
#> Computational engine: lm 
#> 
#> 
extract_wflw(frt_tbl, 1:2)
#> [[1]]
#> ══ Workflow ════════════════════════════════════════════════════════════════════
#> Preprocessor: Recipe
#> Model: linear_reg()
#> 
#> ── Preprocessor ────────────────────────────────────────────────────────────────
#> 0 Recipe Steps
#> 
#> ── Model ───────────────────────────────────────────────────────────────────────
#> Linear Regression Model Specification (regression)
#> 
#> Computational engine: lm 
#> 
#> 
#> [[2]]
#> ══ Workflow ════════════════════════════════════════════════════════════════════
#> Preprocessor: Recipe
#> Model: linear_reg()
#> 
#> ── Preprocessor ────────────────────────────────────────────────────────────────
#> 0 Recipe Steps
#> 
#> ── Model ───────────────────────────────────────────────────────────────────────
#> Linear Regression Model Specification (regression)
#> 
#> Computational engine: glm 
#> 
#> 
```
