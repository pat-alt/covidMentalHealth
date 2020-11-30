#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  callModule(mod_at_a_glance_server, "at_a_glance")
  callModule(mod_covid_server, "covid")
  callModule(mod_mental_server, "mental")
  callModule(mod_data_server, "data")
  chosen_theme <- callModule(mod_change_theme_server, "theme")
}
