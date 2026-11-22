# Gate a candidate on validation score and rank stability

Admit a candidate only if the validation ranking is sufficiently stable
and the candidate is no worse than the incumbent by more than the
tolerance. Tolerance is
`.tau_min + (1 - .rho_hat) * (.tau_max - .tau_min)`. A `FALSE` decision
leaves fallback exploration to the caller.

## Usage

``` r
vgc_gate(
  .incumbent_score,
  .candidate_score,
  .rho_hat,
  .tau_min = 0.002,
  .tau_max = 0.02,
  .min_rho = 0.6,
  .maximize = TRUE
)
```

## Arguments

- .incumbent_score, .candidate_score:

  Numeric scalar validation scores on the same data and scale.

- .rho_hat:

  Rank-stability estimate in `[-1, 1]`, for example from
  [`check_validation_stability()`](https://www.spsanderson.com/tidyaml/reference/check_validation_stability.md).

- .tau_min, .tau_max:

  Non-negative tolerance bounds in score units, with `.tau_min` no
  larger than `.tau_max`. Set them equal for a fixed tolerance.

- .min_rho:

  Minimum rank stability in `[0, 1]`.

- .maximize:

  Logical scalar. Use `FALSE` for losses such as RMSE.

## Value

One logical value. `FALSE` includes abstention when a score or the
stability estimate is missing or non-finite.

## Examples

``` r
vgc_gate(0.82, 0.817, .rho_hat = 0.9)
#> [1] TRUE
vgc_gate(1.10, 1.05, .rho_hat = 0.8, .maximize = FALSE)
#> [1] TRUE
```
