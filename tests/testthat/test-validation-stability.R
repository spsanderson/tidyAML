stability_fixture <- function() {
  data <- withr::with_seed(28L, {
    x <- stats::rnorm(100)
    z <- stats::rnorm(100)
    y <- factor(ifelse(x + z + stats::rnorm(100) > 0, "yes", "no"))
    dplyr::tibble(x = x, z = z, y = y)
  })
  recipe <- recipes::recipe(y ~ ., data = data)
  split <- withr::with_seed(28L, rsample::initial_split(data))
  models <- withr::with_seed(28L, fast_classification(
    data, recipe,
    .parsnip_eng = "glm", .parsnip_fns = "logistic_reg"
  ))
  # A second real classifier fitted to the same analysis rows.
  models <- models[c(1, 1), ]
  models$.model_id <- 1:2
  models$fitted_wflw[[2]] <- workflows::workflow() |>
    workflows::add_formula(y ~ x) |>
    workflows::add_model(parsnip::logistic_reg(engine = "glm")) |>
    parsnip::fit(data = rsample::training(split))
  list(models = models, validation = rsample::testing(split))
}

test_that("stability scores held-out probabilities on shared bootstrap rows", {
  fixture <- stability_fixture()
  models <- fixture$models

  seen <- list()
  expected <- stats::predict(models$fitted_wflw[[1]], fixture$validation, type = "prob")$.pred_yes
  metric <- function(data, truth, estimate, event_level) {
    truth <- dplyr::pull(data, {{ truth }})
    prob <- dplyr::pull(data, {{ estimate }})
    seen[[length(seen) + 1L]] <<- truth
    if (length(seen) == 1L) {
      expect_identical(prob, expected)
    }
    expect_true(all(is.finite(prob) & prob >= 0 & prob <= 1))
    expect_identical(event_level, "second")
    dplyr::tibble(.estimate = mean((truth == levels(truth)[2]) * prob))
  }
  rho <- check_validation_stability(models, metric,
    .n_boot = 5L, .event_level = "second", .seed = 28L
  )
  expect_length(seen, 12L)
  expect_identical(seen[[1]], fixture$validation$y)
  for (i in seq(1L, length(seen), by = 2L)) {
    expect_identical(seen[[i]], seen[[i + 1L]])
    expect_identical(table(seen[[i]]), table(seen[[1]]))
  }
  expect_true(is.finite(rho) && abs(rho) <= 1)
  expect_identical(check_validation_stability(models[1, ]), NA_real_)
})

test_that("ROC AUC rank stability is reproducible and abstains on ties", {
  models <- stability_fixture()$models
  expect_identical(check_validation_stability(models[c(1, 1), ]), NA_real_)
  withr::with_seed(42L, {
    rng_before <- .Random.seed
    a <- check_validation_stability(models, .n_boot = 8L, .seed = 14L)
    b <- check_validation_stability(models, .n_boot = 8L, .seed = 14L)
    expect_true(is.finite(a))
    expect_identical(a, b)
    expect_identical(.Random.seed, rng_before)
  })
  expect_error(check_validation_stability(models, .n_boot = 1.5), "n_boot")
  expect_error(check_validation_stability(models, .event_level = "other"), "event_level")
})
