# Shared validation for the audit helpers and the LightTAR recipe.
unique_audit_names <- function(x) {
  is.character(x) && length(x) > 0L && !anyNA(x) && all(nzchar(x)) && !anyDuplicated(x)
}

is_numeric_audit_column <- function(x) {
  is.numeric(x) && !is.complex(x) && is.null(dim(x))
}

check_audit_number <- function(x, arg, min = -Inf, max = Inf, integer = FALSE) {
  if (!is_numeric_audit_column(x) || length(x) != 1L || !is.finite(x) || x < min || x > max ||
    (integer && (x != trunc(x) || abs(x) > .Machine$integer.max))) {
    kind <- if (integer) "integer" else "number"
    rlang::abort(paste0("`", arg, "` must be a finite ", kind, " in [", min, ", ", max, "]."))
  }
  invisible(x)
}

check_audit_outcome <- function(data, outcome, regression = FALSE) {
  if (!is.data.frame(data) || nrow(data) < 2L || !unique_audit_names(names(data))) {
    rlang::abort("Data must be a data frame with at least two rows and unique column names.")
  }
  if (!unique_audit_names(outcome) || length(outcome) != 1L || !outcome %in% names(data)) {
    rlang::abort("`.outcome_var` must name one existing outcome column.")
  }
  y <- data[[outcome]]
  if (!is_numeric_audit_column(y) && (regression || !is.factor(y))) {
    type <- if (regression) "numeric" else "numeric or factor"
    rlang::abort(paste("The outcome column must be a", type, "vector."))
  }
  invisible(y)
}

with_audit_seed <- function(seed, code) {
  if (is.null(seed)) {
    return(force(code))
  }
  check_audit_number(seed, ".seed", integer = TRUE)
  withr::with_seed(seed, code)
}
