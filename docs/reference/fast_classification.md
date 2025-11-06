# Generate Model Specification calls to `parsnip`

Creates a list/tibble of parsnip model specifications.

## Usage

``` r
fast_classification(
  .data,
  .rec_obj,
  .parsnip_fns = "all",
  .parsnip_eng = "all",
  .split_type = "initial_split",
  .split_args = NULL,
  .drop_na = TRUE
)
```

## Arguments

- .data:

  The data being passed to the function for the classification problem

- .rec_obj:

  The recipe object being passed.

- .parsnip_fns:

  The default is 'all' which will create all possible classification
  model specifications supported.

- .parsnip_eng:

  the default is 'all' which will create all possible classification
  model specifications supported.

- .split_type:

  The default is 'initial_split', you can pass any type of split
  supported by `rsample`

- .split_args:

  The default is NULL, when NULL then the default parameters of the
  split type will be executed for the rsample split type.

- .drop_na:

  The default is TRUE, which will drop all NA's from the data.

## Value

A list or a tibble.

## Details

With this function you can generate a tibble output of any
classification model specification and it's fitted `workflow` object.
Per recipes documentation explicitly with
[`step_string2factor()`](https://recipes.tidymodels.org/reference/step_string2factor.html)
it is encouraged to mutate your predictor into a factor before you
create your recipe.

## See also

Other Model_Generator:
[`create_model_spec()`](https://www.spsanderson.com/tidyaml/reference/create_model_spec.md),
[`fast_regression()`](https://www.spsanderson.com/tidyaml/reference/fast_regression.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
library(recipes)
library(dplyr)
library(tidyr)

df <- Titanic |>
 as_tibble() |>
 uncount(n) |>
 mutate(across(everything(), as.factor))

rec_obj <- recipe(Survived ~ ., data = df)

fct_tbl <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .parsnip_eng = c("glm","earth")
  )
#> Error in `.f()`:
#> ! parsnip could not locate an implementation for `bag_mars`
#>   classification model specifications using the `earth` engine.
#> ℹ The parsnip extension package baguette implements support for this
#>   specification.
#> ℹ Please install (if needed) and load to continue.
#> Error in `.f()`:
#> ! parsnip could not locate an implementation for `discrim_flexible`
#>   classification model specifications using the `earth` engine.
#> ℹ The parsnip extension package discrim implements support for this
#>   specification.
#> ℹ Please install (if needed) and load to continue.
#> Error in UseMethod("fit"): no applicable method for 'fit' applied to an object of class "NULL"
#> Error in UseMethod("fit"): no applicable method for 'fit' applied to an object of class "NULL"
#> Error in `fit_xy()`:
#> ! Please install the earth package to use this engine.
#> Error in UseMethod("predict"): no applicable method for 'predict' applied to an object of class "NULL"
#> Error in UseMethod("predict"): no applicable method for 'predict' applied to an object of class "NULL"
#> Error in UseMethod("predict"): no applicable method for 'predict' applied to an object of class "NULL"

fct_tbl
#> # A tibble: 1 × 8
#>   .model_id .parsnip_engine .parsnip_mode  .parsnip_fns model_spec wflw      
#>       <int> <chr>           <chr>          <chr>        <list>     <list>    
#> 1         3 glm             classification logistic_reg <spec[+]>  <workflow>
#> # ℹ 2 more variables: fitted_wflw <list>, pred_wflw <list>
```
