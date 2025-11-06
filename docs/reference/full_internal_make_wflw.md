# Full Internal Workflow for Model and Recipe

This function creates a full internal workflow for a model and recipe
combination.

## Usage

``` r
full_internal_make_wflw(.model_tbl, .rec_obj)
```

## Arguments

- .model_tbl:

  A model specification table (`tidyaml_mod_spec_tbl`).

- .rec_obj:

  A recipe object.

## Value

The function returns a workflow object for the first model-recipe pair
based on the internal function selected.

## Details

The function checks if the input model specification table inherits the
class 'tidyaml_mod_spec_tbl'. It then manipulates the input table,
making adjustments for factors and creating a list of grouped models.
For each model-recipe pair, it uses the appropriate internal function
based on the model type to create a workflow object. The specific
internal function is selected using a switch statement based on the
class of the model.

## See also

Other Utility:
[`check_duplicate_rows()`](https://www.spsanderson.com/tidyaml/reference/check_duplicate_rows.md),
[`core_packages()`](https://www.spsanderson.com/tidyaml/reference/core_packages.md),
[`create_splits()`](https://www.spsanderson.com/tidyaml/reference/create_splits.md),
[`create_workflow_set()`](https://www.spsanderson.com/tidyaml/reference/create_workflow_set.md),
[`fast_classification_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_classification_parsnip_spec_tbl.md),
[`fast_regression_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_regression_parsnip_spec_tbl.md),
[`install_deps()`](https://www.spsanderson.com/tidyaml/reference/install_deps.md),
[`load_deps()`](https://www.spsanderson.com/tidyaml/reference/load_deps.md),
[`match_args()`](https://www.spsanderson.com/tidyaml/reference/match_args.md),
[`quantile_normalize()`](https://www.spsanderson.com/tidyaml/reference/quantile_normalize.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
library(dplyr)
library(recipes)

rec_obj <- recipe(mpg ~ ., data = mtcars)

mod_tbl <- make_regression_base_tbl()
mod_tbl <- mod_tbl |>
  filter(
    .parsnip_engine %in% c("lm", "glm") &
    .parsnip_fns == "linear_reg"
    )
class(mod_tbl) <- c("tidyaml_mod_spec_tbl", class(mod_tbl))
mod_spec_tbl <- internal_make_spec_tbl(mod_tbl)
result <- full_internal_make_wflw(mod_spec_tbl, rec_obj)
result
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
