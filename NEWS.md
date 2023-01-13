# tidyAML (development version)

## Breaking Changes
None

## New Features
1. Fix #73 - Add function `make_regression_base_tbl()`
2. Fix #74 - Add function `make_classification_base_tbl()`
3. Fix #77 - Add function `internal_make_spec_tbl()`
4. Fix #78 - Add function `internal_set_args_to_tune()`

## Minor Fixes and Improvements
1. Fix #72 - Update `fast_classification_parsnip_spec_tbl()` and 
`fast_regression_parsnip_spec_tbl()` to use the __make_regression__ and 
__make_classification__ functions.
2. Fix #79 #80 - Update `fast_classification_parsnip_spec_tbl()` and
`fast_regression_parsnip_spec_tbl()` to use the `internal_make_spec_tbl()`
function.
3. Fix #85 - This also addresses sub tasks #86 #87 and #88 to make the base table
functions to have a class and to then use that class in `internal_make_spec_tbl()`

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
