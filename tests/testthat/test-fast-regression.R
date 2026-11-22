test_that("fast regression evaluates an inline recipe before drawing the split", {
  make_recipe <- function() {
    recipes::recipe(mpg ~ wt, data = mtcars) |>
      recipes::step_normalize(wt)
  }
  fit <- function(recipe) {
    fast_regression(mtcars, recipe, "linear_reg", "lm")
  }

  expected <- withr::with_seed(5L, {
    recipe <- make_recipe()
    fit(recipe)
  })
  actual <- withr::with_seed(5L, fit(make_recipe()))

  expect_equal(nrow(actual), 1L)
  expect_equal(actual$pred_wflw, expected$pred_wflw)
})

test_that("fast regression evaluates model filters before drawing the split", {
  draw_engines <- function() sample(c("lm", "glm"))
  recipe <- recipes::recipe(mpg ~ wt, data = mtcars)
  fit <- function(engines) {
    fast_regression(mtcars, recipe, "linear_reg", engines)
  }

  expected <- withr::with_seed(5L, {
    engines <- draw_engines()
    fit(engines)
  })
  actual <- withr::with_seed(5L, fit(draw_engines()))

  expect_equal(nrow(actual), 2L)
  expect_equal(actual$pred_wflw, expected$pred_wflw)
  expect_identical(attr(actual, ".parsnip_engines"), attr(expected, ".parsnip_engines"))
})
