#' Title
#'
#' @param n
#'
#' @importFrom data.table :=
#'
#' @return
#'
#' @examples
import_tweets <- function(n) {
  # Load Python module:
  reticulate::source_python(file.path(Sys.getenv("TRANSFORM_DIR"),"tweets_to_df.py"))
  dt <- data.table::data.table(tweets_from_mongo(n)) # executes python function and imports output to R
  return(dt)
}
