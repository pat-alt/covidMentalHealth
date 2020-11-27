import_covid <- function(from_date=NULL, to_date=NULL) {
  # Load Python module:
  reticulate::source_python(file.path(Sys.getenv("TRANSFORM_DIR"),"covid_to_df.py"))
  dt <- data.table::data.table(covid_from_mongo()) # executes python function and imports output to R
  dt[,date:=as.Date(last_update, format="%Y-%m-%dT%H:%M:%S")]
  dt[,last_update:=NULL]
  # Remove duplicate dates:
  dt <- dt[,.(cases=max(cases), deaths=max(deaths), recovered=max(recovered)), by=.(country, date)]
  data.table::setkey(dt, date, country)
  # Complete table:
  dt_compl <- dt[,data.table::CJ(date, country, unique = T)]
  data.table::setkey(dt_compl, date, country)
  dt <- dt[dt_compl]
  return(dt)
}
