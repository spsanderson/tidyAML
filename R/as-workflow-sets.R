#' Create a Workflow Set Object
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @seealso \url{https://workflowsets.tidymodels.org/}
#'
#' @description Create a workflow set object tibble from a model spec tibble.
#'
#' @details Create a `workflow set` object/tibble from a model spec tibble where
#' the object class type is `tidyaml_base_tbl`. This function will take in a list
#' of recipes and will grab the model specifications from the base tibble to
#' create the workflow sets object. You can also supply the logical of TRUE/FALSe
#' the `.cross` parameter which gets passed to the corresponding parameter as an
#' argumnt to the [workflowsets::workflow_set()] function.
#'
#' @param .model_tbl The model table that is generated from a function like
#' `fast_regression_parsnip_spec_tbl()`. The model spec column will be grabbed
#' automatically as the class of the object must be `tidyaml_base_tbl`
#' @param .recipe_list Provide a list of recipes here that will get added to the
#' workflow set object.
#' @param .cross The default is TRUE, can be set to FALSE. This is passed to the
#' `cross` parameter as an argument to the `workflow_set()` function.
#'
#' @examples
#' library(recipes)
#'
#' rec_obj <- recipe(mpg ~ ., data = mtcars)
#' spec_tbl <- fast_regression_parsnip_spec_tbl(
#'   .parsnip_fns = "linear_reg",
#'   .parsnip_eng = c("lm","glm")
#' )
#'
#' create_workflow_set(
#'   spec_tbl,
#'   list(rec_obj)
#' )
#'
#' @return
#' A list object of workflows.
#'
#' @name create_workflow_set
NULL

#' @export
#' @rdname create_workflow_set

# Create the workflow set object
create_workflow_set <- function(.model_tbl = NULL, .recipe_list = list(),
                                .cross = TRUE){

  # Tidyeval ----
  rec_list <- .recipe_list
  mod_tbl <- .model_tbl
  crs <- as.logical(.cross)

  # Checks ----
  # only keep() recipes
  rec_list <- purrr::keep(rec_list, ~ inherits(.x, "recipe"))

  # Does rec_list have something in it?
  if (length(rec_list) < 1 | is.null(rec_list)){
    rlang::abort(
      message = "You must pass as a list at least one recipe, like list(rec_obj)",
      use_cli_format = TRUE
    )
  }

  # Is the mod_tbl a class of `tidyaml_base_tbl`
  if (!inherits(mod_tbl, "tidyaml_base_tbl")){
    rlang::abort(
      message = "'.model_tbl' must be of class 'tidyaml_base_tbl'",
      use_cli_format = TRUE
    )
  }

  if (!is.logical(crs)){
    rlang::abort(
      message = "'.cross' must be a logical of TRUE/FALSE",
      use_cli_format = TRUE
    )
  }

  # Manipulation
  wflw_set <- workflowsets::workflow_set(
    preproc = rec_list,
    models = mod_tbl$model_spec,
    cross = crs
  )

  # Return ----
  return(wflw_set)

}
