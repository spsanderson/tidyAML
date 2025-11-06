# Internals Make a Tunable Model Specification

Make a tuned model specification object.

## Usage

``` r
internal_set_args_to_tune(.model_tbl)
```

## Arguments

- .model_tbl:

  The model table that is generated from a function like
  [`fast_regression_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_regression_parsnip_spec_tbl.md),
  must have a class of "tidyaml_mod_spec_tbl".

## Value

A list object of workflows.

## Details

This will take a model specification that is created from a function
like
[`fast_regression_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_regression_parsnip_spec_tbl.md)
and update the **model_spec** `args` to
[`tune::tune()`](https://hardhat.tidymodels.org/reference/tune.html).
This is done dynamically, meaning you do not need to know the names of
the parameters inside of the model specification.

## See also

Other Internals:
[`internal_make_fitted_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_fitted_wflw.md),
[`internal_make_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/internal_make_spec_tbl.md),
[`internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw.md),
[`internal_make_wflw_gee_lin_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_gee_lin_reg.md),
[`internal_make_wflw_predictions()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_predictions.md),
[`internal_model_builders_classification`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_classification.md),
[`internal_model_builders_regression`](https://www.spsanderson.com/tidyaml/reference/internal_model_builders_regression.md),
[`make_classification_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_classification_base_tbl.md),
[`make_regression_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_regression_base_tbl.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
library(dplyr)

mod_tbl <- fast_regression_parsnip_spec_tbl()
mod_tbl$model_spec[[1]]
#> Linear Regression Model Specification (regression)
#> 
#> Computational engine: lm 
#> 

updated_mod_tbl <- mod_tbl |>
  mutate(model_spec = internal_set_args_to_tune(mod_tbl))
updated_mod_tbl$model_spec[[1]]
#> Linear Regression Model Specification (regression)
#> 
#> Main Arguments:
#>   penalty = tune::tune()
#>   mixture = tune::tune()
#> 
#> Computational engine: lm 
#> 
```
