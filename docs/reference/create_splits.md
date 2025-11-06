# Utility Create Splits Object

Create a splits object.

## Usage

``` r
create_splits(.data, .split_type = "initial_split", .split_args = NULL)
```

## Arguments

- .data:

  The data being passed to make a split on

- .split_type:

  The default is "initial_split", you can pass any other split type from
  the `rsample` library.

- .split_args:

  The default is NULL in order to use the default split arguments. If
  you want to pass other arguments then must pass a list with the
  parameter name and the argument.

## Value

A list object

## Details

Create a splits object that returns a list object of both the splits
object itself and the splits type. This function supports all splits
types from the `rsample` package.

## See also

Other Utility:
[`check_duplicate_rows()`](https://www.spsanderson.com/tidyaml/reference/check_duplicate_rows.md),
[`core_packages()`](https://www.spsanderson.com/tidyaml/reference/core_packages.md),
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
create_splits(mtcars, .split_type = "vfold_cv")
#> $splits
#> #  10-fold cross-validation 
#> # A tibble: 10 × 2
#>    splits         id    
#>    <list>         <chr> 
#>  1 <split [28/4]> Fold01
#>  2 <split [28/4]> Fold02
#>  3 <split [29/3]> Fold03
#>  4 <split [29/3]> Fold04
#>  5 <split [29/3]> Fold05
#>  6 <split [29/3]> Fold06
#>  7 <split [29/3]> Fold07
#>  8 <split [29/3]> Fold08
#>  9 <split [29/3]> Fold09
#> 10 <split [29/3]> Fold10
#> 
#> $split_type
#> [1] "vfold_cv"
#> 
```
