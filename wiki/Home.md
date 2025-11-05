# tidyAML Wiki

Welcome to the **tidyAML** wiki! This comprehensive guide will help you master Automated Machine Learning with the tidymodels ecosystem.

## 📚 Quick Navigation

### Getting Started
- [Installation Guide](Installation-Guide.md)
- [Quick Start Tutorial](Quick-Start.md)
- [Your First Model](Your-First-Model.md)

### Core Concepts
- [Package Overview](Package-Overview.md)

### Tutorials
- [Regression Tutorial](Regression-Tutorial.md)
- [Classification Tutorial](Classification-Tutorial.md)

### Function Reference
- [Model Generators](Function-Reference-Model-Generators.md)
- [Extractors](Function-Reference-Extractors.md)
- [Utilities](Function-Reference-Utilities.md)
- [Plotting Functions](Function-Reference-Plotting.md)

### Reference
- [Supported Models and Engines](Supported-Models.md)
- [Troubleshooting](Troubleshooting.md)
- [FAQ](FAQ.md)
- [Best Practices](Best-Practices.md)

### Contributing
- [Contributing to tidyAML](Contributing.md)
- [Contributing to Wiki](Contributing-Wiki.md)

---

## 🎯 What is tidyAML?

**tidyAML** brings the power of Automated Machine Learning (AutoML) to the tidymodels ecosystem. With just a few lines of code, you can:

- 🚀 Generate multiple model specifications instantly
- 🔄 Train dozens of models with a single function call
- 📊 Handle both regression and classification tasks
- 🛡️ Benefit from graceful failure handling
- 🎯 Work within the native tidymodels framework
- ⚡ Avoid Java dependencies (unlike h2o)
- 🔌 Access 30+ parsnip engines out of the box

## 🌟 Key Features

### Fast Model Generation
```r
# Create multiple regression models at once
models <- fast_regression(
  .data = mtcars,
  .rec_obj = recipe(mpg ~ ., data = mtcars),
  .parsnip_eng = c("lm", "glm", "glmnet")
)
```

### Graceful Failure Handling
Models fail safely without breaking your workflow. If a required package isn't installed, tidyAML skips that model and continues with others.

### tidymodels Native
Built entirely on tidymodels, so you can use all your favorite tidymodels tools and workflows alongside tidyAML.

## 📊 Comparison with Other AutoML Tools

| Feature                   | tidyAML     | h2o         | caret       |
|---------------------------|-------------|-------------|-------------|
| tidymodels Integration    | ✅ Native   | ❌ No       | ⚠️ Limited  |
| Java Required             | ✅ No       | ❌ Yes      | ✅ No       |
| Parallel Model Training   | ✅ Yes      | ✅ Yes      | ✅ Yes      |
| Modern R Workflow         | ✅ Pipes & tidy | ❌ Old style | ⚠️ Mixed |
| Active Development        | ✅ Yes      | ⚠️ Slowing  | ❌ Maintenance |

## 🚀 Quick Example

```r
library(tidyAML)
library(recipes)

# Prepare your data with a recipe
rec_obj <- recipe(mpg ~ ., data = mtcars)

# Generate and train multiple models
models <- fast_regression(
  .data = mtcars,
  .rec_obj = rec_obj,
  .parsnip_eng = c("lm", "glm")
)

# Extract predictions
predictions <- extract_wflw_pred(models, 1:2)

# Visualize results
plot_regression_predictions(models)
```

## 📖 Learning Path

**New to tidyAML?** Follow this learning path:

1. **Start Here**: [Installation Guide](Installation-Guide.md)
2. **First Steps**: [Quick Start Tutorial](Quick-Start.md)
3. **Build Understanding**: [Package Overview](Package-Overview.md)
4. **Choose Your Task**:
   - For regression: [Regression Tutorial](Regression-Tutorial.md)
   - For classification: [Classification Tutorial](Classification-Tutorial.md)
5. **Go Deeper**: [Advanced Topics](Advanced-Custom-Models.md)

## 🆘 Need Help?

- **Bugs & Issues**: [GitHub Issues](https://github.com/spsanderson/tidyAML/issues)
- **Questions**: Check the [FAQ](FAQ.md) or [Troubleshooting](Troubleshooting.md) pages
- **Examples**: See [Tutorials](Regression-Tutorial.md) for comprehensive examples
- **Function Help**: Browse the [Function Reference](Function-Reference-Model-Generators.md)

## 📦 Package Information

- **Version**: 0.0.6.9000 (Development)
- **Author**: Steven P. Sanderson II, MPH
- **License**: MIT
- **Website**: https://www.spsanderson.com/tidyAML/
- **Repository**: https://github.com/spsanderson/tidyAML
- **CRAN**: https://cran.r-project.org/package=tidyAML

## 🙏 Acknowledgments

- Thanks to [Garrick Aden-Buie](https://fosstodon.org/@grrrck/109479826278916014) for the package name suggestion
- Built on the excellent [tidymodels](https://www.tidymodels.org/) framework
- Inspired by [h2o](https://h2o.ai/) but designed for the tidyverse

---

**Ready to get started?** Head to the [Installation Guide](Installation-Guide.md)!

⭐ If you find tidyAML useful, please [star the repository](https://github.com/spsanderson/tidyAML)!
