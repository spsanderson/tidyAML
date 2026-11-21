# tidyAML R Package Development Instructions

tidyAML is an R package for automated machine learning that provides a simple interface for the tidymodels framework. It supports regression and classification problems with a streamlined verb-based API.

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## System Environment

### R Environment Details
- **R Version**: 4.3.3 (2024-02-29) "Angel Food Cake"
- **Platform**: x86_64-pc-linux-gnu (64-bit)  
- **OS**: Ubuntu 24.04.2 LTS
- **Library Paths**: `/usr/local/lib/R/site-library`, `/usr/lib/R/site-library`, `/usr/lib/R/library`

### Installed Development Tools
- r-base, r-base-dev (system packages)
- r-cran-devtools, r-cran-roxygen2, r-cran-remotes
- r-cran-testthat, r-cran-pkgload, r-cran-pkgbuild

## Working Effectively

### Bootstrap and Environment Setup
- Install R and development tools:
  ```bash
  sudo apt update && sudo apt install -y r-base r-base-dev  # takes 76 seconds. NEVER CANCEL. Set timeout to 300+ seconds.
  sudo apt install -y r-cran-devtools r-cran-roxygen2 r-cran-remotes r-cran-testthat r-cran-pkgload r-cran-pkgbuild  # takes 116 seconds. NEVER CANCEL. Set timeout to 300+ seconds.
  ```

### Basic Package Operations (Work Offline)
- Build the package:
  ```bash
  cd /path/to/tidyAML
  R CMD build --no-build-vignettes --no-manual .  # takes 0 seconds
  ```
- Generate documentation (requires dependencies):
  ```bash
  R -e "devtools::document()"  # FAILS without tidymodels dependencies
  ```

### Full Development Workflow (Requires Internet Access)
**CRITICAL LIMITATION**: The following commands require tidymodels dependencies (parsnip, workflows, workflowsets, tune) which need internet access to CRAN:

- Install package dependencies:
  ```bash
  R -e "install.packages(c('parsnip', 'workflows', 'workflowsets', 'tune'), repos='https://cloud.r-project.org')"  # REQUIRES internet access to CRAN
  ```
- Run package checks:
  ```bash
  R -e "devtools::check()"  # takes 300+ seconds when dependencies available. NEVER CANCEL. Set timeout to 1800+ seconds.
  ```
- Install the package:
  ```bash
  sudo R CMD INSTALL tidyAML_*.tar.gz  # takes 30 seconds when dependencies available
  ```

## Validation

### What Can Be Validated Offline
- Repository structure exploration
- Basic R functionality
- Package building (creates .tar.gz file)
- Documentation file viewing

### What Requires Dependencies (Internet Access)
- Full package installation and loading
- Running examples from README.md
- Testing tidyAML functions like `fast_regression()` and `fast_classification()`
- Vignette building
- Complete package checks

### Manual Testing Scenarios (When Dependencies Available)
Always test these scenarios after making changes:
1. **Basic regression workflow**:
   ```r
   library(tidyAML)
   library(recipes)
   rec_obj <- recipe(mpg ~ ., data = mtcars)
   frt_tbl <- fast_regression(mtcars, rec_obj, .parsnip_eng = c("lm","glm"), .parsnip_fns = "linear_reg")
   ```
2. **Model specification creation**:
   ```r
   create_model_spec(.parsnip_eng = list("lm","glm"), .parsnip_fns = list("linear_reg","linear_reg"))
   ```
3. **Extract predictions and residuals**:
   ```r
   extract_wflw_pred(frt_tbl, 1:2)
   extract_regression_residuals(frt_tbl)
   ```

### Package Loading (When Dependencies Available)
When tidymodels dependencies are installed, loading the package shows:
```r
library(tidyAML)
# Shows welcome message:
# == Welcome to tidyAML ===========================================================================
# If you find this package useful, please leave a star: 
#    https://github.com/spsanderson/tidyAML'
# 
# If you encounter a bug or want to request an enhancement please file an issue at:
#    https://github.com/spsanderson/tidyAML/issues
# 
# It is suggested that you run tidymodels::tidymodel_prefer() to set the defaults for your session.
# 
# Thank you for using tidyAML!
# 
# You should run the following commands after loading tidyAML:
# 
# library(tidymodels)
# tidymodels::tidymodels_prefer()

library(tidymodels)
tidymodels::tidymodels_prefer()  # Recommended after loading tidyAML
```

## Dependency Management

### Pre-installed System Packages (Available via apt)
The following tidyverse packages are already available in Ubuntu repositories:
- `r-cran-dplyr`, `r-cran-purrr`, `r-cran-ggplot2`, `r-cran-tidyr`
- `r-cran-broom`, `r-cran-rlang`, `r-cran-forcats`, `r-cran-magrittr`
- `r-cran-rsample`, `r-cran-recipes`, `r-cran-tibble`, `r-cran-stringr`
- `r-cran-knitr`, `r-cran-rmarkdown`

### Missing Critical Dependencies (Require CRAN)
These packages are NOT available in system repositories and need internet access:
- `parsnip` (core dependency)
- `workflows` (core dependency) 
- `workflowsets` (core dependency)
- `tune` (core dependency)

### Dependency Installation Command
When internet access is available:
```bash
R -e "install.packages(c('parsnip', 'workflows', 'workflowsets', 'tune'), dependencies=TRUE, repos='https://cloud.r-project.org')"  # takes 300-600 seconds. NEVER CANCEL. Set timeout to 1800+ seconds.
```

## Common Tasks

### Repository Navigation
```bash
# Key directories:
ls -la /path/to/tidyAML/R          # Source code (32 R files)
ls -la /path/to/tidyAML/man        # Documentation files
ls -la /path/to/tidyAML/vignettes  # Package vignettes
ls -la /path/to/tidyAML/docs       # Generated documentation site
```

### Package Information
- **Package Name**: tidyAML
- **Version**: 0.0.6.9000 (development)
- **Purpose**: Automated machine learning with tidymodels
- **Key Functions**: `fast_regression()`, `fast_classification()`, `create_model_spec()`
- **Core Dependencies**: tidymodels ecosystem (parsnip, workflows, workflowsets, tune)

### Build and Check Commands
```bash
# Quick build (always works):
R CMD build --no-build-vignettes --no-manual .  # 0 seconds

# Full check (requires dependencies):
R -e "devtools::check()"  # 300+ seconds. NEVER CANCEL.

# Documentation generation (requires dependencies):
R -e "devtools::document()"

# Basic syntax validation (works offline):
R --slave -e "parse('R/utils-lib-loads.R')"  # validate individual R files
```

### When Dependencies Are Missing
If you encounter errors about missing packages:
1. **Do not try to build vignettes or run examples**
2. **Do not run devtools::check() or devtools::test()**
3. **Focus on code structure analysis and basic validation**
4. **Document that full testing requires internet access to CRAN**

### Expected Timing
- R installation: 76 seconds
- Development tools installation: 116 seconds  
- Package build: 0 seconds
- Dependency installation (when available): 300-600 seconds
- Full package check (when dependencies available): 300+ seconds
- **NEVER CANCEL any build or installation process**

### Limitations in This Environment
- **No internet access to CRAN** - core tidymodels packages cannot be installed
- **Cannot run full examples** - tidyAML functions require parsnip/workflows
- **Cannot build vignettes** - they contain executable code requiring dependencies
- **Cannot run automated tests** - test suite requires package dependencies

### Alternative Validation Approaches
When full dependencies are not available:
1. **Static code analysis** - review R source files in `/R` directory (32 R files)
2. **Documentation review** - check function documentation in `/man` directory
3. **Structure validation** - ensure DESCRIPTION, NAMESPACE files are correct
4. **Basic R syntax validation**:
   ```bash
   cd /path/to/tidyAML
   R --slave -e "parse('R/filename.R')"  # validates R syntax without loading packages
   ```
5. **R session info check**:
   ```bash
   R -e "sessionInfo(); .libPaths()"  # shows R 4.3.3, Ubuntu 24.04.2 LTS
   ```

### Clean Up Commands
```bash
# Remove build artifacts (run after building):
rm -f *.tar.gz               # Remove package archives
rm -rf ..Rcheck             # Remove R CMD check output directory
rm -rf .Rd2pdf*             # Remove PDF generation temp files
```

## Success Criteria
✅ **Can always do**: Repository exploration, package building, static analysis
⚠️ **Requires dependencies**: Full functionality testing, installation, check commands
❌ **Cannot do without internet**: Install core tidymodels dependencies from CRAN