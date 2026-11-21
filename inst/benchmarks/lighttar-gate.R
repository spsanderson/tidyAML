# Run after installing tidyAML: Rscript inst/benchmarks/lighttar-gate.R
# The corpus is synthetic and the timing is illustrative, not a generalization claim.
seed <- 280L
vocab <- c(
  "appointment", "assessment", "authorization", "balance", "benefit", "billing",
  "calendar", "callback", "care", "case", "claim", "clinic", "code", "contact",
  "coverage", "date", "delivery", "document", "eligibility", "estimate", "fax",
  "followup", "form", "guideline", "history", "identifier", "invoice", "letter",
  "location", "message", "note", "office", "order", "payment", "plan", "policy",
  "record", "referral", "reminder", "request", "review", "schedule", "service",
  "status", "summary", "support", "update", "visit"
)
emb_cols <- paste0("term_", seq_along(vocab))
data <- withr::with_seed(seed, {
  n <- 240L
  counts <- matrix(stats::rpois(n * length(vocab), lambda = 2), nrow = n)
  counts[, 2L] <- counts[, 1L] + stats::rbinom(n, 1, 0.5)
  text <- apply(counts, 1L, function(x) paste(rep(vocab, x), collapse = " "))
  tokens <- strsplit(text, " ", fixed = TRUE)
  embeddings <- t(vapply(tokens, function(x) {
    tabulate(match(x, vocab), nbins = length(vocab))
  }, integer(length(vocab))))
  colnames(embeddings) <- emb_cols
  duration <- 8 + 3 * (counts[, 2L] - counts[, 1L]) + stats::rnorm(n, sd = 0.15)
  dplyr::bind_cols(dplyr::tibble(duration = duration), dplyr::as_tibble(embeddings))
})

has_xgboost <- requireNamespace("xgboost", quietly = TRUE)
has_ranger <- requireNamespace("ranger", quietly = TRUE)
engines <- c("lm", if (has_xgboost) "xgboost", if (has_ranger) "ranger")
gate_engine <- if (has_xgboost) "xgboost" else "lm"
outer <- withr::with_seed(seed, rsample::initial_split(data))
truth <- rsample::assessment(outer)$duration

benchmark <- function(arm, s_pls) {
  recipe <- tidyAML::make_lighttar_recipe(data, "duration", emb_cols, .s_pls = s_pls)
  elapsed <- system.time({
    fit <- withr::with_seed(seed, tidyAML::fast_regression(data, recipe, .parsnip_eng = engines))
  })[["elapsed"]]
  stopifnot(nrow(fit) == length(engines))
  rmse <- vapply(seq_len(nrow(fit)), function(i) {
    pred <- tidyAML::extract_wflw_pred(fit, .model_id = i)
    estimate <- pred$.value[pred$.data_type == "testing"]
    yardstick::rmse_vec(truth, estimate)
  }, numeric(1))
  list(
    scores = dplyr::tibble(recipe = arm, engine = fit$.parsnip_engine, test_rmse = rmse),
    timing = dplyr::tibble(recipe = arm, grid_elapsed_seconds = elapsed)
  )
}

pca <- benchmark("pca", 0L)
lighttar <- benchmark("lighttar", 5L)
elapsed_gate <- system.time({
  gated <- tidyAML::gated_fast_regression(data, "duration", emb_cols,
    .gate_eng = gate_engine, .parsnip_eng = engines, .seed = seed
  )
})[["elapsed"]]
cat("R:", R.version.string, "\n")
cat(
  "Inner gate:", gate_engine, "selected", attr(gated, ".lighttar_selected"),
  "in", elapsed_gate, "seconds (including the final grid)\n"
)
print(aggregate(rmse ~ recipe, attr(gated, ".lighttar_gate"), mean))
print(dplyr::bind_rows(pca$scores, lighttar$scores))
print(dplyr::bind_rows(pca$timing, lighttar$timing))
