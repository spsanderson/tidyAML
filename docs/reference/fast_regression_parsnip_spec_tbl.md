# Utility Regression call to `parsnip`

Creates a tibble of parsnip regression model specifications.

## Usage

``` r
fast_regression_parsnip_spec_tbl(.parsnip_fns = "all", .parsnip_eng = "all")
```

## Arguments

- .parsnip_fns:

  The default for this is set to `all`. This means that all of the
  parsnip **linear regression** functions will be used, for example
  [`linear_reg()`](https://parsnip.tidymodels.org/reference/linear_reg.html),
  or `cubist_rules`. You can also choose to pass a c() vector like
  `c("linear_reg","cubist_rules")`

- .parsnip_eng:

  The default for this is set to `all`. This means that all of the
  parsnip **linear regression engines** will be used, for example `lm`,
  or `glm`. You can also choose to pass a c() vector like
  `c('lm', 'glm')`

## Value

A tibble with an added class of 'fst_reg_spec_tbl'

## Details

Creates a tibble of parsnip regression model specifications. This will
create a tibble of 46 different regression model specifications which
can be filtered. The model specs are created first and then filtered
out. This will only create models for **regression** problems. To find
all of the supported models in this package you can visit
<https://www.tidymodels.org/find/parsnip/>

## See also

Other Utility:
[`check_duplicate_rows()`](https://www.spsanderson.com/tidyaml/reference/check_duplicate_rows.md),
[`core_packages()`](https://www.spsanderson.com/tidyaml/reference/core_packages.md),
[`create_splits()`](https://www.spsanderson.com/tidyaml/reference/create_splits.md),
[`create_workflow_set()`](https://www.spsanderson.com/tidyaml/reference/create_workflow_set.md),
[`fast_classification_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_classification_parsnip_spec_tbl.md),
[`full_internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/full_internal_make_wflw.md),
[`install_deps()`](https://www.spsanderson.com/tidyaml/reference/install_deps.md),
[`load_deps()`](https://www.spsanderson.com/tidyaml/reference/load_deps.md),
[`match_args()`](https://www.spsanderson.com/tidyaml/reference/match_args.md),
[`quantile_normalize()`](https://www.spsanderson.com/tidyaml/reference/quantile_normalize.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
fast_regression_parsnip_spec_tbl(.parsnip_fns = "linear_reg")
#> # A tibble: 11 × 5
#>    .model_id .parsnip_engine .parsnip_mode .parsnip_fns model_spec
#>        <int> <chr>           <chr>         <chr>        <list>    
#>  1         1 lm              regression    linear_reg   <spec[+]> 
#>  2         2 brulee          regression    linear_reg   <spec[+]> 
#>  3         3 gee             regression    linear_reg   <spec[+]> 
#>  4         4 glm             regression    linear_reg   <spec[+]> 
#>  5         5 glmer           regression    linear_reg   <spec[+]> 
#>  6         6 glmnet          regression    linear_reg   <spec[+]> 
#>  7         7 gls             regression    linear_reg   <spec[+]> 
#>  8         8 lme             regression    linear_reg   <spec[+]> 
#>  9         9 lmer            regression    linear_reg   <spec[+]> 
#> 10        10 stan            regression    linear_reg   <spec[+]> 
#> 11        11 stan_glmer      regression    linear_reg   <spec[+]> 
fast_regression_parsnip_spec_tbl(.parsnip_eng = c("lm","glm"))
#> # A tibble: 3 × 5
#>   .model_id .parsnip_engine .parsnip_mode .parsnip_fns model_spec
#>       <int> <chr>           <chr>         <chr>        <list>    
#> 1         1 lm              regression    linear_reg   <spec[+]> 
#> 2         2 glm             regression    linear_reg   <spec[+]> 
#> 3         3 glm             regression    poisson_reg  <spec[+]> 
```
