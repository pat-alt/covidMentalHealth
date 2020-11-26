import_covid <- function(n) {
  # Load Python module:
  reticulate::source_python(file.path(Sys.getenv("TRANSFORM_DIR"),"covid_to_df.py"))
  dt <- data.table::data.table(covid_from_mongo(n)) # executes python function and imports output to R
  return(dt)
}
