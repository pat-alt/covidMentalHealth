#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  reticulate::use_python('/usr/bin/python')
  # List the first level callModules here
  callModule(mod_at_a_glance_server, "at_a_glance")
  callModule(mod_at_a_glance_server, "data")
  callModule(mod_change_theme_server, "theme")
}
