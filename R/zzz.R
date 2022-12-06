# On library attachment, print message to user.
.onAttach <- function(libname, pkgname) {
  msg <- paste0(
    "\n",
    "== Welcome to tidyaml ===========================================================================",
    "\nIf you find this package useful, please leave a star: ",
    "\n   https://github.com/spsanderson/tidyaml'",
    "\n",
    "\nIf you encounter a bug or want to request an enhancement please file an issue at:",
    "\n   https://github.com/spsanderson/tidyaml/issues",
    "\n",
    "\nThank you for using tidyaml!",
    "\n"
  )

  packageStartupMessage(msg)
}
