#' Internals Make a Model Spec tibble
#'
#' @family Internals
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Make a Model Spec tibble.
#'
#' @details Make a Model Spec tibble.
#'
#' @param .data This is the data that should be coming from inside of the regression/classification
#' to parsnip spec functions.
#'
#' @examples
#' make_regression_base_tbl() %>%
#'   internal_make_spec_tbl()
#'
#' make_classification_base_tbl() %>%
#'   internal_make_spec_tbl()
#'
#' @return
#' A model spec tbl.
#'
#' @name internal_make_spec_tbl
NULL

#' @export
#' @rdname internal_make_spec_tbl

internal_make_spec_tbl <- function(.data){

  # Checks ----
  #df <- dplyr::as_tibble(.data)
  df <- .data
  # nms <- unique(names(df))
  #
  # if (!".parsnip_engine" %in% nms | !".parsnip_mode" %in% nms | !".parsnip_fns" %in% nms){
  #   rlang::abort(
  #     message = "The model tibble must come from the class/reg to parsnip function.",
  #     use_cli_format = TRUE
  #   )
  # }

  if (!inherits(df, "tidyaml_base_tbl")){
    rlang::abort(
      message = "The model tibble must come from the make base tbl function.",
      use_cli_format = TRUE
    )
  }

  # Make tibble ----
  mod_spec_tbl <- df %>%
    dplyr::mutate(
      model_spec = purrr::pmap(
        dplyr::cur_data(),
        ~ match.fun(..3)(mode = ..2, engine = ..1)
      )
    ) %>%
    # add .model_id column
    dplyr::mutate(.model_id = dplyr::row_number()) %>%
    dplyr::select(.model_id, dplyr::everything())

  # Return ----
  return(mod_spec_tbl)

}
