import_tweets <- function(n) {
  # Load Python module:
  reticulate::source_python(file.path(Sys.getenv("TRANSFORM_DIR"),"transform.py"))
  dt <- data.table::data.table(load_from_mongo(n)) # executes python function and imports output to R
  return(dt)
}
