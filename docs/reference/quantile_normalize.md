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
#>             [,1]        [,2]        [,3]        [,4]
#> [1,]  0.51872044  0.70424053  0.51872044 -0.83939476
#> [2,]  0.70424053  0.51872044  0.70424053  0.51872044
#> [3,] -0.83939476 -0.83939476  0.09599019  0.70424053
#> [4,] -0.30473642 -0.30473642 -0.30473642  0.09599019
#> [5,]  0.09599019  0.09599019 -0.83939476 -0.30473642
#> 
#> $row_means
#> [1] -0.83939476 -0.30473642  0.09599019  0.51872044  0.70424053
#> 
#> $duplicated_ranks
#>      [,1] [,2] [,3] [,4]
#> [1,]    3    3    5    4
#> [2,]    2    4    4    1
#> [3,]    1    2    1    5
#> [4,]    5    1    2    2
#> [5,]    4    5    3    3
#> 
#> $duplicated_rank_row_indices
#> [1] 1 2 3 4 5
#> 
#> $duplicated_rank_data
#>             [,1]        [,2]       [,3]        [,4]
#> [1,]  0.45742422 -0.16481239 -0.2749438  0.81959245
#> [2,] -0.01695794 -0.75096428  0.4854515  1.01340453
#> [3,] -0.54159436 -1.25336629  0.9169820  1.05360525
#> [4,]  0.87581342 -1.03623626 -0.9853439 -0.07142864
#> [5,]  0.74083815 -0.02943857 -1.4911897  0.95244461
#> 

as.data.frame(normalized_data$normalized_data) |>
  sapply(function(x) quantile(x, probs = seq(0, 1, 1 / 4)))
#>               V1          V2          V3          V4
#> 0%   -0.83939476 -0.83939476 -0.83939476 -0.83939476
#> 25%  -0.30473642 -0.30473642 -0.30473642 -0.30473642
#> 50%   0.09599019  0.09599019  0.09599019  0.09599019
#> 75%   0.51872044  0.51872044  0.51872044  0.51872044
#> 100%  0.70424053  0.70424053  0.70424053  0.70424053

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
#>      ...1    ...2    ...3    ...4
#>     <dbl>   <dbl>   <dbl>   <dbl>
#> 1  0.519   0.704   0.519  -0.839 
#> 2  0.704   0.519   0.704   0.519 
#> 3 -0.839  -0.839   0.0960  0.704 
#> 4 -0.305  -0.305  -0.305   0.0960
#> 5  0.0960  0.0960 -0.839  -0.305 
#> 
#> $row_means
#> # A tibble: 5 × 1
#>     value
#>     <dbl>
#> 1 -0.839 
#> 2 -0.305 
#> 3  0.0960
#> 4  0.519 
#> 5  0.704 
#> 
#> $duplicated_ranks
#> # A tibble: 5 × 4
#>      V1    V2    V3    V4
#>   <int> <int> <int> <int>
#> 1     3     3     5     4
#> 2     2     4     4     1
#> 3     1     2     1     5
#> 4     5     1     2     2
#> 5     4     5     3     3
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
#>        V1      V2     V3      V4
#>     <dbl>   <dbl>  <dbl>   <dbl>
#> 1  0.457  -0.165  -0.275  0.820 
#> 2 -0.0170 -0.751   0.485  1.01  
#> 3 -0.542  -1.25    0.917  1.05  
#> 4  0.876  -1.04   -0.985 -0.0714
#> 5  0.741  -0.0294 -1.49   0.952 
#> 
```
