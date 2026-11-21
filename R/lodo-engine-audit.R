<<<<<<< Updated upstream
#' Audit Engine Selection Across Datasets
#'
#' @param .datasets_list A named list of at least two regression data frames.
#' @param .outcome_var The numeric outcome column name shared by all datasets.
#' @param .parsnip_eng,.parsnip_fns Engine and model filters for fast regression.
#' @param .split_args Arguments passed to each dataset's initial split.
#'
#' @return A tibble with one row per held-out dataset, the selected model,
#'   selection RMSE, held-out RMSE, and their difference. The
#'   `dataset_scores` attribute contains individual model scores.
#' @details Within each dataset, all models share the same test split. Selection
#'   uses mean test RMSE over the other datasets and requires complete scores on
#'   those datasets. Ties break by model identifier. A missing held-out score or
#'   the absence of an eligible model produces missing values for that fold.
#'   RMSE comparisons across datasets assume comparable outcome units and scales.
#'
#' @description
#' Evaluate how well a model selected on several regression datasets
#' performs on a dataset left out of model selection.
#'
#' @author Steven P. Sanderson II, MPH
#' @family Model_Validation
#'
#' @examples
#' set.seed(280)
#' datasets <- list(
#'   automatic = subset(mtcars, am == 0, select = c(mpg, wt, hp)),
#'   manual = subset(mtcars, am == 1, select = c(mpg, wt, hp))
#' )
#' lodo_engine_audit(
#'   datasets, "mpg", .parsnip_eng = c("lm", "glm"),
#'   .parsnip_fns = "linear_reg"
#' )
#'
#' @name lodo_engine_audit
#' @rdname lodo_engine_audit
#' @export
lodo_engine_audit <- function(.datasets_list, .outcome_var,
                              .parsnip_eng = c("glm", "glmnet", "ranger"),
                              .parsnip_fns = "all", .split_args = NULL) {
  datasets <- names(.datasets_list)
  if (!is.list(.datasets_list) || is.data.frame(.datasets_list) ||
      length(.datasets_list) < 2L || is.null(datasets) ||
      anyNA(datasets) || any(!nzchar(datasets)) || anyDuplicated(datasets)) {
    rlang::abort("'.datasets_list' must name at least two datasets uniquely.")
  }
  for (data in .datasets_list) check_regression_outcome(data, .outcome_var)
  scores <- purrr::imap_dfr(.datasets_list, function(data, dataset) {
    rec <- recipes::recipe(regression_formula(.outcome_var), data = data)
    fits <- fast_regression(data, rec, .parsnip_fns, .parsnip_eng,
                            .split_args = .split_args, .drop_na = FALSE)
    losses <- vapply(fits$pred_wflw, function(pred) {
      pair <- validation_prediction_pair(pred)
      validation_rmse(pair$truth, pair$estimate)
    }, numeric(1))
    model <- paste(fits$.parsnip_engine, fits$.parsnip_fns, sep = " - ")
    dplyr::tibble(dataset = rep(dataset, length(losses)), model = model, loss = losses)
  })

  audit <- purrr::map_dfr(datasets, function(held_out) {
    selection <- scores |>
      dplyr::filter(.data$dataset != held_out, is.finite(.data$loss)) |>
      dplyr::group_by(.data$model) |>
      dplyr::summarise(selection_loss = mean(.data$loss),
                       n = dplyr::n_distinct(.data$dataset), .groups = "drop") |>
      dplyr::filter(.data$n == length(datasets) - 1L) |>
      dplyr::arrange(.data$selection_loss, .data$model)
    model <- selection$model[1L]
    selection_loss <- selection$selection_loss[1L]
    held_out_loss <- scores$loss[which(scores$dataset == held_out & scores$model == model)][1L]
    dplyr::tibble(
      held_out_dataset = held_out, selected_model = model,
      selection_loss = selection_loss, held_out_loss = held_out_loss,
      generalization_gap = held_out_loss - selection_loss
    )
  })
  attr(audit, "dataset_scores") <- scores
  audit
}

=======
#' Audit model selection across held-out datasets
#'
#' Score each `tidyAML` regression or classification specification on a
#' shared testing split within each dataset. Hold out one dataset at a time,
#' select the model with the lowest mean loss on the other datasets, and
#' compare its mean selection loss to its loss on the held-out dataset.
#' Models are fitted within each dataset; this audits the choice of model
#' specification, not transfer of fitted weights across datasets.
#'
#' @param .datasets_list Named list of at least two data frames. Each must
#'   contain `.outcome_var`; other column names may differ across datasets.
#' @param .outcome_var Name of one outcome column common to all datasets.
#' @param .parsnip_eng Character vector of engines to compare. With `NULL`,
#'   use `c("lm", "ranger")` for regression or `"glm"` for classification.
#'   Pass more than one working specification to audit a selection decision.
#' @param .parsnip_fns Character vector of model families to include, or
#'   `"all"` for all supported families for the requested engines.
#' @param .metric `"rmse"` for a numeric outcome; `"roc_auc"` (as `1 - AUC`)
#'   or `"mn_log_loss"` for a factor outcome. Loss is always smaller-is-better.
#' @param .event_level `"first"` or `"second"`, used for binary probability
#'   metrics. Multiclass metrics use all class probabilities in factor order.
#' @param .split_args Optional arguments for [rsample::initial_split()],
#'   applied to the shared split within each dataset.
#' @inheritParams gated_fast_regression
#'
#' @details Only models scored on every selection dataset are eligible. Exact
#'   ties are broken by model label in bytewise order. A failed score on the
#'   held-out dataset does not change selection: the held-out loss and gap are
#'   `NA`. Folds with no eligible model have `NA` for all result fields except
#'   the dataset name. Failures are reported with a warning and error details
#'   are retained in the per-dataset score table. Use representative datasets;
#'   the gap is descriptive, and raw RMSE may be dominated by datasets with
#'   larger outcome scales.
#' @return A tibble with one row per held-out dataset and columns
#'   `held_out_dataset`, `selected_model`, `selection_loss`, `held_out_loss`,
#'   and `generalization_gap` (`held_out_loss - selection_loss`). The
#'   `.lodo_scores` attribute is a tibble with `dataset`, `model`, `loss`,
#'   and `error` columns; `.lodo_metric` records the requested metric.
#' @references Hog et al., Towards Reliable Scaling Laws for Tabular
#'   Foundation Models, <https://arxiv.org/abs/2611.24214>.
#' @examples
#' datasets <- list(airquality = na.omit(airquality), mtcars = mtcars)
#' datasets$airquality$outcome <- datasets$airquality$Temp
#' datasets$airquality$Temp <- NULL
#' datasets$mtcars$outcome <- datasets$mtcars$mpg
#' datasets$mtcars$mpg <- NULL
#' lodo_engine_audit(datasets, "outcome", c("lm", "glm"),
#'   .parsnip_fns = "linear_reg", .seed = 280L
#' )
#' @export
lodo_engine_audit <- function(.datasets_list, .outcome_var, .parsnip_eng = NULL,
                              .parsnip_fns = "all", .metric = "rmse",
                              .event_level = "first", .split_args = NULL, .seed = NULL) {
  if (!is.list(.datasets_list) || is.data.frame(.datasets_list) || length(.datasets_list) < 2L) {
    rlang::abort("`.datasets_list` must be a named list of at least two datasets.")
  }
  dataset_names <- names(.datasets_list)
  if (!unique_audit_names(dataset_names)) {
    rlang::abort("`.datasets_list` must have unique, nonempty names.")
  }
  metric <- rlang::arg_match(.metric, c("rmse", "roc_auc", "mn_log_loss"))
  event_level <- rlang::arg_match(.event_level, c("first", "second"))
  regression <- metric == "rmse"
  engines <- .parsnip_eng
  if (is.null(engines)) {
    engines <- if (regression) c("lm", "ranger") else "glm"
  }
  if (!unique_audit_names(engines) || !unique_audit_names(.parsnip_fns)) {
    rlang::abort("`.parsnip_eng` and `.parsnip_fns` must be nonempty character vectors.")
  }
  datasets <- purrr::imap(.datasets_list, function(data, dataset) {
    y <- check_audit_outcome(data, .outcome_var, regression = regression)
    if (regression && any(!is.finite(y))) {
      rlang::abort(paste0("Dataset `", dataset, "` must have a finite numeric outcome."))
    }
    if (!regression) {
      if (!is.factor(y) || anyNA(y) || length(unique(y)) < 2L) {
        rlang::abort(paste0(
          "Dataset `", dataset, "` must have a complete factor outcome with two or more levels."
        ))
      }
      data[[.outcome_var]] <- droplevels(y)
    }
    dplyr::as_tibble(data)
  })
  specs <- if (regression) {
    fast_regression_parsnip_spec_tbl(.parsnip_fns, engines)
  } else {
    fast_classification_parsnip_spec_tbl(.parsnip_fns, engines)
  }
  if (nrow(specs) == 0L) {
    rlang::abort("No model specifications matched `.parsnip_eng` and `.parsnip_fns`.")
  }
  labels <- paste(specs$.parsnip_engine, specs$.parsnip_fns, sep = " - ")

  with_audit_seed(.seed, {
    # Work on independent RNG streams so a held-out dataset cannot change
    # preprocessing, splitting, or fitting on the selection datasets.
    seeds <- stats::setNames(sample.int(.Machine$integer.max, length(datasets)), dataset_names)
    scores <- purrr::imap(datasets, function(data, dataset) {
      withr::with_seed(seeds[[dataset]], {
        split <- create_splits(data, "initial_split", .split_args)$splits
        roles <- ifelse(names(data) == .outcome_var, "outcome", "predictor")
        recipe <- recipes::recipe(data, vars = names(data), roles = roles)
        workflows <- full_internal_make_wflw(specs, recipe)
        score <- purrr::safely(function(workflow) {
          if (regression) {
            regression_split_rmse(workflow, split, .outcome_var)
          } else {
            classification_split_loss(workflow, split, .outcome_var, metric, event_level)
          }
        })
        runs <- purrr::map(workflows, score)
        dplyr::tibble(
          dataset = dataset, model = labels,
          loss = purrr::map_dbl(runs, ~ if (is.null(.x$result)) NA_real_ else .x$result),
          error = purrr::map_chr(runs, function(run) {
            if (is.null(run$error)) NA_character_ else conditionMessage(run$error)
          })
        )
      })
    }) |>
      dplyr::bind_rows()

    result <- purrr::map(dataset_names, ~ lodo_select(scores, .x, length(datasets) - 1L)) |>
      dplyr::bind_rows()
    attr(result, ".lodo_scores") <- scores
    attr(result, ".lodo_metric") <- metric
    if (anyNA(scores$loss)) {
      rlang::warn(paste0(
        sum(is.na(scores$loss)),
        " model/dataset combinations could not be scored; see the `.lodo_scores` attribute."
      ))
    }
    result
  })
}

lodo_select <- function(scores, held_out, required) {
  selection <- scores[scores$dataset != held_out & is.finite(scores$loss), ] |>
    dplyr::group_by(.data$model) |>
    dplyr::summarise(loss = mean(.data$loss), datasets = dplyr::n(), .groups = "drop")
  selection <- selection[selection$datasets == required, ]
  picked <- NA_character_
  selection_loss <- held_out_loss <- NA_real_
  if (nrow(selection) > 0L) {
    first <- order(selection$loss, selection$model, method = "radix")[[1L]]
    picked <- selection$model[[first]]
    selection_loss <- selection$loss[[first]]
    held_out_loss <- scores$loss[scores$dataset == held_out & scores$model == picked][[1L]]
  }
  dplyr::tibble(
    held_out_dataset = held_out, selected_model = picked, selection_loss = selection_loss,
    held_out_loss = held_out_loss, generalization_gap = held_out_loss - selection_loss
  )
}

classification_split_loss <- function(workflow, split, outcome, metric, event_level) {
  train <- rsample::analysis(split)
  assessment <- rsample::assessment(split)
  truth <- assessment[[outcome]]
  outcome_levels <- levels(truth)
  if (nrow(assessment) == 0L || any(table(train[[outcome]]) == 0L)) {
    rlang::abort("Need assessment rows and at least one training row for each class.")
  }
  if (metric == "roc_auc" && any(table(truth) == 0L)) {
    rlang::abort("ROC AUC needs assessment observations for every outcome class.")
  }
  fit <- parsnip::fit(workflow, data = train)
  predictions <- stats::predict(fit, new_data = assessment, type = "prob")
  columns <- paste0(".pred_", outcome_levels)
  if (!all(columns %in% names(predictions)) || nrow(predictions) != length(truth)) {
    rlang::abort("Class probabilities are missing or do not match the assessment rows.")
  }
  probs <- as.matrix(predictions[columns])
  if (!is.numeric(probs) || any(!is.finite(probs) | probs < 0 | probs > 1)) {
    rlang::abort("Expected finite class probabilities between zero and one.")
  }
  if (length(outcome_levels) == 2L) {
    probs <- probs[, if (event_level == "first") 1L else 2L]
  }
  loss <- if (metric == "roc_auc") {
    1 - yardstick::roc_auc_vec(truth, probs, event_level = event_level, na_rm = FALSE)
  } else {
    yardstick::mn_log_loss_vec(truth, probs, event_level = event_level, na_rm = FALSE)
  }
  if (!is.finite(loss)) {
    rlang::abort("Assessment loss was not finite.")
  }
  loss
}
>>>>>>> Stashed changes
