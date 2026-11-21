step_lighttar_pls <- function(recipe, columns, outcome, num_comp) {
  recipes::add_step(recipe, recipes::step(
    subclass = "lighttar_pls",
    role = "predictor",
    trained = FALSE,
    columns = columns,
    outcome = outcome,
    num_comp = num_comp,
    rotation = NULL,
    skip = FALSE,
    id = recipes::rand_id("lighttar_pls")
  ))
}

#' @exportS3Method recipes::prep
prep.step_lighttar_pls <- function(x, training, info = NULL, ...) {
  embedding <- as.matrix(training[, x$columns, drop = FALSE])
  outcome <- training[[x$outcome]]
  if (!all(is.finite(embedding)) || !all(is.finite(outcome))) {
    rlang::abort("PLS requires finite embeddings and outcomes.")
  }

  n <- nrow(embedding)
  residual_x <- embedding
  residual_y <- outcome - mean(outcome)
  rotation <- loadings <- matrix(numeric(), nrow = ncol(embedding), ncol = 0L)
  for (i in seq_len(min(x$num_comp, ncol(embedding), n - 1L))) {
    # In the current row space, shrink X'y by (I + gamma X'X/n)^-1.
    # Using the thin SVD avoids forming the full predictor covariance matrix.
    decomp <- svd(residual_x)
    direction <- decomp$v %*%
      (decomp$d * crossprod(decomp$u, residual_y) / (1 + 60 * (decomp$d / n)^2))
    magnitude <- sqrt(sum(direction^2))
    if (magnitude <= sqrt(.Machine$double.eps)) break
    direction <- direction / magnitude
    scores <- residual_x %*% direction
    sum_squares <- sum(scores^2)
    if (sum_squares <= .Machine$double.eps) break

    loading <- crossprod(residual_x, scores) / sum_squares
    # Express the direction in the original embedding coordinates for bake().
    rotation <- cbind(rotation, direction - rotation %*% crossprod(loadings, direction))
    loadings <- cbind(loadings, loading)
    residual_x <- residual_x - tcrossprod(scores, loading)
    residual_y <- residual_y - drop(scores * (crossprod(scores, residual_y) / sum_squares)[1L])
  }

  colnames(rotation) <- if (ncol(rotation)) paste0("pls_", seq_len(ncol(rotation)))
  x$rotation <- rotation
  x$trained <- TRUE
  x
}

#' @exportS3Method recipes::bake
bake.step_lighttar_pls <- function(object, new_data, ...) {
  recipes::check_new_data(object$columns, object, new_data)
  output <- colnames(object$rotation)
  if (any(output %in% names(new_data))) {
    rlang::abort("PLS component names conflict with existing columns.")
  }
  if (length(output)) {
    scores <- as.matrix(new_data[, object$columns, drop = FALSE]) %*% object$rotation
    new_data[output] <- dplyr::as_tibble(scores)
  }
  new_data
}

#' @exportS3Method recipes::tidy
tidy.step_lighttar_pls <- function(x, ...) {
  if (!x$trained) return(dplyr::tibble(terms = x$columns, id = x$id))
  components <- colnames(x$rotation)
  dplyr::tibble(
    terms = rep(x$columns, times = length(components)),
    component = rep(components, each = length(x$columns)),
    value = as.vector(x$rotation),
    id = x$id
  )
}

