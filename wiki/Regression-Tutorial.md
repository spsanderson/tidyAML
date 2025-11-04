# Regression Tutorial

A comprehensive tutorial for building regression models with tidyAML. Learn how to predict continuous outcomes using multiple algorithms simultaneously.

## Table of Contents

- [Introduction](#introduction)
- [When to Use Regression](#when-to-use-regression)
- [Basic Regression Workflow](#basic-regression-workflow)
- [Working with mtcars](#working-with-mtcars)
- [Advanced Examples](#advanced-examples)
- [Model Comparison](#model-comparison)
- [Extracting Results](#extracting-results)
- [Visualization](#visualization)
- [Best Practices](#best-practices)

## Introduction

Regression models predict continuous numerical outcomes. tidyAML makes it easy to train and compare multiple regression models with minimal code.

### What You'll Learn

- How to prepare data for regression
- Creating and using recipes
- Training multiple regression models
- Extracting and comparing predictions
- Visualizing model performance
- Analyzing residuals

## When to Use Regression

Use regression when your target variable is:
- **Continuous**: Values can be any number
- **Numeric**: Measured on a quantitative scale
- **Examples**: Price, temperature, weight, sales, distance

### Common Regression Tasks

- **Price Prediction**: House prices, stock prices
- **Sales Forecasting**: Revenue, demand
- **Performance Metrics**: Speed, efficiency
- **Physical Measurements**: Distance, weight, temperature

## Basic Regression Workflow

### Step 1: Load Libraries

```r
library(tidyAML)
library(recipes)
library(dplyr)
library(tidymodels)

# Set tidymodels preferences
tidymodels::tidymodels_prefer()
```

### Step 2: Prepare Your Data

```r
# Load data
data(mtcars)

# Inspect data
glimpse(mtcars)
summary(mtcars)

# Check for missing values
sum(is.na(mtcars))
```

### Step 3: Create a Recipe

```r
# Basic recipe
rec_obj <- recipe(mpg ~ ., data = mtcars)

# Recipe with preprocessing
rec_obj <- recipe(mpg ~ ., data = mtcars) |>
  step_normalize(all_numeric_predictors()) |>
  step_zv(all_predictors())
```

### Step 4: Train Models

```r
# Train multiple models
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm")
)

# View results
models
```

### Step 5: Extract and Analyze

```r
# Get predictions
predictions <- extract_wflw_pred(models)

# Get residuals
residuals <- extract_regression_residuals(models)

# Visualize
plot_regression_predictions(models)
plot_regression_residuals(models)
```

## Working with mtcars

Let's build a complete regression example predicting fuel efficiency (mpg).

### Understanding the Data

```r
data(mtcars)

# Structure
str(mtcars)

# Summary statistics
summary(mtcars)

# Correlation with target
cor(mtcars$mpg, mtcars[, -1])
```

The mtcars dataset contains:
- **mpg**: Miles per gallon (target variable)
- **cyl**: Number of cylinders
- **disp**: Displacement
- **hp**: Horsepower
- **drat**: Rear axle ratio
- **wt**: Weight
- **qsec**: 1/4 mile time
- **vs**: Engine shape
- **am**: Transmission type
- **gear**: Number of gears
- **carb**: Number of carburetors

### Simple Linear Models

```r
library(tidyAML)
library(recipes)

# Create basic recipe
rec_obj <- recipe(mpg ~ ., data = mtcars)

# Train linear models
linear_models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm"),
  .parsnip_fns = "linear_reg"
)

# View model table
linear_models
```

### Adding Preprocessing

```r
# Recipe with normalization
rec_normalized <- recipe(mpg ~ ., data = mtcars) |>
  step_normalize(all_numeric_predictors())

# Train with preprocessing
models_normalized <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_normalized,
  .parsnip_eng = c("lm", "glm", "glmnet")
)
```

### Multiple Model Types

```r
# All available linear regression models
all_models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_fns = "linear_reg"
)

# Check which models were created
all_models |>
  select(.model_id, .parsnip_engine, .parsnip_fns)
```

## Advanced Examples

### Custom Data Splits

```r
# 80/20 split with stratification
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm", "glmnet"),
  .split_type = "initial_split",
  .split_args = list(prop = 0.8, strata = "mpg")
)
```

### Feature Engineering

```r
# Advanced recipe with feature engineering
rec_advanced <- recipe(mpg ~ ., data = mtcars) |>
  # Normalize numeric predictors
  step_normalize(all_numeric_predictors()) |>
  # Remove zero variance predictors
  step_zv(all_predictors()) |>
  # Remove highly correlated predictors
  step_corr(all_numeric_predictors(), threshold = 0.9) |>
  # Create interaction terms
  step_interact(terms = ~ wt:hp)

# Train with advanced recipe
models_advanced <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_advanced,
  .parsnip_eng = c("lm", "glmnet")
)
```

### Polynomial Features

```r
# Recipe with polynomial features
rec_poly <- recipe(mpg ~ wt + hp, data = mtcars) |>
  step_poly(wt, hp, degree = 2) |>
  step_normalize(all_numeric_predictors())

# Train polynomial models
models_poly <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_poly,
  .parsnip_eng = "lm"
)
```

### Regularized Regression

```r
# Train regularized models (glmnet)
# Make sure glmnet is installed: install.packages("glmnet")

rec_obj <- recipe(mpg ~ ., data = mtcars) |>
  step_normalize(all_numeric_predictors())

models_regularized <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = "glmnet",
  .parsnip_fns = "linear_reg"
)
```

## Model Comparison

### Extracting Predictions

```r
# Get all predictions
predictions <- extract_wflw_pred(models)

# View structure
head(predictions)

# Split by category
predictions |>
  group_by(.model_type, .data_category) |>
  summarize(n = n())
```

### Calculate Metrics

```r
library(yardstick)

# Function to calculate metrics for each model
calculate_metrics <- function(predictions) {
  predictions |>
    filter(.data_category == "testing") |>
    pivot_wider(
      names_from = .data_type,
      values_from = .value
    ) |>
    group_by(.model_type) |>
    summarize(
      rmse = rmse_vec(actual, predicted),
      mae = mae_vec(actual, predicted),
      rsq = rsq_vec(actual, predicted)
    )
}

# Calculate and compare
metrics <- calculate_metrics(predictions)
print(metrics)
```

### Compare Residuals

```r
# Extract residuals for all models
residuals_list <- extract_regression_residuals(models)

# Analyze first model
residuals_list[[1]] |>
  summarize(
    mean_resid = mean(.resid),
    sd_resid = sd(.resid),
    max_abs_resid = max(abs(.resid))
  )

# Compare across models
map_df(residuals_list, ~ {
  data.frame(
    model = .x$.model_type[1],
    mean_resid = mean(.x$.resid),
    rmse = sqrt(mean(.x$.resid^2))
  )
})
```

### Visual Comparison

```r
# Compare predictions across models
plot_regression_predictions(models)

# Compare residuals
plot_regression_residuals(models)

# Custom comparison plot
library(ggplot2)

predictions |>
  filter(.data_category == "testing") |>
  pivot_wider(
    names_from = .data_type,
    values_from = .value
  ) |>
  ggplot(aes(x = actual, y = predicted)) +
  geom_point(alpha = 0.6) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  facet_wrap(~ .model_type, scales = "free") +
  theme_minimal() +
  labs(
    title = "Predicted vs Actual Values",
    x = "Actual MPG",
    y = "Predicted MPG"
  )
```

## Extracting Results

### Workflow Objects

```r
# Extract workflows
workflows <- extract_wflw(models)

# View workflow for first model
workflows[[1]]

# Extract fitted workflows
fitted_wflws <- extract_wflw_fit(models)
```

### Model Specifications

```r
# Extract model specs
specs <- extract_model_spec(models)

# View specs
specs
```

### Predictions by Type

```r
# Training predictions only
train_preds <- predictions |>
  filter(.data_category == "training")

# Testing predictions only
test_preds <- predictions |>
  filter(.data_category == "testing")

# Actual values
actuals <- predictions |>
  filter(.data_type == "actual")
```

## Visualization

### Built-in Plots

```r
# Predictions plot
plot_regression_predictions(models)

# Residuals plot
plot_regression_residuals(models)
```

### Custom Visualizations

#### Residual Distribution

```r
library(ggplot2)

residuals_list[[1]] |>
  ggplot(aes(x = .resid)) +
  geom_histogram(bins = 15, fill = "steelblue", alpha = 0.7) +
  geom_vline(xintercept = 0, color = "red", linetype = "dashed") +
  theme_minimal() +
  labs(
    title = "Distribution of Residuals",
    x = "Residuals",
    y = "Count"
  )
```

#### Q-Q Plot for Residuals

```r
residuals_list[[1]] |>
  ggplot(aes(sample = .resid)) +
  stat_qq() +
  stat_qq_line(color = "red") +
  theme_minimal() +
  labs(title = "Q-Q Plot of Residuals")
```

#### Residuals vs Fitted

```r
residuals_list[[1]] |>
  ggplot(aes(x = .predicted, y = .resid)) +
  geom_point(alpha = 0.6) +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed") +
  geom_smooth(se = FALSE, color = "blue") +
  theme_minimal() +
  labs(
    title = "Residuals vs Fitted Values",
    x = "Fitted Values",
    y = "Residuals"
  )
```

#### Model Comparison Boxplot

```r
# Combine residuals for all models
all_residuals <- map_df(seq_along(residuals_list), ~ {
  residuals_list[[.x]] |>
    mutate(model_id = .x)
})

all_residuals |>
  ggplot(aes(x = factor(model_id), y = abs(.resid))) +
  geom_boxplot(fill = "lightblue") +
  theme_minimal() +
  labs(
    title = "Absolute Residuals by Model",
    x = "Model ID",
    y = "Absolute Residuals"
  )
```

## Best Practices

### 1. Always Check Your Data

```r
# Check for missing values
sum(is.na(mtcars))

# Check for outliers
boxplot(mtcars$mpg)

# Check distributions
hist(mtcars$mpg)
```

### 2. Start Simple, Then Add Complexity

```r
# Start with basic recipe
rec_basic <- recipe(mpg ~ ., data = mtcars)

# Add preprocessing incrementally
rec_step1 <- rec_basic |>
  step_normalize(all_numeric_predictors())

rec_step2 <- rec_step1 |>
  step_corr(all_numeric_predictors(), threshold = 0.9)
```

### 3. Use Appropriate Data Splits

```r
# For small datasets, use higher training proportion
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .split_args = list(prop = 0.85)
)

# For larger datasets, standard 75/25 or 80/20 is fine
```

### 4. Compare Multiple Models

```r
# Train several different model types
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm", "glmnet")
)

# Don't rely on just one model
```

### 5. Validate with Residual Analysis

```r
# Extract and analyze residuals
residuals <- extract_regression_residuals(models)

# Check residual plots
plot_regression_residuals(models)

# Check for patterns - residuals should be random
```

### 6. Handle Missing Data Appropriately

```r
# Option 1: Drop NAs (default)
models <- fast_regression(
  .data = data_with_nas,
  .rec_obj = rec_obj,
  .drop_na = TRUE
)

# Option 2: Impute in recipe
rec_impute <- recipe(mpg ~ ., data = mtcars) |>
  step_impute_mean(all_numeric_predictors())
```

### 7. Use Stratification for Imbalanced Targets

```r
# If your target has distinct groups
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .split_args = list(prop = 0.75, strata = "mpg")
)
```

## Common Pitfalls

### 1. Forgetting to Normalize
Some models (like glmnet) require normalized features:
```r
# Add normalization step
rec_obj <- recipe(mpg ~ ., data = mtcars) |>
  step_normalize(all_numeric_predictors())
```

### 2. Not Checking for Multicollinearity
Highly correlated predictors can cause issues:
```r
# Remove correlated predictors
rec_obj <- recipe(mpg ~ ., data = mtcars) |>
  step_corr(all_numeric_predictors(), threshold = 0.9)
```

### 3. Overfitting on Small Datasets
Be cautious with complex models on small data:
```r
# mtcars has only 32 observations - use simple models
# Or use cross-validation for better estimates
```

### 4. Ignoring Residual Patterns
Always check residual plots for patterns:
```r
plot_regression_residuals(models)
# Residuals should be randomly scattered
```

## Next Steps

- **Learn Classification**: [Classification Tutorial](Classification-Tutorial.md)
- **Custom Models**: [Advanced Custom Models](Advanced-Custom-Models.md)
- **Function Details**: [Function Reference](Function-Reference-Model-Generators.md)
- **Troubleshooting**: [Troubleshooting Guide](Troubleshooting.md)

---

[← Back to Package Overview](Package-Overview.md) | [Home](Home.md) | [Next: Classification Tutorial →](Classification-Tutorial.md)
