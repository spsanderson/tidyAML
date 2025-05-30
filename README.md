
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyAML <img src="man/figures/logo.png" width="147" height="170" align="right" />

<!-- badges: start -->

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/tidyAML)](https://cran.r-project.org/package=tidyAML)
![](https://cranlogs.r-pkg.org/badges/tidyAML)
![](https://cranlogs.r-pkg.org/badges/grand-total/tidyAML) [![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html##experimental)
[![PRs
Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://kentcdodds.github.io/makeapullrequest.com/)
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

You can install `{tidyAML}` like so:

``` r
#install.packages("tidyAML")
```

Or the development version from GitHub

``` r
# install.packages("devtools")
#devtools::install_github("spsanderson/tidyAML")
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
#> It is suggested that you run tidymodels::tidymodel_prefer() to set the defaults for your session.
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
      "linear_reg",
      "linear_reg",
      "linear_reg",
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
      "linear_reg",
      "linear_reg",
      "linear_reg",
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
  .parsnip_fns = "linear_reg",
  .drop_na = FALSE
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
#> $ pred_wflw       <list> [<tbl_df[64 x 3]>], <NULL>, [<tbl_df[64 x 3]>]
```

As we see above, one of the models has gracefully failed, thanks in part
to the function `purrr::safely()`, which was used to make what I call
**safe_make** functions.

Let’s look at the fitted workflow predictions.

``` r
frt_tbl$pred_wflw
#> [[1]]
#> # A tibble: 64 × 3
#>    .data_category .data_type .value
#>    <chr>          <chr>       <dbl>
#>  1 actual         actual       22.8
#>  2 actual         actual       15  
#>  3 actual         actual       17.8
#>  4 actual         actual       18.7
#>  5 actual         actual       30.4
#>  6 actual         actual       26  
#>  7 actual         actual       14.3
#>  8 actual         actual       19.2
#>  9 actual         actual       14.7
#> 10 actual         actual       17.3
#> # ℹ 54 more rows
#> 
#> [[2]]
#> NULL
#> 
#> [[3]]
#> # A tibble: 64 × 3
#>    .data_category .data_type .value
#>    <chr>          <chr>       <dbl>
#>  1 actual         actual       22.8
#>  2 actual         actual       15  
#>  3 actual         actual       17.8
#>  4 actual         actual       18.7
#>  5 actual         actual       30.4
#>  6 actual         actual       26  
#>  7 actual         actual       14.3
#>  8 actual         actual       19.2
#>  9 actual         actual       14.7
#> 10 actual         actual       17.3
#> # ℹ 54 more rows
```

Now let’s load the `multilevelmod` library so that we can run the `gee`
linear regression.

``` r
library(multilevelmod)

rec_obj <- recipe(mpg ~ ., data = mtcars)
frt_tbl <- fast_regression(
  .data = mtcars, 
  .rec_obj = rec_obj, 
  .parsnip_eng = c("lm","glm","gee"),
  .parsnip_fns = "linear_reg"
)

extract_wflw_pred(frt_tbl, 1:3)
#> # A tibble: 192 × 4
#>    .model_type     .data_category .data_type .value
#>    <chr>           <chr>          <chr>       <dbl>
#>  1 lm - linear_reg actual         actual       15.5
#>  2 lm - linear_reg actual         actual       19.2
#>  3 lm - linear_reg actual         actual       21.5
#>  4 lm - linear_reg actual         actual       14.3
#>  5 lm - linear_reg actual         actual       21.4
#>  6 lm - linear_reg actual         actual       21  
#>  7 lm - linear_reg actual         actual       13.3
#>  8 lm - linear_reg actual         actual       15.2
#>  9 lm - linear_reg actual         actual       24.4
#> 10 lm - linear_reg actual         actual       10.4
#> # ℹ 182 more rows
```

*Getting Regression Residuals*

Getting residuals is easy with `{tidyAML}`. Let’s take a look.

``` r
extract_regression_residuals(frt_tbl)
#> [[1]]
#> # A tibble: 32 × 4
#>    .model_type     .actual .predicted  .resid
#>    <chr>             <dbl>      <dbl>   <dbl>
#>  1 lm - linear_reg    15.5       16.5 -0.988 
#>  2 lm - linear_reg    19.2       19.7 -0.488 
#>  3 lm - linear_reg    21.5       21.6 -0.127 
#>  4 lm - linear_reg    14.3       14.1  0.157 
#>  5 lm - linear_reg    21.4       24.6 -3.23  
#>  6 lm - linear_reg    21         21.1 -0.0800
#>  7 lm - linear_reg    13.3       13.8 -0.482 
#>  8 lm - linear_reg    15.2       17.7 -2.52  
#>  9 lm - linear_reg    24.4       22.3  2.11  
#> 10 lm - linear_reg    10.4       11.5 -1.14  
#> # ℹ 22 more rows
#> 
#> [[2]]
#> # A tibble: 32 × 4
#>    .model_type      .actual .predicted  .resid
#>    <chr>              <dbl>      <dbl>   <dbl>
#>  1 gee - linear_reg    15.5       16.4 -0.896 
#>  2 gee - linear_reg    19.2       19.2  0.0385
#>  3 gee - linear_reg    21.5       22.3 -0.797 
#>  4 gee - linear_reg    14.3       14.6 -0.250 
#>  5 gee - linear_reg    21.4       24.6 -3.24  
#>  6 gee - linear_reg    21         21.1 -0.135 
#>  7 gee - linear_reg    13.3       13.8 -0.505 
#>  8 gee - linear_reg    15.2       17.4 -2.16  
#>  9 gee - linear_reg    24.4       22.6  1.80  
#> 10 gee - linear_reg    10.4       11.8 -1.39  
#> # ℹ 22 more rows
#> 
#> [[3]]
#> # A tibble: 32 × 4
#>    .model_type      .actual .predicted  .resid
#>    <chr>              <dbl>      <dbl>   <dbl>
#>  1 glm - linear_reg    15.5       16.5 -0.988 
#>  2 glm - linear_reg    19.2       19.7 -0.488 
#>  3 glm - linear_reg    21.5       21.6 -0.127 
#>  4 glm - linear_reg    14.3       14.1  0.157 
#>  5 glm - linear_reg    21.4       24.6 -3.23  
#>  6 glm - linear_reg    21         21.1 -0.0800
#>  7 glm - linear_reg    13.3       13.8 -0.482 
#>  8 glm - linear_reg    15.2       17.7 -2.52  
#>  9 glm - linear_reg    24.4       22.3  2.11  
#> 10 glm - linear_reg    10.4       11.5 -1.14  
#> # ℹ 22 more rows
```

You can also pivot them into a long format making plotting easy with
`ggplot2`.

``` r
extract_regression_residuals(frt_tbl, .pivot_long = TRUE)
#> [[1]]
#> # A tibble: 96 × 3
#>    .model_type     name        value
#>    <chr>           <chr>       <dbl>
#>  1 lm - linear_reg .actual    15.5  
#>  2 lm - linear_reg .predicted 16.5  
#>  3 lm - linear_reg .resid     -0.988
#>  4 lm - linear_reg .actual    19.2  
#>  5 lm - linear_reg .predicted 19.7  
#>  6 lm - linear_reg .resid     -0.488
#>  7 lm - linear_reg .actual    21.5  
#>  8 lm - linear_reg .predicted 21.6  
#>  9 lm - linear_reg .resid     -0.127
#> 10 lm - linear_reg .actual    14.3  
#> # ℹ 86 more rows
#> 
#> [[2]]
#> # A tibble: 96 × 3
#>    .model_type      name         value
#>    <chr>            <chr>        <dbl>
#>  1 gee - linear_reg .actual    15.5   
#>  2 gee - linear_reg .predicted 16.4   
#>  3 gee - linear_reg .resid     -0.896 
#>  4 gee - linear_reg .actual    19.2   
#>  5 gee - linear_reg .predicted 19.2   
#>  6 gee - linear_reg .resid      0.0385
#>  7 gee - linear_reg .actual    21.5   
#>  8 gee - linear_reg .predicted 22.3   
#>  9 gee - linear_reg .resid     -0.797 
#> 10 gee - linear_reg .actual    14.3   
#> # ℹ 86 more rows
#> 
#> [[3]]
#> # A tibble: 96 × 3
#>    .model_type      name        value
#>    <chr>            <chr>       <dbl>
#>  1 glm - linear_reg .actual    15.5  
#>  2 glm - linear_reg .predicted 16.5  
#>  3 glm - linear_reg .resid     -0.988
#>  4 glm - linear_reg .actual    19.2  
#>  5 glm - linear_reg .predicted 19.7  
#>  6 glm - linear_reg .resid     -0.488
#>  7 glm - linear_reg .actual    21.5  
#>  8 glm - linear_reg .predicted 21.6  
#>  9 glm - linear_reg .resid     -0.127
#> 10 glm - linear_reg .actual    14.3  
#> # ℹ 86 more rows
```
