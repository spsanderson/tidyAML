#' Perform quantile normalization on a numeric matrix/data.frame
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description This function will perform quantile normalization on two or more
#' distributions of equal length. Quantile normalization is a technique used to make the distribution of values across different samples
#' more similar. It ensures that the distributions of values for each sample have the same quantiles.
#' This function takes a numeric matrix as input and returns a quantile-normalized matrix.
#'
#' @param .data A numeric matrix where each column represents a sample.
#' @param .return_tibble A logical value that determines if the output should be a tibble. Default is 'FALSE'.
#'
#' @return A list object that has the following:
#' \enumerate{
#'  \item A numeric matrix that has been quantile normalized.
#'  \item The row means of the quantile normalized matrix.
#'  \item The sorted data
#'  \item The ranked indices
#' }
#'
#' @details
#' This function performs quantile normalization on a numeric matrix by following these steps:
#' \enumerate{
#'   \item Sort each column of the input matrix.
#'   \item Calculate the mean of each row across the sorted columns.
#'   \item Replace each column's sorted values with the row means.
#'   \item Unsort the columns to their original order.
#' }
#'
#' @examples
#' # Create a sample numeric matrix
#' data <- matrix(rnorm(20), ncol = 4)
#'
#' # Perform quantile normalization
#' normalized_data <- quantile_normalize(data)
#' normalized_data
#'
#' as.data.frame(normalized_data$normalized_data) |>
#'   sapply(function(x) quantile(x, probs = seq(0, 1, 1 / 4)))
#'
#' quantile_normalize(data, .return_tibble = TRUE)
#'
#' @seealso
#' \code{\link{rowMeans}}: Calculate row means.
#'
#' \code{\link{apply}}: Apply a function over the margins of an array.
#'
#' \code{\link{order}}: Order the elements of a vector.
#'
#' @name quantile_normalize
NULL

#' @export
#' @rdname quantile_normalize
# Perform quantile normalization on a numeric matrix 'data_matrix'
quantile_normalize <- function(.data, .return_tibble = FALSE) {
  # Checks ----
  if (!inherits(.data, c("matrix", "data.frame"))) {
    rlang::abort(
      message = "The input data must be a numeric matrix or data.frame.",
      use_cli_format = TRUE
    )
  }

  if (!all(sapply(.data, is.numeric))) {
    rlang::abort(
      message = "The input data must be a numeric matrix or data.frame.",
      use_cli_format = TRUE
    )
  }

  # Data ----
  # Get col_nms
  col_nms <- colnames(.data)
  data_matrix <- as.matrix(.data)

  # Step 1: Sort each column
  sorted_data <- apply(data_matrix, 2, sort)

  # Step 2: Calculate the mean of each row across sorted columns
  row_means <- rowMeans(sorted_data)

  # Step 3: Replace each column's sorted values with the row means
  sorted_data <- matrix(
    row_means,
    nrow = nrow(sorted_data),
    ncol = ncol(sorted_data),
    byrow = TRUE
  )

  # Step 4: Unsort the columns to their original order
  # Get rank index
  rank_indices <- apply(data_matrix, 2, order)

  # Get duplicated rank indices, get the complete data for rows that have a
  # duplicated rank
  duplicated_ranks <- rank_indices[check_duplicate_rows(rank_indices), ]

  # Get duplicated rank vector, get the row indices that have duplicated ranks
  duplicated_rank_vector <- which(check_duplicate_rows(rank_indices))

  # Get duplicated rank data
  duplicated_rank_data <- data_matrix[duplicated_rank_vector, ]

  # Normalize the data
  normalized_data <- matrix(nrow = nrow(data_matrix), ncol = ncol(data_matrix))
  for (i in 1:ncol(data_matrix)) {
    normalized_data[, i] <- sorted_data[rank_indices[, i], i]
  }

  # Add Column Names to all items
  colnames(normalized_data) <- col_nms
  colnames(sorted_data) <- col_nms

  # Should output be a tibble?
  if (.return_tibble) {
    normalized_data <- dplyr::as_tibble(normalized_data, .name_repair = "universal")
    row_means <- dplyr::as_tibble(row_means)
    #sorted_data <- dplyr::as_tibble(sorted_data)
    #rank_indices <- dplyr::as_tibble(rank_indices)
    duplicated_ranks <- dplyr::as_tibble(duplicated_ranks)
    duplicated_rank_data <- dplyr::as_tibble(duplicated_rank_data)
    duplicated_rank_vector <- dplyr::as_tibble(duplicated_rank_vector) |>
      dplyr::rename(row_index = value)
  }

  # Return ----
  if (length(duplicated_rank_vector > 0)) {
    rlang::warn(
      message = "There are duplicated ranks the input data.",
      use_cli_format = TRUE
    )
  }

  return(
    list(
      normalized_data = normalized_data,
      row_means = row_means,
      #sorted_data = sorted_data,
      #column_rank_indices = rank_indices,
      duplicated_ranks = duplicated_ranks,
      duplicated_rank_row_indices = duplicated_rank_vector,
      duplicated_rank_data = duplicated_rank_data
    )
  )
}
