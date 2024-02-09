#' Create ggplot2 plot of regression predictions
#'
#' @family Plotting
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Create a ggplot2 plot of regression predictions.
#'
#' @details Create a ggplot2 plot of regression predictions, the actual, training,
#' and testing values. The output of this function can either be a list of plots
#' or a single faceted plot. This function takes the output of the function
#' `extract_wflw_pred()` function.
#'
#' @param .data The data from the output of the `extract_regression_residuals()`
#' function.
#' @param .output The default is "list" which will return a list of plots. The
#' other option is "facet" which will return a single faceted plot.
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
#' extract_wflw_pred(frt_tbl,1) |> plot_regression_predictions()
#' extract_wflw_pred(frt_tbl,1:nrow(frt_tbl)) |>
#'   plot_regression_predictions(.output = "facet")
#'
#' @return
#' A list of ggplot2 plots or a faceted plot.
#'
#' @name plot_regression_predictions
NULL

#' @export
#' @rdname plot_regression_predictions

plot_regression_predictions <- function(.data, .output = "list"){

  # Variables
  output <- tolower(.output)

  # Checks
  if (!output %in% c("list", "facet")) {
    rlang::abort(
      message = "output must be either 'list' or 'facet'.",
      use_last = TRUE
    )
  }

  if (!is.data.frame(.data)){
    rlang::abort(
      message = "data must be a data.frame/tibble.",
      use_last = TRUE
    )
  }

  if (!is.numeric(.data$.value)) {
    rlang::abort(
      message = ".value must be numeric.",
      use_last = TRUE
    )
  }

  # Plot
  if (output == "list") {
    p <- .data |>
      dplyr::group_split(.model_type) |>
      purrr::map(\(x) x |>
                   dplyr::group_by(.data_category) |>
                   dplyr::mutate(x = dplyr::row_number()) |>
                   dplyr::ungroup() |>
                   tidyr::pivot_wider(names_from = .data_type, values_from = .value) |>
                   ggplot2::ggplot(ggplot2::aes(x = x, y = actual, group = .data_category)) +
                   ggplot2::geom_line(color = "black") +
                   ggplot2::geom_line(ggplot2::aes(x = x, y = training),
                                      linetype = "dashed", color = "red",
                                      linewidth = 1) +
                   ggplot2::geom_line(ggplot2::aes(x = x, y = testing),
                                      linetype = "dashed", color = "blue",
                                      linewidth = 1) +
                   ggplot2::theme_minimal() +
                   ggplot2::labs(
                     x = "",
                     y = "Observed/Predicted Value",
                     title = "Observed vs. Predicted Values by Model Type",
                     subtitle = x$.model_type[1],
                     caption = "Black = Actual, Red = Training, Blue = Testing"
                   )
      )
  } else {

    df <- .data |>
      dplyr::group_by(.model_type, .data_category) |>
      dplyr::mutate(x = dplyr::row_number()) |>
      dplyr::ungroup()

    act_data <- dplyr::filter(df, .data_type == "actual")
    train_data <- dplyr::filter(df, .data_type == "training")
    test_data <- dplyr::filter(df, .data_type == "testing")

    p <- df |>
      dplyr::group_by(.model_type, .data_category) |>
      dplyr::mutate(x = dplyr::row_number()) |>
      dplyr::ungroup() |>
      ggplot2::ggplot(ggplot2::aes(x = x, y = .value)) +
      ggplot2::geom_line(data = act_data, color = "black") +
      ggplot2::geom_line(data = train_data, linetype = "dashed", color = "red") +
      ggplot2::geom_line(data = test_data, linetype = "dashed", color = "blue") +
      ggplot2::facet_wrap(~ .model_type, ncol = 2, scales = "free") +
      ggplot2::labs(
        x = "",
        y = "Observed/Predicted Value",
        title = "Observed vs. Predicted Values by Model Type",
        caption = "Black = Actual, Red = Training, Blue = Testing"
      ) +
      ggplot2::theme_minimal()
  }

  # Return
  return(p)
}
