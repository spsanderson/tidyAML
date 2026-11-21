# Function Reference: Utilities

Complete reference for utility and helper functions in tidyAML.

## Table of Contents

- [Overview](#overview)
- [Package Management](#package-management)
- [Data Splitting](#data-splitting)
- [Data Quality](#data-quality)
- [Helper Functions](#helper-functions)

## Overview

Utility functions provide supporting functionality for package management, data preparation, and workflow management.

---

## Package Management

### core_packages

List core package dependencies.

#### Description

`core_packages()` returns a character vector of core tidyAML and tidymodels packages that are essential for the package to function.

#### Usage

```r
core_packages()
```

#### Value

Character vector of package names.

#### Examples

```r
library(tidyAML)

# List core packages
pkgs <- core_packages()
print(pkgs)

# Check which are installed
installed <- pkgs %in% installed.packages()[, "Package"]
data.frame(package = pkgs, installed = installed)

# Find missing packages
missing <- pkgs[!installed]
if (length(missing) > 0) {
  cat("Missing packages:", paste(missing, collapse = ", "))
}
```

#### See Also

- [load_deps](#load_deps) to load packages
- [install_deps](#install_deps) to install packages

---

### load_deps

Load core package dependencies.

#### Description

`load_deps()` loads all core tidyAML dependencies. Uses `library()` internally with error handling.

#### Usage

```r
load_deps()
```

#### Details

- Loads packages silently (no startup messages)
- Uses `try()` for graceful failure handling
- Continues even if some packages fail to load
- Useful for setup scripts

#### Examples

```r
library(tidyAML)

# Load all core dependencies
load_deps()

# Now all required packages are available
# No need for individual library() calls

# In setup script
if (interactive()) {
  tidyAML::load_deps()
}
```

#### Value

Called for side effects (loading packages). Returns `NULL` invisibly.

#### See Also

- [core_packages](#core_packages) to see what packages
- [install_deps](#install_deps) to install first

---

### install_deps

Install missing package dependencies.

#### Description

`install_deps()` installs any missing packages required by tidyAML. Checks which packages are already installed and only installs missing ones.

#### Usage

```r
install_deps()
```

#### Details

- Only installs packages not already installed
- Uses `install.packages()` with default repository
- May take several minutes
- Uses `try()` for error handling
- Shows progress messages

#### Examples

```r
library(tidyAML)

# Install missing dependencies
install_deps()

# After installation, load them
load_deps()

# Or combine in setup script
setup_tidyaml <- function() {
  library(tidyAML)
  install_deps()
  load_deps()
}
```

#### Note

This installs suggested packages that provide model engines. Core dependencies are already installed with tidyAML.

#### See Also

- [Installation Guide](Installation-Guide.md) for detailed installation instructions

---

## Data Splitting

### create_splits

Create rsample split objects.

#### Description

`create_splits()` creates data splits using rsample functions. Provides a convenient wrapper around rsample splitting functions.

#### Usage

```r
create_splits(
  .data,
  .split_type = "initial_split",
  .split_args = NULL
)
```

#### Arguments

| Argument | Description |
|----------|-------------|
| `.data` | A data frame to split |
| `.split_type` | Character string specifying rsample split type. Default: `"initial_split"`. |
| `.split_args` | Named list of arguments to pass to the split function. Default: `NULL` uses defaults. |

#### Value

Returns an rsample split object that can be used with `training()` and `testing()`.

#### Details

Supported split types from rsample:
- `"initial_split"` - Single train/test split
- `"initial_time_split"` - Time-based split
- `"vfold_cv"` - V-fold cross-validation
- `"bootstraps"` - Bootstrap resampling
- Other rsample split functions

#### Examples

```r
library(tidyAML)
library(rsample)

# Basic split (75/25 by default)
splits <- create_splits(.data = mtcars)
train_data <- training(splits)
test_data <- testing(splits)

# Custom proportion
splits <- create_splits(
  .data = mtcars,
  .split_args = list(prop = 0.8)
)

# With stratification
splits <- create_splits(
  .data = mtcars,
  .split_args = list(prop = 0.75, strata = "mpg")
)

# Different split type
cv_splits <- create_splits(
  .data = mtcars,
  .split_type = "vfold_cv",
  .split_args = list(v = 5)
)

# Bootstrap
boot_splits <- create_splits(
  .data = mtcars,
  .split_type = "bootstraps",
  .split_args = list(times = 25)
)
```

#### See Also

- `rsample` package documentation
- [Advanced Splits](Advanced-Splits.md) guide

---

## Data Quality

### check_duplicate_rows

Check for duplicate rows in a dataset.

#### Description

`check_duplicate_rows()` identifies and counts duplicate rows in a data frame, helping with data quality assessment.

#### Usage

```r
check_duplicate_rows(.data)
```

#### Arguments

| Argument | Description |
|----------|-------------|
| `.data` | A data frame to check for duplicates |

#### Value

Returns information about duplicate rows:
- Number of duplicate rows
- Indices of duplicate rows
- Summary statistics

#### Examples

```r
library(tidyAML)
library(dplyr)

# Check for duplicates
data(mtcars)
check_duplicate_rows(mtcars)

# Create data with duplicates
data_with_dupes <- bind_rows(
  mtcars,
  mtcars[1:5, ]  # Duplicate first 5 rows
)

# Check again
dupes <- check_duplicate_rows(data_with_dupes)
print(dupes)

# Remove duplicates if found
if (dupes$n_duplicates > 0) {
  data_clean <- distinct(data_with_dupes)
}
```

#### See Also

- `dplyr::distinct()` for removing duplicates
- [Data Preparation](Best-Practices.md#data-preparation) best practices

---

### quantile_normalize

Perform quantile normalization on data.

#### Description

`quantile_normalize()` performs quantile normalization, a technique that makes the distribution of values identical across samples.

#### Usage

```r
quantile_normalize(.data, ...)
```

#### Arguments

| Argument | Description |
|----------|-------------|
| `.data` | A data frame or matrix to normalize |
| `...` | Additional arguments passed to internal functions |

#### Value

Returns a normalized data frame or matrix with the same dimensions as input.

#### Details

Quantile normalization:
1. Ranks values in each column
2. Replaces each value with the mean of all values at that rank
3. Ensures identical distributions across columns

Useful for:
- Microarray data
- RNA-seq data
- Cross-sample comparisons
- Removing batch effects

#### Examples

```r
library(tidyAML)

# Create example data with different distributions
data <- data.frame(
  sample1 = c(5, 2, 3, 4, 1),
  sample2 = c(4, 1, 4, 2, 3),
  sample3 = c(3, 4, 6, 8, 2)
)

# Check distributions
summary(data)

# Quantile normalize
data_normalized <- quantile_normalize(data)

# Check normalized distributions
summary(data_normalized)
# Now all columns have same distribution

# Use in workflow
data_norm <- mtcars |>
  select(where(is.numeric)) |>
  quantile_normalize()
```

#### Note

Quantile normalization is aggressive and assumes samples should have identical distributions. Use with caution and domain knowledge.

#### See Also

- [Data Preprocessing](Package-Overview.md#key-components) in Package Overview
- Recipe `step_normalize()` for standard normalization

---

## Helper Functions

### match_args

Match and validate function arguments.

#### Description

`match_args()` is an internal utility for matching and validating arguments. Primarily used internally by tidyAML but available for advanced users.

#### Usage

```r
match_args(.arg, .choices)
```

#### Arguments

| Argument | Description |
|----------|-------------|
| `.arg` | Argument to match |
| `.choices` | Vector of valid choices |

#### Value

Returns matched argument or raises an error if no match.

#### Examples

```r
# Internal use - argument validation
engine <- match_args("lm", c("lm", "glm", "glmnet"))
# Returns: "lm"

# Error if invalid
try(match_args("invalid", c("lm", "glm")))
# Error: 'invalid' is not a valid choice
```

---

## Additional Base Table Functions

### make_regression_base_tbl

Create base regression table (internal).

#### Description

Internal function used by `fast_regression()` to create the base model specification table. Advanced users can use this for custom workflows.

#### Usage

```r
make_regression_base_tbl(.parsnip_fns, .parsnip_eng)
```

---

### make_classification_base_tbl

Create base classification table (internal).

#### Description

Internal function used by `fast_classification()` to create the base model specification table.

#### Usage

```r
make_classification_base_tbl(.parsnip_fns, .parsnip_eng)
```

---

## Internal Workflow Functions

These functions are exported but primarily for internal use. They're documented here for advanced users who want to build custom workflows.

### internal_make_spec_tbl

Create internal specification table.

### internal_make_wflw

Create workflow objects internally.

### internal_make_fitted_wflw

Fit workflows internally.

### internal_make_wflw_predictions

Generate predictions internally.

### full_internal_make_wflw

Complete workflow creation wrapper.

### internal_make_wflw_gee_lin_reg

Special handling for GEE linear regression models.

### internal_set_args_to_tune

Set arguments for hyperparameter tuning.

---

## Usage Patterns

### Package Setup

```r
# Setup script for new project
setup_project <- function() {
  # Install missing packages
  tidyAML::install_deps()
  
  # Load packages
  tidyAML::load_deps()
  
  # Set preferences
  tidymodels::tidymodels_prefer()
  
  message("tidyAML setup complete!")
}
```

### Data Quality Check

```r
# Check data quality before modeling
check_data_quality <- function(data) {
  list(
    duplicates = check_duplicate_rows(data),
    missing = sum(is.na(data)),
    completeness = 1 - mean(is.na(data))
  )
}

# Use it
quality <- check_data_quality(mtcars)
```

### Custom Splits

```r
# Create multiple split types
splits_list <- list(
  standard = create_splits(
    mtcars,
    .split_args = list(prop = 0.75)
  ),
  stratified = create_splits(
    mtcars,
    .split_args = list(prop = 0.75, strata = "cyl")
  ),
  bootstrap = create_splits(
    mtcars,
    .split_type = "bootstraps",
    .split_args = list(times = 25)
  )
)
```

---

## Related Pages

- [Function Reference: Model Generators](Function-Reference-Model-Generators.md)
- [Function Reference: Extractors](Function-Reference-Extractors.md)
- [Function Reference: Plotting](Function-Reference-Plotting.md)
- [Best Practices](Best-Practices.md)

---

[← Back to Extractors](Function-Reference-Extractors.md) | [Home](Home.md) | [Next: Plotting →](Function-Reference-Plotting.md)
