#' Utility Create Splits Object
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Create a splits object.
#'
#' @details Create a splits object that returns a list object of both the
#' splits object itself and the splits type. This function supports all splits
#' types from the `rsample` package.
#'
#' @param .data The data being passed to make a split on
#' @param .split_type The default is "initial_split", you can pass any other split
#' type from the `rsample` library.
#' @param .split_args The default is NULL in order to use the default split arguments.
#' If you want to pass other arguments then must pass a list with the parameter name
#' and the argument.
#'
#' @examples
#' create_splits(mtcars, .split_type = "vfold_cv")
#'
#' @return
#' A list object
#'
#' @name create_splits
NULL

#' @export
#' @rdname create_splits

create_splits <- function(.data, .split_type = "initial_split",
                          .split_args = NULL){

  # Tidyeval ----
  split_type <- tolower(as.character(.split_type))

  # Checks ----
  if (is.null(.split_args)){
    .split_args <- list()
  }

  if (!inherits(.split_args, "list")){
    rlang::abort(
      message = "'.split_args' must be a 'list' of cross validation arguments.",
      use_cli_format = TRUE
    )
  }

  # Manipulation ----
  split_func <- utils::getFromNamespace(split_type, asNamespace("rsample"))
  splits_obj <- do.call(split_func, append(list(data = .data), .split_args))

  splits_tbl <- dplyr::tibble(splits = list(splits_obj), id = .split_type)

  # Return ----
  return(list(splits = splits_obj, split_type = .split_type))
}
