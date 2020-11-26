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
    fluidRow(
      shinydashboard::box(
        title = "Tweets",
        plotOutput(ns("plot"))
      )
    )
  )
}

#' at_a_glance Server Function
#'
#' @noRd
mod_at_a_glance_server <- function(input, output, session){
  ns <- session$ns
  covid <- reactive({
    import_covid(10000)
  })

  output$plot <- renderPlot({
    req(!is.null(covid()))
    ggplot2::ggplot(
      data = covid()[country=="AF"],
      aes(x="last_update", y="cases")
    )
  })
}

