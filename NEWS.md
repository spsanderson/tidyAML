# tidyAML 0.0.3

## Breaking Changes
1. Fix #150 - Require R version >= 4.1.0 in order to use the native pipe.
2. Fix #170 - Drop `magrittr` from `Imports` of `DESCRIPTION` file from #150.

## New Features
1. Fix #157 - `internal_make_spec_tbl()` now adds a class to each `model_spec`
created by `parsnip`, for example, a `gee` engine setting using `linear_reg()` 
will return an extra class of `gee_linear_reg`
2. Fix #175 - Add Getting Started Vignette.

## Minor Fixes and Improvements
1. Fix #142 - Add `gee`, `glmnet`, and `rules` to the `core_packages()` function.
2. Fix #148 - Update `create_model_spec()`
3. Fix #155 - Add class `tidyaml_base_tbl` to the output of `create_model_spec()`
4. Fix #156 - Update `internal_set_args_to_tune()` to use `dplyr::pick()` instead 
of `dplyr::cur_data()` since it was deprecated.
5. Fix #161 - Update `internal_set_args_to_tune()` to use `!names(new_mod_args)`
instead of `!names(.)`
6. Fix #163 - Add attribute to model spec and drop class from #155
7. Fix #147 - Add packages to suggests, as they are not necessary for the pkg to work.
8. Fix #139 - Add suggestion to startup message to run `tidymodels::tidymodels_prefer()`
9. Fix #167 - Add function `internal_make_wflw_gee_lin_reg()`
10. Fix #168 - Add function `full_internal_make_wflw`
11. Fix #169 - Update `fast_classification()` and `fast_regression()` to use
`full_internal_make_wflw()`

# tidyAML 0.0.2

## Breaking Changes
None

## New Features
1. Fix #129 - Add the ability to extract model spec from the `create_model_spec()`
function.

## Minor Fixes and Improvements
1. Fix #130 - Add checks to `create_model_spec()`
2. Fix #127 - Fix `internal_make_wflw_predictions()` to use `recipes::testing()`
instead of `recipes::training()`

# tidyAML 0.0.1

## Breaking Changes
None

## New Features
1. Fix #73 - Add function `make_regression_base_tbl()`
2. Fix #74 - Add function `make_classification_base_tbl()`
3. Fix #77 - Add function `internal_make_spec_tbl()`
4. Fix #78 - Add function `internal_set_args_to_tune()`
5. Fix #16 - Add function `create_workflow_set()`
6. Fix #101 - Add function `get_model()`
7. Fix #102 - Add function `extract_model_spec()`
8. Fix #103 - Add function `extract_wflw()`
9. Fix #104 - Add function `extract_wflw_fit()`
10. Fix #105 - Add function `extract_wflw_pred()`
11. Fix #71 - Add function `match_args()`

## Minor Fixes and Improvements
1. Fix #72 - Update `fast_classification_parsnip_spec_tbl()` and 
`fast_regression_parsnip_spec_tbl()` to use the __make_regression__ and 
__make_classification__ functions.
2. Fix #79 #80 - Update `fast_classification_parsnip_spec_tbl()` and
`fast_regression_parsnip_spec_tbl()` to use the `internal_make_spec_tbl()`
function.
3. Fix #85 - This also addresses sub tasks #86 #87 and #88 to make the base table
functions to have a class and to then use that class in `internal_make_spec_tbl()`
4. Fix #99 - Update DESCRIPTION for __R >= 3.4.0__

# tidyAML 0.0.0.9002

## New Features
1. Fix #62 - Add function `fast_classification_parsnip_spec_tbl()`
2. Fix #65 - Add function `fast_classification()`

## Breaking Changes
None

## Minor Fixes and Improvements
None

# tidyAML 0.0.0.9001

## New Features
1. Fix #48 - Add functions `core_packages()` `install_deps()`, and `load_deps()`

## Breaking Changes
None

## Minor Fixes and Improvements
None

# tidyAML 0.0.0.9000

## New Features
1. Fix #5 - Add function `fast_regression_parsnip_spec_tbl()`
2. Fix #6 - Add function `create_splits()`
3. Fix #7 - Add function `fast_regression()`
4. Fix #11 - Add function `create_model_spec()`
5. Fix #30, #31, 32 - Add internal functions `internal_make_wflw()`, `internal_make_fitted_wflw()`, `internal_make_wflw_predictions()`

## Breaking Changes
None

## Minor Fixes and Improvements
None

* Added a `NEWS.md` file to track changes to the package.
