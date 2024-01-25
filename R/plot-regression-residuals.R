#' Create ggplot2 plot of regression residuals
#'
#' @family Plotting
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Create a ggplot2 plot of regression residuals.
#'
#' @details Create a ggplot2 plot of regression residuals. The output of this
#' function can either be a list of plots or a single faceted plot. This function
#' takes the output of the `extract_regression_residuals()` function.
#'
#' @param .data The data from the output of the `extract_regression_residuals()`
#' function.
#'
#' @examples
#' library(recipes)
#'
#' rec_obj <- recipe(mpg ~ ., data = mtcars)
#' frt_tbl <- fast_regression(
#'   mtcars,
#'   rec_obj,
#'   .parsnip_eng = c("lm","glm"),
#'   .parsnip_fns = "linear_reg"
#'   )
#'
#' extract_regression_residuals(frt_tbl, FALSE)[1] |> plot_regression_residuals()
#' extract_regression_residuals(frt_tbl, TRUE)[1] |> plot_regression_residuals()
#'
#' @return
#' A list of ggplot2 plots or a faceted plot.
#'
#' @name plot_regression_residuals
NULL

#' @export
#' @rdname plot_regression_residuals

plot_regression_residuals <- function(.data) {

  # Variables
  nms <- names(.data[[1]])

  # Checks
  if (!inherits(.data, "list")) {
    rlang::abort(
      message = "Input must be a list.",
      use_last = TRUE
    )
  }

  if (identical(nms, c(".model_type","name","value"))){
    plt_type = "long"
  }

  if (identical(nms, c(".model_type",".actual",".predicted",".resid"))){
    plt_type = "wide"
  }

  # Manipulation
  if (plt_type == "long"){
    plt <- .data |>
      purrr::map(
        \(x) x |>
          dplyr::group_by(name) |>
          dplyr::mutate(x = dplyr::row_number()) |>
          dplyr::ungroup() |>
          dplyr::mutate(plot_group = ifelse(name == ".resid", "Residuals", "Actual and Predictions")) |>
          ggplot2::ggplot(ggplot2::aes(x = x, y = value, group = name, color = name)) +
          ggplot2::geom_line() +
          ggplot2::theme_minimal() +
          ggplot2::facet_wrap(~ plot_group, ncol = 1, scales = "free") +
          ggplot2::labs(
            x = "",
            y = "Value",
            title = "Actual, Predicted, and Residual Values by Model Type",
            subtitle = x$.model_type[1],
            color = "Data Type"
          )
      )
  }

  if (plt_type == "wide"){
    plt <- .data |>
      purrr::map(
        \(x) x |>
          tidyr::pivot_longer(
            cols = -.model_type
          ) |>
          dplyr::group_by(name) |>
          dplyr::mutate(x = dplyr::row_number()) |>
          dplyr::ungroup() |>
          dplyr::mutate(plot_group = ifelse(name == ".resid", "Residuals", "Actual and Predictions")) |>
          ggplot2::ggplot(ggplot2::aes(x = x, y = value, group = name, color = name)) +
          ggplot2::geom_line() +
          ggplot2::theme_minimal() +
          ggplot2::facet_wrap(~ plot_group, ncol = 1, scales = "free") +
          ggplot2::labs(
            x = "",
            y = "Value",
            title = "Actual, Predicted, and Residual Values by Model Type",
            subtitle = x$.model_type[1],
            color = "Data Type"
          )
      )
  }

  # Return
  return(plt)
}
