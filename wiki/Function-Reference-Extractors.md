# Function Reference: Extractors

Complete reference for extractor functions that retrieve components from tidyAML model tables.

## Table of Contents

- [Overview](#overview)
- [extract_wflw_pred](#extract_wflw_pred)
- [extract_wflw](#extract_wflw)
- [extract_wflw_fit](#extract_wflw_fit)
- [extract_model_spec](#extract_model_spec)
- [extract_regression_residuals](#extract_regression_residuals)
- [extract_tunable_params](#extract_tunable_params)

## Overview

Extractor functions pull specific components from the model tables created by `fast_regression()` and `fast_classification()`. They provide access to predictions, workflows, fitted models, residuals, and more.

---

## extract_wflw_pred

Extract predictions from fitted workflows.

### Description

`extract_wflw_pred()` retrieves predictions from one or more fitted workflows, including actual values, training predictions, and testing predictions.

### Usage

```r
extract_wflw_pred(.data, .model_id = NULL)
```

### Arguments

| Argument | Description |
|----------|-------------|
| `.data` | A tidyAML model table (from `fast_regression()` or `fast_classification()`) |
| `.model_id` | Optional integer vector of model IDs to extract. Default: `NULL` extracts all models. |

### Value

Returns a tibble with the following structure:

**For Regression:**
- `.model_type`: Character, model identifier (e.g., "lm - linear_reg")
- `.data_category`: Character, one of "actual", "training", "testing"
- `.data_type`: Character, "actual" or "predicted"
- `.value`: Numeric, the prediction or actual value

**For Classification:**
- `.model_type`: Character, model identifier
- `.data_category`: Character, "actual", "training", or "testing"
- `.data_type`: Character, "actual" or "predicted"
- `.pred_class`: Factor, predicted class
- `.pred_probability`: Numeric, prediction probability (if available)

### Details

- Combines predictions from all specified models
- Includes both training and testing set predictions
- Includes actual values for comparison
- Long format for easy plotting and analysis
- Works with both regression and classification models

### Examples

```r
library(tidyAML)
library(recipes)

# Regression example
rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm")
)

# Extract all predictions
all_preds <- extract_wflw_pred(models)

# Extract specific models
specific_preds <- extract_wflw_pred(models, .model_id = 1:2)

# View structure
head(all_preds)

# Filter testing predictions only
test_preds <- all_preds |>
  filter(.data_category == "testing")

# Get predictions for plotting
library(dplyr)
library(tidyr)

plot_data <- all_preds |>
  filter(.data_category == "testing") |>
  pivot_wider(
    names_from = .data_type,
    values_from = .value
  )
```

### Classification Example

```r
library(tidyr)

# Classification
df <- Titanic |>
  as_tibble() |>
  uncount(n) |>
  mutate(across(everything(), as.factor))

rec_obj <- recipe(Survived ~ ., data = df)
class_models <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .parsnip_eng = c("glm")
)

# Extract predictions
class_preds <- extract_wflw_pred(class_models)

# View classification predictions
head(class_preds)

# Get predicted classes
class_preds |>
  filter(.data_type == "predicted") |>
  count(.pred_class)
```

### See Also

- [extract_regression_residuals](#extract_regression_residuals) for regression residuals
- [plot_regression_predictions](Function-Reference-Plotting.md#plot_regression_predictions) for visualization

---

## extract_wflw

Extract workflow objects from model table.

### Description

`extract_wflw()` retrieves the workflow objects before fitting. Useful for inspection or custom modifications.

### Usage

```r
extract_wflw(.data, .model_id = NULL)
```

### Arguments

| Argument | Description |
|----------|-------------|
| `.data` | tidyAML model table |
| `.model_id` | Optional model IDs to extract. Default: `NULL` (all models) |

### Value

Returns a list of workflow objects (one per model).

### Details

- Workflows include the recipe and model specification
- Not yet fitted - use `extract_wflw_fit()` for fitted workflows
- Can be modified and re-fitted manually
- Useful for custom workflows

### Examples

```r
library(tidyAML)
library(recipes)

rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm")
)

# Extract workflows
workflows <- extract_wflw(models)

# View first workflow
workflows[[1]]

# Extract specific model
wf_model_1 <- extract_wflw(models, .model_id = 1)

# Workflows can be modified and refitted
library(workflows)
modified_wf <- workflows[[1]] |>
  update_recipe(new_recipe)  # if you have modifications
```

### See Also

- [extract_wflw_fit](#extract_wflw_fit) for fitted workflows

---

## extract_wflw_fit

Extract fitted workflow objects.

### Description

`extract_wflw_fit()` retrieves fitted workflow objects, which include the trained model along with the preprocessing recipe.

### Usage

```r
extract_wflw_fit(.data, .model_id = NULL)
```

### Arguments

| Argument | Description |
|----------|-------------|
| `.data` | tidyAML model table |
| `.model_id` | Optional model IDs. Default: `NULL` (all models) |

### Value

Returns a list of fitted workflow objects.

### Details

- Fitted workflows contain the trained model
- Can extract model coefficients, parameters, etc.
- Use with tidymodels functions like `tidy()`, `glance()`, `augment()`
- Can make new predictions with `predict()`

### Examples

```r
library(tidyAML)
library(recipes)
library(broom)

rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm")
)

# Extract fitted workflows
fitted_wfs <- extract_wflw_fit(models)

# View first fitted workflow
fitted_wfs[[1]]

# Extract model from workflow
library(workflows)
model_fit <- extract_fit_parsnip(fitted_wfs[[1]])

# Get model coefficients
tidy(model_fit)

# Get model summary statistics
glance(model_fit)

# Make predictions on new data
new_data <- mtcars[1:5, ]
predict(fitted_wfs[[1]], new_data)
```

### See Also

- [extract_wflw](#extract_wflw) for unfitted workflows
- [extract_model_spec](#extract_model_spec) for model specifications

---

## extract_model_spec

Extract model specification objects.

### Description

`extract_model_spec()` retrieves the parsnip model specification objects from the model table.

### Usage

```r
extract_model_spec(.data, .model_id = NULL)
```

### Arguments

| Argument | Description |
|----------|-------------|
| `.data` | tidyAML model table or spec table |
| `.model_id` | Optional model IDs. Default: `NULL` (all models) |

### Value

Returns a tibble or list of model specification objects.

### Details

- Model specs are parsnip objects defining the model type and engine
- Can be modified and used in custom workflows
- Useful for understanding model parameters
- Can extract tunable parameters with `extract_parameter_set_dials()`

### Examples

```r
library(tidyAML)

# From fast_regression
rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm")
)

# Extract model specs
specs <- extract_model_spec(models)
specs

# View specific spec
specs[[1]]

# From spec table
spec_tbl <- fast_regression_parsnip_spec_tbl(
  .parsnip_eng = c("lm", "glm")
)
specs_from_tbl <- extract_model_spec(spec_tbl)

# Modify a spec
library(parsnip)
modified_spec <- specs[[1]] |>
  set_engine("lm", model = TRUE)
```

### See Also

- [extract_tunable_params](#extract_tunable_params) for tunable parameters
- [create_model_spec](Function-Reference-Model-Generators.md#create_model_spec)

---

## extract_regression_residuals

Extract residuals from regression models.

### Description

`extract_regression_residuals()` computes and extracts residuals (actual - predicted) from fitted regression models.

### Usage

```r
extract_regression_residuals(.data, .model_id = NULL)
```

### Arguments

| Argument | Description |
|----------|-------------|
| `.data` | tidyAML regression model table |
| `.model_id` | Optional model IDs. Default: `NULL` (all models) |

### Value

Returns a list of residual tibbles (one per model), each containing:
- `.model_type`: Character, model identifier
- `.actual`: Numeric, actual target values
- `.predicted`: Numeric, predicted values
- `.resid`: Numeric, residuals (actual - predicted)

### Details

- Only works with regression models
- Residuals are calculated as: actual - predicted
- Returns separate tibble for each model
- Useful for model diagnostics
- Check for patterns in residuals (should be random)

### Examples

```r
library(tidyAML)
library(recipes)
library(ggplot2)

rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm")
)

# Extract residuals
residuals <- extract_regression_residuals(models)

# View first model's residuals
residuals[[1]]

# Analyze residuals
residuals[[1]] |>
  summarize(
    mean_resid = mean(.resid),
    sd_resid = sd(.resid),
    rmse = sqrt(mean(.resid^2)),
    max_abs_resid = max(abs(.resid))
  )

# Plot residuals vs fitted
residuals[[1]] |>
  ggplot(aes(x = .predicted, y = .resid)) +
  geom_point(alpha = 0.6) +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed") +
  labs(
    title = "Residuals vs Fitted",
    x = "Fitted Values",
    y = "Residuals"
  )

# Check for normality
residuals[[1]] |>
  ggplot(aes(sample = .resid)) +
  stat_qq() +
  stat_qq_line(color = "red")

# Compare residuals across models
library(purrr)
map_df(residuals, ~ {
  data.frame(
    model = .x$.model_type[1],
    rmse = sqrt(mean(.x$.resid^2)),
    mean_abs_resid = mean(abs(.x$.resid))
  )
})
```

### See Also

- [plot_regression_residuals](Function-Reference-Plotting.md#plot_regression_residuals) for visualization
- [extract_wflw_pred](#extract_wflw_pred) for predictions

---

## extract_tunable_params

Extract tunable hyperparameters from model specifications.

### Description

`extract_tunable_params()` identifies and extracts the tunable hyperparameters from model specifications.

### Usage

```r
extract_tunable_params(.model_tbl)
```

### Arguments

| Argument | Description |
|----------|-------------|
| `.model_tbl` | tidyAML model specification table |

### Value

Returns information about tunable parameters in the model specifications.

### Details

- Identifies which parameters can be tuned
- Useful for setting up hyperparameter tuning
- Works with tune package for parameter optimization
- Shows parameter names, types, and ranges

### Examples

```r
library(tidyAML)

# Create model specs
spec_tbl <- fast_regression_parsnip_spec_tbl(
  .parsnip_eng = c("lm", "glm", "glmnet")
)

# Extract tunable parameters
tunable <- extract_tunable_params(spec_tbl)
tunable

# For models with tunable parameters (e.g., glmnet)
glmnet_spec <- fast_regression_parsnip_spec_tbl(
  .parsnip_eng = "glmnet"
)

# Check tunable parameters
extract_tunable_params(glmnet_spec)
```

### See Also

- `tune` package for hyperparameter tuning
- [Advanced Tuning](Advanced-Tuning.md) guide

---

## Usage Patterns

### Extract and Compare Predictions

```r
# Train models
models <- fast_regression(.data = mtcars, .rec_obj = rec_obj)

# Get predictions
preds <- extract_wflw_pred(models)

# Compare on test set
preds |>
  filter(.data_category == "testing") |>
  group_by(.model_type) |>
  summarize(
    rmse = sqrt(mean((.value[.data_type == "actual"] - 
                     .value[.data_type == "predicted"])^2))
  )
```

### Extract and Modify Workflows

```r
# Get workflows
workflows <- extract_wflw(models)

# Modify and refit
library(workflows)
modified_wf <- workflows[[1]] |>
  update_recipe(new_recipe)

# Fit modified workflow
fitted <- fit(modified_wf, data = training_data)
```

### Diagnostic Analysis

```r
# Get residuals
residuals <- extract_regression_residuals(models)

# Check assumptions
residuals[[1]] |>
  summarize(
    shapiro_p = shapiro.test(.resid)$p.value,  # Normality
    mean_resid = mean(.resid),  # Should be near 0
    variance = var(.resid)
  )
```

## Common Issues

**Issue**: "No predictions available"
**Solution**: Ensure models were fitted successfully. Check `.fitted_wflw` column isn't NULL.

**Issue**: "Cannot extract residuals from classification"
**Solution**: `extract_regression_residuals()` only works with regression models.

**Issue**: Empty list returned
**Solution**: Check that `.model_id` values exist in the model table.

---

## Related Pages

- [Function Reference: Model Generators](Function-Reference-Model-Generators.md)
- [Function Reference: Utilities](Function-Reference-Utilities.md)
- [Function Reference: Plotting](Function-Reference-Plotting.md)
- [Regression Tutorial](Regression-Tutorial.md)

---

[← Back to Model Generators](Function-Reference-Model-Generators.md) | [Home](Home.md) | [Next: Utilities →](Function-Reference-Utilities.md)
