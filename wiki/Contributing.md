# Contributing to tidyAML

Thank you for your interest in contributing to tidyAML! This guide will help you get started.

## Table of Contents

- [Ways to Contribute](#ways-to-contribute)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Code Contribution Guidelines](#code-contribution-guidelines)
- [Documentation Contributions](#documentation-contributions)
- [Reporting Issues](#reporting-issues)
- [Community Guidelines](#community-guidelines)

## Ways to Contribute

You can contribute to tidyAML in many ways:

### 1. **Report Bugs** 🐛
Found a bug? Let us know! See [Reporting Issues](#reporting-issues).

### 2. **Suggest Features** 💡
Have an idea for improvement? Open a feature request!

### 3. **Improve Documentation** 📚
Help make the documentation clearer and more comprehensive.

### 4. **Write Code** 👨‍💻
Fix bugs, add features, or optimize performance.

### 5. **Share Examples** 📊
Create tutorials, blog posts, or example workflows.

### 6. **Help Others** 🤝
Answer questions in GitHub Issues or discussions.

## Getting Started

### Prerequisites

- R >= 4.1.0
- RStudio (recommended)
- Git for version control
- GitHub account

### Fork and Clone

1. **Fork the repository** on GitHub
2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/tidyAML.git
   cd tidyAML
   ```
3. **Set up remotes**:
   ```bash
   git remote add upstream https://github.com/spsanderson/tidyAML.git
   ```

## Development Setup

### Install Development Dependencies

```r
# Install devtools
install.packages("devtools")

# Install package in development mode
devtools::load_all()

# Install dependencies
devtools::install_deps(dependencies = TRUE)

# Install suggested packages for testing
install.packages(c(
  "testthat",
  "roxygen2",
  "pkgdown",
  "lintr",
  "styler"
))
```

### Build and Check

```r
# Load package for development
devtools::load_all()

# Run tests
devtools::test()

# Check package
devtools::check()

# Build documentation
devtools::document()

# Build website
pkgdown::build_site()
```

## Code Contribution Guidelines

### Workflow

1. **Create a branch** for your feature:
   ```bash
   git checkout -b feature/my-new-feature
   ```

2. **Make your changes**

3. **Test your changes**:
   ```r
   devtools::test()
   devtools::check()
   ```

4. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Add feature: description"
   ```

5. **Push to your fork**:
   ```bash
   git push origin feature/my-new-feature
   ```

6. **Create a Pull Request** on GitHub

### Code Style

tidyAML follows the tidyverse style guide:

```r
# Use styler to format code
styler::style_pkg()

# Check with lintr
lintr::lint_package()
```

**Key principles**:
- Use `snake_case` for function names
- Use `_` prefix for internal functions
- Maximum line length: ~80 characters
- Use meaningful variable names
- Comment complex logic

**Example**:
```r
# Good
calculate_model_metrics <- function(.data, .metric_set) {
  .data |>
    group_by(.model_type) |>
    summarize(across(all_of(.metric_set), mean))
}

# Avoid
calc_mod_met <- function(d, m) {
  d |> group_by(.model_type) |> summarize(across(all_of(m), mean))
}
```

### Function Documentation

Use roxygen2 for documentation:

```r
#' Calculate Model Metrics
#'
#' @description
#' Calculates performance metrics for trained models.
#'
#' @param .data A tidyAML model table
#' @param .metric_set Character vector of metrics to calculate
#'
#' @return A tibble with metrics by model
#'
#' @examples
#' \dontrun{
#' metrics <- calculate_model_metrics(models, c("rmse", "rsq"))
#' }
#'
#' @export
calculate_model_metrics <- function(.data, .metric_set) {
  # Function implementation
}
```

### Testing

Write tests for new features:

```r
# tests/testthat/test-my-feature.R
test_that("my_function works correctly", {
  # Setup
  data <- mtcars
  rec_obj <- recipe(mpg ~ ., data = data)
  
  # Test
  result <- my_function(data, rec_obj)
  
  # Assertions
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 0)
  expect_named(result, c("expected", "columns"))
})

test_that("my_function handles errors", {
  expect_error(my_function(NULL), "must provide data")
  expect_error(my_function(iris, NULL), "must provide recipe")
})
```

### Pull Request Process

1. **Update documentation** if needed
2. **Add tests** for new features
3. **Update NEWS.md** with your changes
4. **Ensure all checks pass**:
   - R CMD check passes
   - All tests pass
   - Code coverage maintained
5. **Request review** from maintainers

**PR Title Format**:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation
- `test:` for tests
- `refactor:` for code improvements

**Example**: `feat: add support for xgboost hyperparameter tuning`

## Documentation Contributions

### Package Documentation

- Function documentation: Use roxygen2
- Vignettes: Add `.Rmd` files in `vignettes/`
- README: Update `README.Rmd` (not `README.md`)
- Website: Modify `_pkgdown.yml` for structure

### This Wiki

To contribute to the wiki:

1. **Wiki files** are in the `wiki/` directory
2. **Format**: Markdown (`.md`)
3. **Follow existing structure**
4. **Add internal links** to related pages
5. **Include examples** with code
6. **Test code examples** before submitting

**Wiki page template**:
```markdown
# Page Title

Brief introduction.

## Table of Contents

- [Section 1](#section-1)
- [Section 2](#section-2)

## Section 1

Content here.

### Subsection

More content.

## Examples

```r
# Working example
library(tidyAML)
# ...
```

## See Also

- [Related Page](Related-Page.md)

---

[← Back to Home](Home.md)
```

### Writing Good Documentation

**DO**:
- ✅ Use clear, simple language
- ✅ Include working examples
- ✅ Explain why, not just what
- ✅ Add screenshots for UI changes
- ✅ Link to related pages
- ✅ Keep examples simple and focused

**DON'T**:
- ❌ Assume knowledge
- ❌ Use jargon without explanation
- ❌ Write long paragraphs (break them up!)
- ❌ Skip testing examples
- ❌ Leave broken links

## Reporting Issues

### Before Reporting

1. **Search existing issues** to avoid duplicates
2. **Check FAQ** and troubleshooting guide
3. **Try latest version**: `devtools::install_github("spsanderson/tidyAML")`
4. **Create minimal reproducible example**

### Bug Report Template

```markdown
## Description
Brief description of the bug.

## Reproducible Example
```r
library(tidyAML)
library(recipes)

# Minimal code to reproduce
rec_obj <- recipe(mpg ~ ., data = mtcars)
models <- fast_regression(.data = mtcars, .rec_obj = rec_obj)
# Error occurs here
```

## Expected Behavior
What you expected to happen.

## Actual Behavior
What actually happened (include error message).

## System Information
- tidyAML version: `packageVersion("tidyAML")`
- R version: `R.version.string`
- OS: Windows/Mac/Linux

## Additional Context
Any other relevant information.
```

### Feature Request Template

```markdown
## Feature Description
Clear description of the proposed feature.

## Use Case
Why is this feature needed? What problem does it solve?

## Proposed Solution
How you envision it working (code examples welcome).

## Alternatives Considered
Other approaches you've thought about.

## Additional Context
Related features, external resources, etc.
```

## Community Guidelines

### Code of Conduct

We follow the [Contributor Covenant Code of Conduct](../CODE_OF_CONDUCT.md).

**In summary**:
- Be respectful and inclusive
- Welcome newcomers
- Accept constructive criticism
- Focus on what's best for the community
- Show empathy

### Communication Channels

- **GitHub Issues**: Bug reports, feature requests
- **GitHub Discussions**: Questions, ideas, show-and-tell
- **Pull Requests**: Code contributions
- **Email**: Security issues only

### Getting Help

**If you're stuck**:
1. Check the [FAQ](FAQ.md)
2. Read [Troubleshooting](Troubleshooting.md)
3. Search [GitHub Issues](https://github.com/spsanderson/tidyAML/issues)
4. Ask in GitHub Discussions
5. Be patient - maintainers are volunteers!

## Review Process

### What to Expect

1. **Acknowledgment** within a few days
2. **Review** by maintainers (may take longer)
3. **Feedback** and requested changes
4. **Iteration** based on review
5. **Merge** when approved

### Review Criteria

Contributions are evaluated on:
- **Correctness**: Does it work?
- **Tests**: Are there tests?
- **Documentation**: Is it documented?
- **Style**: Does it follow conventions?
- **Scope**: Is it focused?
- **Maintainability**: Can we support it long-term?

## Development Tips

### Testing Locally

```r
# Run all tests
devtools::test()

# Run specific test file
devtools::test_active_file("tests/testthat/test-my-feature.R")

# Test coverage
covr::package_coverage()
```

### Debugging

```r
# Use browser() to debug
my_function <- function(x) {
  browser()  # Execution will pause here
  x + 1
}

# Or use debug()
debug(my_function)
my_function(5)
undebug(my_function)
```

### Performance Profiling

```r
# Profile your code
profvis::profvis({
  # Code to profile
  models <- fast_regression(.data = large_data, .rec_obj = rec_obj)
})
```

### Building Documentation

```r
# Update function documentation
devtools::document()

# Build vignettes
devtools::build_vignettes()

# Build pkgdown site
pkgdown::build_site()
```

## Recognition

Contributors are recognized in:
- GitHub contributors list
- Package `DESCRIPTION` file (for significant contributions)
- Release notes
- Website acknowledgments

## Questions?

Still have questions about contributing?

- Open a [GitHub Discussion](https://github.com/spsanderson/tidyAML/discussions)
- Check the [FAQ](FAQ.md)
- Email the maintainer (for security issues only)

## Thank You! 🙏

Every contribution, no matter how small, makes tidyAML better. We appreciate your time and effort!

---

[← Back to Home](Home.md) | [Code of Conduct →](../CODE_OF_CONDUCT.md)
