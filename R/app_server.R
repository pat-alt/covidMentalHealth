#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Set-up:
  reticulate::use_python('/usr/bin/python')
  covid <<- import_covid() # Covid data is sourced into memory once as it is not very large and this speeds up other processes
  world_map <<- data.table::data.table(ggplot2::map_data("world")) # Load world map data on start up
  # Custome plot theme:
  ggplot2::theme_set(theme_covid_mental()) # global plot theme
  # List the first level callModules here
  callModule(mod_at_a_glance_server, "at_a_glance")
  callModule(mod_covid_server, "covid")
  callModule(mod_mental_server, "mental")
  callModule(mod_data_server, "data")
  callModule(mod_change_theme_server, "theme")
}
