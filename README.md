
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

This is a basic example which shows you how to solve a common problem:

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

Here are all of the `parsnip::engines` and `parsnip regression`
functions that are supported for the
`fast_regression_parsnip_spec_tbl()` function.

``` r
library(gt)
library(dplyr)

fast_regression_parsnip_spec_tbl() %>%
  select(-model_spec) %>%
  knitr::kable()
```

| .model_id | .parsnip_engine | .parsnip_mode       | .parsnip_fns     |
|----------:|:----------------|:--------------------|:-----------------|
|         1 | lm              | regression          | linear_reg       |
|         2 | brulee          | regression          | linear_reg       |
|         3 | gee             | regression          | linear_reg       |
|         4 | glm             | regression          | linear_reg       |
|         5 | glmer           | regression          | linear_reg       |
|         6 | glmnet          | regression          | linear_reg       |
|         7 | gls             | regression          | linear_reg       |
|         8 | h2o             | regression          | linear_reg       |
|         9 | keras           | regression          | linear_reg       |
|        10 | lme             | regression          | linear_reg       |
|        11 | lmer            | regression          | linear_reg       |
|        12 | spark           | regression          | linear_reg       |
|        13 | stan            | regression          | linear_reg       |
|        14 | stan_glmer      | regression          | linear_reg       |
|        15 | Cubist          | regression          | cubist_rules     |
|        16 | glm             | regression          | poisson_reg      |
|        17 | gee             | regression          | poisson_reg      |
|        18 | glmer           | regression          | poisson_reg      |
|        19 | glmnet          | regression          | poisson_reg      |
|        20 | h2o             | regression          | poisson_reg      |
|        21 | hurdle          | regression          | poisson_reg      |
|        22 | stan            | regression          | poisson_reg      |
|        23 | stan_glmer      | regression          | poisson_reg      |
|        24 | zeroinfl        | regression          | poisson_reg      |
|        25 | survival        | censored regression | survival_reg     |
|        26 | flexsurv        | censored regression | survival_reg     |
|        27 | flexsurvspline  | censored regression | survival_reg     |
|        28 | earth           | regression          | bag_mars         |
|        29 | rpart           | regression          | bag_tree         |
|        30 | dbarts          | regression          | bart             |
|        31 | xgboost         | regression          | boost_tree       |
|        32 | h2o             | regression          | boost_tree       |
|        33 | lightgbm        | regression          | boost_tree       |
|        34 | spark           | regression          | boost_tree       |
|        35 | mboost          | censored regression | boost_tree       |
|        36 | rpart           | regression          | decision_tree    |
|        37 | spark           | regression          | decision_tree    |
|        38 | partykit        | regression          | decision_tree    |
|        39 | mgcv            | regression          | gen_additive_mod |
|        40 | earth           | regression          | mars             |
|        41 | nnet            | regression          | mlp              |
|        42 | brulee          | regression          | mlp              |
|        43 | h2o             | regression          | mlp              |
|        44 | keras           | regression          | mlp              |
|        45 | kknn            | regression          | nearest_neighbor |
|        46 | mixOmics        | regression          | pls              |
|        47 | ranger          | regression          | rand_forest      |
|        48 | h2o             | regression          | rand_forest      |
|        49 | randomForest    | regression          | rand_forest      |
|        50 | spark           | regression          | rand_forest      |
|        51 | partykit        | censored regression | rand_forest      |
|        52 | aorsf           | censored regression | rand_forest      |
|        53 | xrf             | regression          | rule_fit         |
|        54 | h2o             | regression          | rule_fit         |
|        55 | LiblineaR       | regression          | svm_linear       |
|        56 | kernlab         | regression          | svm_linear       |
|        57 | kernlab         | regression          | svm_poly         |
|        58 | kernlab         | regression          | svm_rbf          |

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
