# Perform quantile normalization on a numeric matrix/data.frame

This function will perform quantile normalization on two or more
distributions of equal length. Quantile normalization is a technique
used to make the distribution of values across different samples more
similar. It ensures that the distributions of values for each sample
have the same quantiles. This function takes a numeric matrix as input
and returns a quantile-normalized matrix.

## Usage

``` r
quantile_normalize(.data, .return_tibble = FALSE)
```

## Arguments

- .data:

  A numeric matrix where each column represents a sample.

- .return_tibble:

  A logical value that determines if the output should be a tibble.
  Default is 'FALSE'.

## Value

A list object that has the following:

1.  A numeric matrix that has been quantile normalized.

2.  The row means of the quantile normalized matrix.

3.  The sorted data

4.  The ranked indices

## Details

This function performs quantile normalization on a numeric matrix by
following these steps:

1.  Sort each column of the input matrix.

2.  Calculate the mean of each row across the sorted columns.

3.  Replace each column's sorted values with the row means.

4.  Unsort the columns to their original order.

## See also

[`rowMeans`](https://rdrr.io/r/base/colSums.html): Calculate row means.

[`apply`](https://rdrr.io/r/base/apply.html): Apply a function over the
margins of an array.

[`order`](https://rdrr.io/r/base/order.html): Order the elements of a
vector.

Other Utility:
[`check_duplicate_rows()`](https://www.spsanderson.com/tidyaml/reference/check_duplicate_rows.md),
[`core_packages()`](https://www.spsanderson.com/tidyaml/reference/core_packages.md),
[`create_splits()`](https://www.spsanderson.com/tidyaml/reference/create_splits.md),
[`create_workflow_set()`](https://www.spsanderson.com/tidyaml/reference/create_workflow_set.md),
[`fast_classification_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_classification_parsnip_spec_tbl.md),
[`fast_regression_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_regression_parsnip_spec_tbl.md),
[`full_internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/full_internal_make_wflw.md),
[`install_deps()`](https://www.spsanderson.com/tidyaml/reference/install_deps.md),
[`load_deps()`](https://www.spsanderson.com/tidyaml/reference/load_deps.md),
[`match_args()`](https://www.spsanderson.com/tidyaml/reference/match_args.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
# Create a sample numeric matrix
data <- matrix(rnorm(20), ncol = 4)

# Perform quantile normalization
normalized_data <- quantile_normalize(data)
#> Warning: There are duplicated ranks the input data.
normalized_data
#> $normalized_data
#>            [,1]       [,2]       [,3]       [,4]
#> [1,]  0.4357278 -1.1090827 -0.7464220 -1.1090827
#> [2,] -1.1090827 -0.1385169 -1.1090827 -0.7464220
#> [3,] -0.1385169 -0.7464220 -0.1385169  0.4357278
#> [4,] -0.7464220  0.4357278  0.4357278  0.5583424
#> [5,]  0.5583424  0.5583424  0.5583424 -0.1385169
#> 
#> $row_means
#> [1] -1.1090827 -0.7464220 -0.1385169  0.4357278  0.5583424
#> 
#> $duplicated_ranks
#>      [,1] [,2] [,3] [,4]
#> [1,]    3    2    2    4
#> [2,]    1    5    3    3
#> [3,]    4    1    1    1
#> [4,]    5    4    5    5
#> [5,]    2    3    4    2
#> 
#> $duplicated_rank_row_indices
#> [1] 1 2 3 4 5
#> 
#> $duplicated_rank_data
#>            [,1]        [,2]        [,3]       [,4]
#> [1,] -0.7992955 -0.01695794 -0.75096428  0.4854515
#> [2,]  0.4700128 -0.54159436 -1.25336629  0.9169820
#> [3,] -1.1501805  0.87581342 -1.03623626 -0.9853439
#> [4,] -0.2715967  0.74083815 -0.02943857 -1.4911897
#> [5,]  0.4574242 -0.16481239 -0.27494378  0.8195924
#> 

as.data.frame(normalized_data$normalized_data) |>
  sapply(function(x) quantile(x, probs = seq(0, 1, 1 / 4)))
#>              V1         V2         V3         V4
#> 0%   -1.1090827 -1.1090827 -1.1090827 -1.1090827
#> 25%  -0.7464220 -0.7464220 -0.7464220 -0.7464220
#> 50%  -0.1385169 -0.1385169 -0.1385169 -0.1385169
#> 75%   0.4357278  0.4357278  0.4357278  0.4357278
#> 100%  0.5583424  0.5583424  0.5583424  0.5583424

quantile_normalize(data, .return_tibble = TRUE)
#> New names:
#> • `` -> `...1`
#> • `` -> `...2`
#> • `` -> `...3`
#> • `` -> `...4`
#> Warning: The `x` argument of `as_tibble.matrix()` must have unique column names if
#> `.name_repair` is omitted as of tibble 2.0.0.
#> ℹ Using compatibility `.name_repair`.
#> ℹ The deprecated feature was likely used in the tidyAML package.
#>   Please report the issue at <https://github.com/spsanderson/tidyAML/issues>.
#> Warning: There are duplicated ranks the input data.
#> $normalized_data
#> # A tibble: 5 × 4
#>     ...1   ...2   ...3   ...4
#>    <dbl>  <dbl>  <dbl>  <dbl>
#> 1  0.436 -1.11  -0.746 -1.11 
#> 2 -1.11  -0.139 -1.11  -0.746
#> 3 -0.139 -0.746 -0.139  0.436
#> 4 -0.746  0.436  0.436  0.558
#> 5  0.558  0.558  0.558 -0.139
#> 
#> $row_means
#> # A tibble: 5 × 1
#>    value
#>    <dbl>
#> 1 -1.11 
#> 2 -0.746
#> 3 -0.139
#> 4  0.436
#> 5  0.558
#> 
#> $duplicated_ranks
#> # A tibble: 5 × 4
#>      V1    V2    V3    V4
#>   <int> <int> <int> <int>
#> 1     3     2     2     4
#> 2     1     5     3     3
#> 3     4     1     1     1
#> 4     5     4     5     5
#> 5     2     3     4     2
#> 
#> $duplicated_rank_row_indices
#> # A tibble: 5 × 1
#>   row_index
#>       <int>
#> 1         1
#> 2         2
#> 3         3
#> 4         4
#> 5         5
#> 
#> $duplicated_rank_data
#> # A tibble: 5 × 4
#>       V1      V2      V3     V4
#>    <dbl>   <dbl>   <dbl>  <dbl>
#> 1 -0.799 -0.0170 -0.751   0.485
#> 2  0.470 -0.542  -1.25    0.917
#> 3 -1.15   0.876  -1.04   -0.985
#> 4 -0.272  0.741  -0.0294 -1.49 
#> 5  0.457 -0.165  -0.275   0.820
#> 
```
