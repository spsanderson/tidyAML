# Installation Guide

This guide covers everything you need to install and set up tidyAML on your system.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installing from CRAN](#installing-from-cran)
- [Installing from GitHub](#installing-from-github)
- [Installing Dependencies](#installing-dependencies)
- [Verifying Installation](#verifying-installation)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)

## Prerequisites

Before installing tidyAML, ensure you have:

- **R version 4.1.0 or higher**: tidyAML requires R >= 4.1.0 to use the native pipe operator (`|>`)
- **RStudio** (optional but recommended): For the best development experience

Check your R version:
```r
R.version.string
```

If you need to update R, visit [CRAN](https://cran.r-project.org/) and download the latest version for your operating system.

## Installing from CRAN

The easiest way to install tidyAML is from CRAN (stable release):

```r
install.packages("tidyAML")
```

This will automatically install all required dependencies.

## Installing from GitHub

To get the latest development version with newest features:

```r
# Install devtools if you don't have it
install.packages("devtools")

# Install tidyAML from GitHub
devtools::install_github("spsanderson/tidyAML")
```

## Installing Dependencies

tidyAML depends on the tidymodels ecosystem. The core dependencies are installed automatically, but some model engines require additional packages.

### Core Dependencies

These are installed automatically:
- `parsnip` - Model specification
- `workflows` - Workflow management
- `workflowsets` - Multiple workflows
- `tune` - Hyperparameter tuning
- `rsample` - Data splitting
- `recipes` - Data preprocessing
- `dplyr`, `purrr`, `tidyr` - Data manipulation
- `ggplot2` - Visualization
- `broom` - Model tidying

### Optional Model Engine Packages

To use specific model engines, you may need to install additional packages:

```r
# Install all suggested packages
install.packages(c(
  "glmnet",      # Elastic net models
  "ranger",      # Random forests
  "xgboost",     # Gradient boosting
  "kknn",        # K-nearest neighbors
  "kernlab",     # Support vector machines
  "earth",       # Multivariate adaptive regression splines
  "randomForest", # Random forests
  "LiblineaR",   # Linear classification
  "dbarts",      # Bayesian additive regression trees
  "rstanarm",    # Bayesian models
  "baguette",    # Bagging
  "bonsai",      # Tree-based models
  "brulee",      # Neural networks
  "censored",    # Survival analysis
  "multilevelmod", # Multilevel models
  "rules",       # Rule-based models
  "poissonreg",  # Poisson regression
  "discrim",     # Discriminant analysis
  "klaR",        # Classification
  "mda",         # Mixture discriminant analysis
  "sda",         # Shrinkage discriminant analysis
  "sparsediscrim" # Sparse discriminant analysis
))
```

### Using tidyAML Helper Functions

tidyAML provides utility functions to manage dependencies:

#### List Core Packages
```r
library(tidyAML)
core_packages()
```

#### Load Core Dependencies
```r
load_deps()
```

#### Install Missing Dependencies
```r
install_deps()
```

Note: These functions will safely handle missing packages and provide informative messages.

## Verifying Installation

After installation, verify everything works:

```r
# Load the library
library(tidyAML)

# Check if it loads without errors
# You should see a welcome message

# Test basic functionality
library(recipes)
rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = "lm"
)

# If this runs without errors, you're good to go!
print(models)
```

Expected output:
```
== Welcome to tidyAML ===========================================================================
If you find this package useful, please leave a star: 
   https://github.com/spsanderson/tidyAML'

If you encounter a bug or want to request an enhancement please file an issue at:
   https://github.com/spsanderson/tidyAML/issues

It is suggested that you run tidymodels::tidymodel_prefer() to set the defaults for your session.

Thank you for using tidyAML!
```

## Post-Installation Setup

### Set tidymodels Preferences

It's recommended to set tidymodels preferences after loading tidyAML:

```r
library(tidyAML)
library(tidymodels)
tidymodels::tidymodels_prefer()
```

This ensures that tidymodels functions take precedence over similarly named functions from other packages.

### Add to .Rprofile (Optional)

To automatically load tidyAML and set preferences in every session, add this to your `.Rprofile`:

```r
# Edit your .Rprofile
usethis::edit_r_profile()

# Add these lines:
if (interactive()) {
  suppressMessages(library(tidyAML))
  suppressMessages(library(tidymodels))
  suppressMessages(tidymodels::tidymodels_prefer())
}
```

## Troubleshooting

### Issue: "there is no package called 'parsnip'"

**Solution**: Install the missing core dependency:
```r
install.packages("parsnip")
```

### Issue: "R version >= 4.1.0 required"

**Solution**: Update your R installation from [CRAN](https://cran.r-project.org/).

### Issue: Model engine not available

**Solution**: Install the specific engine package. For example:
```r
# For glmnet
install.packages("glmnet")

# For ranger
install.packages("ranger")
```

### Issue: Package installation fails on Linux

**Solution**: You may need to install system dependencies first:

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install libxml2-dev libcurl4-openssl-dev libssl-dev
```

**Fedora/CentOS:**
```bash
sudo yum install libxml2-devel curl-devel openssl-devel
```

### Issue: GitHub installation fails

**Solution**: Try with specific version or check internet connection:
```r
# Try with a specific release
devtools::install_github("spsanderson/tidyAML@v0.0.6")

# Or update devtools
install.packages("devtools")
```

### Issue: Cannot install on corporate network

**Solution**: Configure proxy settings:
```r
# Set proxy
Sys.setenv(http_proxy = "http://proxy.example.com:8080")
Sys.setenv(https_proxy = "https://proxy.example.com:8080")
```

## System Requirements

### Minimum System Requirements
- **RAM**: 4 GB (8 GB recommended)
- **Disk Space**: 500 MB for package and dependencies
- **R Version**: 4.1.0 or higher

### Recommended System Configuration
- **RAM**: 16 GB or more for large datasets
- **Processor**: Multi-core for parallel processing
- **R Version**: Latest stable release

## Platform-Specific Notes

### Windows
- No special requirements
- RTools may be needed for package development

### macOS
- Xcode Command Line Tools may be required:
  ```bash
  xcode-select --install
  ```

### Linux
- System libraries may be needed (see troubleshooting above)
- Most distributions work out of the box

## Updating tidyAML

To update to the latest version:

```r
# Update from CRAN
update.packages("tidyAML")

# Or update from GitHub
devtools::install_github("spsanderson/tidyAML")
```

Check your current version:
```r
packageVersion("tidyAML")
```

## Uninstalling

If you need to uninstall tidyAML:

```r
remove.packages("tidyAML")
```

## Getting Help

If you encounter issues during installation:

1. Check the [Troubleshooting](Troubleshooting.md) page
2. Search [GitHub Issues](https://github.com/spsanderson/tidyAML/issues)
3. Open a new issue with:
   - Your R version: `R.version.string`
   - Your OS: `Sys.info()[c("sysname", "release", "version")]`
   - Error message and steps to reproduce

## Next Steps

Now that tidyAML is installed:

1. **Learn the Basics**: [Quick Start Tutorial](Quick-Start.md)
2. **Understand the Package**: [Package Overview](Package-Overview.md)
3. **Build Your First Model**: [Your First Model](Your-First-Model.md)
4. **Explore Examples**: [Regression Tutorial](Regression-Tutorial.md) or [Classification Tutorial](Classification-Tutorial.md)

---

[← Back to Home](Home.md) | [Next: Quick Start →](Quick-Start.md)
