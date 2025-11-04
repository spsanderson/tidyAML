# Best Practices

Guidelines and recommendations for using tidyAML effectively.

## Table of Contents

- [Workflow Design](#workflow-design)
- [Data Preparation](#data-preparation)
- [Model Selection](#model-selection)
- [Recipe Design](#recipe-design)
- [Evaluation & Validation](#evaluation--validation)
- [Performance Optimization](#performance-optimization)
- [Production Considerations](#production-considerations)
- [Code Organization](#code-organization)

## Workflow Design

### Start with Clear Goals

Define what you're trying to achieve:

```r
# Bad: Unclear goal
models <- fast_regression(.data = data, .rec_obj = rec_obj)

# Good: Clear goal documented
# Goal: Predict house prices with RMSE < 10000
# Baseline: Mean prediction gives RMSE of 15000
models <- fast_regression(
  .data = housing_data,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glmnet", "ranger")
)
```

### Iterative Approach

Build complexity gradually:

```r
# Step 1: Simple baseline
simple_models <- fast_regression(
  .data = data,
  .rec_obj = recipe(target ~ ., data = data),
  .parsnip_eng = "lm"
)

# Step 2: Add preprocessing
preprocessed_models <- fast_regression(
  .data = data,
  .rec_obj = recipe(target ~ ., data = data) |>
    step_normalize(all_numeric_predictors()),
  .parsnip_eng = c("lm", "glmnet")
)

# Step 3: Expand model selection
final_models <- fast_regression(
  .data = data,
  .rec_obj = advanced_recipe,
  .parsnip_eng = c("lm", "glmnet", "ranger", "xgboost")
)
```

### Document Your Process

```r
# Document key decisions and findings
# 
# Data: mtcars (n=32, p=10)
# Target: mpg (range: 10.4-33.9)
# Goal: Predict fuel efficiency
# 
# Models tested: lm, glm, glmnet, ranger
# Best model: ranger (RMSE = 2.3)
# Baseline: lm (RMSE = 3.0)
```

## Data Preparation

### Understand Your Data First

```r
# Always start with EDA
library(tidyAML)
library(dplyr)

# 1. Structure
glimpse(data)

# 2. Missing values
data |> 
  summarize(across(everything(), ~sum(is.na(.))))

# 3. Distributions
summary(data)

# 4. Correlations (for regression)
cor(data[, sapply(data, is.numeric)])

# 5. Class balance (for classification)
prop.table(table(data$target))
```

### Handle Missing Data Appropriately

```r
# Option 1: Drop if < 5% missing
if (mean(is.na(data)) < 0.05) {
  models <- fast_regression(
    .data = data,
    .rec_obj = rec_obj,
    .drop_na = TRUE
  )
}

# Option 2: Impute in recipe
rec_obj <- recipe(target ~ ., data = data) |>
  step_impute_mean(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors())

# Option 3: Use models that handle missing data
# (e.g., xgboost, ranger with appropriate settings)
```

### Proper Data Types

```r
# Ensure correct types BEFORE modeling
data <- data |>
  mutate(
    # Factors for categorical
    category = as.factor(category),
    # Numeric for continuous
    amount = as.numeric(amount),
    # Integer for counts
    count = as.integer(count),
    # Date/datetime as appropriate
    date = as.Date(date)
  )

# Verify
str(data)
```

### Train/Test Split Strategy

```r
# For small datasets (< 1000 rows)
.split_args = list(prop = 0.85)  # Keep more for training

# For medium datasets (1000-10000 rows)
.split_args = list(prop = 0.80)  # Standard 80/20

# For large datasets (> 10000 rows)
.split_args = list(prop = 0.75)  # Can afford more test data

# Always stratify for classification
.split_args = list(prop = 0.75, strata = "target")

# Stratify regression if target has distinct groups
.split_args = list(prop = 0.75, strata = "outcome_variable")
```

## Model Selection

### Start Simple, Then Complex

```r
# Phase 1: Fast baseline models
baseline <- fast_regression(
  .data = data,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm")
)

# Phase 2: Add regularization
regularized <- fast_regression(
  .data = data,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm", "glmnet")
)

# Phase 3: Tree-based models
tree_models <- fast_regression(
  .data = data,
  .rec_obj = rec_obj,
  .parsnip_eng = c("ranger", "xgboost")
)

# Compare all
all_predictions <- bind_rows(
  extract_wflw_pred(baseline),
  extract_wflw_pred(regularized),
  extract_wflw_pred(tree_models)
)
```

### Choose Appropriate Algorithms

```r
# For interpretability
.parsnip_eng = c("lm", "glm")

# For many features with correlation
.parsnip_eng = "glmnet"

# For nonlinear relationships
.parsnip_eng = c("ranger", "xgboost", "earth")

# For small datasets
.parsnip_eng = c("lm", "glm", "kknn")

# For large datasets
.parsnip_eng = c("glmnet", "ranger", "xgboost")
```

### Don't Train Too Many Models at Once

```r
# Bad: Training 50+ models blindly
models <- fast_regression(.data = data, .rec_obj = rec_obj)
# (Uses all available engines - may be slow!)

# Good: Strategic model selection
models <- fast_regression(
  .data = data,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm", "glmnet", "ranger")
)
# Covers: linear, regularized, tree-based
```

## Recipe Design

### Keep Recipes Modular

```r
# Base recipe
rec_base <- recipe(target ~ ., data = data)

# Normalization layer
rec_normalized <- rec_base |>
  step_normalize(all_numeric_predictors())

# Full preprocessing
rec_full <- rec_normalized |>
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_corr(all_numeric_predictors(), threshold = 0.9)

# Test each level
models_base <- fast_regression(.data = data, .rec_obj = rec_base)
models_norm <- fast_regression(.data = data, .rec_obj = rec_normalized)
models_full <- fast_regression(.data = data, .rec_obj = rec_full)
```

### Essential Recipe Steps

```r
# Minimal but effective recipe
rec_obj <- recipe(target ~ ., data = data) |>
  # Remove zero variance predictors
  step_zv(all_predictors()) |>
  # Normalize numeric features
  step_normalize(all_numeric_predictors()) |>
  # Dummy encode factors
  step_dummy(all_nominal_predictors()) |>
  # Remove highly correlated features
  step_corr(all_numeric_predictors(), threshold = 0.95)
```

### Recipe for Different Model Types

```r
# For linear models (lm, glm)
rec_linear <- recipe(target ~ ., data = data) |>
  step_normalize(all_numeric_predictors()) |>
  step_dummy(all_nominal_predictors())

# For glmnet (requires normalization)
rec_glmnet <- recipe(target ~ ., data = data) |>
  step_normalize(all_numeric_predictors()) |>
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors())

# For tree-based models (ranger, xgboost)
rec_trees <- recipe(target ~ ., data = data) |>
  step_zv(all_predictors())
  # Trees don't need normalization or dummy encoding
```

### Advanced Feature Engineering

```r
# Only add if needed!
rec_advanced <- recipe(target ~ ., data = data) |>
  # Polynomial features (for nonlinearity)
  step_poly(numeric_pred1, numeric_pred2, degree = 2) |>
  # Interaction terms
  step_interact(terms = ~ var1:var2) |>
  # PCA for dimensionality reduction
  step_pca(all_numeric_predictors(), num_comp = 5) |>
  # Normalize
  step_normalize(all_numeric_predictors())

# Compare to simpler recipe
# Advanced isn't always better!
```

## Evaluation & Validation

### Use Multiple Metrics

```r
library(yardstick)

# For regression
evaluate_regression <- function(predictions) {
  predictions |>
    filter(.data_category == "testing") |>
    pivot_wider(names_from = .data_type, values_from = .value) |>
    group_by(.model_type) |>
    summarize(
      rmse = rmse_vec(actual, predicted),
      mae = mae_vec(actual, predicted),
      rsq = rsq_vec(actual, predicted),
      mape = mape_vec(actual, predicted)
    )
}

# For classification
evaluate_classification <- function(pred_data) {
  pred_data |>
    group_by(.model_type) |>
    summarize(
      accuracy = accuracy_vec(actual, predicted),
      precision = precision_vec(actual, predicted),
      recall = recall_vec(actual, predicted),
      f1 = f_meas_vec(actual, predicted)
    )
}
```

### Always Evaluate on Test Set

```r
# Bad: Evaluating on training data
train_preds <- predictions |>
  filter(.data_category == "training")  # Overly optimistic!

# Good: Evaluating on test data
test_preds <- predictions |>
  filter(.data_category == "testing")  # True performance

# Calculate metrics on test set only
metrics <- calculate_metrics(test_preds)
```

### Check Residuals (Regression)

```r
# Extract and analyze residuals
residuals <- extract_regression_residuals(models)

# Check assumptions
residuals[[1]] |>
  summarize(
    mean_resid = mean(.resid),      # Should be near 0
    sd_resid = sd(.resid),           
    shapiro_p = shapiro.test(.resid)$p.value  # Normality test
  )

# Visual checks
plot_regression_residuals(models)

# Look for:
# - Random scatter (good)
# - Patterns (bad - nonlinearity)
# - Funnel shape (bad - heteroscedasticity)
# - Outliers (investigate)
```

### Confusion Matrix (Classification)

```r
library(yardstick)

# Always check confusion matrix
pred_data |>
  filter(.model_type == "glm - logistic_reg") |>
  conf_mat(truth = actual, estimate = predicted)

# Look for:
# - Which classes are confused?
# - Is one class much harder to predict?
# - Are errors symmetric or asymmetric?
```

### Cross-Validation for Small Datasets

```r
# For small datasets, consider manual CV
# tidyAML doesn't do this automatically
# Use tidymodels directly:

library(rsample)
library(tune)

# Create CV folds
cv_folds <- vfold_cv(data, v = 5, strata = "target")

# Then use tidymodels workflow for CV
# (Beyond tidyAML scope, but recommended for small data)
```

## Performance Optimization

### Reduce Models Strategically

```r
# Instead of all models
# models <- fast_regression(.data = data, .rec_obj = rec_obj)

# Select strategic subset
models <- fast_regression(
  .data = data,
  .rec_obj = rec_obj,
  .parsnip_fns = "linear_reg"  # Just one function type
)
```

### Sample Data for Initial Exploration

```r
# Use sample for initial testing
data_sample <- data |>
  slice_sample(prop = 0.1)

# Test on sample
models_test <- fast_regression(
  .data = data_sample,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "ranger", "xgboost")
)

# Then run on full data with best models
```

### Simplify Recipes

```r
# Complex recipe (slow)
rec_complex <- recipe(target ~ ., data = data) |>
  step_poly(all_numeric_predictors(), degree = 3) |>
  step_interact(terms = ~ all_predictors():all_predictors()) |>
  step_pca(all_numeric_predictors(), num_comp = 20)

# Simpler recipe (faster)
rec_simple <- recipe(target ~ ., data = data) |>
  step_normalize(all_numeric_predictors()) |>
  step_dummy(all_nominal_predictors())

# Start simple!
```

### Use Faster Models First

```r
# Fast models for initial exploration
fast_models <- c("lm", "glm", "glmnet")

# Slower models after initial results
slow_models <- c("ranger", "xgboost")

# Start with fast
models_fast <- fast_regression(
  .data = data,
  .rec_obj = rec_obj,
  .parsnip_eng = fast_models
)

# If promising, try slower
models_slow <- fast_regression(
  .data = data,
  .rec_obj = rec_obj,
  .parsnip_eng = slow_models
)
```

## Production Considerations

### Save Your Best Models

```r
# After identifying best model
best_model_id <- 2

# Extract fitted workflow
best_wf <- extract_wflw_fit(models)[[best_model_id]]

# Save for production
saveRDS(best_wf, "production_model.rds")

# Document
# Model: glmnet linear regression
# Training date: 2024-01-15
# Training RMSE: 2.3
# Test RMSE: 2.5
# Features: normalized numeric, dummy-encoded categorical
```

### Version Control Your Process

```r
# Save script with version info
# model_training_v1.R
# model_training_v2.R

# Save different model versions
saveRDS(models_v1, "models_v1.rds")
saveRDS(models_v2, "models_v2.rds")

# Track changes
# v1: Basic lm, glm
# v2: Added glmnet, ranger
# v3: Improved recipe with feature engineering
```

### Validate on New Data

```r
# Don't just test once!
# Get new data periodically

# Load saved model
prod_model <- readRDS("production_model.rds")

# Predict on new data
new_predictions <- predict(prod_model, new_data)

# Check performance degradation
new_rmse <- calculate_rmse(new_predictions, new_actuals)
if (new_rmse > training_rmse * 1.5) {
  warning("Model performance degraded - consider retraining")
}
```

### Document Everything

```r
# Model card / documentation
model_info <- list(
  name = "House Price Predictor",
  version = "1.0",
  date = "2024-01-15",
  model_type = "glmnet linear regression",
  features = c("sqft", "bedrooms", "location"),
  preprocessing = "normalized numeric, dummy categorical",
  performance = list(
    train_rmse = 2.3,
    test_rmse = 2.5,
    train_rsq = 0.92,
    test_rsq = 0.89
  ),
  limitations = "Not validated for luxury homes >$2M",
  update_schedule = "Quarterly"
)

saveRDS(model_info, "model_info.rds")
```

## Code Organization

### Use Functions

```r
# Instead of repeating code
train_and_evaluate <- function(data, recipe, engines) {
  # Train
  models <- fast_regression(
    .data = data,
    .rec_obj = recipe,
    .parsnip_eng = engines
  )
  
  # Extract predictions
  preds <- extract_wflw_pred(models)
  
  # Evaluate
  metrics <- evaluate_metrics(preds)
  
  list(models = models, predictions = preds, metrics = metrics)
}

# Use it
results <- train_and_evaluate(
  data = mtcars,
  recipe = rec_obj,
  engines = c("lm", "glm", "glmnet")
)
```

### Organize Workflow

```r
# 01_data_prep.R
# - Load raw data
# - Clean data
# - Create train/test split
# - Save processed data

# 02_feature_engineering.R
# - Create recipes
# - Test preprocessing
# - Save recipes

# 03_model_training.R
# - Train models
# - Save model objects

# 04_evaluation.R
# - Evaluate models
# - Compare performance
# - Generate reports

# 05_production.R
# - Deploy best model
# - Monitor performance
```

### Use Configuration

```r
# config.R
config <- list(
  data_path = "data/raw/data.csv",
  models_path = "models/",
  split_prop = 0.75,
  engines = c("lm", "glm", "glmnet", "ranger"),
  recipe_steps = c("normalize", "dummy", "zv")
)

# Use in scripts
models <- fast_regression(
  .data = data,
  .rec_obj = rec_obj,
  .parsnip_eng = config$engines,
  .split_args = list(prop = config$split_prop)
)
```

## Summary Checklist

✅ **Data Preparation**
- [ ] Explore data thoroughly
- [ ] Handle missing values appropriately
- [ ] Ensure correct data types
- [ ] Check for outliers
- [ ] Stratify splits when appropriate

✅ **Modeling**
- [ ] Start with simple models
- [ ] Document your process
- [ ] Use strategic model selection
- [ ] Test incrementally

✅ **Evaluation**
- [ ] Use multiple metrics
- [ ] Evaluate on test set
- [ ] Check residuals/confusion matrix
- [ ] Compare models fairly

✅ **Production**
- [ ] Save best models
- [ ] Document everything
- [ ] Version control
- [ ] Monitor performance
- [ ] Plan for updates

---

[← Back to Home](Home.md) | [FAQ →](FAQ.md)
