lighttar_fixture <- function() {
  withr::with_seed(280L, {
    x <- stats::rnorm(60)
    a <- x + stats::rnorm(60, sd = 0.3)
    b <- x + stats::rnorm(60, sd = 0.3)
    c <- stats::rnorm(60)
    dplyr::tibble(y = a - b + c / 2, a = a, b = b, c = c, keep = factor(x > 0))
  })
}

test_that("LightTAR fits parallel feature blocks and bakes without outcomes", {
  data <- lighttar_fixture()
  rec <- make_lighttar_recipe(data, "y", c("a", "b", "c"), 2, 1)
  expect_s3_class(rec, "recipe")
  fit <- recipes::prep(rec, training = data[1:45, ])
  holdout <- data[46:60, ]
  baked <- recipes::bake(fit, new_data = dplyr::select(holdout, -y))
  expect_named(baked, c("keep", "pca_1", "pca_2", "pls_1"))
  expect_identical(baked$keep, holdout$keep)
  expect_equal(nrow(baked), nrow(holdout))

  holdout$y <- 1000 * holdout$y
  expect_equal(dplyr::select(recipes::bake(fit, new_data = holdout), -y), baked)
})

test_that("the supervised projection solves the regularized PLS objective", {
  data <- lighttar_fixture()
  emb <- c("a", "b", "c")
  x <- scale(as.matrix(data[emb])) * sqrt(nrow(data) / (nrow(data) - 1))
  y <- scale(data$y) * sqrt(nrow(data) / (nrow(data) - 1))
  xy <- crossprod(x, y) / nrow(data)
  xx <- crossprod(x) / nrow(data)

  for (m in c(0, 60)) {
    rec <- make_lighttar_recipe(data, "y", emb, 1, 2, .m = m)
    baked <- recipes::bake(recipes::prep(rec), new_data = data)
    w <- eigen(tcrossprod(xy) + (m / nrow(data)) * xx, symmetric = TRUE)$vectors[, 1]
    expect_equal(abs(stats::cor(drop(x %*% w), baked$pls_1)), 1, tolerance = 1e-10)
    expect_equal(stats::cor(baked$pls_1, baked$pls_2), 0, tolerance = 1e-10)
    expect_s3_class(recipes::tidy(recipes::prep(rec), number = 1), "tbl_df")
  }
})

test_that("LightTAR retains other predictors and bounds components by training rank", {
  data <- lighttar_fixture()
  data$constant <- 1
  data$copy <- data$a
  data$`non-syntactic outcome` <- factor(data$y > 0)
  cols <- c("a", "constant", "copy")
  rec <- make_lighttar_recipe(data, "non-syntactic outcome", cols)
  baked <- recipes::bake(recipes::prep(rec), new_data = data)
  expect_named(baked, c("y", "b", "c", "keep", "non-syntactic outcome", "pca_1", "pls_1"))
  pca <- recipes::prep(make_lighttar_recipe(data, "y", cols, 2, 0))
  expect_false(any(startsWith(names(recipes::bake(pca, new_data = data)), "pls_")))
  expect_error(make_lighttar_recipe(data, "y", c("a", "keep")), "numeric")
  expect_error(make_lighttar_recipe(data, "y", "y"), "outcome")
  expect_error(make_lighttar_recipe(data, "y", "missing"), "missing")
  expect_error(make_lighttar_recipe(data, "y", "a", .m = -1), "\\.m")
  expect_error(recipes::prep(make_lighttar_recipe(data, "y", "constant")), "constant")
})
