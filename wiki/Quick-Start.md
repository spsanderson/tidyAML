# Quick Start Guide

Get up and running with tidyAML in minutes! This guide shows you the essential steps to start using automated machine learning with tidymodels.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Basic Workflow](#basic-workflow)
- [Regression Example](#regression-example)
- [Classification Example](#classification-example)
- [Understanding the Output](#understanding-the-output)
- [Next Steps](#next-steps)

## Prerequisites

Make sure you have tidyAML installed:

```r
install.packages("tidyAML")
```

Load the required libraries:

```r
library(tidyAML)
library(recipes)
library(dplyr)

# Recommended: Set tidymodels preferences
library(tidymodels)
tidymodels::tidymodels_prefer()
```

## Basic Workflow

The tidyAML workflow follows these simple steps:

```r
# 1. Prepare your data
# 2. Create a recipe
# 3. Generate and train models
# 4. Extract predictions
# 5. Visualize results
```

## Regression Example

Let's predict car mileage (mpg) using the `mtcars` dataset:

### Step 1: Prepare Your Data

```r
# Load the data
data(mtcars)

# Preview the data
head(mtcars)
```

### Step 2: Create a Recipe

A recipe defines how to preprocess your data:

```r
library(recipes)

# Create a basic recipe
rec_obj <- recipe(mpg ~ ., data = mtcars)

# You can add preprocessing steps if needed:
rec_obj_advanced <- recipe(mpg ~ ., data = mtcars) |>
  step_normalize(all_numeric_predictors()) |>
  step_dummy(all_nominal_predictors())
```

### Step 3: Generate and Train Models

Use `fast_regression()` to create and train multiple models at once:

```r
# Train multiple regression models
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm"),
  .parsnip_fns = "linear_reg"
)

# View the results
models
```

Output:
```
# A tibble: 2 × 8
  .model_id .parsnip_engine .parsnip_mode .parsnip_fns model_spec wflw   fitted_wflw pred_wflw
      <int> <chr>           <chr>         <chr>        <list>     <list> <list>      <list>   
1         1 lm              regression    linear_reg   <spec[+]>  <...>  <...>       <...>    
2         2 glm             regression    linear_reg   <spec[+]>  <...>  <...>       <...>    
```

### Step 4: Extract Predictions

Get predictions from your trained models:

```r
# Extract predictions from all models
predictions <- extract_wflw_pred(models)

# View predictions
head(predictions)
```

### Step 5: Visualize Results

Create visualizations to compare model performance:

```r
# Plot predictions vs actual values
plot_regression_predictions(models)

# Plot residuals
plot_regression_residuals(models)
```

### Complete Regression Example

Here's the full code in one block:

```r
library(tidyAML)
library(recipes)

# Prepare data and recipe
rec_obj <- recipe(mpg ~ ., data = mtcars)

# Train models
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm", "glmnet")
)

# Extract predictions
predictions <- extract_wflw_pred(models)

# Visualize
plot_regression_predictions(models)
```

## Classification Example

Let's predict Titanic survival using classification models:

### Step 1: Prepare Your Data

```r
library(tidyr)

# Prepare Titanic data
df <- Titanic |>
  as_tibble() |>
  uncount(n) |>
  mutate(across(everything(), as.factor))

# Preview
head(df)
```

### Step 2: Create a Recipe

```r
# Create recipe for classification
rec_obj <- recipe(Survived ~ ., data = df)
```

### Step 3: Generate and Train Models

Use `fast_classification()` for classification tasks:

```r
# Train multiple classification models
class_models <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .parsnip_eng = c("glm", "glmnet"),
  .parsnip_fns = "logistic_reg"
)

# View results
class_models
```

### Step 4: Extract Predictions

```r
# Get classification predictions
class_predictions <- extract_wflw_pred(class_models)

# View predictions
head(class_predictions)
```

### Complete Classification Example

```r
library(tidyAML)
library(recipes)
library(tidyr)
library(dplyr)

# Prepare data
df <- Titanic |>
  as_tibble() |>
  uncount(n) |>
  mutate(across(everything(), as.factor))

# Create recipe
rec_obj <- recipe(Survived ~ ., data = df)

# Train models
class_models <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .parsnip_eng = c("glm", "earth")
)

# Extract predictions
predictions <- extract_wflw_pred(class_models)
```

## Understanding the Output

### Model Table Structure

The output from `fast_regression()` and `fast_classification()` is a tibble with these columns:

- `.model_id`: Unique identifier for each model
- `.parsnip_engine`: The engine used (e.g., "lm", "glm")
- `.parsnip_mode`: "regression" or "classification"
- `.parsnip_fns`: The parsnip function used (e.g., "linear_reg")
- `model_spec`: The model specification object
- `wflw`: The workflow object
- `fitted_wflw`: The fitted workflow
- `pred_wflw`: Predictions from the workflow

### Predictions Structure

Predictions from `extract_wflw_pred()` include:

**For Regression:**
- `.model_type`: Model identifier
- `.data_category`: "actual", "training", or "testing"
- `.data_type`: "actual" or "predicted"
- `.value`: The numeric value

**For Classification:**
- `.model_type`: Model identifier
- `.data_category`: "actual", "training", or "testing"  
- `.data_type`: "actual" or "predicted"
- `.pred_class`: Predicted class
- `.pred_probability`: Prediction probability

## Common Patterns

### Train All Available Models

```r
# Train all available regression models
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj
  # Default: .parsnip_fns = "all", .parsnip_eng = "all"
)
```

### Train Specific Model Types

```r
# Only linear models
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_fns = "linear_reg"
)

# Only specific engines
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm")
)
```

### Custom Data Splits

```r
# Use custom split
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .split_type = "initial_split",
  .split_args = list(prop = 0.8, strata = "mpg")
)
```

### Handle Missing Data

```r
# Drop NAs (default behavior)
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .drop_na = TRUE
)
```

## Tips for Success

### 1. Start Simple
Begin with a few models to ensure everything works:
```r
# Start with just 2 models
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm")
)
```

### 2. Check for Missing Engines
Some models require additional packages:
```r
# This might fail if glmnet isn't installed
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = "glmnet"
)

# Install missing package
install.packages("glmnet")
```

### 3. Use Informative Recipes
Add preprocessing steps relevant to your data:
```r
rec_obj <- recipe(mpg ~ ., data = mtcars) |>
  step_normalize(all_numeric_predictors()) |>
  step_corr(all_numeric_predictors(), threshold = 0.9) |>
  step_zv(all_predictors())
```

### 4. Extract What You Need
Use extractor functions to get specific information:
```r
# Get just the workflows
workflows <- extract_wflw(models)

# Get fitted workflows
fitted <- extract_wflw_fit(models)

# Get model specs
specs <- extract_model_spec(models)
```

### 5. Handle Failures Gracefully
tidyAML uses `purrr::safely()` internally, so failed models return NULL:
```r
# Some models might fail - that's okay!
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj
)

# Check which models succeeded
models |>
  filter(!is.null(fitted_wflw))
```

## Common Gotchas

### 1. Factor Levels in Classification
Always convert character columns to factors before classification:
```r
# Wrong
df <- data.frame(outcome = c("yes", "no", "yes"), x = 1:3)

# Right
df <- data.frame(
  outcome = factor(c("yes", "no", "yes")),
  x = 1:3
)
```

### 2. Recipe Target Variable
The recipe must include your target variable:
```r
# Right
recipe(mpg ~ ., data = mtcars)

# Wrong
recipe(~ ., data = mtcars)  # No target variable!
```

### 3. Consistent Data in Recipe and Function
Use the same dataset:
```r
# Right
rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(.data = mtcars, .rec_obj = rec_obj)

# Wrong - different datasets
rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(.data = iris, .rec_obj = rec_obj)  # Error!
```

## Next Steps

Now that you've seen the basics:

1. **Deep Dive**: [Package Overview](Package-Overview.md) for comprehensive understanding
2. **Learn More**: 
   - [Regression Tutorial](Regression-Tutorial.md) for detailed regression examples
   - [Classification Tutorial](Classification-Tutorial.md) for classification workflows
3. **Explore Functions**: [Function Reference](Function-Reference-Model-Generators.md)
4. **Advanced Topics**: [Custom Model Specifications](Advanced-Custom-Models.md)

## Need Help?

- **Stuck?** Check the [Troubleshooting](Troubleshooting.md) guide
- **Questions?** See the [FAQ](FAQ.md)
- **Examples?** Browse the [Tutorials](Regression-Tutorial.md)

---

[← Back to Installation](Installation-Guide.md) | [Home](Home.md) | [Next: Package Overview →](Package-Overview.md)
