# Loading Python dependencies

# global reference to scipy (will be initialized in .onLoad)
pymongo <- NULL
pandas <- NULL

.onLoad <- function(libname, pkgname) {
  # use superassignment to update global reference to scipy
  pandas <<- reticulate::import("pandas", delay_load = TRUE)
  pymongo <<- reticulate::import("pymongo", delay_load = TRUE)
}
