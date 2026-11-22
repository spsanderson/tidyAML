# Audit model selection across held-out datasets

Score each `tidyAML` regression or classification specification on a
shared testing split within each dataset. Hold out one dataset at a
time, select the model with the lowest mean loss on the other datasets,
and compare its mean selection loss to its loss on the held-out dataset.
Models are fitted within each dataset; this audits the choice of model
specification, not transfer of fitted weights across datasets.

## Usage

``` r
lodo_engine_audit(
  .datasets_list,
  .outcome_var,
  .parsnip_eng = NULL,
  .parsnip_fns = "all",
  .metric = "rmse",
  .event_level = "first",
  .split_args = NULL,
  .seed = NULL
)
```

## Arguments

- .datasets_list:

  Named list of at least two data frames. Each must contain
  `.outcome_var`; other column names may differ across datasets.

- .outcome_var:

  Name of one outcome column common to all datasets.

- .parsnip_eng:

  Character vector of engines to compare. With `NULL`, use
  `c("lm", "ranger")` for regression or `"glm"` for classification. Pass
  more than one working specification to audit a selection decision.

- .parsnip_fns:

  Character vector of model families to include, or `"all"` for all
  supported families for the requested engines.

- .metric:

  `"rmse"` for a numeric outcome; `"roc_auc"` (as `1 - AUC`) or
  `"mn_log_loss"` for a factor outcome. Loss is always
  smaller-is-better.

- .event_level:

  `"first"` or `"second"`, used for binary probability metrics.
  Multiclass metrics use all class probabilities in factor order.

- .split_args:

  Optional arguments for
  [`rsample::initial_split()`](https://rsample.tidymodels.org/reference/initial_split.html),
  applied to the shared split within each dataset.

- .seed:

  Optional integer seed for splitting and fitting. A supplied seed
  leaves the caller's R RNG state unchanged.

## Value

A tibble with one row per held-out dataset and columns
`held_out_dataset`, `selected_model`, `selection_loss`, `held_out_loss`,
and `generalization_gap` (`held_out_loss - selection_loss`). The
`.lodo_scores` attribute is a tibble with `dataset`, `model`, `loss`,
and `error` columns; `.lodo_metric` records the requested metric.

## Details

Only models scored on every selection dataset are eligible. Exact ties
are broken by model label in bytewise order. A failed score on the
held-out dataset does not change selection: the held-out loss and gap
are `NA`. Folds with no eligible model have `NA` for all result fields
except the dataset name. Failures are reported with a warning and error
details are retained in the per-dataset score table. Use representative
datasets; the gap is descriptive, and raw RMSE may be dominated by
datasets with larger outcome scales.

## References

Hog et al., Towards Reliable Scaling Laws for Tabular Foundation Models,
<https://arxiv.org/abs/2611.24214>.

## Examples

``` r
datasets <- list(airquality = na.omit(airquality), mtcars = mtcars)
datasets$airquality$outcome <- datasets$airquality$Temp
datasets$airquality$Temp <- NULL
datasets$mtcars$outcome <- datasets$mtcars$mpg
datasets$mtcars$mpg <- NULL
lodo_engine_audit(datasets, "outcome", c("lm", "glm"),
  .parsnip_fns = "linear_reg", .seed = 280L
)
#> # A tibble: 2 × 5
#>   held_out_dataset selected_model   selection_loss held_out_loss
#>   <chr>            <chr>                     <dbl>         <dbl>
#> 1 airquality       glm - linear_reg           2.69          7.78
#> 2 mtcars           glm - linear_reg           7.78          2.69
#> # ℹ 1 more variable: generalization_gap <dbl>
```
