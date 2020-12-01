#' Import latest tweets
#'
#' @param n
#'
#' @return
#'
#' @examples
import_latest_tweets <- function(n) {
  # Load Python module:
  reticulate::source_python(file.path(Sys.getenv("TRANSFORM_DIR"),"tweets_to_df.py"))
  dt <- data.table::data.table(import_latest_tweets(n)) # executes python function and imports output to R
  dt <- tryCatch(
    {
      # Pre-process hashtags:
      dt[,hashtags:=list(lapply(hashtags, function(i) lapply(i, function(j) j$text)))]
      dt <- dt[order(timestamp)]
      return(dt)
    },
    error = function(e) {
      warning("Tweet database returned no data.")
      return(data.table::data.table())
    }
  )
  return(dt)
}
