# Utility Classification call to `parsnip`

Creates a tibble of parsnip classification model specifications.

## Usage

``` r
fast_classification_parsnip_spec_tbl(
  .parsnip_fns = "all",
  .parsnip_eng = "all"
)
```

## Arguments

- .parsnip_fns:

  The default for this is set to `all`. This means that all of the
  parsnip **classification** functions will be used, for example
  [`bag_mars()`](https://parsnip.tidymodels.org/reference/bag_mars.html),
  or [`bart()`](https://parsnip.tidymodels.org/reference/bart.html). You
  can also choose to pass a c() vector like `c("barg_mars","bart")`

- .parsnip_eng:

  The default for this is set to `all`. This means that all of the
  parsnip **classification engines** will be used, for example `earth`,
  or `dbarts`. You can also choose to pass a c() vector like
  `c('earth', 'dbarts')`

## Value

A tibble with an added class of 'fst_class_spec_tbl'

## Details

Creates a tibble of parsnip classification model specifications. This
will create a tibble of 32 different classification model specifications
which can be filtered. The model specs are created first and then
filtered out. This will only create models for **classification**
problems. To find all of the supported models in this package you can
visit <https://www.tidymodels.org/find/parsnip/>

## See also

Other Utility:
[`check_duplicate_rows()`](https://www.spsanderson.com/tidyaml/reference/check_duplicate_rows.md),
[`core_packages()`](https://www.spsanderson.com/tidyaml/reference/core_packages.md),
[`create_splits()`](https://www.spsanderson.com/tidyaml/reference/create_splits.md),
[`create_workflow_set()`](https://www.spsanderson.com/tidyaml/reference/create_workflow_set.md),
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
fast_classification_parsnip_spec_tbl(.parsnip_fns = "logistic_reg")
#> # A tibble: 6 × 5
#>   .model_id .parsnip_engine .parsnip_mode  .parsnip_fns model_spec
#>       <int> <chr>           <chr>          <chr>        <list>    
#> 1         1 brulee          classification logistic_reg <spec[+]> 
#> 2         2 gee             classification logistic_reg <spec[+]> 
#> 3         3 glm             classification logistic_reg <spec[+]> 
#> 4         4 glmer           classification logistic_reg <spec[+]> 
#> 5         5 glmnet          classification logistic_reg <spec[+]> 
#> 6         6 LiblineaR       classification logistic_reg <spec[+]> 
fast_classification_parsnip_spec_tbl(.parsnip_eng = c("earth","dbarts"))
#> # A tibble: 4 × 5
#>   .model_id .parsnip_engine .parsnip_mode  .parsnip_fns     model_spec
#>       <int> <chr>           <chr>          <chr>            <list>    
#> 1         1 earth           classification bag_mars         <spec[+]> 
#> 2         2 earth           classification discrim_flexible <spec[+]> 
#> 3         3 dbarts          classification bart             <spec[+]> 
#> 4         4 earth           classification mars             <spec[+]> 
```
