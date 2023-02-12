#' Match function arguments
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Match a functions arguments.
#'
#' @details Match a functions arguments, the bad ones passed will be rejected but
#' the remaining passing ones will be returned.
#'
#' @param f The parsnip function such as `"linear_reg"` as a string and without
#' the parentheses.
#' @param args The arguments you want to supply to `f`
#'
#' @examples
#' library(parsnip)
#'
#' match_args(
#'   f = "linear_reg",
#'   args = list(
#'     mode = "regression",
#'     engine = "lm",
#'     trees = 1,
#'     mtry = 1
#'    )
#'  )
#'
#' @return
#' A list of matched arguments.
#'
#' @name match_args
NULL

#' @export
#' @rdname match_args

match_args <- function(f, args) {
  formal_names <- names(formals(f, envir = parent.frame()))
  matching_args <- names(args) %in% formal_names

  if (! all(matching_args)) {
    bad_arg_names <- unique(names(args)[! matching_args])
    rlang::inform(
      message = paste0("bad arguments passed: ", bad_arg_names),
      use_cli_format = TRUE
    )
  }

  args[matching_args]
}
