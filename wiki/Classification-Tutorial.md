# Classification Tutorial

A comprehensive tutorial for building classification models with tidyAML. Learn how to predict categorical outcomes using multiple algorithms simultaneously.

## Table of Contents

- [Introduction](#introduction)
- [When to Use Classification](#when-to-use-classification)
- [Basic Classification Workflow](#basic-classification-workflow)
- [Binary Classification Example](#binary-classification-example)
- [Multi-class Classification](#multi-class-classification)
- [Model Evaluation](#model-evaluation)
- [Advanced Techniques](#advanced-techniques)
- [Best Practices](#best-practices)

## Introduction

Classification models predict categorical outcomes. tidyAML makes it easy to train and compare multiple classification models with a simple interface.

### What You'll Learn

- How to prepare data for classification
- Binary vs multi-class classification
- Training multiple classification models
- Evaluating model performance
- Working with class probabilities
- Handling imbalanced datasets

## When to Use Classification

Use classification when your target variable is:
- **Categorical**: Discrete categories or classes
- **Qualitative**: Not numerical in nature
- **Examples**: Yes/No, Survived/Died, Species, Customer segment

### Common Classification Tasks

- **Binary Classification**: Spam detection, fraud detection, medical diagnosis
- **Multi-class Classification**: Image recognition, text categorization, species identification
- **Customer Segmentation**: High/Medium/Low value customers
- **Risk Assessment**: High/Medium/Low risk

## Basic Classification Workflow

### Step 1: Load Libraries

```r
library(tidyAML)
library(recipes)
library(dplyr)
library(tidyr)
library(tidymodels)

# Set preferences
tidymodels::tidymodels_prefer()
```

### Step 2: Prepare Your Data

**Critical: Convert target to factor!**

```r
# Example dataset
data(iris)

# MUST convert target to factor
iris <- iris |>
  mutate(Species = as.factor(Species))

# Check levels
levels(iris$Species)
```

### Step 3: Create a Recipe

```r
# Basic recipe
rec_obj <- recipe(Species ~ ., data = iris)

# Recipe with preprocessing
rec_obj <- recipe(Species ~ ., data = iris) |>
  step_normalize(all_numeric_predictors()) |>
  step_zv(all_predictors())
```

### Step 4: Train Models

```r
# Train multiple classification models
models <- fast_classification(
  .data = iris,
  .rec_obj = rec_obj,
  .parsnip_eng = c("glm", "glmnet"),
  .parsnip_fns = "logistic_reg"
)

# View results
models
```

### Step 5: Extract and Evaluate

```r
# Get predictions
predictions <- extract_wflw_pred(models)

# Evaluate
library(yardstick)
predictions |>
  filter(.data_category == "testing", .data_type == "predicted") |>
  # Evaluation code here
```

## Binary Classification Example

Let's build a complete binary classification example using the Titanic dataset.

### Preparing Titanic Data

```r
library(tidyAML)
library(recipes)
library(dplyr)
library(tidyr)

# Load and prepare Titanic data
df <- Titanic |>
  as_tibble() |>
  uncount(n) |>
  mutate(across(everything(), as.factor))

# Check the data
glimpse(df)
table(df$Survived)

# Class balance
prop.table(table(df$Survived))
```

The Titanic dataset contains:
- **Class**: 1st, 2nd, 3rd, Crew
- **Sex**: Male, Female
- **Age**: Child, Adult
- **Survived**: No, Yes (target variable)

### Simple Logistic Regression

```r
# Create recipe
rec_obj <- recipe(Survived ~ ., data = df)

# Train logistic regression models
logistic_models <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .parsnip_eng = c("glm", "glmnet"),
  .parsnip_fns = "logistic_reg"
)

# View model table
logistic_models
```

### With Preprocessing

```r
# Recipe with preprocessing for numeric features
# Note: Titanic has all categorical features, so normalization not needed

# For datasets with numeric features:
rec_preprocessed <- recipe(Survived ~ ., data = df) |>
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors())

# Train with preprocessing
models_preprocessed <- fast_classification(
  .data = df,
  .rec_obj = rec_preprocessed,
  .parsnip_eng = c("glm", "glmnet")
)
```

### Multiple Algorithm Types

```r
# Try different classification algorithms
# (requires additional packages like earth, kknn, etc.)

all_models <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .parsnip_eng = c("glm", "earth"),
  .parsnip_fns = c("logistic_reg", "discrim_flexible")
)
```

## Multi-class Classification

### Using Iris Dataset

```r
library(tidyAML)
library(recipes)

# Load iris data
data(iris)

# Ensure Species is a factor
iris <- iris |>
  mutate(Species = as.factor(Species))

# Check classes
levels(iris$Species)  # "setosa", "versicolor", "virginica"
```

### Create Recipe for Multi-class

```r
# Recipe with normalization for numeric features
rec_iris <- recipe(Species ~ ., data = iris) |>
  step_normalize(all_numeric_predictors()) |>
  step_zv(all_predictors())
```

### Train Multi-class Models

```r
# Train multiple multi-class classification models
iris_models <- fast_classification(
  .data = iris,
  .rec_obj = rec_iris,
  .parsnip_eng = c("glm", "glmnet"),
  .parsnip_fns = "multinom_reg"
)

# Or use other classifiers
iris_models_alt <- fast_classification(
  .data = iris,
  .rec_obj = rec_iris,
  .parsnip_fns = "logistic_reg"  # Works for multi-class with some engines
)
```

### Extract Multi-class Predictions

```r
# Get predictions
predictions <- extract_wflw_pred(iris_models)

# View structure
head(predictions)

# Check predicted classes
predictions |>
  filter(.data_category == "testing", .data_type == "predicted") |>
  group_by(.pred_class) |>
  summarize(n = n())
```

## Model Evaluation

### Confusion Matrix

```r
library(yardstick)

# Prepare data for confusion matrix
pred_data <- predictions |>
  filter(.data_category == "testing") |>
  select(.model_type, .data_type, .pred_class) |>
  pivot_wider(
    names_from = .data_type,
    values_from = .pred_class
  ) |>
  unnest(cols = c(actual, predicted))

# Create confusion matrix for first model
pred_data |>
  filter(.model_type == unique(.model_type)[1]) |>
  conf_mat(truth = actual, estimate = predicted)
```

### Classification Metrics

```r
# Calculate multiple metrics
classification_metrics <- pred_data |>
  group_by(.model_type) |>
  summarize(
    accuracy = accuracy_vec(actual, predicted),
    precision = precision_vec(actual, predicted),
    recall = recall_vec(actual, predicted),
    f1 = f_meas_vec(actual, predicted)
  )

print(classification_metrics)
```

### ROC Curve and AUC

```r
# For binary classification with probabilities
# Extract probabilities
probs <- predictions |>
  filter(
    .data_category == "testing",
    !is.na(.pred_probability)
  )

# Calculate AUC (for binary classification)
# Note: Requires specific data format
```

### Custom Evaluation

```r
# Custom evaluation function
evaluate_classification <- function(predictions, model_id = 1) {
  pred_data <- predictions |>
    filter(.data_category == "testing") |>
    select(.model_type, .data_type, .pred_class) |>
    pivot_wider(
      names_from = .data_type,
      values_from = .pred_class
    ) |>
    unnest(cols = c(actual, predicted))
  
  model_data <- pred_data |>
    filter(.model_type == unique(.model_type)[model_id])
  
  list(
    confusion_matrix = conf_mat(model_data, truth = actual, estimate = predicted),
    accuracy = accuracy_vec(model_data$actual, model_data$predicted),
    kappa = kap_vec(model_data$actual, model_data$predicted)
  )
}

# Use it
results <- evaluate_classification(predictions, model_id = 1)
results
```

## Advanced Techniques

### Handling Imbalanced Data

```r
# Use stratified sampling
models_stratified <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .split_args = list(prop = 0.75, strata = "Survived")
)

# In recipe, use upsampling/downsampling
rec_balanced <- recipe(Survived ~ ., data = df) |>
  step_dummy(all_nominal_predictors()) |>
  step_upsample(Survived)  # or step_downsample()

# Note: requires themis package
# install.packages("themis")
```

### Feature Engineering for Classification

```r
# Create interaction terms
rec_interactions <- recipe(Survived ~ ., data = df) |>
  step_dummy(all_nominal_predictors()) |>
  step_interact(terms = ~ Class:Sex)

# Create polynomial features (for numeric predictors)
rec_poly <- recipe(Species ~ ., data = iris) |>
  step_poly(Sepal.Length, Sepal.Width, degree = 2) |>
  step_normalize(all_numeric_predictors())
```

### Custom Data Splits

```r
# 80/20 split
models <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .split_type = "initial_split",
  .split_args = list(prop = 0.8, strata = "Survived")
)

# Could also use other rsample split types
# See ?rsample for options
```

### Ensemble Different Algorithms

```r
# Train diverse set of algorithms
diverse_models <- fast_classification(
  .data = iris,
  .rec_obj = rec_iris,
  .parsnip_eng = c("glm", "glmnet", "earth")
)

# Extract predictions from all
all_predictions <- extract_wflw_pred(diverse_models)

# Could create ensemble by voting/averaging
```

## Visualization

### Prediction Distribution

```r
library(ggplot2)

# Plot predicted class distribution
predictions |>
  filter(.data_category == "testing", .data_type == "predicted") |>
  ggplot(aes(x = .pred_class, fill = .model_type)) +
  geom_bar(position = "dodge") +
  theme_minimal() +
  labs(
    title = "Predicted Class Distribution by Model",
    x = "Predicted Class",
    y = "Count",
    fill = "Model Type"
  )
```

### Confusion Matrix Heatmap

```r
# Prepare confusion matrix data
cm_data <- pred_data |>
  filter(.model_type == unique(.model_type)[1]) |>
  count(actual, predicted)

# Plot heatmap
cm_data |>
  ggplot(aes(x = predicted, y = actual, fill = n)) +
  geom_tile() +
  geom_text(aes(label = n), color = "white") +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  theme_minimal() +
  labs(
    title = "Confusion Matrix",
    x = "Predicted",
    y = "Actual",
    fill = "Count"
  )
```

### Model Comparison

```r
# Compare accuracy across models
classification_metrics |>
  ggplot(aes(x = reorder(.model_type, accuracy), y = accuracy)) +
  geom_col(fill = "steelblue") +
  geom_text(aes(label = round(accuracy, 3)), hjust = -0.1) +
  coord_flip() +
  ylim(0, 1) +
  theme_minimal() +
  labs(
    title = "Model Accuracy Comparison",
    x = "Model Type",
    y = "Accuracy"
  )
```

## Best Practices

### 1. Always Convert Target to Factor

```r
# Critical step!
df <- df |>
  mutate(target = as.factor(target))

# Check it
class(df$target)  # Should be "factor"
```

### 2. Check Class Balance

```r
# Check distribution
table(df$target)
prop.table(table(df$target))

# If imbalanced, consider:
# - Stratified sampling
# - Upsampling/downsampling
# - Different evaluation metrics (F1, not just accuracy)
```

### 3. Use Stratified Splits

```r
# Always use strata for classification
models <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .split_args = list(strata = "target")
)
```

### 4. Evaluate with Multiple Metrics

```r
# Don't rely only on accuracy
# Also check: precision, recall, F1, AUC
metrics <- pred_data |>
  group_by(.model_type) |>
  summarize(
    accuracy = accuracy_vec(actual, predicted),
    precision = precision_vec(actual, predicted),
    recall = recall_vec(actual, predicted),
    f1 = f_meas_vec(actual, predicted)
  )
```

### 5. Check Confusion Matrix

```r
# Always inspect confusion matrix
conf_mat(pred_data, truth = actual, estimate = predicted)

# Look for patterns:
# - Which classes are confused?
# - Is one class harder to predict?
```

### 6. Preprocess Appropriately

```r
# Dummy encode categorical predictors
rec_obj <- recipe(target ~ ., data = df) |>
  step_dummy(all_nominal_predictors()) |>
  step_normalize(all_numeric_predictors()) |>
  step_zv(all_predictors())
```

### 7. Handle Missing Data

```r
# In recipe
rec_obj <- recipe(target ~ ., data = df) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_impute_mean(all_numeric_predictors())

# Or drop NAs
models <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .drop_na = TRUE
)
```

## Common Pitfalls

### 1. Target Not a Factor

```r
# Wrong
df <- data.frame(target = c("yes", "no"), x = 1:2)

# Right
df <- data.frame(
  target = factor(c("yes", "no")),
  x = 1:2
)
```

### 2. Ignoring Class Imbalance

If you have 95% class A and 5% class B:
- Model might just predict class A always
- Accuracy looks great (95%) but model is useless
- Solution: Use F1-score, stratified sampling, resampling

### 3. Not Using Stratification

```r
# Use strata to maintain class balance in splits
.split_args = list(strata = "target")
```

### 4. Forgetting to Dummy Encode

Many models need numeric inputs:
```r
rec_obj <- recipe(target ~ ., data = df) |>
  step_dummy(all_nominal_predictors())
```

### 5. Using Wrong Parsnip Function

```r
# For binary classification
.parsnip_fns = "logistic_reg"

# For multi-class classification  
.parsnip_fns = "multinom_reg"  # or logistic_reg with some engines
```

## Real-World Example: Titanic

Complete end-to-end example:

```r
library(tidyAML)
library(recipes)
library(dplyr)
library(tidyr)
library(yardstick)

# 1. Prepare data
df <- Titanic |>
  as_tibble() |>
  uncount(n) |>
  mutate(across(everything(), as.factor))

# 2. Create recipe
rec_obj <- recipe(Survived ~ ., data = df) |>
  step_dummy(all_nominal_predictors())

# 3. Train models
models <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .parsnip_eng = c("glm", "earth"),
  .split_args = list(prop = 0.75, strata = "Survived")
)

# 4. Extract predictions
predictions <- extract_wflw_pred(models)

# 5. Evaluate
pred_data <- predictions |>
  filter(.data_category == "testing") |>
  select(.model_type, .data_type, .pred_class) |>
  pivot_wider(
    names_from = .data_type,
    values_from = .pred_class
  ) |>
  unnest(cols = c(actual, predicted))

# 6. Calculate metrics
metrics <- pred_data |>
  group_by(.model_type) |>
  summarize(
    accuracy = accuracy_vec(actual, predicted),
    precision = precision_vec(actual, predicted),
    recall = recall_vec(actual, predicted)
  )

print(metrics)

# 7. Confusion matrix
pred_data |>
  filter(.model_type == unique(.model_type)[1]) |>
  conf_mat(truth = actual, estimate = predicted)
```

## Next Steps

- **Learn Regression**: [Regression Tutorial](Regression-Tutorial.md)
- **Model Comparison**: [Multi-Model Comparison](Multi-Model-Comparison.md)
- **Advanced Topics**: [Advanced Custom Models](Advanced-Custom-Models.md)
- **Function Details**: [Function Reference](Function-Reference-Model-Generators.md)

---

[← Back to Regression Tutorial](Regression-Tutorial.md) | [Home](Home.md) | [Next: Function Reference →](Function-Reference-Model-Generators.md)
