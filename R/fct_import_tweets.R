import_tweets <- function(n) {
  # Load Python module:
  transform <- reticulate::import_from_path("transform", Sys.getenv("TRANSFORM_DIR")) # loads python module
  dt <- data.table::data.table(transform$load_from_mongo(n)) # executes python function and imports output to R
  return(dt)
}
