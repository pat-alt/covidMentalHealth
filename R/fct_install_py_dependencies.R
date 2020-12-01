#' install_py_dependencies
#'
#' @param method Inherited from reticulate package
#' @param conda Inherited from reticulate package
#'
#' @description Wrapper function that can be used to conveniently install all Python dependencies.
#'
#' @return
#' @export

install_py_dependencies <- function(method = "auto", conda = "auto") {
  py_modules <- list(
    "pandas",
    "pymongo"
  )
  lapply(
    py_modules,
    function(module) {
      reticulate::py_install(module, method = method, conda = conda)
    }
  )
}
