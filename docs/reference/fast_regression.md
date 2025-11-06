# Generate Model Specification calls to `parsnip`

Creates a list/tibble of parsnip model specifications.

## Usage

``` r
fast_regression(
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

  The data being passed to the function for the regression problem

- .rec_obj:

  The recipe object being passed.

- .parsnip_fns:

  The default is 'all' which will create all possible regression model
  specifications supported.

- .parsnip_eng:

  the default is 'all' which will create all possible regression model
  specifications supported.

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

With this function you can generate a tibble output of any regression
model specification and it's fitted `workflow` object.

## See also

Other Model_Generator:
[`create_model_spec()`](https://www.spsanderson.com/tidyaml/reference/create_model_spec.md),
[`fast_classification()`](https://www.spsanderson.com/tidyaml/reference/fast_classification.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
library(recipes, quietly = TRUE)

rec_obj <- recipe(mpg ~ ., data = mtcars)
frt_tbl <- fast_regression(
  mtcars,
  rec_obj,
  .parsnip_eng = c("lm","glm","gee"),
  .parsnip_fns = "linear_reg"
  )
#> Error in `.f()`:
#> ! parsnip could not locate an implementation for `linear_reg` regression
#>   model specifications using the `gee` engine.
#> ℹ The parsnip extension package multilevelmod implements support for this
#>   specification.
#> ℹ Please install (if needed) and load to continue.
#> Error in UseMethod("fit"): no applicable method for 'fit' applied to an object of class "NULL"
#> Error in UseMethod("predict"): no applicable method for 'predict' applied to an object of class "NULL"

frt_tbl
#> # A tibble: 2 × 8
#>   .model_id .parsnip_engine .parsnip_mode .parsnip_fns model_spec wflw      
#>       <int> <chr>           <chr>         <chr>        <list>     <list>    
#> 1         1 lm              regression    linear_reg   <spec[+]>  <workflow>
#> 2         3 glm             regression    linear_reg   <spec[+]>  <workflow>
#> # ℹ 2 more variables: fitted_wflw <list>, pred_wflw <list>
```
