audit_fixture <- function() {
  withr::with_seed(76L, {
    make_data <- function(k) {
      x <- stats::rnorm(80)
      z <- stats::rnorm(80)
      dplyr::tibble(y = k * x + z + stats::rnorm(80), x = x, z = z)
    }
    list(one = make_data(1), two = make_data(2), three = make_data(3))
  })
}

test_that("LODO selects using only other datasets and returns their mean and held-out loss", {
  data <- audit_fixture()
  audit <- function(data) {
    lodo_engine_audit(data, "y", c("lm", "glm"),
      .parsnip_fns = "linear_reg", .seed = 19L
    )
  }
  result <- audit(data)
  expect_s3_class(result, "tbl_df")
  expect_named(result, c(
    "held_out_dataset", "selected_model", "selection_loss", "held_out_loss", "generalization_gap"
  ))
  expect_identical(result$held_out_dataset, names(data))
  scores <- attr(result, ".lodo_scores")
  expect_equal(nrow(scores), 6L)
  for (i in seq_len(nrow(result))) {
    selected <- result$selected_model[i]
    held_out <- result$held_out_dataset[i]
    candidates <- with(scores, tapply(loss[dataset != held_out], model[dataset != held_out], mean))
    expect_equal(result$selection_loss[i], min(candidates))
    measured <- with(scores, loss[model == selected & dataset == held_out])
    expect_equal(result$held_out_loss[i], measured)
  }
  expect_equal(result$generalization_gap, result$held_out_loss - result$selection_loss)

  data$two$y <- 1000 * data$two$z^2
  changed <- audit(data)
  expect_identical(changed$selected_model[2], result$selected_model[2])
  expect_identical(changed$selection_loss[2], result$selection_loss[2])
  expect_false(isTRUE(all.equal(changed$held_out_loss[2], result$held_out_loss[2])))
})

test_that("LODO handles exact ties and does not switch after a held-out failure", {
  data <- audit_fixture()
  data <- lapply(data, function(x) transform(x, y = 0))
  fit <- function(data) {
    lodo_engine_audit(data, "y", c("lm", "glm"),
      .parsnip_fns = "linear_reg", .seed = 19L
    )
  }
  expect_identical(fit(data)$selected_model, rep("glm - linear_reg", 3L))
  data$two$x <- Inf
  expect_warning(result <- fit(data), "could not be scored")
  expect_identical(result$selected_model, c(NA_character_, "glm - linear_reg", NA_character_))
  expect_true(all(is.na(result$held_out_loss)))
  expect_true(all(!is.na(attr(result, ".lodo_scores")$error[3:4])))
})

test_that("LODO reports probability losses for classification as well as RMSE", {
  data <- lapply(audit_fixture(), function(x) transform(x, y = factor(y > 0)))
  for (metric in c("roc_auc", "mn_log_loss")) {
    result <- lodo_engine_audit(data, "y", "glm",
      .parsnip_fns = "logistic_reg",
      .metric = metric, .seed = 19L
    )
    expect_true(all(is.finite(result$held_out_loss) & result$held_out_loss >= 0))
    expect_identical(result$selected_model, rep("glm - logistic_reg", 3L))
    if (metric == "roc_auc") {
      expect_true(all(result$held_out_loss <= 1))
    }
  }
  expect_error(lodo_engine_audit(data[1], "y"), "two.*datasets")
  expect_error(lodo_engine_audit(unname(data), "y"), "unique.*names")
  expect_error(lodo_engine_audit(data, "y", .metric = "rmse"), "numeric")
})

test_that("multiclass LODO uses probabilities for every outcome level", {
  skip_if_not_installed("nnet")
  data <- lapply(audit_fixture(), function(x) {
    x$y <- cut(x$y, breaks = c(-Inf, -0.6, 0.6, Inf), labels = c("low", "middle", "high"))
    x
  })
  for (metric in c("roc_auc", "mn_log_loss")) {
    result <- lodo_engine_audit(data, "y", "nnet",
      .parsnip_fns = "multinom_reg",
      .metric = metric, .seed = 19L
    )
    expect_true(all(is.finite(result$held_out_loss)))
    expect_identical(attr(result, ".lodo_metric"), metric)
  }
})
