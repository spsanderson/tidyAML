# Function Reference: Model Generators

Complete reference for model generation functions in tidyAML.

## Table of Contents

- [Overview](#overview)
- [fast_regression](#fast_regression)
- [fast_classification](#fast_classification)
- [create_model_spec](#create_model_spec)
- [fast_regression_parsnip_spec_tbl](#fast_regression_parsnip_spec_tbl)
- [fast_classification_parsnip_spec_tbl](#fast_classification_parsnip_spec_tbl)
- [create_workflow_set](#create_workflow_set)

## Overview

Model generators are the core functions in tidyAML that create and train machine learning models. They automate the process of model specification, workflow creation, fitting, and prediction.

---

## fast_regression

Generate and train multiple regression models automatically.

### Description

`fast_regression()` creates model specifications, workflows, fits models, and generates predictions for regression tasks with a single function call.

### Usage

```r
fast_regression(
  .data,
  .rec_obj,
  .parsnip_fns = "all",
  .parsnip_eng = "all",
  .split_type = "initial_split",
  .split_args = NULL,
  .drop_na = TRUE
)
```

### Arguments

| Argument | Description |
|----------|-------------|
| `.data` | A data frame containing your dataset |
| `.rec_obj` | A recipes object defining preprocessing steps. Must include the target variable. |
| `.parsnip_fns` | Character vector of parsnip function names (e.g., `"linear_reg"`, `"boost_tree"`). Default: `"all"` uses all available regression functions. |
| `.parsnip_eng` | Character vector of parsnip engine names (e.g., `"lm"`, `"glmnet"`). Default: `"all"` uses all available engines. |
| `.split_type` | Type of rsample split to use. Default: `"initial_split"`. |
| `.split_args` | Named list of arguments to pass to the split function. Default: `NULL` uses default split parameters. |
| `.drop_na` | Logical. If `TRUE` (default), drops rows with missing values before modeling. |

### Value

Returns a tibble with the following columns:
- `.model_id`: Integer, unique identifier for each model
- `.parsnip_engine`: Character, the engine used
- `.parsnip_mode`: Character, "regression"
- `.parsnip_fns`: Character, the parsnip function used
- `model_spec`: List-column containing model specification objects
- `wflw`: List-column containing workflow objects
- `fitted_wflw`: List-column containing fitted workflows
- `pred_wflw`: List-column containing prediction tibbles

### Details

- Uses `purrr::safely()` internally for graceful failure handling
- Models that fail (e.g., due to missing packages) return `NULL` instead of stopping execution
- Automatically creates train/test splits using rsample
- Generates predictions for both training and testing sets
- Returns only successful models (failed models are filtered out)

### Examples

```r
library(tidyAML)
library(recipes)

# Basic usage with default settings
rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj
)

# Specific engines only
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm")
)

# Specific function type
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_fns = "linear_reg"
)

# Combined filtering
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm"),
  .parsnip_fns = "linear_reg"
)

# Custom split with stratification
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .split_type = "initial_split",
  .split_args = list(prop = 0.8, strata = "mpg")
)

# With preprocessing
rec_obj <- recipe(mpg ~ ., data = mtcars) |>
  step_normalize(all_numeric_predictors()) |>
  step_corr(all_numeric_predictors(), threshold = 0.9)

models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glmnet")
)
```

### See Also

- [fast_classification](#fast_classification) for classification tasks
- [extract_wflw_pred](Function-Reference-Extractors.md#extract_wflw_pred) to extract predictions
- [plot_regression_predictions](Function-Reference-Plotting.md#plot_regression_predictions) for visualization

---

## fast_classification

Generate and train multiple classification models automatically.

### Description

`fast_classification()` creates model specifications, workflows, fits models, and generates predictions for classification tasks with a single function call.

### Usage

```r
fast_classification(
  .data,
  .rec_obj,
  .parsnip_fns = "all",
  .parsnip_eng = "all",
  .split_type = "initial_split",
  .split_args = NULL,
  .drop_na = TRUE
)
```

### Arguments

| Argument | Description |
|----------|-------------|
| `.data` | A data frame with the target variable as a factor |
| `.rec_obj` | A recipes object. Target must be a factor. |
| `.parsnip_fns` | Character vector of parsnip function names (e.g., `"logistic_reg"`, `"rand_forest"`). Default: `"all"`. |
| `.parsnip_eng` | Character vector of engine names (e.g., `"glm"`, `"ranger"`). Default: `"all"`. |
| `.split_type` | Type of rsample split. Default: `"initial_split"`. |
| `.split_args` | Named list of split arguments. Default: `NULL`. |
| `.drop_na` | Logical. Drop NAs before modeling. Default: `TRUE`. |

### Value

Returns a tibble with the following columns:
- `.model_id`: Unique model identifier
- `.parsnip_engine`: Engine used
- `.parsnip_mode`: "classification"
- `.parsnip_fns`: Parsnip function used
- `model_spec`: Model specification objects
- `wflw`: Workflow objects
- `fitted_wflw`: Fitted workflows
- `pred_wflw`: Prediction tibbles (includes predicted classes and probabilities)

### Details

- Target variable MUST be a factor
- Use `mutate(target = as.factor(target))` to convert if needed
- Graceful failure handling via `purrr::safely()`
- Returns predicted classes and probabilities
- Automatically stratifies splits by target (recommended)

### Examples

```r
library(tidyAML)
library(recipes)
library(dplyr)
library(tidyr)

# Prepare Titanic data
df <- Titanic |>
  as_tibble() |>
  uncount(n) |>
  mutate(across(everything(), as.factor))

# Basic classification
rec_obj <- recipe(Survived ~ ., data = df)
models <- fast_classification(
  .data = df,
  .rec_obj = rec_obj
)

# Specific engines
models <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .parsnip_eng = c("glm", "glmnet")
)

# With stratification (recommended)
models <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .split_args = list(prop = 0.75, strata = "Survived")
)

# Multi-class example
data(iris)
iris <- iris |> mutate(Species = as.factor(Species))

rec_iris <- recipe(Species ~ ., data = iris) |>
  step_normalize(all_numeric_predictors())

iris_models <- fast_classification(
  .data = iris,
  .rec_obj = rec_iris,
  .parsnip_fns = "multinom_reg"
)
```

### See Also

- [fast_regression](#fast_regression) for regression tasks
- [extract_wflw_pred](Function-Reference-Extractors.md#extract_wflw_pred) to extract predictions
- [Classification Tutorial](Classification-Tutorial.md) for detailed examples

---

## create_model_spec

Create custom model specifications without training.

### Description

`create_model_spec()` generates model specifications (parsnip objects) for specified engines and functions, without actually training them. Useful for custom workflows or inspection.

### Usage

```r
create_model_spec(
  .parsnip_eng = list("lm"),
  .mode = list("regression"),
  .parsnip_fns = list("linear_reg"),
  .return_tibble = TRUE
)
```

### Arguments

| Argument | Description |
|----------|-------------|
| `.parsnip_eng` | List of engine names (e.g., `list("lm", "glm", "glmnet")`) |
| `.mode` | List of modes, same length as `.parsnip_eng`. Options: `"regression"`, `"classification"`. Default: `list("regression")`. |
| `.parsnip_fns` | List of parsnip function names, same length as `.parsnip_eng`. |
| `.return_tibble` | Logical. If `TRUE` (default), returns a tibble; if `FALSE`, returns a list. |

### Value

If `.return_tibble = TRUE`:
- Returns a tibble with columns:
  - `.parsnip_engine`: Engine name
  - `.parsnip_mode`: Mode ("regression" or "classification")
  - `.parsnip_fns`: Function name
  - `.model_spec`: Model specification object

If `.return_tibble = FALSE`:
- Returns a list of model specification objects

### Details

- All argument lists must be the same length
- Model specs are parsnip objects that can be modified
- Does NOT fit models - only creates specifications
- Useful for:
  - Custom workflows
  - Inspecting model parameters
  - Building your own training loops

### Examples

```r
library(tidyAML)

# Basic usage
specs <- create_model_spec(
  .parsnip_eng = list("lm", "glm"),
  .parsnip_fns = list("linear_reg", "linear_reg")
)

# Multiple different model types
specs <- create_model_spec(
  .parsnip_eng = list("lm", "glm", "glmnet", "ranger"),
  .parsnip_fns = list("linear_reg", "linear_reg", "linear_reg", "rand_forest"),
  .mode = list("regression", "regression", "regression", "regression")
)

# Classification specs
specs <- create_model_spec(
  .parsnip_eng = list("glm", "glmnet"),
  .parsnip_fns = list("logistic_reg", "logistic_reg"),
  .mode = list("classification", "classification")
)

# Return as list
specs_list <- create_model_spec(
  .parsnip_eng = list("lm", "glm"),
  .parsnip_fns = list("linear_reg", "linear_reg"),
  .return_tibble = FALSE
)

# Access individual specs
specs_list[[1]]  # First model spec
```

### See Also

- [fast_regression_parsnip_spec_tbl](#fast_regression_parsnip_spec_tbl) for pre-built regression specs
- [fast_classification_parsnip_spec_tbl](#fast_classification_parsnip_spec_tbl) for classification specs

---

## fast_regression_parsnip_spec_tbl

Generate a table of regression model specifications.

### Description

Creates a tibble of all available or filtered regression model specifications without training them.

### Usage

```r
fast_regression_parsnip_spec_tbl(
  .parsnip_fns = "all",
  .parsnip_eng = "all"
)
```

### Arguments

| Argument | Description |
|----------|-------------|
| `.parsnip_fns` | Character vector of parsnip function names to filter by. Default: `"all"` includes all available regression functions. |
| `.parsnip_eng` | Character vector of engine names to filter by. Default: `"all"` includes all available engines. |

### Value

Returns a tibble with class `c("fst_reg_spec_tbl", "tidyaml_mod_spec_tbl", "tbl_df")` containing:
- `.model_id`: Sequential model ID
- `.parsnip_engine`: Engine name
- `.parsnip_mode`: "regression"
- `.parsnip_fns`: Function name
- `model_spec`: Model specification object

### Details

- Useful for exploring available models
- Can filter by function name or engine or both
- Does not require data or recipes
- Model specs can be extracted and modified

### Examples

```r
library(tidyAML)

# All regression models
all_specs <- fast_regression_parsnip_spec_tbl()

# All linear regression models
linear_specs <- fast_regression_parsnip_spec_tbl(
  .parsnip_fns = "linear_reg"
)

# Specific engines only
lm_glm_specs <- fast_regression_parsnip_spec_tbl(
  .parsnip_eng = c("lm", "glm")
)

# Combined filter
filtered_specs <- fast_regression_parsnip_spec_tbl(
  .parsnip_eng = c("lm", "glm", "glmnet"),
  .parsnip_fns = "linear_reg"
)

# Explore what's available
filtered_specs |>
  select(.parsnip_engine, .parsnip_fns)
```

### See Also

- [fast_classification_parsnip_spec_tbl](#fast_classification_parsnip_spec_tbl) for classification
- [create_model_spec](#create_model_spec) for custom specs

---

## fast_classification_parsnip_spec_tbl

Generate a table of classification model specifications.

### Description

Creates a tibble of all available or filtered classification model specifications.

### Usage

```r
fast_classification_parsnip_spec_tbl(
  .parsnip_fns = "all",
  .parsnip_eng = "all"
)
```

### Arguments

| Argument | Description |
|----------|-------------|
| `.parsnip_fns` | Character vector of parsnip function names. Default: `"all"`. |
| `.parsnip_eng` | Character vector of engine names. Default: `"all"`. |

### Value

Returns a tibble with class `c("fst_class_spec_tbl", "tidyaml_mod_spec_tbl", "tbl_df")`:
- `.model_id`: Model ID
- `.parsnip_engine`: Engine name
- `.parsnip_mode`: "classification"
- `.parsnip_fns`: Function name
- `model_spec`: Specification object

### Examples

```r
library(tidyAML)

# All classification models
all_class_specs <- fast_classification_parsnip_spec_tbl()

# Logistic regression only
logistic_specs <- fast_classification_parsnip_spec_tbl(
  .parsnip_fns = "logistic_reg"
)

# Specific engines
glm_specs <- fast_classification_parsnip_spec_tbl(
  .parsnip_eng = c("glm", "glmnet")
)

# Combined filter
filtered <- fast_classification_parsnip_spec_tbl(
  .parsnip_eng = c("glm", "glmnet"),
  .parsnip_fns = "logistic_reg"
)
```

---

## create_workflow_set

Create a workflowsets object from tidyAML model specifications.

### Description

Converts tidyAML model specification tibbles into workflowsets objects for use with the workflowsets package.

### Usage

```r
create_workflow_set(.model_tbl)
```

### Arguments

| Argument | Description |
|----------|-------------|
| `.model_tbl` | A tidyAML model specification tibble (from `create_model_spec()` or spec table functions) |

### Value

Returns a `workflow_set` object that can be used with workflowsets functions.

### Details

- Requires the workflowsets package
- Useful for custom tuning workflows
- Integrates tidyAML specs with workflowsets ecosystem

### Examples

```r
library(tidyAML)
library(workflowsets)

# Create specs
specs <- create_model_spec(
  .parsnip_eng = list("lm", "glm"),
  .parsnip_fns = list("linear_reg", "linear_reg")
)

# Convert to workflow set
wf_set <- create_workflow_set(specs)

# Use with workflowsets functions
# (requires recipe and other setup)
```

### See Also

- `workflowsets` package documentation
- [Advanced Tuning](Advanced-Tuning.md) guide

---

## Additional Notes

### Graceful Failure Handling

All model generation functions use `purrr::safely()` internally:

```r
# If a model fails (e.g., package not installed), 
# it returns NULL instead of stopping
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj
)

# Check for successful models
successful <- models |>
  filter(!is.null(fitted_wflw))
```

### Performance Tips

1. **Start small**: Test with a few models before running all
2. **Filter early**: Use `.parsnip_eng` and `.parsnip_fns` to reduce models
3. **Check packages**: Install required engine packages beforehand

### Common Issues

**Issue**: "There is no package called 'glmnet'"
**Solution**: Install the missing engine package: `install.packages("glmnet")`

**Issue**: Recipe doesn't include target variable
**Solution**: Ensure recipe includes formula with target: `recipe(target ~ ., data = data)`

**Issue**: Classification target not a factor
**Solution**: Convert to factor: `mutate(target = as.factor(target))`

---

## Related Pages

- [Function Reference: Extractors](Function-Reference-Extractors.md)
- [Function Reference: Utilities](Function-Reference-Utilities.md)
- [Function Reference: Plotting](Function-Reference-Plotting.md)
- [Regression Tutorial](Regression-Tutorial.md)
- [Classification Tutorial](Classification-Tutorial.md)

---

[← Back to Package Overview](Package-Overview.md) | [Home](Home.md) | [Next: Extractors →](Function-Reference-Extractors.md)
