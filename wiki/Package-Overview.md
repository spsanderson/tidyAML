# Package Overview

A comprehensive guide to understanding tidyAML's architecture, design principles, and capabilities.

## Table of Contents

- [What is tidyAML?](#what-is-tidyaml)
- [Core Philosophy](#core-philosophy)
- [Architecture](#architecture)
- [Key Components](#key-components)
- [Workflow](#workflow)
- [Feature Highlights](#feature-highlights)
- [Comparison with Alternatives](#comparison-with-alternatives)

## What is tidyAML?

**tidyAML** is an R package that brings Automated Machine Learning (AutoML) capabilities to the tidymodels ecosystem. It provides a simple, intuitive interface for generating, training, and comparing multiple machine learning models simultaneously.

### Design Goals

1. **Simplicity**: Train multiple models with a single function call
2. **Integration**: Native tidymodels integration for seamless workflows
3. **Robustness**: Graceful failure handling without breaking pipelines
4. **Flexibility**: Support for 30+ parsnip engines and growing
5. **Accessibility**: No external dependencies like Java (unlike h2o)

### Version Information

- **Current Version**: 0.0.6.9000 (Development)
- **Stable Version**: 0.0.6 (CRAN)
- **R Requirement**: >= 4.1.0
- **License**: MIT

## Core Philosophy

### Tidymodels First

tidyAML is built entirely on tidymodels, which means:
- All tidymodels functions work seamlessly
- Workflows are standard tidymodels workflows
- Model specs are standard parsnip specs
- Preprocessing uses recipes
- Resampling uses rsample

### Fail Gracefully

Using `purrr::safely()` internally, tidyAML ensures:
- Missing engine packages don't break your workflow
- Failed models return NULL instead of stopping execution
- You get results for successful models even if some fail

### Batteries Included

- Pre-configured model specifications
- Automatic workflow creation
- Built-in visualization functions
- Helper utilities for common tasks

## Architecture

### High-Level Structure

```
tidyAML
│
├── Model Generators
│   ├── fast_regression()
│   ├── fast_classification()
│   └── create_model_spec()
│
├── Workflow Management
│   ├── Internal workflow creation
│   ├── Model fitting
│   └── Prediction generation
│
├── Extractors
│   ├── extract_wflw_pred()
│   ├── extract_wflw()
│   ├── extract_wflw_fit()
│   ├── extract_model_spec()
│   ├── extract_regression_residuals()
│   └── extract_tunable_params()
│
├── Visualization
│   ├── plot_regression_predictions()
│   └── plot_regression_residuals()
│
└── Utilities
    ├── core_packages()
    ├── load_deps()
    ├── install_deps()
    ├── create_splits()
    └── Helper functions
```

### Data Flow

```
Input Data → Recipe → Model Specs → Workflows → Fitted Models → Predictions → Visualizations
     ↓                                    ↓              ↓
  Splits                              Training        Testing
                                      Results         Results
```

## Key Components

### 1. Model Generators

Generate and train multiple models automatically.

#### fast_regression()
Generates regression models for continuous outcomes.

**Key Parameters:**
- `.data`: Your dataset
- `.rec_obj`: recipes object for preprocessing
- `.parsnip_fns`: Model functions (default: "all")
- `.parsnip_eng`: Model engines (default: "all")
- `.split_type`: Type of data split
- `.split_args`: Arguments for splitting
- `.drop_na`: Whether to drop missing values

**Example:**
```r
models <- fast_regression(
  .data = mtcars,
  .rec_obj = recipe(mpg ~ ., data = mtcars),
  .parsnip_eng = c("lm", "glm", "glmnet")
)
```

#### fast_classification()
Generates classification models for categorical outcomes.

**Key Parameters:**
Same as `fast_regression()` but optimized for classification tasks.

**Example:**
```r
models <- fast_classification(
  .data = df,
  .rec_obj = recipe(Survived ~ ., data = df),
  .parsnip_eng = c("glm", "glmnet")
)
```

#### create_model_spec()
Creates custom model specifications without training.

**Key Parameters:**
- `.parsnip_eng`: List of engines
- `.parsnip_fns`: List of functions
- `.mode`: "regression" or "classification"
- `.return_tibble`: Return as tibble or list

**Example:**
```r
specs <- create_model_spec(
  .parsnip_eng = list("lm", "glm"),
  .parsnip_fns = list("linear_reg", "linear_reg")
)
```

### 2. Model Specification Tables

Pre-built model specification tables for quick access.

#### fast_regression_parsnip_spec_tbl()
Generate regression model specification table.

**Filtering Options:**
- By function: `.parsnip_fns = "linear_reg"`
- By engine: `.parsnip_eng = c("lm", "glm")`
- Combined: Both function and engine filters

**Example:**
```r
# All linear regression models
specs <- fast_regression_parsnip_spec_tbl(.parsnip_fns = "linear_reg")

# Specific engines only
specs <- fast_regression_parsnip_spec_tbl(.parsnip_eng = c("lm", "glm"))

# Combined filters
specs <- fast_regression_parsnip_spec_tbl(
  .parsnip_eng = c("lm", "glm"),
  .parsnip_fns = "linear_reg"
)
```

#### fast_classification_parsnip_spec_tbl()
Generate classification model specification table.

### 3. Extractors

Extract specific components from model tables.

#### extract_wflw_pred()
Extract predictions from fitted workflows.

**Returns:**
- Actual values
- Training predictions
- Testing predictions
- Model type information

**Example:**
```r
predictions <- extract_wflw_pred(models)
```

#### extract_wflw()
Extract workflow objects.

**Example:**
```r
workflows <- extract_wflw(models)
```

#### extract_wflw_fit()
Extract fitted workflow objects.

**Example:**
```r
fitted <- extract_wflw_fit(models)
```

#### extract_model_spec()
Extract model specifications.

**Example:**
```r
specs <- extract_model_spec(models)
```

#### extract_regression_residuals()
Extract residuals from regression models.

**Returns:**
- Actual values
- Predicted values
- Residuals
- Model type

**Example:**
```r
residuals <- extract_regression_residuals(models)
```

#### extract_tunable_params()
Extract tunable hyperparameters from model specs.

**Example:**
```r
params <- extract_tunable_params(models)
```

### 4. Visualization Functions

Built-in plotting for quick model assessment.

#### plot_regression_predictions()
Plot predicted vs actual values for regression models.

**Features:**
- Faceted by model type
- Training and testing predictions
- Perfect prediction line
- Color-coded by data type

**Example:**
```r
plot_regression_predictions(models)
```

#### plot_regression_residuals()
Plot residuals for regression models.

**Features:**
- Residual plots by model
- Histogram of residuals
- Zero reference line
- Diagnostic information

**Example:**
```r
plot_regression_residuals(models)
```

### 5. Utilities

Helper functions for common tasks.

#### core_packages()
List core package dependencies.

```r
core_packages()
```

#### load_deps()
Load required packages.

```r
load_deps()
```

#### install_deps()
Install missing dependencies.

```r
install_deps()
```

#### create_splits()
Create rsample split objects.

```r
splits <- create_splits(
  .data = mtcars,
  .split_type = "initial_split",
  .split_args = list(prop = 0.75)
)
```

## Workflow

### Standard tidyAML Workflow

```r
# 1. Load libraries
library(tidyAML)
library(recipes)

# 2. Prepare data
data(mtcars)

# 3. Create recipe
rec_obj <- recipe(mpg ~ ., data = mtcars) |>
  step_normalize(all_numeric_predictors())

# 4. Generate models
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm", "glmnet")
)

# 5. Extract predictions
predictions <- extract_wflw_pred(models)

# 6. Visualize
plot_regression_predictions(models)
plot_regression_residuals(models)

# 7. Evaluate
library(yardstick)
predictions |>
  filter(.data_category == "testing") |>
  group_by(.model_type) |>
  metrics(truth = .value[.data_type == "actual"],
          estimate = .value[.data_type == "predicted"])
```

### Advanced Workflow with Custom Specs

```r
# 1. Create custom specs
specs <- create_model_spec(
  .parsnip_eng = list("lm", "glm", "glmnet"),
  .parsnip_fns = list("linear_reg", "linear_reg", "linear_reg")
)

# 2. Train with custom splits
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .split_type = "initial_split",
  .split_args = list(prop = 0.8, strata = "mpg")
)

# 3. Extract residuals
residuals <- extract_regression_residuals(models)

# 4. Analyze each model
residuals[[1]]  # First model's residuals
residuals[[2]]  # Second model's residuals
```

## Feature Highlights

### 1. Graceful Failure Handling

```r
# Even if some models fail (e.g., missing packages),
# successful models still return results
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj
  # Some models might fail - that's okay!
)

# Filter to successful models
successful_models <- models |>
  filter(!is.null(fitted_wflw))
```

### 2. Flexible Model Selection

```r
# Train ALL available models
all_models <- fast_regression(.data = mtcars, .rec_obj = rec_obj)

# Train specific model type
linear_models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_fns = "linear_reg"
)

# Train specific engines
selected_models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm")
)
```

### 3. Built-in Data Splitting

```r
# Automatic data splitting with various methods
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .split_type = "initial_split",
  .split_args = list(prop = 0.75, strata = "mpg")
)
```

### 4. Comprehensive Predictions

Predictions include:
- Actual values
- Training set predictions
- Testing set predictions
- Model identification

### 5. Easy Visualization

One-line plotting for quick insights:
```r
plot_regression_predictions(models)
plot_regression_residuals(models)
```

## Comparison with Alternatives

### tidyAML vs h2o

| Feature | tidyAML | h2o |
|---------|---------|-----|
| Java Required | ❌ No | ✅ Yes |
| tidymodels Integration | ✅ Native | ❌ No |
| Learning Curve | 🟢 Low | 🟡 Medium |
| Model Selection | Manual + Auto | Auto |
| Hyperparameter Tuning | External (tune) | Built-in |
| Distributed Computing | No | Yes |
| Best For | tidymodels users, R-first workflows | Large-scale ML, production |

### tidyAML vs caret

| Feature | tidyAML | caret |
|---------|---------|-------|
| tidymodels Integration | ✅ Native | ⚠️ Limited |
| Active Development | ✅ Yes | ⚠️ Maintenance |
| Modern R Syntax | ✅ Pipes, tidy | ⚠️ Mixed |
| Model Ecosystem | parsnip (30+) | caret (200+) |
| Learning Curve | 🟢 Low | 🟡 Medium |
| Best For | Modern workflows | Legacy projects |

### tidyAML vs Manual tidymodels

| Feature | tidyAML | Manual tidymodels |
|---------|---------|-------------------|
| Speed of Development | 🚀 Fast | 🐌 Slower |
| Flexibility | 🟡 Good | 🟢 Excellent |
| Control | 🟡 Moderate | 🟢 Complete |
| Batch Training | ✅ Yes | ❌ Manual |
| Learning Curve | 🟢 Low | 🟡 Medium |
| Best For | Rapid prototyping, exploration | Production, fine-tuned models |

## Use Cases

### Ideal For

1. **Rapid Prototyping**: Quickly test multiple algorithms
2. **Model Comparison**: Compare many models with minimal code
3. **Exploratory Analysis**: Understand which models work best for your data
4. **Learning**: Understand tidymodels through simplified interface
5. **Baseline Models**: Generate baseline models for comparison

### Not Ideal For

1. **Heavy Hyperparameter Tuning**: Use tune package directly
2. **Distributed Computing**: Consider h2o or spark
3. **Production Deployment**: May want more control
4. **Deep Learning**: Use keras or torch directly
5. **Ensemble Methods**: Build custom ensembles

## Dependencies

### Core Dependencies (Always Loaded)
- parsnip - Model specifications
- workflows - Workflow management
- workflowsets - Multiple workflows
- rsample - Data splitting
- tune - Parameter tuning support

### Important Imports
- dplyr - Data manipulation
- purrr - Functional programming
- tidyr - Data tidying
- ggplot2 - Visualization
- recipes - Preprocessing
- broom - Model tidying

### Suggested Packages (Optional)
- glmnet, ranger, xgboost, kknn, etc. - Model engines
- See [Installation Guide](Installation-Guide.md) for complete list

## Next Steps

Now that you understand tidyAML's architecture:

1. **Try It Out**: [Quick Start Guide](Quick-Start.md)
2. **Learn by Example**: [Regression Tutorial](Regression-Tutorial.md)
3. **Explore Functions**: [Function Reference](Function-Reference-Model-Generators.md)
4. **Go Advanced**: [Custom Models](Advanced-Custom-Models.md)

---

[← Back to Quick Start](Quick-Start.md) | [Home](Home.md) | [Next: Regression Tutorial →](Regression-Tutorial.md)
