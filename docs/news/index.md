# Changelog

## tidyAML (development version)

### Breaking Changes

None

### New Features

None

### Minor Fixes and Improvements

1.  Fix [\#256](https://github.com/spsanderson/tidyAML/issues/256) -
    Update
    [`load_deps()`](https://www.spsanderson.com/tidyaml/reference/load_deps.md)
    and
    [`install_deps()`](https://www.spsanderson.com/tidyaml/reference/install_deps.md)
    to use a `try` block.
2.  Fix [\#266](https://github.com/spsanderson/tidyAML/issues/266) -
    Major overhaul in how regression and classification model specs are
    built.

## tidyAML 0.0.6

CRAN release: 2025-05-12

### Breaking Changes

None

### New Features

1.  Fix [\#242](https://github.com/spsanderson/tidyAML/issues/242) - Add
    function
    [`quantile_normalize()`](https://www.spsanderson.com/tidyaml/reference/quantile_normalize.md).
2.  Fix [\#243](https://github.com/spsanderson/tidyAML/issues/243) - Add
    function
    [`check_duplicate_rows()`](https://www.spsanderson.com/tidyaml/reference/check_duplicate_rows.md).
3.  Fix [\#248](https://github.com/spsanderson/tidyAML/issues/248) - Add
    function
    [`extract_tunable_params()`](https://www.spsanderson.com/tidyaml/reference/extract_tunable_params.md).

### Minor Fixes and Improvements

1.  Fix [\#239](https://github.com/spsanderson/tidyAML/issues/239) - Fix
    erroneous documentation for
    [`plot_regression_predictions()`](https://www.spsanderson.com/tidyaml/reference/plot_regression_predictions.md).

## tidyAML 0.0.5

CRAN release: 2024-03-12

### Breaking Changes

None

### New Features

1.  Fix [\#217](https://github.com/spsanderson/tidyAML/issues/217) - Add
    function
    [`plot_regression_residuals()`](https://www.spsanderson.com/tidyaml/reference/plot_regression_residuals.md)
    to plot the residuals.
2.  Fix [\#215](https://github.com/spsanderson/tidyAML/issues/215) - Add
    function
    [`plot_regression_predictions()`](https://www.spsanderson.com/tidyaml/reference/plot_regression_predictions.md)
    to plot the predictions from the function
    `extract_wflw_predictions()`

### Minor Fixes and Improvements

1.  Fix [\#214](https://github.com/spsanderson/tidyAML/issues/214) -
    Drop selection message from
    [`load_deps()`](https://www.spsanderson.com/tidyaml/reference/load_deps.md)
2.  Fix [\#222](https://github.com/spsanderson/tidyAML/issues/222) -
    Update
    [`fast_regression()`](https://www.spsanderson.com/tidyaml/reference/fast_regression.md)
    and
    [`fast_classification()`](https://www.spsanderson.com/tidyaml/reference/fast_classification.md)
    to drop NULL predictions.

## tidyAML 0.0.4

CRAN release: 2024-01-09

### Breaking Changes

None

### New Features

1.  Fix [\#187](https://github.com/spsanderson/tidyAML/issues/187) and
    [\#198](https://github.com/spsanderson/tidyAML/issues/198) - Add
    function
    [`extract_regression_residuals()`](https://www.spsanderson.com/tidyaml/reference/extract_regression_residuals.md)
2.  Fix [\#199](https://github.com/spsanderson/tidyAML/issues/199) - Add
    parameters `.drop_na` to
    [`fast_classification()`](https://www.spsanderson.com/tidyaml/reference/fast_classification.md)
    and
    [`fast_regression()`](https://www.spsanderson.com/tidyaml/reference/fast_regression.md).

### Minor Fixes and Improvements

1.  Fix [\#186](https://github.com/spsanderson/tidyAML/issues/186) - Add
    the following to the core_packages():
    - `discrim`
    - `mda`
    - `sda`
    - `sparsediscrim`
    - `liquidSVM`
    - `kernlab`
    - `klaR`
2.  Fix [\#190](https://github.com/spsanderson/tidyAML/issues/190) -
    Update the
    [`internal_make_wflw_predictions()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_predictions.md)
    to include all data
    - The actual data
    - The training predictions
    - The testing predictions

## tidyAML 0.0.3

CRAN release: 2023-11-29

### Breaking Changes

1.  Fix [\#150](https://github.com/spsanderson/tidyAML/issues/150) -
    Require R version \>= 4.1.0 in order to use the native pipe.
2.  Fix [\#170](https://github.com/spsanderson/tidyAML/issues/170) -
    Drop `magrittr` from `Imports` of `DESCRIPTION` file from
    [\#150](https://github.com/spsanderson/tidyAML/issues/150).

### New Features

1.  Fix [\#157](https://github.com/spsanderson/tidyAML/issues/157) -
    [`internal_make_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/internal_make_spec_tbl.md)
    now adds a class to each `model_spec` created by `parsnip`, for
    example, a `gee` engine setting using
    [`linear_reg()`](https://parsnip.tidymodels.org/reference/linear_reg.html)
    will return an extra class of `gee_linear_reg`
2.  Fix [\#175](https://github.com/spsanderson/tidyAML/issues/175) - Add
    Getting Started Vignette.

### Minor Fixes and Improvements

1.  Fix [\#142](https://github.com/spsanderson/tidyAML/issues/142) - Add
    `gee`, `glmnet`, and `rules` to the
    [`core_packages()`](https://www.spsanderson.com/tidyaml/reference/core_packages.md)
    function.
2.  Fix [\#148](https://github.com/spsanderson/tidyAML/issues/148) -
    Update
    [`create_model_spec()`](https://www.spsanderson.com/tidyaml/reference/create_model_spec.md)
3.  Fix [\#155](https://github.com/spsanderson/tidyAML/issues/155) - Add
    class `tidyaml_base_tbl` to the output of
    [`create_model_spec()`](https://www.spsanderson.com/tidyaml/reference/create_model_spec.md)
4.  Fix [\#156](https://github.com/spsanderson/tidyAML/issues/156) -
    Update
    [`internal_set_args_to_tune()`](https://www.spsanderson.com/tidyaml/reference/internal_set_args_to_tune.md)
    to use
    [`dplyr::pick()`](https://dplyr.tidyverse.org/reference/pick.html)
    instead of
    [`dplyr::cur_data()`](https://dplyr.tidyverse.org/reference/deprec-context.html)
    since it was deprecated.
5.  Fix [\#161](https://github.com/spsanderson/tidyAML/issues/161) -
    Update
    [`internal_set_args_to_tune()`](https://www.spsanderson.com/tidyaml/reference/internal_set_args_to_tune.md)
    to use `!names(new_mod_args)` instead of `!names(.)`
6.  Fix [\#163](https://github.com/spsanderson/tidyAML/issues/163) - Add
    attribute to model spec and drop class from
    [\#155](https://github.com/spsanderson/tidyAML/issues/155)
7.  Fix [\#147](https://github.com/spsanderson/tidyAML/issues/147) - Add
    packages to suggests, as they are not necessary for the pkg to work.
8.  Fix [\#139](https://github.com/spsanderson/tidyAML/issues/139) - Add
    suggestion to startup message to run
    [`tidymodels::tidymodels_prefer()`](https://tidymodels.tidymodels.org/reference/tidymodels_prefer.html)
9.  Fix [\#167](https://github.com/spsanderson/tidyAML/issues/167) - Add
    function
    [`internal_make_wflw_gee_lin_reg()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_gee_lin_reg.md)
10. Fix [\#168](https://github.com/spsanderson/tidyAML/issues/168) - Add
    function `full_internal_make_wflw`
11. Fix [\#169](https://github.com/spsanderson/tidyAML/issues/169) -
    Update
    [`fast_classification()`](https://www.spsanderson.com/tidyaml/reference/fast_classification.md)
    and
    [`fast_regression()`](https://www.spsanderson.com/tidyaml/reference/fast_regression.md)
    to use
    [`full_internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/full_internal_make_wflw.md)

## tidyAML 0.0.2

CRAN release: 2023-04-20

### Breaking Changes

None

### New Features

1.  Fix [\#129](https://github.com/spsanderson/tidyAML/issues/129) - Add
    the ability to extract model spec from the
    [`create_model_spec()`](https://www.spsanderson.com/tidyaml/reference/create_model_spec.md)
    function.

### Minor Fixes and Improvements

1.  Fix [\#130](https://github.com/spsanderson/tidyAML/issues/130) - Add
    checks to
    [`create_model_spec()`](https://www.spsanderson.com/tidyaml/reference/create_model_spec.md)
2.  Fix [\#127](https://github.com/spsanderson/tidyAML/issues/127) - Fix
    [`internal_make_wflw_predictions()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_predictions.md)
    to use `recipes::testing()` instead of `recipes::training()`

## tidyAML 0.0.1

CRAN release: 2023-02-16

### Breaking Changes

None

### New Features

1.  Fix [\#73](https://github.com/spsanderson/tidyAML/issues/73) - Add
    function
    [`make_regression_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_regression_base_tbl.md)
2.  Fix [\#74](https://github.com/spsanderson/tidyAML/issues/74) - Add
    function
    [`make_classification_base_tbl()`](https://www.spsanderson.com/tidyaml/reference/make_classification_base_tbl.md)
3.  Fix [\#77](https://github.com/spsanderson/tidyAML/issues/77) - Add
    function
    [`internal_make_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/internal_make_spec_tbl.md)
4.  Fix [\#78](https://github.com/spsanderson/tidyAML/issues/78) - Add
    function
    [`internal_set_args_to_tune()`](https://www.spsanderson.com/tidyaml/reference/internal_set_args_to_tune.md)
5.  Fix [\#16](https://github.com/spsanderson/tidyAML/issues/16) - Add
    function
    [`create_workflow_set()`](https://www.spsanderson.com/tidyaml/reference/create_workflow_set.md)
6.  Fix [\#101](https://github.com/spsanderson/tidyAML/issues/101) - Add
    function
    [`get_model()`](https://www.spsanderson.com/tidyaml/reference/get_model.md)
7.  Fix [\#102](https://github.com/spsanderson/tidyAML/issues/102) - Add
    function
    [`extract_model_spec()`](https://www.spsanderson.com/tidyaml/reference/extract_model_spec.md)
8.  Fix [\#103](https://github.com/spsanderson/tidyAML/issues/103) - Add
    function
    [`extract_wflw()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw.md)
9.  Fix [\#104](https://github.com/spsanderson/tidyAML/issues/104) - Add
    function
    [`extract_wflw_fit()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_fit.md)
10. Fix [\#105](https://github.com/spsanderson/tidyAML/issues/105) - Add
    function
    [`extract_wflw_pred()`](https://www.spsanderson.com/tidyaml/reference/extract_wflw_pred.md)
11. Fix [\#71](https://github.com/spsanderson/tidyAML/issues/71) - Add
    function
    [`match_args()`](https://www.spsanderson.com/tidyaml/reference/match_args.md)

### Minor Fixes and Improvements

1.  Fix [\#72](https://github.com/spsanderson/tidyAML/issues/72) -
    Update
    [`fast_classification_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_classification_parsnip_spec_tbl.md)
    and
    [`fast_regression_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_regression_parsnip_spec_tbl.md)
    to use the **make_regression** and **make_classification**
    functions.
2.  Fix [\#79](https://github.com/spsanderson/tidyAML/issues/79)
    [\#80](https://github.com/spsanderson/tidyAML/issues/80) - Update
    [`fast_classification_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_classification_parsnip_spec_tbl.md)
    and
    [`fast_regression_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_regression_parsnip_spec_tbl.md)
    to use the
    [`internal_make_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/internal_make_spec_tbl.md)
    function.
3.  Fix [\#85](https://github.com/spsanderson/tidyAML/issues/85) - This
    also addresses sub tasks
    [\#86](https://github.com/spsanderson/tidyAML/issues/86)
    [\#87](https://github.com/spsanderson/tidyAML/issues/87) and
    [\#88](https://github.com/spsanderson/tidyAML/issues/88) to make the
    base table functions to have a class and to then use that class in
    [`internal_make_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/internal_make_spec_tbl.md)
4.  Fix [\#99](https://github.com/spsanderson/tidyAML/issues/99) -
    Update DESCRIPTION for **R \>= 3.4.0**

## tidyAML 0.0.0.9002

### New Features

1.  Fix [\#62](https://github.com/spsanderson/tidyAML/issues/62) - Add
    function
    [`fast_classification_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_classification_parsnip_spec_tbl.md)
2.  Fix [\#65](https://github.com/spsanderson/tidyAML/issues/65) - Add
    function
    [`fast_classification()`](https://www.spsanderson.com/tidyaml/reference/fast_classification.md)

### Breaking Changes

None

### Minor Fixes and Improvements

None

## tidyAML 0.0.0.9001

### New Features

1.  Fix [\#48](https://github.com/spsanderson/tidyAML/issues/48) - Add
    functions
    [`core_packages()`](https://www.spsanderson.com/tidyaml/reference/core_packages.md)
    [`install_deps()`](https://www.spsanderson.com/tidyaml/reference/install_deps.md),
    and
    [`load_deps()`](https://www.spsanderson.com/tidyaml/reference/load_deps.md)

### Breaking Changes

None

### Minor Fixes and Improvements

None

## tidyAML 0.0.0.9000

### New Features

1.  Fix [\#5](https://github.com/spsanderson/tidyAML/issues/5) - Add
    function
    [`fast_regression_parsnip_spec_tbl()`](https://www.spsanderson.com/tidyaml/reference/fast_regression_parsnip_spec_tbl.md)
2.  Fix [\#6](https://github.com/spsanderson/tidyAML/issues/6) - Add
    function
    [`create_splits()`](https://www.spsanderson.com/tidyaml/reference/create_splits.md)
3.  Fix [\#7](https://github.com/spsanderson/tidyAML/issues/7) - Add
    function
    [`fast_regression()`](https://www.spsanderson.com/tidyaml/reference/fast_regression.md)
4.  Fix [\#11](https://github.com/spsanderson/tidyAML/issues/11) - Add
    function
    [`create_model_spec()`](https://www.spsanderson.com/tidyaml/reference/create_model_spec.md)
5.  Fix [\#30](https://github.com/spsanderson/tidyAML/issues/30),
    [\#31](https://github.com/spsanderson/tidyAML/issues/31), 32 - Add
    internal functions
    [`internal_make_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw.md),
    [`internal_make_fitted_wflw()`](https://www.spsanderson.com/tidyaml/reference/internal_make_fitted_wflw.md),
    [`internal_make_wflw_predictions()`](https://www.spsanderson.com/tidyaml/reference/internal_make_wflw_predictions.md)

### Breaking Changes

None

### Minor Fixes and Improvements

None

- Added a `NEWS.md` file to track changes to the package.
