# tidyAML Wiki

Welcome to the comprehensive tidyAML wiki documentation! This wiki provides detailed guides, tutorials, and references for using tidyAML effectively.

## 📖 About This Wiki

This wiki contains extensive documentation for the tidyAML R package, covering everything from installation to advanced techniques. All content is searchable and cross-referenced for easy navigation.

## 🗂️ Wiki Structure

### Getting Started
Perfect for newcomers to tidyAML:
- **[Home](Home.md)** - Main landing page with overview and navigation
- **[Installation Guide](Installation-Guide.md)** - Complete installation instructions
- **[Quick Start](Quick-Start.md)** - Get up and running in minutes
- **[Your First Model](Your-First-Model.md)** - Step-by-step tutorial for absolute beginners

### Core Concepts
Understand tidyAML's architecture and features:
- **[Package Overview](Package-Overview.md)** - Architecture, components, and philosophy
- **[Model Specification](Function-Reference-Model-Generators.md)** - How model specs work
- **[Supported Models](Supported-Models.md)** - Complete list of available models and engines

### Tutorials
Comprehensive step-by-step guides:
- **[Regression Tutorial](Regression-Tutorial.md)** - Complete regression modeling guide
- **[Classification Tutorial](Classification-Tutorial.md)** - Complete classification guide
- **[Multi-Model Comparison](Quick-Start.md#regression-example)** - Compare multiple models

### Function Reference
Complete API documentation:
- **[Model Generators](Function-Reference-Model-Generators.md)** - `fast_regression()`, `fast_classification()`, etc.
- **[Extractors](Function-Reference-Extractors.md)** - `extract_wflw_pred()`, `extract_residuals()`, etc.
- **[Utilities](Function-Reference-Utilities.md)** - Helper functions and tools
- **[Plotting](Function-Reference-Plotting.md)** - Visualization functions

### Support & Resources
Help when you need it:
- **[FAQ](FAQ.md)** - Frequently asked questions
- **[Troubleshooting](Troubleshooting.md)** - Solutions to common problems
- **[Best Practices](Best-Practices.md)** - Recommendations and guidelines

### Contributing
Join the tidyAML community:
- **[Contributing Guide](Contributing.md)** - How to contribute to tidyAML

## 🚀 Quick Links

### For Beginners
Start here if you're new to tidyAML:
1. [Installation Guide](Installation-Guide.md)
2. [Your First Model](Your-First-Model.md)
3. [Quick Start](Quick-Start.md)

### For Practitioners
Already know the basics?
1. [Regression Tutorial](Regression-Tutorial.md)
2. [Classification Tutorial](Classification-Tutorial.md)
3. [Best Practices](Best-Practices.md)

### For Reference
Looking up specific functions?
1. [Function Reference: Model Generators](Function-Reference-Model-Generators.md)
2. [Function Reference: Extractors](Function-Reference-Extractors.md)
3. [Supported Models](Supported-Models.md)

### Need Help?
Having issues?
1. [FAQ](FAQ.md)
2. [Troubleshooting](Troubleshooting.md)
3. [GitHub Issues](https://github.com/spsanderson/tidyAML/issues)

## 📊 What is tidyAML?

tidyAML brings Automated Machine Learning (AutoML) to the tidymodels ecosystem. Key features:

- 🚀 **Fast Model Generation**: Create multiple models with one function call
- 🔄 **Batch Training**: Train dozens of models simultaneously
- 📊 **Regression & Classification**: Support for all common ML tasks
- 🛡️ **Graceful Failure**: Models fail safely without breaking workflows
- 🎯 **tidymodels Native**: Built on the robust tidymodels framework
- ⚡ **No Java**: Unlike h2o, runs purely in R
- 🔌 **Extensible**: Works with 30+ parsnip engines

## 💻 Quick Example

```r
library(tidyAML)
library(recipes)

# Create recipe
rec_obj <- recipe(mpg ~ ., data = mtcars)

# Train multiple models
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm", "glmnet")
)

# Extract predictions
predictions <- extract_wflw_pred(models)

# Visualize
plot_regression_predictions(models)
```

## 📦 Installation

```r
# From CRAN (stable)
install.packages("tidyAML")

# From GitHub (development)
devtools::install_github("spsanderson/tidyAML")
```

## 🎯 Learning Paths

### Path 1: Quick Start (30 minutes)
For those who want to dive in quickly:
1. [Installation](Installation-Guide.md) (5 min)
2. [Quick Start](Quick-Start.md) (15 min)
3. [Your First Model](Your-First-Model.md) (10 min)

### Path 2: Comprehensive Learning (2-3 hours)
For thorough understanding:
1. [Installation](Installation-Guide.md)
2. [Package Overview](Package-Overview.md)
3. [Regression Tutorial](Regression-Tutorial.md) OR [Classification Tutorial](Classification-Tutorial.md)
4. [Best Practices](Best-Practices.md)
5. [Function Reference](Function-Reference-Model-Generators.md)

### Path 3: Problem-Solving (As needed)
When you encounter issues:
1. [FAQ](FAQ.md) - Check common questions
2. [Troubleshooting](Troubleshooting.md) - Solve specific problems
3. [GitHub Issues](https://github.com/spsanderson/tidyAML/issues) - Report bugs

## 📚 Additional Resources

### Official Documentation
- **Website**: https://www.spsanderson.com/tidyAML/
- **CRAN**: https://cran.r-project.org/package=tidyAML
- **GitHub**: https://github.com/spsanderson/tidyAML

### Package Vignettes
```r
# View available vignettes
vignette(package = "tidyAML")

# Getting started vignette
vignette("getting-started", package = "tidyAML")
```

### Community
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions and community interaction

## 🔍 Search Tips

When searching this wiki:
- Use specific function names: `fast_regression`, `extract_wflw_pred`
- Search by task: "regression", "classification", "predictions"
- Search by problem: "error", "missing package", "slow"
- Search by topic: "recipe", "preprocessing", "visualization"

## 📝 Wiki Pages Index

### Getting Started (4 pages)
- [Home](Home.md) - Main landing page
- [Installation Guide](Installation-Guide.md) - Installation instructions
- [Quick Start](Quick-Start.md) - Quick start tutorial
- [Your First Model](Your-First-Model.md) - Beginner tutorial

### Core Documentation (3 pages)
- [Package Overview](Package-Overview.md) - Architecture and design
- [Supported Models](Supported-Models.md) - Available models and engines
- [Best Practices](Best-Practices.md) - Guidelines and recommendations

### Tutorials (2 pages)
- [Regression Tutorial](Regression-Tutorial.md) - Regression workflows
- [Classification Tutorial](Classification-Tutorial.md) - Classification workflows

### Function Reference (4 pages)
- [Model Generators](Function-Reference-Model-Generators.md) - Core functions
- [Extractors](Function-Reference-Extractors.md) - Data extraction functions
- [Utilities](Function-Reference-Utilities.md) - Helper functions
- [Plotting](Function-Reference-Plotting.md) - Visualization functions

### Support (2 pages)
- [FAQ](FAQ.md) - Frequently asked questions
- [Troubleshooting](Troubleshooting.md) - Problem solutions

### Contributing (1 page)
- [Contributing](Contributing.md) - Contribution guidelines

**Total: 16 comprehensive wiki pages**

## 🤝 Contributing to the Wiki

Found an error? Have a suggestion? See the [Contributing Guide](Contributing.md) for how to help improve this wiki.

Quick ways to contribute:
- Report typos or unclear explanations
- Suggest additional examples
- Share your use cases
- Improve existing content

## 📄 License

This wiki is part of the tidyAML package, licensed under the MIT License.

## ⭐ Support tidyAML

If you find tidyAML useful:
- ⭐ [Star the repository](https://github.com/spsanderson/tidyAML)
- 📢 Share with colleagues
- 🐛 Report bugs
- 💡 Suggest improvements
- 👥 Contribute code or documentation

## 🙏 Acknowledgments

- Built on the excellent [tidymodels](https://www.tidymodels.org/) framework
- Inspired by [h2o](https://h2o.ai/) AutoML
- Package name suggested by [Garrick Aden-Buie](https://fosstodon.org/@grrrck/109479826278916014)
- Maintained by Steven P. Sanderson II, MPH

---

**Last Updated**: 2024
**Wiki Version**: 1.0
**Package Version**: 0.0.6.9000

For the latest updates, visit the [GitHub repository](https://github.com/spsanderson/tidyAML).
