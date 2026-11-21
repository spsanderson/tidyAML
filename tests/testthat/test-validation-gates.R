test_that("validation stability pairs held-out rows and ignores training predictions", {
  saved <- function(testing) {
    dplyr::tibble(
      .data_type = c(rep("actual", 6), rep("training", 2), rep("testing", 4)),
      .value = c(100, -100, 1:4, 900, 900, testing)
    )
  }
  models <- dplyr::tibble(pred_wflw = list(saved(1:4), saved(5:8)))
  class(models) <- c("tidyaml_mod_spec_tbl", class(models))
  set.seed(280)
  metric <- function(truth, estimate) {
    expect_true(all(truth %in% 1:4))
    mean(abs(truth - estimate))
  }
  expect_equal(check_validation_stability(models, metric, 8), 1)
  expect_equal(check_validation_stability(models[1, ]), 1)
  expect_true(is.na(check_validation_stability(models[c(1, 1), ])))
  models$pred_wflw[[2]]$.value[3] <- 101
  expect_error(check_validation_stability(models), "same validation rows")
  expect_error(check_validation_stability(models, .n_boot = 0), "whole number")
})

test_that("stability scores probabilities on shared binary validation data", {
  data <- data.frame(
    label = factor(rep(c("yes", "no"), each = 30), levels = c("yes", "no")),
    signal = rep(c(1, -1), each = 30) + rep(seq(-2, 2, length.out = 30), 2),
    noise = rep(seq_len(30), 2)
  )
  make_fit <- function(formula) {
    workflows::workflow() |>
      workflows::add_formula(formula) |>
      workflows::add_model(parsnip::set_engine(parsnip::logistic_reg(), "glm")) |>
      parsnip::fit(data = data)
  }
  models <- dplyr::tibble(
    fitted_wflw = list(make_fit(label ~ signal), make_fit(label ~ noise)),
    pred_wflw = list(NULL, NULL)
  )
  class(models) <- c("tidyaml_mod_spec_tbl", class(models))
  set.seed(11)
  expect_gt(check_validation_stability(
    models, yardstick::roc_auc_vec, .validation_data = data,
    .outcome_var = "label", .prediction_type = "prob"
  ), 0.5)
  expect_error(check_validation_stability(models, .prediction_type = "prob"),
               "require '.validation_data'")
})

test_that("VGC accepts only candidates supported by validation evidence", {
  expect_true(vgc_gate(0.8, 0.791, 0.8, .tau_min = 0.005, .tau_max = 0.03))
  expect_false(vgc_gate(0.8, 0.78, 0.8, .tau_min = 0.005, .tau_max = 0.03))
  expect_false(vgc_gate(0.8, 0.9, 0.4))
  expect_false(vgc_gate(0.8, NA_real_, 0.9))
  expect_false(vgc_gate(0.8, 0.9, NA_real_))
  expect_true(vgc_gate(3, 2, 1, .direction = "minimize"))
  expect_false(vgc_gate(3, 4, 1, .direction = "minimize"))
  expect_error(vgc_gate(3, 4, 1, .tau_min = 2, .tau_max = 1), "tau_min")
})

test_that("LightTAR bakes both projections from the training embeddings", {
  set.seed(12)
  data <- data.frame("response value" = rnorm(60), x1 = rnorm(60),
                     x2 = rnorm(60), x3 = rnorm(60), passthrough = 1:60,
                     check.names = FALSE)
  data[["response value"]] <- 3 * data$x1 - data$x2 + data[["response value"]]
  rec <- make_lighttar_recipe(data, "response value", c("x1", "x2", "x3"), 1, 2)
  fit <- recipes::prep(rec, training = data[1:45, ])
  new_data <- data[46:60, setdiff(names(data), "response value")]
  baked <- recipes::bake(fit, new_data = new_data)
  expect_setequal(names(baked), c("pca_1", "pls_1", "pls_2", "passthrough"))
  expect_equal(baked$passthrough, 46:60)
  expect_true(all(is.finite(baked$pls_1)))
  expect_equal(nrow(recipes::tidy(fit, number = 2)), 6L)
  expect_error(make_lighttar_recipe(data, "response value", "response value"), "predictor")
  constant <- data
  constant[["response value"]] <- 0
  constant_fit <- recipes::prep(rec, training = constant)
  expect_false(any(startsWith(names(recipes::bake(constant_fit, new_data)), "pls_")))
})

test_that("gated regression uses matched inner folds and holds outer rows back", {
  set.seed(280)
  latent <- rnorm(160)
  data <- data.frame(
    y = 10 * latent + rnorm(160, sd = 0.1),
    x1 = rnorm(160), x2 = rnorm(160), x3 = latent, x4 = rnorm(160)
  )
  run_gate <- function(data) {
    set.seed(130)
    gated_fast_regression(data, "y", names(data)[-1], .gate_eng = "lm",
                          .u_pca = 1, .s_pls = 1, .v = 4, .parsnip_eng = "lm")
  }
  set.seed(130)
  split <- rsample::initial_split(dplyr::as_tibble(data))
  held_rows <- as.integer(split, data = "assessment")
  result <- run_gate(data)
  gate <- attr(result, "lighttar_gate")
  expect_s3_class(result, "fst_reg_tbl")
  expect_equal(gate$selected_recipe, "pca_pls")
  expect_equal(gate$metrics$fold[1:4], gate$metrics$fold[5:8])
  expect_true(all(is.finite(gate$metrics$rmse)))
  expect_equal(validation_prediction_pair(result$pred_wflw[[1]])$truth, data$y[held_rows])
  changed <- data
  changed$y[held_rows] <- changed$y[held_rows] + 1000
  expect_equal(attr(run_gate(changed), "lighttar_gate"), gate)
})

test_that("the LODO audit selects on the other datasets and reports test RMSE", {
  data <- list(a = mtcars, b = transform(mtcars, mpg = mpg * 2),
               c = transform(mtcars, mpg = mpg + sin(wt)))
  set.seed(13)
  result <- lodo_engine_audit(data, "mpg", c("lm", "glm"), "linear_reg")
  scores <- attr(result, "dataset_scores")
  expect_s3_class(result, "tbl_df")
  expect_equal(result$held_out_dataset, names(data))
  expect_equal(nrow(scores), 6L)
  expect_equal(result$generalization_gap, result$held_out_loss - result$selection_loss)
  for (i in seq_len(nrow(result))) {
    selected <- scores$model == result$selected_model[i]
    held_out <- scores$dataset == result$held_out_dataset[i]
    expect_equal(result$selection_loss[i], mean(scores$loss[selected & !held_out]))
    expect_equal(result$held_out_loss[i], scores$loss[selected & held_out])
  }
  set.seed(13)
  first <- fast_regression(mtcars, recipes::recipe(mpg ~ ., mtcars),
                           "linear_reg", c("lm", "glm"))
  pred <- first$pred_wflw[[1]]
  expected <- sqrt(mean((tail(pred$.value[pred$.data_type == "actual"], 8) -
                           pred$.value[pred$.data_type == "testing"])^2))
  expect_equal(scores$loss[1], expected)
  expect_error(lodo_engine_audit(unname(data), "mpg"), "name at least two")
})
