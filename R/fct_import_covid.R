import_covid <- function(from_date=NULL, to_date=NULL) {
  # Load Python module:
  reticulate::source_python(file.path(Sys.getenv("TRANSFORM_DIR"),"covid_to_df.py"))
  dt <- data.table::data.table(covid_from_mongo()) # executes python function and imports output to R
  dt <- tryCatch(
    {
      dt[,date:=as.Date(last_update, format="%Y-%m-%dT%H:%M:%S")]
      dt[,last_update:=NULL]
      # Remove duplicate dates:
      dt[,(c("cases", "deaths", "recovered")) := .(
        cases=max(cases, na.rm = T),
        deaths=max(deaths, na.rm = T),
        recovered=max(recovered, na.rm = T)
      ), by=.(country, date)]
      data.table::setkey(dt, date, country)
      # Complete table:
      dt <- complete_dt(dt, c("country", "country_name"), c("date"))
      dt[,cases:=zoo::na.locf(cases, na.rm = F), by=.(country)]
      dt[,deaths:=zoo::na.locf(deaths, na.rm = F), by=.(country)]
      dt[,recovered:=zoo::na.locf(recovered, na.rm = F), by=.(country)]
      return(dt)
    },
    error = function(e) {
      warning("COVID database returned no data.")
      return(data.table::data.table())
    }
  )
  return(dt)
}
