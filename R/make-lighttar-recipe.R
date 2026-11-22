#' Build a LightTAR-style recipe for numeric embeddings
#'
#' Replace embedding columns with PCA features and a separate block of
#' regularized partial least squares (PLS) features. Both blocks start from the
#' same standardized embeddings. Only PLS uses the outcome. All projections
#' are estimated by [recipes::prep()] on its training rows and applied by
#' [recipes::bake()] without the outcome. Other columns are preserved.
#'
#' @param .data A data frame containing embeddings, an outcome, and any other
#'   predictors. Supply precomputed numeric embeddings; no encoder is run.
#' @param .outcome_var Name of one numeric or factor outcome column.
#' @param .emb_cols Nonempty character vector of unique numeric embedding
#'   column names, excluding the outcome.
#' @param .u_pca Positive integer: maximum number of PCA components.
#' @param .s_pls Non-negative integer: maximum number of supervised components.
#'   Set to `0` for PCA only.
#' @param .m Non-negative input-variance weight. The fitted PLS penalty is
#'   `.m / n`, where `n` is the number of training rows. Use `0` for plain PLS.
#'
#' @details This single-embedding-block version of LightTAR uses the same
#'   columns for PCA and PLS. Constant embedding columns contribute no
#'   variation; at least one column must vary. The number of components may
#'   be smaller than requested if training data are rank deficient or the
#'   supervised deflation has no signal left. The PCA and PLS blocks are not
#'   jointly orthogonal; choose `.u_pca` below the embedding rank if you want
#'   to leave room for additional signal. Embeddings and training outcomes
#'   must be finite and complete (factors must have no missing values).
#' @return An untrained [recipes::recipe()] that creates `pca_` and, where
#'   applicable, `pls_` predictors.
#' @references Shapira et al., LightTAR: Light and Fast Target-Aware
#'   Representations for Multimodal Tabular Learning, <https://arxiv.org/abs/2611.17600>.
#' @examples
#' rec <- make_lighttar_recipe(mtcars, "mpg", c("disp", "hp", "wt"), 2, 1)
#' trained <- recipes::prep(rec, training = mtcars[1:24, ])
#' recipes::bake(trained, new_data = mtcars[25:32, ])
#' @export
make_lighttar_recipe <- function(.data, .outcome_var, .emb_cols,
                                 .u_pca = 30L, .s_pls = 5L, .m = 60) {
  check_audit_outcome(.data, .outcome_var)
  .data <- dplyr::as_tibble(.data)
  if (!unique_audit_names(.emb_cols) || any(!.emb_cols %in% names(.data))) {
    rlang::abort("`.emb_cols` must contain unique, existing column names with none missing.")
  }
  if (.outcome_var %in% .emb_cols) {
    rlang::abort("`.emb_cols` cannot include the outcome column.")
  }
  if (!all(purrr::map_lgl(.data[.emb_cols], is_numeric_audit_column))) {
    rlang::abort("All embedding columns must be numeric vectors.")
  }
  check_audit_number(.u_pca, ".u_pca", min = 1, integer = TRUE)
  check_audit_number(.s_pls, ".s_pls", min = 0, integer = TRUE)
  check_audit_number(.m, ".m", min = 0)

  roles <- ifelse(names(.data) == .outcome_var, "outcome", "predictor")
  rec <- recipes::recipe(.data, vars = names(.data), roles = roles)
  step <- recipes::step(
    subclass = "lighttar", role = "predictor", trained = FALSE, skip = FALSE,
    id = recipes::rand_id("lighttar"), columns = .emb_cols, outcome = .outcome_var,
    u_pca = .u_pca, s_pls = .s_pls, m = .m
  )
  recipes::add_step(rec, step)
}

#' @export
#' @importFrom recipes prep
prep.step_lighttar <- function(x, training, info = NULL, ...) {
  embedding <- as.matrix(training[, x$columns, drop = FALSE])
  if (nrow(embedding) < 2L || any(!is.finite(embedding))) {
    rlang::abort("LightTAR needs at least two training rows with finite embeddings.")
  }
  center <- colMeans(embedding)
  centered <- sweep(embedding, 2L, center, "-")
  scale <- sqrt(colMeans(centered^2))
  scale[scale == 0] <- 1
  z <- sweep(centered, 2L, scale, "/")
  pca <- svd(z, nu = 0L, nv = min(x$u_pca, dim(z)))
  rank <- sum(pca$d > pca$d[1L] * max(dim(z)) * .Machine$double.eps)
  if (rank < 1L) {
    rlang::abort("LightTAR cannot fit when all embedding columns are constant.")
  }
  anchor <- pca$v[, seq_len(min(rank, x$u_pca)), drop = FALSE]
  colnames(anchor) <- paste0("pca_", seq_len(ncol(anchor)))
  rotation <- anchor
  if (x$s_pls > 0) {
    target <- lighttar_target(training[[x$outcome]])
    pls <- lighttar_pls(z, target, min(rank, x$s_pls), x$m / nrow(z))
    colnames(pls) <- paste0("pls_", seq_len(ncol(pls)))
    rotation <- cbind(anchor, pls)
  }
  check_lighttar_names(colnames(rotation), names(training))
  x$center <- center
  x$scale <- scale
  x$rotation <- rotation
  x$trained <- TRUE
  x
}

#' @export
#' @importFrom recipes bake
bake.step_lighttar <- function(object, new_data, ...) {
  missing <- setdiff(object$columns, names(new_data))
  if (length(missing) > 0L) {
    rlang::abort(paste("Missing embedding columns:", paste(missing, collapse = ", ")))
  }
  check_lighttar_names(colnames(object$rotation), names(new_data))
  embedding <- as.matrix(new_data[, object$columns, drop = FALSE])
  if (!is.numeric(embedding) || any(!is.finite(embedding))) {
    rlang::abort("LightTAR needs finite numeric embeddings when baking.")
  }
  z <- scale(embedding, center = object$center, scale = object$scale)
  features <- dplyr::as_tibble(z %*% object$rotation)
  dplyr::bind_cols(new_data[, setdiff(names(new_data), object$columns)], features)
}

#' @export
#' @importFrom recipes tidy
tidy.step_lighttar <- function(x, ...) {
  if (!x$trained) {
    return(dplyr::tibble(terms = x$columns, value = NA_real_, component = NA_character_, id = x$id))
  }
  dplyr::tibble(
    terms = rep(x$columns, ncol(x$rotation)), value = as.vector(x$rotation),
    component = rep(colnames(x$rotation), each = length(x$columns)), id = x$id
  )
}

#' @export
print.step_lighttar <- function(x, ...) {
  cat("LightTAR projection of ", paste(x$columns, collapse = ", "),
    if (x$trained) " [trained]" else "", "\n",
    sep = ""
  )
  invisible(x)
}

#' @export
#' @importFrom recipes required_pkgs
required_pkgs.step_lighttar <- function(x, ...) {
  "tidyAML"
}

# Center and scale a numeric outcome or factor indicators, dropping constants.
lighttar_target <- function(y) {
  if (anyNA(y) || (is.numeric(y) && any(!is.finite(y)))) {
    rlang::abort("LightTAR needs a complete, finite training outcome.")
  }
  y <- if (is.factor(y)) outer(as.integer(y), seq_len(nlevels(y)), `==`) * 1 else as.matrix(y)
  y <- sweep(y, 2L, colMeans(y), "-")
  sd <- sqrt(colMeans(y^2))
  varies <- sd > 0
  if (any(varies)) sweep(y[, varies, drop = FALSE], 2L, sd[varies], "/") else y[, FALSE]
}

# Leading right singular vector of the stacked matrix solves the regularized
# covariance objective without forming a square matrix of embedding width.
lighttar_pls <- function(z, y, ncomp, gamma) {
  n <- nrow(z)
  rotation <- loadings <- matrix(0, ncol(z), ncomp)
  if (ncol(y) == 0L) {
    return(rotation[, FALSE, drop = FALSE])
  }
  used <- 0L
  tolerance <- sqrt(sum(z^2)) * max(dim(z)) * .Machine$double.eps
  for (j in seq_len(ncomp)) {
    xy <- crossprod(y, z) / n
    target_signal <- if (gamma > 0) rbind(xy, sqrt(gamma / n) * z) else xy
    if (max(abs(target_signal)) <= .Machine$double.eps) {
      break
    }
    w <- svd(target_signal, nu = 0L, nv = 1L)$v[, 1L]
    t <- drop(z %*% w)
    energy <- sum(t^2)
    if (sqrt(energy) <= tolerance) {
      break
    }
    p <- drop(crossprod(z, t)) / energy
    q <- drop(crossprod(y, t)) / energy
    prev <- seq_len(used)
    rotation[, j] <- w - drop(rotation[, prev, drop = FALSE] %*%
      crossprod(loadings[, prev, drop = FALSE], w))
    loadings[, j] <- p
    z <- z - tcrossprod(t, p)
    y <- y - tcrossprod(t, q)
    used <- j
  }
  rotation[, seq_len(used), drop = FALSE]
}

check_lighttar_names <- function(generated, existing) {
  conflict <- intersect(generated, existing)
  if (length(conflict) > 0L) {
    rlang::abort(paste("LightTAR output names already exist:", paste(conflict, collapse = ", ")))
  }
}
