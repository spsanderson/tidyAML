# tidyAML - Automatic Machine Learning with tidymodels

tidyAML is an R package that provides a simple interface for automatic machine learning that fits the tidymodels framework. The package works for regression and classification problems with a simple verb framework.

**ALWAYS follow these instructions completely. Only search for additional information or run other bash commands if the specific information you need is not covered in these instructions or if you find errors in the documented commands.**

## Working Effectively

### System Requirements and Setup
- Install R and R development tools:
  - `sudo apt update && sudo apt install -y r-base r-base-dev`
- R version 4.3.3+ is installed and working
- Standard R package development uses `R CMD` commands

### Dependencies and Package Management
- **CRITICAL**: This package requires the entire tidymodels ecosystem
- **Network Limitation**: CRAN access may be blocked in some environments
- Core dependencies (Imports): parsnip, rlang, purrr, dplyr, rsample, workflows, forcats, workflowsets, tidyr, broom, ggplot2, magrittr, tune
- Many suggested packages for ML engines: multilevelmod, rules, poissonreg, censored, baguette, bonsai, brulee, rstanarm, dbarts, kknn, ranger, randomForest, LiblineaR, flexsurv, gee, glmnet, discrim, kernlab, klaR, mda, sda, sparsediscrim
- VignetteBuilder: knitr

### Building the Package
- **Basic build** (without dependencies): `cd /home/runner/work/tidyAML && R CMD build --no-build-vignettes tidyAML`
- **Build time**: < 1 second. NEVER CANCEL - builds are extremely fast for this R package.
- **With vignettes** (requires knitr): `R CMD build tidyAML` - **FAILS** with "vignette builder 'knitr' not found" if knitr not installed
- **Output**: Creates `tidyAML_VERSION.tar.gz` in parent directory

### Package Checking and Validation
- **Without dependencies**: `R CMD check --no-vignettes --no-manual tidyAML_VERSION.tar.gz` - **FAILS** due to missing required packages
- **Expected check time**: 5-10 minutes with dependencies. NEVER CANCEL - Set timeout to 15+ minutes.
- **With dependencies**: `R CMD check tidyAML_VERSION.tar.gz` (requires all dependencies installed)
- **Structure check only**: `_R_CHECK_FORCE_SUGGESTS_=false R CMD check --no-examples --no-tests --no-vignettes --no-manual tidyAML_VERSION.tar.gz` - **STILL FAILS** due to required imports

### Installing Dependencies (if CRAN access available)
- Install core tidymodels: `R -e "install.packages(c('tidymodels', 'devtools'), repos='https://cran.r-project.org/')"`
- Install all suggested packages: Use the package's `install_deps()` function after loading
- **Installation time**: 15-30 minutes for full ecosystem. NEVER CANCEL - Set timeout to 45+ minutes.

### Package Installation and Loading
- **Install from source**: `R CMD INSTALL tidyAML_VERSION.tar.gz`
- **Load in development**: `R -e "devtools::load_all('tidyAML')"` (requires devtools)
- **Install package dependencies**: `R -e "tidyAML::install_deps()"` (interactive, requires user input)

## Validation Scenarios

### Testing Package Functionality
**ALWAYS run these validation steps after making changes:**

1. **Build validation** (ALWAYS WORKS):
   ```bash
   cd /home/runner/work/tidyAML
   R CMD build --no-build-vignettes tidyAML
   ```

2. **Syntax validation** (WORKS without dependencies):
   ```bash
   # Check syntax of specific R files
   R -e "parse('tidyAML/R/make-regression-fast.R')"
   R -e "parse('tidyAML/R/make-classification-fast.R')"
   
   # Check syntax of ALL R files
   R -e "invisible(sapply(list.files('tidyAML/R', full.names=TRUE), function(f) tryCatch(parse(f), error=function(e) cat('ERROR in', f, ':', e\$message, '\n'))))"
   ```

3. **Package structure validation** (via successful build):
   - DESCRIPTION file format
   - NAMESPACE consistency
   - R file syntax
   - Documentation structure

4. **Full functionality test** (requires all dependencies - NETWORK DEPENDENT):
   ```r
   library(tidyAML)
   library(recipes)
   
   # Test regression workflow
   rec_obj <- recipe(mpg ~ ., data = mtcars)
   frt_tbl <- fast_regression(
     .data = mtcars,
     .rec_obj = rec_obj,
     .parsnip_eng = c("lm", "glm"),
     .parsnip_fns = "linear_reg"
   )
   print(frt_tbl)
   ```

5. **Classification workflow test** (requires dependencies - NETWORK DEPENDENT):
   ```r
   # Test classification workflow
   df <- Titanic |>
     as_tibble() |>
     uncount(n) |>
     mutate(across(everything(), as.factor))
   
   rec_obj <- recipe(Survived ~ ., data = df)
   fct_tbl <- fast_classification(
     .data = df,
     .rec_obj = rec_obj,
     .parsnip_eng = c("glm")
   )
   print(fct_tbl)
   ```

**NOTE**: Tests 4 and 5 require CRAN access to install dependencies. In environments without CRAN access, focus on tests 1-3.

### Documentation and Website
- **Generate documentation**: Uses roxygen2 - documentation is auto-generated during build
- **Build website**: `R -e "pkgdown::build_site()"` (requires pkgdown and dependencies)
- **Website time**: 5-10 minutes. NEVER CANCEL - Set timeout to 15+ minutes.

## Common Tasks and Troubleshooting

### Working Without CRAN Access
- **Build always works**: `R CMD build --no-build-vignettes tidyAML` (< 1 second)
- **Check FAILS without dependencies**: All R CMD check variants fail due to required imports
- **Syntax validation WORKS**: `R -e "parse('R/filename.R')"` for individual R files
- **Package structure validation**: Build process validates basic package structure

### Key Package Functions
- `fast_regression()`: Main function for regression problems
- `fast_classification()`: Main function for classification problems  
- `create_model_spec()`: Create parsnip model specifications
- `extract_wflw_pred()`: Extract workflow predictions
- `plot_regression_predictions()`: Plot regression predictions
- `install_deps()`: Install all package dependencies (interactive)
- `load_deps()`: Load all package dependencies

### Development Workflows
- **Add new functions**: Place in `R/` directory with roxygen2 documentation
- **Update documentation**: Rebuild package, documentation auto-generated
- **Test changes**: Run build and basic check commands above
- **Update dependencies**: Modify DESCRIPTION file Imports/Suggests sections

### File Structure Reference
```
tidyAML/
├── DESCRIPTION          # Package metadata and dependencies
├── NAMESPACE           # Auto-generated from roxygen2
├── R/                  # All R source code
├── man/               # Auto-generated documentation  
├── vignettes/         # Package vignettes (requires knitr)
├── docs/              # pkgdown website files
├── README.Rmd         # Source for README
├── README.md          # Generated from README.Rmd
└── _pkgdown.yml       # Website configuration
```

### Expected Timings
- **Package build**: < 1 second (extremely fast)
- **Package check** (no deps): FAILS - requires dependencies
- **Package check** (with deps): 5-10 minutes
- **Dependency installation**: 15-30 minutes
- **Website build**: 5-10 minutes

### Important Notes
- **NO formal test suite**: Package relies on examples in documentation for testing
- **Dependencies are extensive**: Requires most of tidymodels ecosystem to function
- **Examples in documentation**: All functions have working examples that serve as tests
- **Network-dependent**: Full functionality requires CRAN package installation
- **RStudio project**: Configured as R package with devtools integration
- **CRITICAL LIMITATION**: In environments without CRAN access, only build and syntax validation work
- **Package check ALWAYS FAILS**: Without dependencies - this is expected behavior

### When CRAN Access is NOT Available
**This is the typical scenario in many development environments.**

What WORKS:
- ✅ Package building (`R CMD build --no-build-vignettes`)
- ✅ Syntax validation of R files
- ✅ Package structure validation
- ✅ Documentation structure verification (via build)

What FAILS (expected):
- ❌ `R CMD check` (any variant) - requires dependencies
- ❌ Installing packages from CRAN
- ❌ Running functional examples
- ❌ Full package testing

**Development Workflow Without Dependencies:**
1. Make code changes
2. Run syntax validation: `R -e "invisible(sapply(list.files('tidyAML/R', full.names=TRUE), function(f) tryCatch(parse(f), error=function(e) cat('ERROR in', f, ':', e\$message, '\n'))))"`
3. Build package: `R CMD build --no-build-vignettes tidyAML`
4. Verify successful build (no errors)
5. Commit changes