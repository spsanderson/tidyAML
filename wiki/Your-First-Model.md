# Your First Model

A step-by-step tutorial for absolute beginners. Learn to build your first machine learning model with tidyAML in 10 minutes.

## What You'll Learn

- Setting up tidyAML
- Preparing data for modeling
- Creating your first regression model
- Understanding the results
- Making predictions

## Prerequisites

- R installed (version 4.1.0 or higher)
- RStudio (recommended)
- 10 minutes of your time!

## Step 1: Install and Load tidyAML

First, let's install tidyAML if you haven't already:

```r
# Install from CRAN (do this once)
install.packages("tidyAML")

# Load the package
library(tidyAML)
```

You should see a welcome message!

## Step 2: Load Your Data

We'll use the built-in `mtcars` dataset, which contains information about different car models:

```r
# Load the data
data(mtcars)

# Take a quick look
head(mtcars)
```

You'll see something like:
```
                   mpg cyl disp  hp drat    wt  qsec vs am gear carb
Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
...
```

**What are these columns?**
- `mpg`: Miles per gallon (we'll predict this!)
- `cyl`: Number of cylinders
- `disp`: Displacement
- `hp`: Horsepower
- `wt`: Weight
- And more...

## Step 3: Set Your Goal

Let's predict **fuel efficiency (mpg)** based on other car characteristics.

**Question we're asking**: Given a car's weight, horsepower, and other features, can we predict its fuel efficiency?

## Step 4: Create a Recipe

A "recipe" tells tidyAML how to prepare your data:

```r
library(recipes)

# Create a recipe
rec_obj <- recipe(mpg ~ ., data = mtcars)
```

**What does this mean?**
- `mpg ~`: We want to predict mpg
- `.`: Using all other columns as predictors
- `data = mtcars`: From the mtcars dataset

Think of it as saying: "Predict mpg using everything else in mtcars"

## Step 5: Train Your First Model

Now the magic happens! Let's train a simple linear regression model:

```r
# Train the model
my_first_model <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = "lm"  # "lm" = linear model
)

# View the result
my_first_model
```

**What just happened?**
- tidyAML split your data into training and testing sets
- It trained a model on the training data
- It made predictions on the testing data
- All automatically!

## Step 6: Look at the Results

Your model table shows:

```r
my_first_model
```

You'll see something like:
```
# A tibble: 1 × 8
  .model_id .parsnip_engine .parsnip_mode .parsnip_fns model_spec wflw  fitted_wflw pred_wflw
      <int> <chr>           <chr>         <chr>        <list>     <list> <list>      <list>   
1         1 lm              regression    linear_reg   <spec[+]>  <...>  <...>       <...>    
```

**What does this mean?**
- Row 1 contains your trained model
- `fitted_wflw`: The trained model
- `pred_wflw`: Predictions from the model

## Step 7: Extract Predictions

Let's see how well your model did:

```r
# Get predictions
predictions <- extract_wflw_pred(my_first_model)

# View them
head(predictions)
```

You'll see actual vs predicted values!

## Step 8: Visualize Results

See how well your model predicts:

```r
# Plot predictions vs actual values
plot_regression_predictions(my_first_model)
```

**What to look for:**
- Points should be near the diagonal line
- Points near the line = good predictions
- Points far from the line = poor predictions

## Step 9: Check Model Quality

Let's see how good our predictions are:

```r
# Plot residuals (prediction errors)
plot_regression_residuals(my_first_model)
```

**What to look for:**
- Points should be randomly scattered
- No obvious patterns
- Close to the zero line

## Step 10: Calculate Performance Metrics

How accurate is your model?

```r
library(yardstick)
library(tidyr)
library(dplyr)

# Calculate metrics
predictions |>
  filter(.data_category == "testing") |>
  pivot_wider(names_from = .data_type, values_from = .value) |>
  summarize(
    RMSE = rmse_vec(actual, predicted),
    MAE = mae_vec(actual, predicted),
    R_squared = rsq_vec(actual, predicted)
  )
```

**Understanding the metrics:**
- **RMSE** (Root Mean Square Error): Average prediction error (lower is better)
- **MAE** (Mean Absolute Error): Average absolute error (lower is better)
- **R²** (R-squared): Proportion of variance explained (higher is better, max = 1.0)

## 🎉 Congratulations!

You just:
1. ✅ Loaded data
2. ✅ Created a recipe
3. ✅ Trained a machine learning model
4. ✅ Made predictions
5. ✅ Evaluated performance

## What's Next?

### Train Multiple Models

Want to see which algorithm works best? Train multiple models at once:

```r
# Train 3 different models
multiple_models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm", "glmnet")
)

# Compare them
plot_regression_predictions(multiple_models)
```

### Try Different Data

Use your own data:

```r
# Load your CSV
my_data <- read.csv("my_data.csv")

# Make sure target is numeric for regression!
str(my_data)

# Create recipe (replace 'target_column' with your column name)
my_recipe <- recipe(target_column ~ ., data = my_data)

# Train models
my_models <- fast_regression(
  .data = my_data,
  .rec_obj = my_recipe,
  .parsnip_eng = c("lm", "glm")
)
```

### Add Preprocessing

Improve your model with data preprocessing:

```r
# Advanced recipe
rec_advanced <- recipe(mpg ~ ., data = mtcars) |>
  step_normalize(all_numeric_predictors()) |>  # Normalize values
  step_corr(all_numeric_predictors(), threshold = 0.9)  # Remove correlated features

# Train with advanced recipe
better_models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_advanced,
  .parsnip_eng = c("lm", "glm", "glmnet")
)
```

### Try Classification

Have a categorical target (like "yes/no" or "high/medium/low")?

```r
# First, convert target to factor!
my_data <- my_data |>
  mutate(target = as.factor(target))

# Then use fast_classification
class_models <- fast_classification(
  .data = my_data,
  .rec_obj = recipe(target ~ ., data = my_data),
  .parsnip_eng = c("glm", "glmnet")
)
```

## Common Beginner Mistakes

### 1. Wrong R Version

**Error**: "R version >= 4.1.0 required"

**Fix**: Update R from [CRAN](https://cran.r-project.org/)

### 2. Missing Package

**Error**: "there is no package called 'glmnet'"

**Fix**: 
```r
install.packages("glmnet")
```

### 3. Classification Without Factor

**Error**: Model fails or gives weird results

**Fix**: Convert target to factor:
```r
data <- data |> mutate(target = as.factor(target))
```

### 4. Wrong Recipe Format

**Error**: "Recipe has wrong number of variables"

**Fix**: Ensure same data in recipe and model:
```r
# Both should use same data
rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(.data = mtcars, .rec_obj = rec_obj)
```

## Quick Reference Card

```r
# 1. Load packages
library(tidyAML)
library(recipes)

# 2. Load data
data(mtcars)

# 3. Create recipe
rec_obj <- recipe(mpg ~ ., data = mtcars)

# 4. Train model
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = "lm"
)

# 5. Get predictions
predictions <- extract_wflw_pred(models)

# 6. Visualize
plot_regression_predictions(models)
plot_regression_residuals(models)
```

## Getting Help

**Stuck?** Here's where to look:

1. **Function help**: `?fast_regression`
2. **FAQ**: [Frequently Asked Questions](FAQ.md)
3. **Troubleshooting**: [Troubleshooting Guide](Troubleshooting.md)
4. **More examples**: [Quick Start](Quick-Start.md)
5. **Detailed tutorial**: [Regression Tutorial](Regression-Tutorial.md)
6. **GitHub Issues**: [Report a problem](https://github.com/spsanderson/tidyAML/issues)

## Keep Learning

Now that you've built your first model, continue with:

- [Quick Start Guide](Quick-Start.md) - More examples
- [Regression Tutorial](Regression-Tutorial.md) - Deep dive into regression
- [Classification Tutorial](Classification-Tutorial.md) - Learn classification
- [Package Overview](Package-Overview.md) - Understand tidyAML architecture
- [Best Practices](Best-Practices.md) - Write better code

## Celebrate! 🎊

You've successfully built your first machine learning model with tidyAML! 

**Share your success**:
- Tweet about it with #tidyAML
- Star the [GitHub repo](https://github.com/spsanderson/tidyAML)
- Try it on your own data!

---

[← Back to Quick Start](Quick-Start.md) | [Home](Home.md) | [Next: Regression Tutorial →](Regression-Tutorial.md)
