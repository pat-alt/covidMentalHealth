#' Title
#'
#' @param n
#'
#' @importFrom data.table :=
#'
#' @return
#'
#' @examples
import_latest_tweets <- function(n) {
  # Load Python module:
  reticulate::source_python(file.path(Sys.getenv("TRANSFORM_DIR"),"tweets_to_df.py"))
  dt <- data.table::data.table(import_latest_tweets(n)) # executes python function and imports output to R
  return(dt)
}
