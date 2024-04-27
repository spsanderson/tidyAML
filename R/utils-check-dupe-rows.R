#' Check for Duplicate Rows in a Data Frame
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function checks for duplicate rows in a data frame.
#'
#' @param .data A data frame.
#' @return A logical vector indicating whether each row is a duplicate or not.
#' @details This function checks for duplicate rows by comparing each row in the
#' data frame to every other row. If a row is identical to another row, it is
#' considered a duplicate.
#' @examples
#' data <- data.frame(
#'   x = c(1, 2, 3, 1),
#'   y = c(2, 3, 4, 2),
#'   z = c(3, 2, 5, 3)
#' )
#'
#' check_duplicate_rows(data)
#'
#' @seealso \code{\link{duplicated}}, \code{\link{anyDuplicated}}
#'
#' @name check_duplicate_rows
NULL

#' @rdname check_duplicate_rows
#' @export
check_duplicate_rows <- function(.data) {
  !apply(.data, 1, function(x) length(unique(x)) == ncol(.data))
}
