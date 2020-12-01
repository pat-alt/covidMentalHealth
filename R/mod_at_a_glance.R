#' at_a_glance UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_at_a_glance_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      shinydashboard::box(
        mod_covid_ui(ns("covid")),
        title = span( icon("viruses"), "Covid"),
        width = 12,
        height = 6,
        collapsible = T
      ),
      shinydashboard::box(
        mod_mental_ui(ns("mental")),
        title = span( icon("head-side-virus"), "Mental health"),
        width = 12,
        height = 6,
        collapsible = T
      )
    )
  )
}

#' at_a_glance Server Function
#'
#' @noRd
mod_at_a_glance_server <- function(input, output, session){
  ns <- session$ns
  callModule(mod_covid_server, "covid")
  callModule(mod_mental_server, "mental")
}

