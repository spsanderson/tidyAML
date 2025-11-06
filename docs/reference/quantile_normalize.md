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
#> [1,]  0.2638742 -0.2852950  0.2638742 -0.2852950
#> [2,]  0.9520457 -0.5718011 -0.2852950  0.9520457
#> [3,]  0.6158511  0.9520457 -0.5718011 -0.5718011
#> [4,] -0.2852950  0.2638742  0.9520457  0.2638742
#> [5,] -0.5718011  0.6158511  0.6158511  0.6158511
#> 
#> $row_means
#> [1] -0.5718011 -0.2852950  0.2638742  0.6158511  0.9520457
#> 
#> $duplicated_ranks
#>      [,1] [,2] [,3] [,4]
#> [1,]    4    1    1    3
#> [2,]    2    2    2    5
#> [3,]    3    3    3    4
#> [4,]    5    5    4    2
#> [5,]    1    4    5    1
#> 
#> $duplicated_rank_row_indices
#> [1] 1 2 3 4 5
#> 
#> $duplicated_rank_data
#>            [,1]       [,2]       [,3]      [,4]
#> [1,]  1.6562563 -1.0963913 -0.3922393 0.8322193
#> [2,] -0.5882615 -0.5161159 -0.3349218 0.4565936
#> [3,]  0.7249359 -0.2668701  0.2683600 0.2464881
#> [4,] -1.0450618  0.6326245  0.5274953 0.3290709
#> [5,]  1.6533545 -0.1740388  0.6870826 0.2981192
#> 

as.data.frame(normalized_data$normalized_data) |>
  sapply(function(x) quantile(x, probs = seq(0, 1, 1 / 4)))
#>              V1         V2         V3         V4
#> 0%   -0.5718011 -0.5718011 -0.5718011 -0.5718011
#> 25%  -0.2852950 -0.2852950 -0.2852950 -0.2852950
#> 50%   0.2638742  0.2638742  0.2638742  0.2638742
#> 75%   0.6158511  0.6158511  0.6158511  0.6158511
#> 100%  0.9520457  0.9520457  0.9520457  0.9520457

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
#> 1  0.264 -0.285  0.264 -0.285
#> 2  0.952 -0.572 -0.285  0.952
#> 3  0.616  0.952 -0.572 -0.572
#> 4 -0.285  0.264  0.952  0.264
#> 5 -0.572  0.616  0.616  0.616
#> 
#> $row_means
#> # A tibble: 5 × 1
#>    value
#>    <dbl>
#> 1 -0.572
#> 2 -0.285
#> 3  0.264
#> 4  0.616
#> 5  0.952
#> 
#> $duplicated_ranks
#> # A tibble: 5 × 4
#>      V1    V2    V3    V4
#>   <int> <int> <int> <int>
#> 1     4     1     1     3
#> 2     2     2     2     5
#> 3     3     3     3     4
#> 4     5     5     4     2
#> 5     1     4     5     1
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
#>       V1     V2     V3    V4
#>    <dbl>  <dbl>  <dbl> <dbl>
#> 1  1.66  -1.10  -0.392 0.832
#> 2 -0.588 -0.516 -0.335 0.457
#> 3  0.725 -0.267  0.268 0.246
#> 4 -1.05   0.633  0.527 0.329
#> 5  1.65  -0.174  0.687 0.298
#> 
```
