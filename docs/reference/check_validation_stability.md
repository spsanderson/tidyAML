# Check classification validation rank stability

Score fitted binary classifiers on their shared testing split, then
measure how well their score rankings survive a paired bootstrap. Each
draw samples testing rows with replacement within outcome classes and
uses those same rows for all models. Models are not refitted.

## Usage

``` r
check_validation_stability(
  .model_tbl,
  .metric_fn = yardstick::roc_auc,
  .n_boot = 25L,
  .event_level = "first",
  .seed = NULL
)
```

## Arguments

- .model_tbl:

  A fitted table from
  [`fast_classification()`](https://www.spsanderson.com/tidyaml/reference/fast_classification.md).
  Use models fitted and evaluated on the same split. Unfitted entries
  are ignored.

- .metric_fn:

  A binary probability metric with the interface of
  [`yardstick::roc_auc()`](https://yardstick.tidymodels.org/reference/roc_auc.html),
  returning one numeric `.estimate`.

- .n_boot:

  A positive integer giving the number of bootstrap draws.

- .event_level:

  `"first"` or `"second"`: the outcome factor level whose predicted
  probability is supplied to `.metric_fn`.

- .seed:

  Optional integer seed. A supplied seed leaves the caller's RNG state
  unchanged.

## Value

A numeric scalar: the mean Spearman correlation of the full testing
scores with the bootstrap scores. Undefined draws are omitted. Returns
`NA_real_` when stability cannot be estimated, including when there are
fewer than two fitted models, either class is absent, or all full-sample
scores are tied. A non-finite full-sample metric or invalid testing
probabilities also make the result unavailable.

## See also

[`vgc_gate()`](https://www.spsanderson.com/tidyaml/reference/vgc_gate.md)

## Examples

``` r
data <- transform(mtcars, am = factor(am))
rec <- recipes::recipe(am ~ mpg + hp, data = data)
models <- withr::with_seed(1L, fast_classification(data, rec, .parsnip_eng = c("lm","glm")))
check_validation_stability(models) # One model cannot establish a ranking.
#> [1] NA
```
