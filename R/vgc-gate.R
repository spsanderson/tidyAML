#' Gate a candidate on validation score and rank stability
#'
#' Admit a candidate only if the validation ranking is sufficiently stable and
#' the candidate is no worse than the incumbent by more than the tolerance.
#' Tolerance is `.tau_min + (1 - .rho_hat) * (.tau_max - .tau_min)`.
#' A `FALSE` decision leaves fallback exploration to the caller.
#'
#' @param .incumbent_score,.candidate_score Numeric scalar validation scores on
#'   the same data and scale.
#' @param .rho_hat Rank-stability estimate in `[-1, 1]`, for example from
#'   [check_validation_stability()].
#' @param .tau_min,.tau_max Non-negative tolerance bounds in score units, with
#'   `.tau_min` no larger than `.tau_max`. Set them equal for a fixed tolerance.
#' @param .min_rho Minimum rank stability in `[0, 1]`.
#' @param .maximize Logical scalar. Use `FALSE` for losses such as RMSE.
#'
#' @return One logical value. `FALSE` includes abstention when a score or the
#'   stability estimate is missing or non-finite.
#' @examples
#' vgc_gate(0.82, 0.817, .rho_hat = 0.9)
#' vgc_gate(1.10, 1.05, .rho_hat = 0.8, .maximize = FALSE)
#' @export
vgc_gate <- function(.incumbent_score, .candidate_score, .rho_hat,
                     .tau_min = 0.002, .tau_max = 0.02, .min_rho = 0.6,
                     .maximize = TRUE) {
  check_audit_number(.tau_min, ".tau_min", min = 0)
  check_audit_number(.tau_max, ".tau_max", min = .tau_min)
  check_audit_number(.min_rho, ".min_rho", min = 0, max = 1)
  if (!is.logical(.maximize) || !is.null(dim(.maximize)) ||
    length(.maximize) != 1L || is.na(.maximize)) {
    rlang::abort("`.maximize` must be TRUE or FALSE.")
  }
  evidence <- list(
    .incumbent_score = .incumbent_score, .candidate_score = .candidate_score, .rho_hat = .rho_hat
  )
  purrr::iwalk(evidence, function(x, name) {
    if (length(x) != 1L || !(is_numeric_audit_column(x) || identical(x, NA))) {
      rlang::abort(paste0("`", name, "` must be one numeric value or NA."))
    }
  })
  if (is.finite(.rho_hat)) {
    check_audit_number(.rho_hat, ".rho_hat", min = -1, max = 1)
  }
  if (!all(is.finite(unlist(evidence))) || .rho_hat < .min_rho) {
    return(FALSE)
  }
  tolerance <- .tau_min + (1 - .rho_hat) * (.tau_max - .tau_min)
  if (.maximize) {
    .candidate_score >= .incumbent_score - tolerance
  } else {
    .candidate_score <= .incumbent_score + tolerance
  }
}
