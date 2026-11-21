# Function Reference: Plotting Functions

Complete reference for visualization functions in tidyAML.

## Table of Contents

- [Overview](#overview)
- [plot_regression_predictions](#plot_regression_predictions)
- [plot_regression_residuals](#plot_regression_residuals)
- [Custom Visualizations](#custom-visualizations)

## Overview

tidyAML provides built-in plotting functions for quick model assessment. These functions create ggplot2 visualizations that can be further customized.

---

## plot_regression_predictions

Plot predicted vs actual values for regression models.

### Description

`plot_regression_predictions()` creates a faceted scatter plot showing predicted vs actual values for each regression model, with separate panels for training and testing data.

### Usage

```r
plot_regression_predictions(
  .data,
  .model_id = NULL,
  .interactive = FALSE
)
```

### Arguments

| Argument | Description |
|----------|-------------|
| `.data` | tidyAML regression model table (from `fast_regression()`) |
| `.model_id` | Optional integer vector of model IDs to plot. Default: `NULL` plots all models. |
| `.interactive` | Logical. If `TRUE`, creates interactive plotly plot. Default: `FALSE`. |

### Value

Returns a ggplot2 object (or plotly if `.interactive = TRUE`) that can be further customized.

### Details

The plot includes:
- **X-axis**: Actual values
- **Y-axis**: Predicted values
- **Reference line**: Perfect prediction (y = x) shown as dashed line
- **Colors**: Different colors for actual, training predictions, testing predictions
- **Facets**: One panel per model type
- **Points**: Semi-transparent for overplotting

### Examples

```r
library(tidyAML)
library(recipes)

# Train models
rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm", "glmnet")
)

# Basic plot
plot_regression_predictions(models)

# Plot specific models
plot_regression_predictions(models, .model_id = 1:2)

# Interactive plot
plot_regression_predictions(models, .interactive = TRUE)

# Customize the plot
library(ggplot2)
p <- plot_regression_predictions(models)
p +
  labs(
    title = "Model Predictions Comparison",
    subtitle = "mtcars dataset - MPG prediction"
  ) +
  theme_minimal()

# Save plot
ggsave("predictions_plot.png", p, width = 10, height = 6)
```

### Interpretation

**Good predictions:**
- Points cluster around the diagonal line
- Similar performance on training and testing
- No systematic deviations

**Warning signs:**
- Points far from diagonal (poor predictions)
- Different patterns for training vs testing (overfitting)
- Systematic bias (all above or below line)
- Funnel shape (heteroscedasticity)

### Customization

```r
# Get the base plot
p <- plot_regression_predictions(models)

# Add custom theme
p <- p + theme_bw()

# Modify colors
p <- p + scale_color_manual(values = c("red", "blue", "green"))

# Change labels
p <- p + labs(
  x = "Observed MPG",
  y = "Predicted MPG",
  color = "Data Type"
)

# Adjust facets
p <- p + facet_wrap(~ .model_type, scales = "free")

# Add annotations
p <- p + annotate(
  "text",
  x = 15, y = 30,
  label = "Good predictions\nshould fall on\nthis line",
  color = "darkgray"
)
```

### See Also

- [plot_regression_residuals](#plot_regression_residuals) for residual plots
- [extract_wflw_pred](Function-Reference-Extractors.md#extract_wflw_pred) for prediction data
- [Regression Tutorial](Regression-Tutorial.md) for examples

---

## plot_regression_residuals

Plot residuals for regression models.

### Description

`plot_regression_residuals()` creates diagnostic residual plots for regression models, including residuals vs fitted values and residual distributions.

### Usage

```r
plot_regression_residuals(
  .data,
  .model_id = NULL,
  .interactive = FALSE
)
```

### Arguments

| Argument | Description |
|----------|-------------|
| `.data` | tidyAML regression model table |
| `.model_id` | Optional model IDs to plot. Default: `NULL` (all models) |
| `.interactive` | Logical. Create interactive plotly plot. Default: `FALSE` |

### Value

Returns a ggplot2 object (or plotly if interactive).

### Details

The plot shows:
- **X-axis**: Fitted (predicted) values
- **Y-axis**: Residuals (actual - predicted)
- **Reference line**: Zero line (perfect predictions)
- **Smooth line**: Loess smooth to detect patterns
- **Facets**: One panel per model
- **Points**: Colored by magnitude of residual

### Examples

```r
library(tidyAML)
library(recipes)

# Train models
rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm", "glmnet")
)

# Basic residual plot
plot_regression_residuals(models)

# Plot specific models
plot_regression_residuals(models, .model_id = 1:2)

# Interactive version
plot_regression_residuals(models, .interactive = TRUE)

# Customize
library(ggplot2)
p <- plot_regression_residuals(models)
p +
  labs(
    title = "Residual Diagnostics",
    subtitle = "Check for patterns in residuals"
  ) +
  theme_minimal()
```

### Interpretation

**Good residuals (desirable):**
- Randomly scattered around zero
- No patterns or trends
- Consistent spread across fitted values
- Smooth line stays near zero

**Warning signs:**
- **Patterns/curves**: Non-linear relationship not captured
- **Funnel shape**: Heteroscedasticity (non-constant variance)
- **Systematic bias**: Smooth line not near zero
- **Outliers**: Points far from zero
- **Clusters**: Might indicate subgroups

### Diagnostic Checks

```r
# After plotting, check numerically
residuals <- extract_regression_residuals(models)

# Check assumptions
residuals[[1]] |>
  summarize(
    mean_resid = mean(.resid),          # Should be ~0
    sd_resid = sd(.resid),
    normality_p = shapiro.test(.resid)$p.value  # Normality test
  )
```

### Additional Diagnostic Plots

```r
library(ggplot2)

# Get residuals
residuals <- extract_regression_residuals(models)

# Histogram of residuals
residuals[[1]] |>
  ggplot(aes(x = .resid)) +
  geom_histogram(bins = 15, fill = "steelblue", alpha = 0.7) +
  geom_vline(xintercept = 0, color = "red", linetype = "dashed") +
  labs(title = "Distribution of Residuals")

# Q-Q plot
residuals[[1]] |>
  ggplot(aes(sample = .resid)) +
  stat_qq() +
  stat_qq_line(color = "red") +
  labs(title = "Q-Q Plot - Check Normality")

# Scale-location plot
residuals[[1]] |>
  ggplot(aes(x = .predicted, y = sqrt(abs(.resid)))) +
  geom_point(alpha = 0.6) +
  geom_smooth(se = FALSE, color = "red") +
  labs(
    title = "Scale-Location Plot",
    x = "Fitted Values",
    y = "√|Residuals|"
  )

# Residuals by observation
residuals[[1]] |>
  mutate(obs = row_number()) |>
  ggplot(aes(x = obs, y = .resid)) +
  geom_point() +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed") +
  labs(
    title = "Residuals by Observation",
    x = "Observation",
    y = "Residuals"
  )
```

### See Also

- [plot_regression_predictions](#plot_regression_predictions) for predictions plot
- [extract_regression_residuals](Function-Reference-Extractors.md#extract_regression_residuals) for residual data
- [Regression Tutorial](Regression-Tutorial.md) for interpretation guide

---

## Custom Visualizations

While tidyAML provides built-in plotting functions, you can create custom visualizations using the extracted data.

### Custom Prediction Plot

```r
library(ggplot2)
library(dplyr)

# Extract predictions
predictions <- extract_wflw_pred(models)

# Create custom plot
predictions |>
  filter(.data_category == "testing") |>
  pivot_wider(names_from = .data_type, values_from = .value) |>
  ggplot(aes(x = actual, y = predicted)) +
  geom_point(aes(color = .model_type), alpha = 0.6, size = 3) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  facet_wrap(~ .model_type) +
  theme_minimal() +
  labs(
    title = "Custom Prediction Comparison",
    x = "Actual Values",
    y = "Predicted Values",
    color = "Model Type"
  )
```

### Model Comparison Metrics Plot

```r
library(yardstick)
library(tidyr)

# Calculate metrics
metrics <- predictions |>
  filter(.data_category == "testing") |>
  pivot_wider(names_from = .data_type, values_from = .value) |>
  group_by(.model_type) |>
  summarize(
    RMSE = rmse_vec(actual, predicted),
    MAE = mae_vec(actual, predicted),
    R2 = rsq_vec(actual, predicted)
  )

# Plot metrics
metrics |>
  pivot_longer(-`.model_type`, names_to = "metric", values_to = "value") |>
  ggplot(aes(x = reorder(.model_type, value), y = value, fill = metric)) +
  geom_col(position = "dodge") +
  facet_wrap(~ metric, scales = "free_y") +
  coord_flip() +
  theme_minimal() +
  labs(
    title = "Model Performance Comparison",
    x = "Model",
    y = "Metric Value",
    fill = "Metric"
  )
```

### Prediction Interval Plot

```r
# Custom prediction interval visualization
predictions |>
  filter(.data_category == "testing", .model_type == "lm - linear_reg") |>
  pivot_wider(names_from = .data_type, values_from = .value) |>
  mutate(
    error = predicted - actual,
    obs = row_number()
  ) |>
  ggplot(aes(x = obs)) +
  geom_point(aes(y = actual), color = "black", size = 2) +
  geom_point(aes(y = predicted), color = "blue", size = 2, alpha = 0.6) +
  geom_segment(aes(xend = obs, y = actual, yend = predicted), 
               color = "gray", alpha = 0.5) +
  theme_minimal() +
  labs(
    title = "Prediction Intervals",
    x = "Observation",
    y = "Value"
  )
```

### Residual Distribution Comparison

```r
# Compare residual distributions
residuals_list <- extract_regression_residuals(models)

# Combine residuals
all_residuals <- map_df(seq_along(residuals_list), ~ {
  residuals_list[[.x]] |>
    mutate(model_id = .x)
})

# Plot distributions
all_residuals |>
  ggplot(aes(x = .resid, fill = .model_type)) +
  geom_density(alpha = 0.5) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
  theme_minimal() +
  labs(
    title = "Residual Distributions by Model",
    x = "Residuals",
    y = "Density",
    fill = "Model Type"
  )
```

### Interactive Plotly Visualizations

```r
library(plotly)

# Get base plot
p <- plot_regression_predictions(models)

# Convert to interactive
ggplotly(p)

# Custom interactive plot
predictions |>
  filter(.data_category == "testing") |>
  pivot_wider(names_from = .data_type, values_from = .value) |>
  plot_ly(x = ~actual, y = ~predicted, color = ~.model_type,
          type = "scatter", mode = "markers",
          text = ~paste("Actual:", round(actual, 2),
                       "<br>Predicted:", round(predicted, 2),
                       "<br>Model:", .model_type)) |>
  add_trace(x = ~actual, y = ~actual, mode = "lines",
            line = list(dash = "dash", color = "red"),
            name = "Perfect Prediction", showlegend = TRUE) |>
  layout(
    title = "Interactive Predictions Plot",
    xaxis = list(title = "Actual"),
    yaxis = list(title = "Predicted")
  )
```

### Saving Plots

```r
# Save static plot
p <- plot_regression_predictions(models)
ggsave("predictions.png", p, width = 10, height = 6, dpi = 300)

# Save PDF
ggsave("predictions.pdf", p, width = 10, height = 6)

# Save interactive plot
library(htmlwidgets)
p_interactive <- ggplotly(p)
saveWidget(p_interactive, "predictions_interactive.html")

# Multiple plots in one figure
library(patchwork)
p1 <- plot_regression_predictions(models)
p2 <- plot_regression_residuals(models)
combined <- p1 / p2
ggsave("combined_diagnostics.png", combined, width = 12, height = 10)
```

## Tips for Effective Visualization

### 1. Choose Appropriate Plot Type

```r
# For model comparison: side-by-side metrics
# For diagnostics: residual plots
# For communication: prediction plots with confidence
```

### 2. Use Color Meaningfully

```r
# Color by data type (actual/predicted)
# Color by model type
# Color by error magnitude
```

### 3. Add Context

```r
p + labs(
  title = "Clear, Descriptive Title",
  subtitle = "Additional context",
  caption = "Data source and date"
)
```

### 4. Make it Accessible

```r
# Use colorblind-friendly palettes
scale_color_viridis_d()

# Add clear labels
# Use high contrast
# Include legends
```

## Related Pages

- [Function Reference: Model Generators](Function-Reference-Model-Generators.md)
- [Function Reference: Extractors](Function-Reference-Extractors.md)
- [Regression Tutorial](Regression-Tutorial.md) for visualization examples
- [Best Practices](Best-Practices.md) for workflow guidance

---

[← Back to Utilities](Function-Reference-Utilities.md) | [Home](Home.md)
