# Supported Models and Engines

Complete reference of models and engines supported by tidyAML.

## Table of Contents

- [Overview](#overview)
- [Regression Models](#regression-models)
- [Classification Models](#classification-models)
- [Required Packages](#required-packages)
- [Engine Details](#engine-details)

## Overview

tidyAML leverages the parsnip package ecosystem, supporting 30+ model engines across various algorithm types. This page documents which models are available and what packages are required.

### How to Use This Reference

1. **Find your task**: Regression or Classification
2. **Choose a model type**: Linear, Tree-based, etc.
3. **Check required package**: Install if needed
4. **Use with tidyAML**: Reference the engine name

### Quick Reference

```r
# See all available regression models
fast_regression_parsnip_spec_tbl()

# See all available classification models
fast_classification_parsnip_spec_tbl()

# See specific model type
fast_regression_parsnip_spec_tbl(.parsnip_fns = "linear_reg")
```

## Regression Models

### Linear Regression

Standard linear regression models.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `lm` | `linear_reg()` | stats (base R) | Ordinary least squares |
| `glm` | `linear_reg()` | stats (base R) | Generalized linear model |
| `glmnet` | `linear_reg()` | glmnet | Elastic net regularization |
| `gee` | `linear_reg()` | gee | Generalized estimating equations |
| `glmer` | `linear_reg()` | lme4 | Mixed effects model |
| `lmer` | `linear_reg()` | lme4 | Linear mixed effects |
| `gls` | `linear_reg()` | nlme | Generalized least squares |
| `lme` | `linear_reg()` | nlme | Linear mixed effects |
| `stan` | `linear_reg()` | rstanarm | Bayesian linear regression |
| `stan_glmer` | `linear_reg()` | rstanarm | Bayesian mixed effects |
| `brulee` | `linear_reg()` | brulee | Neural network linear regression |

**Example**:
```r
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm", "glmnet")
)
```

### Poisson Regression

For count data.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `glm` | `poisson_reg()` | stats (base R) | Poisson GLM |
| `glmnet` | `poisson_reg()` | glmnet | Regularized Poisson |
| `stan` | `poisson_reg()` | rstanarm | Bayesian Poisson |

**Example**:
```r
rec_obj <- recipe(count_variable ~ ., data = count_data)
models <- fast_regression(
  .data = count_data,
  .rec_obj = rec_obj,
  .parsnip_fns = "poisson_reg"
)
```

### Decision Trees

Tree-based regression models.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `rpart` | `decision_tree()` | rpart | CART decision tree |
| `C5.0` | `decision_tree()` | C50 | C5.0 decision tree |
| `partykit` | `decision_tree()` | partykit | Conditional inference tree |

**Example**:
```r
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_fns = "decision_tree"
)
```

### Random Forests

Ensemble tree methods.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `ranger` | `rand_forest()` | ranger | Fast random forest implementation |
| `randomForest` | `rand_forest()` | randomForest | Original random forest |

**Example**:
```r
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("ranger", "randomForest")
)
```

### Boosting

Gradient boosting algorithms.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `xgboost` | `boost_tree()` | xgboost | Extreme gradient boosting |
| `lightgbm` | `boost_tree()` | lightgbm | Light GBM |
| `catboost` | `boost_tree()` | catboost | CatBoost |

**Example**:
```r
# Requires xgboost package
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = "xgboost"
)
```

### Support Vector Machines

SVM for regression.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `kernlab` | `svm_rbf()` | kernlab | Radial basis function SVM |
| `kernlab` | `svm_poly()` | kernlab | Polynomial kernel SVM |
| `kernlab` | `svm_linear()` | kernlab | Linear SVM |
| `LiblineaR` | `svm_linear()` | LiblineaR | Linear SVM (large-scale) |

**Example**:
```r
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_fns = "svm_rbf"
)
```

### K-Nearest Neighbors

Instance-based learning.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `kknn` | `nearest_neighbor()` | kknn | Weighted k-NN |

**Example**:
```r
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = "kknn"
)
```

### Neural Networks

Neural network models.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `nnet` | `mlp()` | nnet | Single hidden layer network |
| `brulee` | `mlp()` | brulee | Torch-based neural network |
| `keras` | `mlp()` | keras | Keras/TensorFlow backend |

### Bayesian Models

Bayesian regression.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `stan` | `linear_reg()` | rstanarm | Bayesian linear model |
| `stan_glmer` | `linear_reg()` | rstanarm | Bayesian mixed effects |

### MARS

Multivariate adaptive regression splines.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `earth` | `mars()` | earth | MARS algorithm |

**Example**:
```r
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = "earth"
)
```

### Rule-Based Models

Models using rules.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `cubist` | `cubist_rules()` | Cubist | Rule-based regression |
| `xrf` | `rule_fit()` | xrf | RuleFit algorithm |

### Survival Models

For time-to-event data (requires censored package).

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `flexsurv` | `survival_reg()` | flexsurv | Flexible parametric survival |
| `survival` | `survival_reg()` | survival | Cox proportional hazards |

## Classification Models

### Logistic Regression

Binary and multinomial classification.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `glm` | `logistic_reg()` | stats (base R) | Logistic regression |
| `glmnet` | `logistic_reg()` | glmnet | Regularized logistic regression |
| `LiblineaR` | `logistic_reg()` | LiblineaR | Large-scale linear classification |
| `stan` | `logistic_reg()` | rstanarm | Bayesian logistic regression |
| `brulee` | `logistic_reg()` | brulee | Neural network logistic |
| `keras` | `logistic_reg()` | keras | Deep learning logistic |

**Example**:
```r
models <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .parsnip_eng = c("glm", "glmnet")
)
```

### Multinomial Regression

Multi-class classification.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `glmnet` | `multinom_reg()` | glmnet | Regularized multinomial |
| `nnet` | `multinom_reg()` | nnet | Neural network multinomial |
| `keras` | `multinom_reg()` | keras | Deep learning multinomial |
| `brulee` | `multinom_reg()` | brulee | Torch multinomial |

**Example**:
```r
# For multi-class problems
iris_models <- fast_classification(
  .data = iris,
  .rec_obj = rec_obj,
  .parsnip_fns = "multinom_reg"
)
```

### Decision Trees

Tree-based classification.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `rpart` | `decision_tree()` | rpart | CART classification tree |
| `C5.0` | `decision_tree()` | C50 | C5.0 algorithm |
| `partykit` | `decision_tree()` | partykit | Conditional inference |

### Random Forests

Ensemble methods for classification.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `ranger` | `rand_forest()` | ranger | Fast random forest |
| `randomForest` | `rand_forest()` | randomForest | Original implementation |

### Boosting

Gradient boosting for classification.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `xgboost` | `boost_tree()` | xgboost | XGBoost classifier |
| `lightgbm` | `boost_tree()` | lightgbm | Light GBM classifier |
| `catboost` | `boost_tree()` | catboost | CatBoost classifier |
| `C5.0` | `boost_tree()` | C50 | C5.0 boosting |

### Naive Bayes

Probabilistic classifier.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `klaR` | `naive_Bayes()` | klaR | Naive Bayes classifier |
| `naivebayes` | `naive_Bayes()` | naivebayes | Alternative implementation |

**Example**:
```r
models <- fast_classification(
  .data = df,
  .rec_obj = rec_obj,
  .parsnip_fns = "naive_Bayes"
)
```

### Discriminant Analysis

Linear and quadratic discriminant analysis.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `MASS` | `discrim_linear()` | MASS | Linear discriminant analysis |
| `MASS` | `discrim_quad()` | MASS | Quadratic discriminant |
| `mda` | `discrim_flexible()` | mda | Flexible discriminant |
| `sda` | `discrim_regularized()` | sda | Shrinkage discriminant |
| `sparsediscrim` | `discrim_regularized()` | sparsediscrim | Sparse discriminant |
| `klaR` | `discrim_regularized()` | klaR | Regularized discriminant |

**Example**:
```r
models <- fast_classification(
  .data = iris,
  .rec_obj = rec_obj,
  .parsnip_fns = "discrim_linear"
)
```

### Support Vector Machines

SVM for classification.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `kernlab` | `svm_rbf()` | kernlab | RBF kernel SVM |
| `kernlab` | `svm_poly()` | kernlab | Polynomial kernel |
| `kernlab` | `svm_linear()` | kernlab | Linear SVM |
| `LiblineaR` | `svm_linear()` | LiblineaR | Large-scale linear SVM |

### K-Nearest Neighbors

Instance-based classification.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `kknn` | `nearest_neighbor()` | kknn | Weighted k-NN |

### Neural Networks

Neural network classifiers.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `nnet` | `mlp()` | nnet | Multi-layer perceptron |
| `brulee` | `mlp()` | brulee | Torch neural network |
| `keras` | `mlp()` | keras | Deep learning |

### MARS

MARS for classification.

| Engine | Function | Package Required | Description |
|--------|----------|------------------|-------------|
| `earth` | `mars()` | earth | MARS classifier |

## Required Packages

### Always Required (Installed with tidyAML)

- `parsnip` - Model specifications
- `workflows` - Workflow management
- `dplyr` - Data manipulation
- `purrr` - Functional programming
- `recipes` - Preprocessing

### Commonly Used (Recommended)

```r
install.packages(c(
  "glmnet",        # Elastic net
  "ranger",        # Random forest
  "xgboost",       # Gradient boosting
  "kknn",          # K-nearest neighbors
  "earth"          # MARS
))
```

### Specialized (Install as Needed)

```r
# Bayesian models
install.packages("rstanarm")

# Advanced discriminant analysis
install.packages(c("mda", "sda", "sparsediscrim", "klaR"))

# Deep learning
install.packages(c("keras", "brulee"))

# Additional engines
install.packages(c(
  "LiblineaR",     # Linear models
  "randomForest",  # Random forest
  "C50",           # C5.0
  "Cubist",        # Rule-based
  "dbarts",        # Bayesian trees
  "kernlab",       # SVM
  "nnet"           # Neural networks
))
```

### Installing All Optional Packages

```r
# Use tidyAML helper
tidyAML::install_deps()

# Or install all suggested packages
install.packages(c(
  "glmnet", "ranger", "xgboost", "kknn", "earth",
  "randomForest", "LiblineaR", "dbarts", "rstanarm",
  "baguette", "bonsai", "brulee", "censored",
  "multilevelmod", "rules", "poissonreg", "discrim",
  "kernlab", "klaR", "mda", "sda", "sparsediscrim",
  "flexsurv", "gee"
))
```

## Engine Details

### Performance Characteristics

| Engine Category | Speed | Memory | Scalability | Interpretability |
|----------------|-------|--------|-------------|------------------|
| Linear (lm, glm) | ⚡⚡⚡ | ✓✓✓ | ✓✓✓ | ⭐⭐⭐ |
| Regularized (glmnet) | ⚡⚡ | ✓✓✓ | ✓✓✓ | ⭐⭐ |
| Random Forest | ⚡⚡ | ✓✓ | ✓✓ | ⭐ |
| Boosting (xgboost) | ⚡ | ✓✓ | ✓✓ | ⭐ |
| SVM | ⚡ | ✓ | ✓ | ⭐ |
| Neural Networks | ⚡ | ✓ | ✓✓ | ⭐ |
| Bayesian | 🐌 | ✓ | ✓ | ⭐⭐ |

### Choosing an Engine

**Start with these (fast, reliable)**:
- `lm`, `glm` - Simple and interpretable
- `glmnet` - Good with many features
- `ranger` - Good general performance

**For better accuracy (slower)**:
- `xgboost` - Often best performance
- `ranger` with many trees
- Ensemble methods

**For special cases**:
- `rstanarm` - Need uncertainty quantification
- `gee`, `lmer` - Hierarchical/grouped data
- `earth` - Need interpretable nonlinear
- `kknn` - Small datasets, local patterns

### Model Selection Tips

1. **Start simple**: Try `lm` or `glm` first
2. **Add complexity**: Try `glmnet`, `ranger`
3. **Test multiple**: Use tidyAML to compare
4. **Evaluate properly**: Use test set metrics
5. **Consider context**: Interpretability vs accuracy

## Checking Available Models

```r
library(tidyAML)

# All regression models
all_reg <- fast_regression_parsnip_spec_tbl()
nrow(all_reg)  # How many models?

# Group by function type
all_reg |>
  count(.parsnip_fns)

# All classification models
all_class <- fast_classification_parsnip_spec_tbl()

# Specific model family
linear_models <- fast_regression_parsnip_spec_tbl(
  .parsnip_fns = "linear_reg"
)
linear_models |>
  pull(.parsnip_engine)
```

## Next Steps

- **Try Models**: [Quick Start](Quick-Start.md)
- **Learn More**: [Regression Tutorial](Regression-Tutorial.md)
- **Get Help**: [Troubleshooting](Troubleshooting.md)

---

[← Back to Home](Home.md) | [Troubleshooting →](Troubleshooting.md)
