complete_dt <-  function(dt, x_cols, y_cols) {
  dt_x <- unique(dt[,.SD,.SDcols=x_cols])
  dt_y <- unique(dt[,.SD,.SDcols=y_cols])
  rows <- do.call(data.table::CJ, lapply(list(dt_x, dt_y), function(x) if(is.data.frame(x)) seq_len(nrow(x)) else seq_along(x)));
  dt_cj <- do.call(data.table::data.table, Map(function(x, y) x[y], list(dt_x, dt_y), rows))
  merge(dt, dt_cj, by=c(x_cols,y_cols), all.y = T)
}
