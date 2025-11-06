# Check for Duplicate Rows in a Data Frame

This function checks for duplicate rows in a data frame.

## Usage

``` r
check_duplicate_rows(.data)
```

## Arguments

- .data:

  A data frame.

## Value

A logical vector indicating whether each row is a duplicate or not.

## Details

This function checks for duplicate rows by comparing each row in the
data frame to every other row. If a row is identical to another row, it
is considered a duplicate.

## See also

[`duplicated`](https://rdrr.io/r/base/duplicated.html),
[`anyDuplicated`](https://rdrr.io/r/base/duplicated.html)

Other Utility:
[`core_packages()`](https://www.spsanderson.com/tidyaml/reference/core_packages.md),
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
data <- data.frame(
  x = c(1, 2, 3, 1),
  y = c(2, 3, 4, 2),
  z = c(3, 2, 5, 3)
)

check_duplicate_rows(data)
#> [1] FALSE  TRUE FALSE FALSE
```
