# Troubleshooting Guide

Solutions to common issues when using tidyAML.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Loading & Dependencies](#loading--dependencies)
- [Data Preparation Issues](#data-preparation-issues)
- [Model Training Errors](#model-training-errors)
- [Recipe Errors](#recipe-errors)
- [Prediction Issues](#prediction-issues)
- [Performance Problems](#performance-problems)
- [Platform-Specific Issues](#platform-specific-issues)

## Installation Issues

### Error: "package 'tidyAML' is not available"

**Problem**: tidyAML not found on CRAN or GitHub.

**Solutions**:
1. Check package name spelling (it's `tidyAML`, not `tidyaml`)
2. Update R to >= 4.1.0
3. Try installing from GitHub:
   ```r
   devtools::install_github("spsanderson/tidyAML")
   ```

### Error: "R version >= 4.1.0 required"

**Problem**: Your R version is too old.

**Solution**: Update R from [CRAN](https://cran.r-project.org/)

```r
# Check your R version
R.version.string

# If < 4.1.0, download and install latest R
```

### Error: "installation of package 'X' had non-zero exit status"

**Problem**: Dependency installation failed.

**Solutions**:

**On Linux**:
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install libxml2-dev libcurl4-openssl-dev libssl-dev

# Fedora/CentOS
sudo yum install libxml2-devel curl-devel openssl-devel
```

**On macOS**:
```bash
xcode-select --install
```

**On Windows**:
- Install RTools from [CRAN](https://cran.r-project.org/bin/windows/Rtools/)

### Error: "Cannot remove prior installation of package"

**Problem**: Package locked or in use.

**Solutions**:
1. Restart R session
2. Close all R sessions
3. Manually remove old package:
   ```r
   # Find package location
   .libPaths()
   
   # Remove manually via file explorer
   # Then reinstall
   install.packages("tidyAML")
   ```

## Loading & Dependencies

### Error: "there is no package called 'parsnip'"

**Problem**: Core dependency not installed.

**Solution**:
```r
install.packages("parsnip")
# Or install all tidymodels
install.packages("tidymodels")
```

### Error: "there is no package called 'glmnet'" (or other engine)

**Problem**: Model engine package not installed.

**Solution**:
```r
# Install the specific package
install.packages("glmnet")

# Or use tidyAML helper
tidyAML::install_deps()
```

**Note**: tidyAML will skip models with missing packages - this is normal behavior.

### Error: "namespace 'X' is already loaded"

**Problem**: Package version conflict.

**Solutions**:
1. Restart R session
2. Update all packages:
   ```r
   update.packages(ask = FALSE)
   ```
3. Remove and reinstall problem package:
   ```r
   remove.packages("package_name")
   install.packages("package_name")
   ```

### Warning: "package 'X' was built under R version Y.Z"

**Problem**: Package built with different R version.

**Solutions**:
- Usually safe to ignore
- If issues persist, update R to latest version
- Or rebuild package from source:
  ```r
  install.packages("package_name", type = "source")
  ```

## Data Preparation Issues

### Error: "object 'target' not found"

**Problem**: Target variable not in dataset.

**Solution**: Check column names:
```r
names(your_data)
# Ensure target column exists and is spelled correctly
```

### Error: "All columns selected are character or factor"

**Problem**: No numeric predictors for regression.

**Solution**: Check data types:
```r
str(your_data)
# Ensure you have numeric columns for regression
# Convert if needed:
your_data$numeric_col <- as.numeric(your_data$character_col)
```

### Error: "outcome should be a factor for classification"

**Problem**: Classification target is not a factor.

**Solution**: Convert to factor:
```r
# Check current type
class(your_data$target)

# Convert to factor
your_data <- your_data |>
  mutate(target = as.factor(target))

# Verify
class(your_data$target)
```

### Issue: Missing values causing errors

**Problem**: NA values in data.

**Solutions**:

1. **Drop NAs** (default in tidyAML):
   ```r
   models <- fast_regression(
     .data = your_data,
     .rec_obj = rec_obj,
     .drop_na = TRUE
   )
   ```

2. **Impute in recipe**:
   ```r
   rec_obj <- recipe(target ~ ., data = your_data) |>
     step_impute_mean(all_numeric_predictors()) |>
     step_impute_mode(all_nominal_predictors())
   ```

3. **Remove specific columns**:
   ```r
   rec_obj <- recipe(target ~ ., data = your_data) |>
     step_rm(column_with_many_nas)
   ```

### Issue: Imbalanced classes (classification)

**Problem**: One class dominates (e.g., 95% vs 5%).

**Solutions**:

1. **Stratified sampling**:
   ```r
   models <- fast_classification(
     .data = data,
     .rec_obj = rec_obj,
     .split_args = list(strata = "target")
   )
   ```

2. **Resampling in recipe**:
   ```r
   # Requires themis package
   library(themis)
   
   rec_obj <- recipe(target ~ ., data = data) |>
     step_upsample(target)  # or step_downsample()
   ```

3. **Use appropriate metrics**: F1-score instead of accuracy

## Model Training Errors

### Error: "No models were successfully trained"

**Problem**: All models failed.

**Diagnostic steps**:
1. Check data:
   ```r
   glimpse(your_data)
   sum(is.na(your_data))
   ```

2. Check recipe:
   ```r
   rec_obj
   ```

3. Test with simple model:
   ```r
   models <- fast_regression(
     .data = your_data,
     .rec_obj = rec_obj,
     .parsnip_eng = "lm"  # Just try lm
   )
   ```

4. Check error messages:
   ```r
   # Models table will show NULLs
   models
   ```

### Error: "Recipe has wrong number of variables"

**Problem**: Recipe and data mismatch.

**Solution**: Use same data for recipe and modeling:
```r
# Correct
rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(.data = mtcars, .rec_obj = rec_obj)

# Wrong
rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(.data = iris, .rec_obj = rec_obj)  # Different data!
```

### Error: "For regularized regression, please use X"

**Problem**: glmnet or similar models need normalized data.

**Solution**: Add normalization to recipe:
```r
rec_obj <- recipe(mpg ~ ., data = mtcars) |>
  step_normalize(all_numeric_predictors())
```

### Error: "Model requires categorical predictors"

**Problem**: Model needs factors but got numeric.

**Solution**: Convert or dummy encode:
```r
rec_obj <- recipe(target ~ ., data = data) |>
  step_dummy(all_nominal_predictors())
```

### Issue: Some models return NULL

**Problem**: Individual models failed.

**Analysis**: This is expected behavior! tidyAML uses graceful failure handling.

**To investigate**:
```r
# Check which models succeeded
models |>
  filter(!is.null(fitted_wflw)) |>
  select(.model_id, .parsnip_engine)

# Check which failed
models |>
  filter(is.null(fitted_wflw)) |>
  select(.model_id, .parsnip_engine)
```

**Common causes**:
- Missing engine package
- Model-data incompatibility
- Insufficient data
- Numerical instability

## Recipe Errors

### Error: "No terms on right-hand side of formula"

**Problem**: Recipe formula is incomplete.

**Solution**: Ensure proper formula:
```r
# Correct
recipe(mpg ~ ., data = mtcars)

# Wrong
recipe(~ ., data = mtcars)  # Missing target!
```

### Error: "All predictors are of the same type"

**Problem**: Recipe step expects mixed types.

**Solution**: Check your step requirements:
```r
# If you only have numeric predictors
rec_obj <- recipe(mpg ~ ., data = mtcars) |>
  step_normalize(all_numeric_predictors())  # This works

# Don't use steps that require factors if you have none
```

### Error: "Not all variables are present in new_data"

**Problem**: Recipe expects variables not in new data.

**Solution**: Ensure consistent variables:
```r
# Training and testing must have same columns
# (except target in testing)

# Check names
names(training_data)
names(testing_data)
```

### Error: "Can't subset columns that don't exist"

**Problem**: Recipe references non-existent column.

**Solution**: Check column names:
```r
names(your_data)

# Ensure recipe columns exist
rec_obj <- recipe(target ~ existing_col1 + existing_col2, data = your_data)
```

## Prediction Issues

### Error: "No predictions found"

**Problem**: Models weren't fitted or failed.

**Solutions**:
1. Check fitted workflows:
   ```r
   models |>
     filter(!is.null(fitted_wflw))
   ```

2. Rerun with fewer models:
   ```r
   models <- fast_regression(
     .data = data,
     .rec_obj = rec_obj,
     .parsnip_eng = "lm"
   )
   ```

### Error: "Can't subset columns that don't exist: .pred"

**Problem**: Trying to extract predictions that don't exist.

**Solution**: Use tidyAML extractors:
```r
# Don't manually subset - use extractors
predictions <- extract_wflw_pred(models)
```

### Issue: Predictions are all the same

**Problem**: Model isn't learning or predicting mean/mode.

**Causes**:
1. Insufficient data
2. No informative predictors
3. Target has no variance
4. Model too simple

**Solutions**:
- Check data: `summary(your_data)`
- Try different models
- Add feature engineering to recipe
- Check for data leakage

### Issue: Predictions outside expected range

**Problem**: Predictions don't make sense.

**Investigation**:
```r
# Check prediction range
predictions |>
  filter(.data_type == "predicted") |>
  summary(.value)

# Compare to actual
predictions |>
  filter(.data_type == "actual") |>
  summary(.value)

# Check for outliers in training
boxplot(your_data$target)
```

## Performance Problems

### Issue: Training is very slow

**Solutions**:

1. **Reduce models**:
   ```r
   .parsnip_eng = c("lm", "glm")  # Not "all"
   ```

2. **Sample data initially**:
   ```r
   sample_data <- your_data[1:1000, ]
   ```

3. **Simplify recipe**:
   ```r
   # Remove expensive steps
   rec_obj <- recipe(target ~ ., data = data)
   # Instead of complex preprocessing
   ```

4. **Use faster models first**:
   ```r
   # Fast models
   .parsnip_eng = c("lm", "glm")
   
   # Slower models
   .parsnip_eng = c("ranger", "xgboost")
   ```

### Issue: Running out of memory

**Solutions**:

1. **Reduce data size**:
   ```r
   sample_data <- slice_sample(your_data, prop = 0.5)
   ```

2. **Train fewer models**:
   ```r
   .parsnip_eng = c("lm", "glm")
   ```

3. **Remove large objects**:
   ```r
   rm(large_object)
   gc()  # Garbage collection
   ```

4. **Increase system memory** or use cloud resources

### Issue: R session crashes

**Causes**:
- Out of memory
- Infinite loop in model
- System instability

**Solutions**:
1. Start fresh R session
2. Reduce data/models
3. Update all packages
4. Check system resources

## Platform-Specific Issues

### macOS: "cannot open shared object file"

**Solution**: Install Xcode Command Line Tools:
```bash
xcode-select --install
```

### Linux: "compilation failed for package"

**Solution**: Install system dependencies:
```bash
# Ubuntu/Debian
sudo apt-get install build-essential libxml2-dev libcurl4-openssl-dev

# Fedora/CentOS  
sudo yum groupinstall "Development Tools"
sudo yum install libxml2-devel curl-devel
```

### Windows: RTools not found

**Solution**: Install RTools from [CRAN](https://cran.r-project.org/bin/windows/Rtools/)

### Corporate network: Cannot download packages

**Solution**: Configure proxy:
```r
Sys.setenv(http_proxy = "http://proxy.company.com:8080")
Sys.setenv(https_proxy = "https://proxy.company.com:8080")
```

## Getting More Help

### Before Asking for Help

1. **Check the FAQ**: [FAQ](FAQ.md)
2. **Search existing issues**: [GitHub Issues](https://github.com/spsanderson/tidyAML/issues)
3. **Review documentation**: [Home](Home.md)

### When Reporting Issues

Include:

1. **Reproducible example**:
   ```r
   library(tidyAML)
   library(recipes)
   
   # Minimal code that reproduces error
   rec_obj <- recipe(mpg ~ ., data = mtcars)
   models <- fast_regression(.data = mtcars, .rec_obj = rec_obj)
   ```

2. **Session info**:
   ```r
   sessionInfo()
   ```

3. **Error message**: Complete error text

4. **What you tried**: Steps taken to resolve

### Where to Get Help

- **GitHub Issues**: [Open an issue](https://github.com/spsanderson/tidyAML/issues)
- **Stack Overflow**: Tag with `r`, `tidymodels`, and `tidyaml`
- **Documentation**: Check function help: `?fast_regression`

## Diagnostic Commands

Quick diagnostic checklist:

```r
# 1. Check R version
R.version.string

# 2. Check tidyAML version
packageVersion("tidyAML")

# 3. Check data
glimpse(your_data)
sum(is.na(your_data))

# 4. Check recipe
rec_obj

# 5. Test simple model
models <- fast_regression(
  .data = your_data[1:100, ],
  .rec_obj = recipe(target ~ ., data = your_data),
  .parsnip_eng = "lm"
)

# 6. Check results
models

# 7. Session info
sessionInfo()
```

---

[← Back to FAQ](FAQ.md) | [Home](Home.md)
