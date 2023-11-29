# On library attachment, print message to user.
.onAttach <- function(libname, pkgname) {
  msg <- paste0(
    "\n",
    "== Welcome to tidyAML ===========================================================================",
    "\nIf you find this package useful, please leave a star: ",
    "\n   https://github.com/spsanderson/tidyAML'",
    "\n",
    "\nIf you encounter a bug or want to request an enhancement please file an issue at:",
    "\n   https://github.com/spsanderson/tidyAML/issues",
    "\n",
    "\nIt is suggested that you run tidymodels::tidymodel_prefer() to set the defaults for your session.",
    "\n",
    "\nThank you for using tidyAML!",
    "\n"
  )

  packageStartupMessage(msg)
}
