# Internals Safely Make Workflow for GEE Linear Regression

Safely Make a workflow from a model spec tibble.

## Usage

``` r
internal_make_wflw_gee_lin_reg(.model_tbl, .rec_obj)
```

## Arguments

- .model_tbl:

  The model table that is generated from a function like
  [`fast_regression_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_regression_parsnip_spec_tbl.md),
  must have a class of "tidyaml_mod_spec_tbl".

- .rec_obj:

  The recipe object that is going to be used to make the workflow
  object.

## Value

A list object of workflows.

## Details

Create a model specification tibble that has a
[`workflows::workflow()`](https://workflows.tidymodels.org/reference/workflow.html)
list column.

## See also

Other Internals:
[`internal_make_fitted_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_fitted_wflw.md),
[`internal_make_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/internal_make_spec_tbl.md),
[`internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw.md),
[`internal_make_wflw_predictions()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_predictions.md),
[`internal_model_builders_classification`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md),
[`internal_model_builders_regression`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md),
[`internal_set_args_to_tune()`](https://www.spsanderson.com/tidyaml/reference/internal_set_args_to_tune.md),
[`make_classification_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_classification_base_tbl.md),
[`make_regression_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_regression_base_tbl.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
library(dplyr)
library(recipes)
library(multilevelmod)
#> Error in library(multilevelmod): there is no package called 'multilevelmod'

mod_tbl <- make_regression_base_tbl()
mod_tbl <- mod_tbl |>
  filter(
  .parsnip_engine %in% c("gee") &
  .parsnip_fns == "linear_reg"
  )

class(mod_tbl) <- c("tidyaml_mod_spec_tbl", class(mod_tbl))
mod_spec_tbl <- internal_make_spec_tbl(mod_tbl)
rec_obj <- recipe(mpg ~ ., data = mtcars)

internal_make_wflw_gee_lin_reg(mod_spec_tbl, rec_obj)
#> Error in `.f()`:
#> ! parsnip could not locate an implementation for `linear_reg` regression
#>   model specifications using the `gee` engine.
#> ℹ The parsnip extension package multilevelmod implements support for this
#>   specification.
#> ℹ Please install (if needed) and load to continue.
#> [[1]]
#> NULL
#> 
```
