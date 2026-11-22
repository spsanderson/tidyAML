gate_fixture <- function() {
  withr::with_seed(49L, {
    noise <- stats::rnorm(120, sd = 5)
    signal <- stats::rnorm(120)
    dplyr::tibble(
      y = signal + stats::rnorm(120, sd = 0.05),
      x1 = noise + signal, x2 = noise - signal
    )
  })
}

test_that("regression gate detects supervised signal on paired inner folds", {
  data <- gate_fixture()
  output <- gated_fast_regression(data, "y", c("x1", "x2"),
    .gate_eng = "lm",
    .u_pca = 1L, .s_pls = 1L, .m = 0, .parsnip_eng = "lm", .seed = 54L
  )
  expect_s3_class(output, "fst_reg_tbl")
  expect_equal(nrow(output), 1L)
  expect_identical(attr(output, ".lighttar_selected"), "lighttar")
  scores <- attr(output, ".lighttar_gate")
  expect_s3_class(scores, "tbl_df")
  expect_named(scores, c("fold", "recipe", "rmse"))
  expect_equal(nrow(scores), 10L)
  expect_identical(scores$fold[scores$recipe == "pca"], scores$fold[scores$recipe == "lighttar"])
  losses <- tapply(scores$rmse, scores$recipe, mean)
  expect_lt(losses[["lighttar"]], losses[["pca"]])
})

test_that("changing outer test outcomes cannot change recipe selection or predictions", {
  data <- gate_fixture()
  split <- withr::with_seed(57L, rsample::initial_split(data))
  fit <- function(data) {
    gated_fast_regression(data, "y", c("x1", "x2"),
      .gate_eng = "lm",
      .u_pca = 1L, .s_pls = 1L, .m = 0, .parsnip_eng = "lm", .seed = 57L
    )
  }
  output <- fit(data)
  # Split identifiers are positional for this data frame.
  data$y[setdiff(seq_len(nrow(data)), split$in_id)] <- 1e6
  changed <- fit(data)
  expect_identical(attr(changed, ".lighttar_gate"), attr(output, ".lighttar_gate"))
  expect_identical(attr(changed, ".lighttar_selected"), attr(output, ".lighttar_selected"))
  assessment <- function(x) with(x$pred_wflw[[1]], .value[.data_type == "testing"])
  expect_equal(assessment(output), assessment(changed))
  expect_length(assessment(output), nrow(rsample::testing(split)))
})

test_that("regression gate prefers the simpler recipe when scores tie", {
  withr::with_seed(42L, {
    rng_before <- .Random.seed
    data <- gate_fixture()
    output <- gated_fast_regression(data, "y", c("x1", "x2"),
      .gate_eng = "lm",
      .u_pca = 1L, .s_pls = 0L, .parsnip_eng = "lm", .seed = 28L
    )
    expect_identical(attr(output, ".lighttar_selected"), "pca")
    expect_identical(.Random.seed, rng_before)
  })
  expect_error(
    gated_fast_regression(gate_fixture(), "y", "x1", .gate_eng = "glm"),
    "single.*model|one.*model"
  )
})

test_that("regression gate diagnoses a final grid with no valid models", {
  data <- gate_fixture()
  data$y <- -abs(data$y) - 1
  expect_error(suppressMessages(gated_fast_regression(
    data, "y", c("x1", "x2"),
    .gate_eng = "lm", .u_pca = 1L, .s_pls = 0L,
    .parsnip_eng = "glm", .parsnip_fns = "poisson_reg", .seed = 82L
  )), "No final regression model")
})
