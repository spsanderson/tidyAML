
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyAML <img src="man/figures/logo.png" width="147" height="170" align="right" />

<!-- badges: start -->
<!-- [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/tidyAML)](https://cran.r-project.org/package=tidyAML) -->

![](https://cranlogs.r-pkg.org/badges/tidyAML)
![](https://cranlogs.r-pkg.org/badges/grand-total/tidyAML) [![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html##experimental)
[![PRs
Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://makeapullrequest.com)
<!-- badges: end -->

## Introduction

Welcome to **`{tidyAML}`** which is a new R package that makes it easy
to use the `tidymodels` ecosystem to perform automated machine learning
(AutoML). This package provides a simple and intuitive interface that
allows users to quickly generate machine learning models without
worrying about the underlying details. It also includes a safety
mechanism that ensures that the package will fail gracefully if any
required extension packages are not installed on the user’s machine.
With `{tidyAML}`, users can easily build high-quality machine learning
models in just a few lines of code. Whether you are a beginner or an
experienced machine learning practitioner, `{tidyAML}` has something to
offer.

Some ideas are that we should be able to generate regression models on
the fly without having to actually go through the process of building
the specification, especially if it is a non-tuning model, meaning we
are not planing on tuning hyper-parameters like `penalty` and `cost`.

The idea is not to re-write the excellent work the `tidymodels` team has
done (because it’s not possible) but rather to try and make an enhanced
easy to use set of functions that do what they say and can generate many
models and predictions at once.

This is similar to the great `h2o` package, but, `{tidyAML}` does not
require java to be setup properly like `h2o` because `{tidyAML}` is
built on `tidymodels`.

## Thanks

Thank you [Garrick
Aden-Buie](https://fosstodon.org/@grrrck/109479826278916014) for the
easy name change suggestion.

## Installation

You can install `{tidyAML}` like so (Not yet available on CRAN)

``` r
# Not yet on CRAN
# install.packages("tidyAML")
```

Or the development version from GitHub

``` r
# install.packages("devtools")
devtools::install_github("spsanderson/tidyAML")
#> 
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>          checking for file 'C:\Users\steve\AppData\Local\Temp\RtmpcTQ0qQ\remotes20301fd86a70\spsanderson-tidyAML-4589656/DESCRIPTION' ...  ✔  checking for file 'C:\Users\steve\AppData\Local\Temp\RtmpcTQ0qQ\remotes20301fd86a70\spsanderson-tidyAML-4589656/DESCRIPTION'
#>       ─  preparing 'tidyAML': (1.7s)
#>    checking DESCRIPTION meta-information ...     checking DESCRIPTION meta-information ...   ✔  checking DESCRIPTION meta-information
#>       ─  checking for LF line-endings in source and make files and shell scripts
#>       ─  checking for empty or unneeded directories
#>       ─  building 'tidyAML_0.0.0.9002.tar.gz'
#>      
#> 
```

## Examples

Part of the reason to use `{tidyAML}` is so that you can generate many
models of your data set. One way of modeling a data set is using
regression for some numeric output. There is a convienent function in
**tidyAML** that will generate a set of non-tuning models for *fast
regression*. Let’s take a look below.

First let’s load the library

``` r
library(tidyAML)
#> Loading required package: parsnip
#> 
#> == Welcome to tidyAML ===========================================================================
#> If you find this package useful, please leave a star: 
#>    https://github.com/spsanderson/tidyAML'
#> 
#> If you encounter a bug or want to request an enhancement please file an issue at:
#>    https://github.com/spsanderson/tidyAML/issues
#> 
#> Thank you for using tidyAML!
```

Now lets see the function in action.

``` r
fast_regression_parsnip_spec_tbl(.parsnip_fns = "linear_reg")
#> # A tibble: 11 × 5
#>    .model_id .parsnip_engine .parsnip_mode .parsnip_fns model_spec
#>        <int> <chr>           <chr>         <chr>        <list>    
#>  1         1 lm              regression    linear_reg   <spec[+]> 
#>  2         2 brulee          regression    linear_reg   <spec[+]> 
#>  3         3 gee             regression    linear_reg   <spec[+]> 
#>  4         4 glm             regression    linear_reg   <spec[+]> 
#>  5         5 glmer           regression    linear_reg   <spec[+]> 
#>  6         6 glmnet          regression    linear_reg   <spec[+]> 
#>  7         7 gls             regression    linear_reg   <spec[+]> 
#>  8         8 lme             regression    linear_reg   <spec[+]> 
#>  9         9 lmer            regression    linear_reg   <spec[+]> 
#> 10        10 stan            regression    linear_reg   <spec[+]> 
#> 11        11 stan_glmer      regression    linear_reg   <spec[+]>
fast_regression_parsnip_spec_tbl(.parsnip_eng = c("lm","glm"))
#> # A tibble: 3 × 5
#>   .model_id .parsnip_engine .parsnip_mode .parsnip_fns model_spec
#>       <int> <chr>           <chr>         <chr>        <list>    
#> 1         1 lm              regression    linear_reg   <spec[+]> 
#> 2         2 glm             regression    linear_reg   <spec[+]> 
#> 3         3 glm             regression    poisson_reg  <spec[+]>
fast_regression_parsnip_spec_tbl(.parsnip_eng = c("lm","glm","gee"), 
                                 .parsnip_fns = "linear_reg")
#> # A tibble: 3 × 5
#>   .model_id .parsnip_engine .parsnip_mode .parsnip_fns model_spec
#>       <int> <chr>           <chr>         <chr>        <list>    
#> 1         1 lm              regression    linear_reg   <spec[+]> 
#> 2         2 gee             regression    linear_reg   <spec[+]> 
#> 3         3 glm             regression    linear_reg   <spec[+]>
```

As shown we can easily select the models we want either by choosing the
supported `parsnip` function like `linear_reg()` or by choose the
desired `engine`, you can also use them both in conjunction with each
other!

This function also does add a class to the output. Let’s see it.

``` r
class(fast_regression_parsnip_spec_tbl())
#> [1] "tidyaml_mod_spec_tbl" "fst_reg_spec_tbl"     "tidyaml_base_tbl"    
#> [4] "tbl_df"               "tbl"                  "data.frame"
```

We see that there are two added classes, first `fst_reg_spec_tbl`
because this creates a set of non-tuning regression models and then
`tidyaml_mod_spec_tbl` because this is a model specification tibble
built with `{tidyAML}`

Now, what if you want to create a non-tuning model spec without using
the `fast_regression_parsnip_spec_tbl()` function. Well, you can. The
function is called `create_model_spec()`.

``` r
create_model_spec(
 .parsnip_eng = list("lm","glm","glmnet","cubist"),
 .parsnip_fns = list(
      rep(
        "linear_reg", 3),
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
      rep(
        "linear_reg", 3),
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
```

Now the reason we are here. Let’s take a look at the first function for
modeling with `{tidyAML}`, **`fast_regression()`**.

``` r
library(recipes)
library(dplyr)

rec_obj <- recipe(mpg ~ ., data = mtcars)
frt_tbl <- fast_regression(
  .data = mtcars, 
  .rec_obj = rec_obj, 
  .parsnip_eng = c("lm","glm","gee"),
  .parsnip_fns = "linear_reg"
)

glimpse(frt_tbl)
#> Rows: 3
#> Columns: 8
#> $ .model_id       <int> 1, 2, 3
#> $ .parsnip_engine <chr> "lm", "gee", "glm"
#> $ .parsnip_mode   <chr> "regression", "regression", "regression"
#> $ .parsnip_fns    <chr> "linear_reg", "linear_reg", "linear_reg"
#> $ model_spec      <list> [~NULL, ~NULL, NULL, regression, TRUE, NULL, lm, TRUE]…
#> $ wflw            <list> [cyl, disp, hp, drat, wt, qsec, vs, am, gear, carb, mp…
#> $ fitted_wflw     <list> [cyl, disp, hp, drat, wt, qsec, vs, am, gear, carb, mp…
#> $ pred_wflw       <list> [<tbl_df[24 x 1]>], <NULL>, [<tbl_df[24 x 1]>]
```

As we see above, one of the models has gracefully failed, thanks in part
to the function `purrr::safely()`, which was used to make what I call
**safe_make** functions.

Let’s look at the fitted workflow predictions.

``` r
frt_tbl$pred_wflw
#> [[1]]
#> # A tibble: 24 × 1
#>    .pred
#>    <dbl>
#>  1  23.9
#>  2  31.2
#>  3  15.4
#>  4  15.5
#>  5  11.3
#>  6  27.1
#>  7  17.8
#>  8  32.3
#>  9  28.1
#> 10  17.6
#> # … with 14 more rows
#> 
#> [[2]]
#> NULL
#> 
#> [[3]]
#> # A tibble: 24 × 1
#>    .pred
#>    <dbl>
#>  1  23.9
#>  2  31.2
#>  3  15.4
#>  4  15.5
#>  5  11.3
#>  6  27.1
#>  7  17.8
#>  8  32.3
#>  9  28.1
#> 10  17.6
#> # … with 14 more rows
```
