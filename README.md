
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyaml <img src="man/figures/logo.png" width="147" height="170" align="right" />

<!-- badges: start -->

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/tidyaml)](https://cran.r-project.org/package=tidyaml)
![](https://cranlogs.r-pkg.org/badges/tidyaml)
![](https://cranlogs.r-pkg.org/badges/grand-total/tidyaml) [![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html##experimental)
[![PRs
Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://makeapullrequest.com)
<!-- badges: end -->

The goal of tidyaml is to …

## Installation

You can install the development version of tidyaml like so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## Example

Part of the reason to use `{tidyaml}` is so that you can generate many
models of your data set. One way of modeling a data set is using
regression for some numeric output. There is a convienent function in
**tidyaml** that will generate a set of non-tunable models for *fast
regression*. Let’s take a look below.

``` r
library(tidyaml)
#> Loading required package: parsnip
#> 
#> == Welcome to tidyaml ===========================================================================
#> If you find this package useful, please leave a star: 
#>    https://github.com/spsanderson/tidyaml'
#> 
#> If you encounter a bug or want to request an enhancement please file an issue at:
#>    https://github.com/spsanderson/tidyaml/issues
#> 
#> Thank you for using tidyaml!

fast_regression_parsnip_spec_tbl(.parsnip_fns = "linear_reg")
#> # A tibble: 14 × 5
#>    .model_id .parsnip_engine .parsnip_mode .parsnip_fns model_spec
#>        <int> <chr>           <chr>         <chr>        <list>    
#>  1         1 lm              regression    linear_reg   <spec[+]> 
#>  2         2 brulee          regression    linear_reg   <spec[+]> 
#>  3         3 gee             regression    linear_reg   <spec[+]> 
#>  4         4 glm             regression    linear_reg   <spec[+]> 
#>  5         5 glmer           regression    linear_reg   <spec[+]> 
#>  6         6 glmnet          regression    linear_reg   <spec[+]> 
#>  7         7 gls             regression    linear_reg   <spec[+]> 
#>  8         8 h2o             regression    linear_reg   <spec[+]> 
#>  9         9 keras           regression    linear_reg   <spec[+]> 
#> 10        10 lme             regression    linear_reg   <spec[+]> 
#> 11        11 lmer            regression    linear_reg   <spec[+]> 
#> 12        12 spark           regression    linear_reg   <spec[+]> 
#> 13        13 stan            regression    linear_reg   <spec[+]> 
#> 14        14 stan_glmer      regression    linear_reg   <spec[+]>
fast_regression_parsnip_spec_tbl(.parsnip_eng = c("lm","glm"))
#> # A tibble: 3 × 5
#>   .model_id .parsnip_engine .parsnip_mode .parsnip_fns model_spec
#>       <int> <chr>           <chr>         <chr>        <list>    
#> 1         1 lm              regression    linear_reg   <spec[+]> 
#> 2         2 glm             regression    linear_reg   <spec[+]> 
#> 3         3 glm             regression    poisson_reg  <spec[+]>
```
