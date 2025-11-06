# Functions to Install all Core Libraries

Lists the core packages necessary to run all potential modeling
algorithms.

## Usage

``` r
core_packages()
```

## Value

A character vector

## Details

Lists the core packages necessary to run all potential modeling
algorithms.

## See also

Other Utility:
[`check_duplicate_rows()`](https://www.spsanderson.com/tidyaml/reference/check_duplicate_rows.md),
[`create_splits()`](https://www.spsanderson.com/tidyaml/reference/create_splits.md),
[`create_workflow_set()`](https://www.spsanderson.com/tidyaml/reference/create_workflow_set.md),
[`fast_classification_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_classification_parsnip_spec_tbl.md),
[`fast_regression_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_regression_parsnip_spec_tbl.md),
[`full_internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/full_internal_make_wflw.md),
[`install_deps()`](https://www.spsanderson.com/tidyaml/reference/install_deps.md),
[`load_deps()`](https://www.spsanderson.com/tidyaml/reference/load_deps.md),
[`match_args()`](https://www.spsanderson.com/tidyaml/reference/match_args.md),
[`quantile_normalize()`](https://www.spsanderson.com/tidyaml/reference/quantile_normalize.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
core_packages()
#>  [1] "multilevelmod" "rules"         "poissonreg"    "censored"     
#>  [5] "baguette"      "bonsai"        "brulee"        "rstanarm"     
#>  [9] "dbarts"        "kknn"          "ranger"        "randomForest" 
#> [13] "LiblineaR"     "flexsurv"      "gee"           "glmnet"       
#> [17] "discrim"       "klaR"          "kernlab"       "mda"          
#> [21] "sda"           "sparsediscrim" "liquidSVM"    
```
