# Create a Workflow Set Object

Create a workflow set object tibble from a model spec tibble.

## Usage

``` r
create_workflow_set(.model_tbl = NULL, .recipe_list = list(), .cross = TRUE)
```

## Arguments

- .model_tbl:

  The model table that is generated from a function like
  [`fast_regression_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_regression_parsnip_spec_tbl.md).
  The model spec column will be grabbed automatically as the class of
  the object must be `tidyaml_base_tbl`

- .recipe_list:

  Provide a list of recipes here that will get added to the workflow set
  object.

- .cross:

  The default is TRUE, can be set to FALSE. This is passed to the
  `cross` parameter as an argument to the `workflow_set()` function.

## Value

A list object of workflows.

## Details

Create a `workflow set` object/tibble from a model spec tibble where the
object class type is `tidyaml_base_tbl`. This function will take in a
list of recipes and will grab the model specifications from the base
tibble to create the workflow sets object. You can also supply the
logical of TRUE/FALSe the `.cross` parameter which gets passed to the
corresponding parameter as an argumnt to the
[`workflowsets::workflow_set()`](https://workflowsets.tidymodels.org/reference/workflow_set.html)
function.

## See also

<https://workflowsets.tidymodels.org/>

Other Utility:
[`check_duplicate_rows()`](https://www.spsanderson.com/tidyaml/reference/check_duplicate_rows.md),
[`core_packages()`](https://www.spsanderson.com/tidyaml/reference/core_packages.md),
[`create_splits()`](https://www.spsanderson.com/tidyaml/reference/create_splits.md),
[`fast_classification_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_classification_parsnip_spec_tbl.md),
[`fast_regression_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_regression_parsnip_spec_tbl.md),
[`full_internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/full_internal_make_wflw.md),
[`install_deps()`](https://www.spsanderson.com/tidyaml/reference/install_deps.md),
[`load_deps()`](https://www.spsanderson.com/tidyaml/reference/load_deps.md),
[`match_args()`](https://www.spsanderson.com/tidyaml/reference/match_args.md),
[`quantile_normalize()`](https://www.spsanderson.com/tidyaml/reference/quantile_normalize.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
library(recipes)
#> Loading required package: dplyr
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
#> 
#> Attaching package: 'recipes'
#> The following object is masked from 'package:stats':
#> 
#>     step

rec_obj <- recipe(mpg ~ ., data = mtcars)
spec_tbl <- fast_regression_parsnip_spec_tbl(
  .parsnip_fns = "linear_reg",
  .parsnip_eng = c("lm","glm")
)

create_workflow_set(
  spec_tbl,
  list(rec_obj)
)
#> # A workflow set/tibble: 2 × 4
#>   wflow_id            info             option    result    
#>   <chr>               <list>           <list>    <list>    
#> 1 recipe_linear_reg_1 <tibble [1 × 4]> <opts[0]> <list [0]>
#> 2 recipe_linear_reg_2 <tibble [1 × 4]> <opts[0]> <list [0]>
```
