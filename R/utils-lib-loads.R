#' Functions to Install all Core Libraries
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details Lists the core packages necessary to run all potential modeling
#' algorithms.
#'
#' @description Lists the core packages necessary to run all potential modeling
#' algorithms.
#'
#' @examples
#' core_packages()
#'
#' @return
#' A character vector
#'
#' @name core_packages
NULL

#' @export
#' @rdname core_packages

core_packages <- function(){
  c(
    "multilevelmod","rules","poissonreg","censored","baguette","bonsai",
    "brulee","rstanarm","dbarts","kknn","ranger","randomForest",
    "LiblineaR","flexsurv","gee","glmnet",
    "discrim","klaR","kernlab","mda","sda","sparsediscrim",
    "liquidSVM"
  )
}

#' Functions to Install all Core Libraries
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details Installs all dependencies in the `core_packages()` function.
#'
#' @description Installs all dependencies in the `core_packages()` function.
#'
#' @examples
#' \dontrun{
#'   install_deps()
#' }
#'
#' @return
#' No return value, called for side effects
#'
#' @name install_deps
NULL

#' @export
#' @rdname install_deps

install_deps <- function(){

  ans <- utils::menu(c("Yes","No"), title = "Do you want to install all of the dependencies?")

  pkgs <- core_packages()

  if (ans == 1){

    # Loop through each name
    for (lib in pkgs){

      # check if already installed
      if (!require(lib, character.only = TRUE)){

        # If the library is not installed then install it
        utils::install.packages(lib, dependencies = TRUE)
      }
    }
  }
}

#' Functions to Install all Core Libraries
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details Load all the core packages necessary to run all potential modeling
#' algorithms.
#'
#' @description Load all the core packages necessary to run all potential modeling
#' algorithms.
#'
#' @examples
#' \dontrun{
#' load_deps()
#' }
#'
#' @return
#' No return value, called for side effects
#'
#' @name load_deps
NULL

#' @export
#' @rdname load_deps

load_deps <- function(){

  pkgs <- core_packages()

  pkgs_unloaded <- function(){
    search <- paste0("package:", pkgs)
    pkgs[!search %in% search()]
  }

  same_lib <- function(pkg){
    loc <- if (pkg %in% loadedNamespaces()) dirname(getNamespaceInfo(pkg, "path"))
    library(pkg, lib.loc = loc, character.only = TRUE, warn.conflicts = FALSE)
  }

  tidyaml_pkg_attach <- function(){
    to_load <- pkgs_unloaded()

    suppressPackageStartupMessages(lapply(to_load, same_lib))

    invisible(to_load)
  }

  pkgs_unloaded()
  tidyaml_pkg_attach()
}
