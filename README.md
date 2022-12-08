
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
  gt() %>%
  tab_header(
    title = "Supported Parsnip Engines and Functions for Regression"
  )
```

<div id="ggfquyscis" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ggfquyscis .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ggfquyscis .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ggfquyscis .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#ggfquyscis .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ggfquyscis .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ggfquyscis .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ggfquyscis .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ggfquyscis .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ggfquyscis .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ggfquyscis .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ggfquyscis .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ggfquyscis .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ggfquyscis .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#ggfquyscis .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ggfquyscis .gt_from_md > :first-child {
  margin-top: 0;
}

#ggfquyscis .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ggfquyscis .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ggfquyscis .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#ggfquyscis .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#ggfquyscis .gt_row_group_first td {
  border-top-width: 2px;
}

#ggfquyscis .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ggfquyscis .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#ggfquyscis .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#ggfquyscis .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ggfquyscis .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ggfquyscis .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ggfquyscis .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ggfquyscis .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ggfquyscis .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ggfquyscis .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ggfquyscis .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ggfquyscis .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ggfquyscis .gt_left {
  text-align: left;
}

#ggfquyscis .gt_center {
  text-align: center;
}

#ggfquyscis .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ggfquyscis .gt_font_normal {
  font-weight: normal;
}

#ggfquyscis .gt_font_bold {
  font-weight: bold;
}

#ggfquyscis .gt_font_italic {
  font-style: italic;
}

#ggfquyscis .gt_super {
  font-size: 65%;
}

#ggfquyscis .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#ggfquyscis .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#ggfquyscis .gt_indent_1 {
  text-indent: 5px;
}

#ggfquyscis .gt_indent_2 {
  text-indent: 10px;
}

#ggfquyscis .gt_indent_3 {
  text-indent: 15px;
}

#ggfquyscis .gt_indent_4 {
  text-indent: 20px;
}

#ggfquyscis .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  <thead class="gt_header">
    <tr>
      <td colspan="4" class="gt_heading gt_title gt_font_normal gt_bottom_border" style>Supported Parsnip Engines and Functions for Regression</td>
    </tr>
    
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id=".model_id">.model_id</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=".parsnip_engine">.parsnip_engine</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=".parsnip_mode">.parsnip_mode</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=".parsnip_fns">.parsnip_fns</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=".model_id" class="gt_row gt_right">1</td>
<td headers=".parsnip_engine" class="gt_row gt_left">lm</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">linear_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">2</td>
<td headers=".parsnip_engine" class="gt_row gt_left">brulee</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">linear_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">3</td>
<td headers=".parsnip_engine" class="gt_row gt_left">gee</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">linear_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">4</td>
<td headers=".parsnip_engine" class="gt_row gt_left">glm</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">linear_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">5</td>
<td headers=".parsnip_engine" class="gt_row gt_left">glmer</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">linear_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">6</td>
<td headers=".parsnip_engine" class="gt_row gt_left">glmnet</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">linear_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">7</td>
<td headers=".parsnip_engine" class="gt_row gt_left">gls</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">linear_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">8</td>
<td headers=".parsnip_engine" class="gt_row gt_left">h2o</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">linear_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">9</td>
<td headers=".parsnip_engine" class="gt_row gt_left">keras</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">linear_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">10</td>
<td headers=".parsnip_engine" class="gt_row gt_left">lme</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">linear_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">11</td>
<td headers=".parsnip_engine" class="gt_row gt_left">lmer</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">linear_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">12</td>
<td headers=".parsnip_engine" class="gt_row gt_left">spark</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">linear_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">13</td>
<td headers=".parsnip_engine" class="gt_row gt_left">stan</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">linear_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">14</td>
<td headers=".parsnip_engine" class="gt_row gt_left">stan_glmer</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">linear_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">15</td>
<td headers=".parsnip_engine" class="gt_row gt_left">Cubist</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">cubist_rules</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">16</td>
<td headers=".parsnip_engine" class="gt_row gt_left">glm</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">poisson_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">17</td>
<td headers=".parsnip_engine" class="gt_row gt_left">gee</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">poisson_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">18</td>
<td headers=".parsnip_engine" class="gt_row gt_left">glmer</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">poisson_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">19</td>
<td headers=".parsnip_engine" class="gt_row gt_left">glmnet</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">poisson_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">20</td>
<td headers=".parsnip_engine" class="gt_row gt_left">h2o</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">poisson_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">21</td>
<td headers=".parsnip_engine" class="gt_row gt_left">hurdle</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">poisson_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">22</td>
<td headers=".parsnip_engine" class="gt_row gt_left">stan</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">poisson_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">23</td>
<td headers=".parsnip_engine" class="gt_row gt_left">stan_glmer</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">poisson_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">24</td>
<td headers=".parsnip_engine" class="gt_row gt_left">zeroinfl</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">poisson_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">25</td>
<td headers=".parsnip_engine" class="gt_row gt_left">survival</td>
<td headers=".parsnip_mode" class="gt_row gt_left">censored regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">survival_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">26</td>
<td headers=".parsnip_engine" class="gt_row gt_left">flexsurv</td>
<td headers=".parsnip_mode" class="gt_row gt_left">censored regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">survival_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">27</td>
<td headers=".parsnip_engine" class="gt_row gt_left">flexsurvspline</td>
<td headers=".parsnip_mode" class="gt_row gt_left">censored regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">survival_reg</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">28</td>
<td headers=".parsnip_engine" class="gt_row gt_left">earth</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">bag_mars</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">29</td>
<td headers=".parsnip_engine" class="gt_row gt_left">rpart</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">bag_tree</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">30</td>
<td headers=".parsnip_engine" class="gt_row gt_left">dbarts</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">bart</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">31</td>
<td headers=".parsnip_engine" class="gt_row gt_left">xgboost</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">boost_tree</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">32</td>
<td headers=".parsnip_engine" class="gt_row gt_left">h2o</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">boost_tree</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">33</td>
<td headers=".parsnip_engine" class="gt_row gt_left">lightgbm</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">boost_tree</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">34</td>
<td headers=".parsnip_engine" class="gt_row gt_left">spark</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">boost_tree</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">35</td>
<td headers=".parsnip_engine" class="gt_row gt_left">mboost</td>
<td headers=".parsnip_mode" class="gt_row gt_left">censored regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">boost_tree</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">36</td>
<td headers=".parsnip_engine" class="gt_row gt_left">rpart</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">decision_tree</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">37</td>
<td headers=".parsnip_engine" class="gt_row gt_left">spark</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">decision_tree</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">38</td>
<td headers=".parsnip_engine" class="gt_row gt_left">partykit</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">decision_tree</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">39</td>
<td headers=".parsnip_engine" class="gt_row gt_left">mgcv</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">gen_additive_mod</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">40</td>
<td headers=".parsnip_engine" class="gt_row gt_left">earth</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">mars</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">41</td>
<td headers=".parsnip_engine" class="gt_row gt_left">nnet</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">mlp</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">42</td>
<td headers=".parsnip_engine" class="gt_row gt_left">brulee</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">mlp</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">43</td>
<td headers=".parsnip_engine" class="gt_row gt_left">h2o</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">mlp</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">44</td>
<td headers=".parsnip_engine" class="gt_row gt_left">keras</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">mlp</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">45</td>
<td headers=".parsnip_engine" class="gt_row gt_left">kknn</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">nearest_neighbor</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">46</td>
<td headers=".parsnip_engine" class="gt_row gt_left">mixOmics</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">pls</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">47</td>
<td headers=".parsnip_engine" class="gt_row gt_left">ranger</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">rand_forest</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">48</td>
<td headers=".parsnip_engine" class="gt_row gt_left">h2o</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">rand_forest</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">49</td>
<td headers=".parsnip_engine" class="gt_row gt_left">randomForest</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">rand_forest</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">50</td>
<td headers=".parsnip_engine" class="gt_row gt_left">spark</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">rand_forest</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">51</td>
<td headers=".parsnip_engine" class="gt_row gt_left">partykit</td>
<td headers=".parsnip_mode" class="gt_row gt_left">censored regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">rand_forest</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">52</td>
<td headers=".parsnip_engine" class="gt_row gt_left">aorsf</td>
<td headers=".parsnip_mode" class="gt_row gt_left">censored regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">rand_forest</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">53</td>
<td headers=".parsnip_engine" class="gt_row gt_left">xrf</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">rule_fit</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">54</td>
<td headers=".parsnip_engine" class="gt_row gt_left">h2o</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">rule_fit</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">55</td>
<td headers=".parsnip_engine" class="gt_row gt_left">LiblineaR</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">svm_linear</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">56</td>
<td headers=".parsnip_engine" class="gt_row gt_left">kernlab</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">svm_linear</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">57</td>
<td headers=".parsnip_engine" class="gt_row gt_left">kernlab</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">svm_poly</td></tr>
    <tr><td headers=".model_id" class="gt_row gt_right">58</td>
<td headers=".parsnip_engine" class="gt_row gt_left">kernlab</td>
<td headers=".parsnip_mode" class="gt_row gt_left">regression</td>
<td headers=".parsnip_fns" class="gt_row gt_left">svm_rbf</td></tr>
  </tbody>
  
  
</table>
</div>

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
