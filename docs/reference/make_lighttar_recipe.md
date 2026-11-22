# Build a LightTAR-style recipe for numeric embeddings

Replace embedding columns with PCA features and a separate block of
regularized partial least squares (PLS) features. Both blocks start from
the same standardized embeddings. Only PLS uses the outcome. All
projections are estimated by
[`recipes::prep()`](https://recipes.tidymodels.org/reference/prep.html)
on its training rows and applied by
[`recipes::bake()`](https://recipes.tidymodels.org/reference/bake.html)
without the outcome. Other columns are preserved.

## Usage

``` r
make_lighttar_recipe(
  .data,
  .outcome_var,
  .emb_cols,
  .u_pca = 30L,
  .s_pls = 5L,
  .m = 60
)
```

## Arguments

- .data:

  A data frame containing embeddings, an outcome, and any other
  predictors. Supply precomputed numeric embeddings; no encoder is run.

- .outcome_var:

  Name of one numeric or factor outcome column.

- .emb_cols:

  Nonempty character vector of unique numeric embedding column names,
  excluding the outcome.

- .u_pca:

  Positive integer: maximum number of PCA components.

- .s_pls:

  Non-negative integer: maximum number of supervised components. Set to
  `0` for PCA only.

- .m:

  Non-negative input-variance weight. The fitted PLS penalty is
  `.m / n`, where `n` is the number of training rows. Use `0` for plain
  PLS.

## Value

An untrained
[`recipes::recipe()`](https://recipes.tidymodels.org/reference/recipe.html)
that creates `pca_` and, where applicable, `pls_` predictors.

## Details

This single-embedding-block version of LightTAR uses the same columns
for PCA and PLS. Constant embedding columns contribute no variation; at
least one column must vary. The number of components may be smaller than
requested if training data are rank deficient or the supervised
deflation has no signal left. The PCA and PLS blocks are not jointly
orthogonal; choose `.u_pca` below the embedding rank if you want to
leave room for additional signal. Embeddings and training outcomes must
be finite and complete (factors must have no missing values).

## References

Shapira et al., LightTAR: Light and Fast Target-Aware Representations
for Multimodal Tabular Learning, <https://arxiv.org/abs/2611.17600>.

## Examples

``` r
rec <- make_lighttar_recipe(mtcars, "mpg", c("disp", "hp", "wt"), 2, 1)
trained <- recipes::prep(rec, training = mtcars[1:24, ])
recipes::bake(trained, new_data = mtcars[25:32, ])
#> # A tibble: 8 × 11
#>     mpg   cyl  drat  qsec    vs    am  gear  carb  pca_1  pca_2  pls_1
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl>
#> 1  19.2     8  3.08  17.0     0     0     3     2  1.39  0.0750  1.39 
#> 2  27.3     4  4.08  18.9     1     1     4     1 -2.37  0.159  -2.37 
#> 3  26       4  4.43  16.7     0     1     5     2 -1.80  0.312  -1.80 
#> 4  30.4     4  3.77  16.9     1     1     5     2 -2.08  1.04   -2.08 
#> 5  15.8     8  4.22  14.5     0     1     5     4  1.62  1.66    1.62 
#> 6  19.7     6  3.62  15.5     0     1     5     6 -0.489 0.880  -0.488
#> 7  15       8  3.54  14.6     0     1     5     8  2.31  2.24    2.31 
#> 8  21.4     4  4.11  18.6     1     1     4     2 -1.24  0.0681 -1.24 
```
