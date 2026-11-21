# Frequently Asked Questions (FAQ)

Common questions and answers about tidyAML.

## Table of Contents

- [General Questions](#general-questions)
- [Installation & Setup](#installation--setup)
- [Usage Questions](#usage-questions)
- [Model Training](#model-training)
- [Predictions & Evaluation](#predictions--evaluation)
- [Performance & Optimization](#performance--optimization)
- [Comparison with Other Tools](#comparison-with-other-tools)

## General Questions

### What is tidyAML?

tidyAML is an R package that brings Automated Machine Learning (AutoML) to the tidymodels ecosystem. It allows you to generate, train, and compare multiple machine learning models with a single function call.

### Why should I use tidyAML?

Use tidyAML when you want to:
- Quickly explore multiple algorithms for your data
- Compare model performance without writing repetitive code
- Leverage tidymodels within an AutoML workflow
- Build baseline models rapidly
- Learn tidymodels through a simplified interface

### Is tidyAML production-ready?

tidyAML is excellent for:
- ✅ Rapid prototyping and exploration
- ✅ Model comparison and baseline creation
- ✅ Learning and education
- ✅ Research and analysis

For production deployment, you may want to:
- Take the best models from tidyAML and tune them manually
- Use tidymodels directly for more control
- Add custom validation and monitoring

### What's the difference between tidyAML and h2o?

| Feature | tidyAML | h2o |
|---------|---------|-----|
| Integration | tidymodels native | Standalone |
| Dependencies | No Java | Requires Java |
| Control | Manual model selection | Automatic |
| Hyperparameter Tuning | External (tune pkg) | Built-in |
| Best For | tidyverse users | Large-scale ML |

### Can I use tidyAML with tidymodels?

Yes! tidyAML is built entirely on tidymodels. All tidyAML outputs are standard tidymodels objects (workflows, model specs, etc.) that work with other tidymodels functions.

## Installation & Setup

### How do I install tidyAML?

```r
# From CRAN (stable)
install.packages("tidyAML")

# From GitHub (development)
devtools::install_github("spsanderson/tidyAML")
```

### What R version do I need?

tidyAML requires R >= 4.1.0 because it uses the native pipe operator (`|>`).

### Do I need to install additional packages?

Core dependencies are installed automatically. However, specific model engines require additional packages:

```r
# Example: For glmnet models
install.packages("glmnet")

# For random forests
install.packages("ranger")

# Use tidyAML helpers
tidyAML::install_deps()
```

### Why do I get "there is no package called 'X'"?

This means the engine package for a specific model isn't installed. Install it:

```r
install.packages("package_name")
```

tidyAML will skip models with missing packages and continue with others.

### Should I run `tidymodels_prefer()`?

Yes, it's recommended:

```r
library(tidyAML)
library(tidymodels)
tidymodels::tidymodels_prefer()
```

This ensures tidymodels functions take precedence over similarly named functions from other packages.

## Usage Questions

### How do I start?

Follow this basic workflow:

```r
library(tidyAML)
library(recipes)

# 1. Create recipe
rec_obj <- recipe(target ~ ., data = your_data)

# 2. Train models
models <- fast_regression(
  .data = your_data,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm")
)

# 3. Extract predictions
predictions <- extract_wflw_pred(models)

# 4. Visualize
plot_regression_predictions(models)
```

### What's a recipe and why do I need one?

A recipe (from the recipes package) defines:
- Your target variable
- Your predictor variables
- Preprocessing steps (normalization, dummy coding, etc.)

```r
# Basic recipe
rec_obj <- recipe(mpg ~ ., data = mtcars)

# Recipe with preprocessing
rec_obj <- recipe(mpg ~ ., data = mtcars) |>
  step_normalize(all_numeric_predictors()) |>
  step_dummy(all_nominal_predictors())
```

### Can I use custom preprocessing?

Yes! Add steps to your recipe:

```r
rec_obj <- recipe(mpg ~ ., data = mtcars) |>
  step_normalize(all_numeric_predictors()) |>
  step_corr(all_numeric_predictors(), threshold = 0.9) |>
  step_pca(all_numeric_predictors(), num_comp = 5) |>
  step_interact(terms = ~ var1:var2)
```

### How do I choose which models to train?

Three options:

1. **Train all models** (default):
```r
models <- fast_regression(.data = data, .rec_obj = rec_obj)
```

2. **Filter by function type**:
```r
models <- fast_regression(
  .data = data,
  .rec_obj = rec_obj,
  .parsnip_fns = "linear_reg"
)
```

3. **Filter by engine**:
```r
models <- fast_regression(
  .data = data,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm", "glmnet")
)
```

### Can I use my own train/test split?

Yes, use `.split_args`:

```r
models <- fast_regression(
  .data = data,
  .rec_obj = rec_obj,
  .split_type = "initial_split",
  .split_args = list(prop = 0.8, strata = "target")
)
```

## Model Training

### Why do some models fail?

Common reasons:
1. **Missing package**: Engine package not installed
2. **Data issues**: Missing values, wrong data types
3. **Model-data mismatch**: E.g., classification model on numeric target

tidyAML handles failures gracefully - failed models return NULL and successful models continue.

### How do I see which models succeeded?

```r
# Check for successful models
models |>
  filter(!is.null(fitted_wflw)) |>
  select(.model_id, .parsnip_engine, .parsnip_fns)
```

### Can I train classification and regression together?

No, they're separate:
- Use `fast_regression()` for continuous targets
- Use `fast_classification()` for categorical targets

### My classification model fails - why?

Most common issue: **Target not a factor**

```r
# Wrong
df <- data.frame(target = c("yes", "no"), x = 1:2)

# Right
df <- data.frame(
  target = factor(c("yes", "no")),
  x = 1:2
)

# Or convert
df <- df |> mutate(target = as.factor(target))
```

### How long does training take?

Depends on:
- Number of models
- Dataset size
- Model complexity
- Your hardware

Tips:
- Start with 2-3 models to test
- Use smaller data samples initially
- Filter to specific engines

### Can I train in parallel?

Not directly in tidyAML. However, you can:
1. Use tidymodels' parallel processing capabilities
2. Split models across multiple `fast_regression()` calls
3. Use future/furrr for parallel execution

## Predictions & Evaluation

### How do I get predictions?

```r
predictions <- extract_wflw_pred(models)
```

This returns predictions for training and testing sets, plus actual values.

### What's the prediction format?

**Regression:**
- `.model_type`: Model identifier
- `.data_category`: "actual", "training", or "testing"
- `.data_type`: "actual" or "predicted"
- `.value`: Numeric value

**Classification:**
- `.model_type`: Model identifier
- `.data_category`: "actual", "training", or "testing"
- `.data_type`: "actual" or "predicted"
- `.pred_class`: Predicted class
- `.pred_probability`: Probability (if available)

### How do I evaluate model performance?

```r
library(yardstick)

# For regression
predictions |>
  filter(.data_category == "testing") |>
  pivot_wider(names_from = .data_type, values_from = .value) |>
  group_by(.model_type) |>
  summarize(
    rmse = rmse_vec(actual, predicted),
    mae = mae_vec(actual, predicted),
    rsq = rsq_vec(actual, predicted)
  )

# For classification
pred_data |>
  group_by(.model_type) |>
  summarize(
    accuracy = accuracy_vec(actual, predicted),
    precision = precision_vec(actual, predicted),
    recall = recall_vec(actual, predicted)
  )
```

### Can I get residuals?

For regression, yes:

```r
residuals <- extract_regression_residuals(models)
```

Each element is a tibble with actual, predicted, and residual values.

### How do I choose the best model?

1. Extract predictions
2. Calculate metrics
3. Compare on test set (not training!)
4. Consider multiple metrics
5. Check residual plots (regression)
6. Review confusion matrix (classification)

### Can I make predictions on new data?

Yes, extract the fitted workflow:

```r
fitted_wf <- extract_wflw_fit(models)[[1]]  # First model
new_predictions <- predict(fitted_wf, new_data)
```

## Performance & Optimization

### My code is running slow - help!

Optimization tips:

1. **Reduce models**:
```r
.parsnip_eng = c("lm", "glm")  # Instead of "all"
```

2. **Start with small data**:
```r
sample_data <- data[1:1000, ]
```

3. **Remove expensive models**:
Avoid computationally intensive engines initially

4. **Check your recipe**:
Complex preprocessing can be slow

### How much RAM do I need?

Depends on:
- Dataset size
- Number of models
- Model complexity

Recommendations:
- Small datasets (<10K rows): 4GB
- Medium datasets (10K-100K): 8-16GB
- Large datasets (>100K): 16GB+

### Can I save my models?

Yes:

```r
# Save entire model table
saveRDS(models, "my_models.rds")

# Load later
models <- readRDS("my_models.rds")

# Or save specific fitted workflows
fitted_wf <- extract_wflw_fit(models)[[1]]
saveRDS(fitted_wf, "best_model.rds")
```

### How do I tune hyperparameters?

tidyAML focuses on non-tuning models. For hyperparameter tuning:

1. Use tidyAML to identify promising models
2. Extract those model specs
3. Use tune package for hyperparameter optimization

See [Advanced Tuning](Advanced-Tuning.md) guide.

## Comparison with Other Tools

### tidyAML vs manual tidymodels?

**tidyAML**:
- ✅ Faster development
- ✅ Multiple models easily
- ✅ Good for exploration
- ⚠️ Less control
- ⚠️ No built-in tuning

**Manual tidymodels**:
- ✅ Full control
- ✅ Custom workflows
- ✅ Fine-tuned optimization
- ⚠️ More code
- ⚠️ Slower initial development

**Best approach**: Use tidyAML for exploration, then manual tidymodels for production tuning.

### tidyAML vs caret?

**tidyAML**:
- Modern tidyverse syntax
- tidymodels integration
- Active development
- Fewer models overall

**caret**:
- More models (200+)
- Mature and stable
- Mixed syntax
- Maintenance mode

### Should I switch from h2o?

Consider tidyAML if:
- ✅ You prefer tidyverse/tidymodels
- ✅ You want to avoid Java dependencies
- ✅ You're working with small-to-medium data
- ✅ You want easier integration with R workflows

Stay with h2o if:
- You need distributed computing
- You're working with very large datasets
- You need built-in automatic tuning
- You're already invested in h2o

### Can I use tidyAML and h2o together?

Yes! They serve different purposes:
- Use tidyAML for tidymodels workflows
- Use h2o for large-scale AutoML
- Compare results between both

## Still Have Questions?

- 📖 Check the [Documentation](Home.md)
- 🔍 Browse [Tutorials](Regression-Tutorial.md)
- 🐛 Search [GitHub Issues](https://github.com/spsanderson/tidyAML/issues)
- ❓ Open a new issue for help
- 📚 Read the [Troubleshooting Guide](Troubleshooting.md)

---

[← Back to Home](Home.md) | [Troubleshooting →](Troubleshooting.md)
