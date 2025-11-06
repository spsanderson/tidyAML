# Generate Model Specification calls to `parsnip`

Creates a list/tibble of parsnip model specifications.

## Usage

``` r
create_model_spec(
  .parsnip_eng = list("lm"),
  .mode = list("regression"),
  .parsnip_fns = list("linear_reg"),
  .return_tibble = TRUE
)
```

## Arguments

- .parsnip_eng:

  The input must be a list. The default for this is set to `all`. This
  means that all of the parsnip **linear regression engines** will be
  used, for example `lm`, or `glm`.

- .mode:

  The input must be a list. The default is 'regression'

- .parsnip_fns:

  The input must be a list. The default for this is set to `all`. This
  means that all of the parsnip **linear regression** functions will be
  used, for example
  [`linear_reg()`](https://parsnip.tidymodels.org/reference/linear_reg.html),
  or `cubist_rules`.

- .return_tibble:

  The default is TRUE. FALSE will return a list object.

## Value

A list or a tibble.

## Details

Creates a list/tibble of parsnip model specifications. With this
function you can generate a list/tibble output of any model
specification and engine you choose that is supported by the `parsnip`
ecosystem.

## See also

Other Model_Generator:
[`fast_classification()`](https://www.spsanderson.com/tidyaml/reference/fast_classification.md),
[`fast_regression()`](https://www.spsanderson.com/tidyaml/reference/fast_regression.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
create_model_spec(
 .parsnip_eng = list("lm","glm","glmnet","cubist"),
 .parsnip_fns = list(
      "linear_reg","linear_reg","linear_reg",
      "cubist_rules"
     )
 )
#> # A tibble: 4 × 4
#>   .parsnip_engine .parsnip_mode .parsnip_fns .model_spec
#>   <chr>           <chr>         <chr>        <list>     
#> 1 lm              regression    linear_reg   <spec[+]>  
#> 2 glm             regression    linear_reg   <spec[+]>  
#> 3 glmnet          regression    linear_reg   <spec[+]>  
#> 4 cubist          regression    cubist_rules <spec[+]>  

create_model_spec(
 .parsnip_eng = list("lm","glm","glmnet","cubist"),
 .parsnip_fns = list(
      "linear_reg","linear_reg","linear_reg",
      "cubist_rules"
     ),
 .return_tibble = FALSE
 )
#> $.parsnip_engine
#> $.parsnip_engine[[1]]
#> [1] "lm"
#> 
#> $.parsnip_engine[[2]]
#> [1] "glm"
#> 
#> $.parsnip_engine[[3]]
#> [1] "glmnet"
#> 
#> $.parsnip_engine[[4]]
#> [1] "cubist"
#> 
#> 
#> $.parsnip_mode
#> $.parsnip_mode[[1]]
#> [1] "regression"
#> 
#> 
#> $.parsnip_fns
#> $.parsnip_fns[[1]]
#> [1] "linear_reg"
#> 
#> $.parsnip_fns[[2]]
#> [1] "linear_reg"
#> 
#> $.parsnip_fns[[3]]
#> [1] "linear_reg"
#> 
#> $.parsnip_fns[[4]]
#> [1] "cubist_rules"
#> 
#> 
#> $.model_spec
#> $.model_spec[[1]]
#> Linear Regression Model Specification (regression)
#> 
#> Computational engine: lm 
#> 
#> 
#> $.model_spec[[2]]
#> Linear Regression Model Specification (regression)
#> 
#> Computational engine: glm 
#> 
#> 
#> $.model_spec[[3]]
#> Linear Regression Model Specification (regression)
#> 
#> Computational engine: glmnet 
#> 
#> 
#> $.model_spec[[4]]
#> ! parsnip could not locate an implementation for `cubist_rules` regression
#>   model specifications using the `cubist` engine.
#> Cubist Model Specification (regression)
#> 
#> Computational engine: cubist 
#> 
#> 
#> 
```
