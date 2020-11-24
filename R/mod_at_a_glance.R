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
      shinydashboard::box(plotOutput("plot1", height = 250)),
      shinydashboard::box(
        title = "Controls",
        sliderInput("slider", "Number of observations:", 1, 100, 50)
      )
    )
  )
}

#' at_a_glance Server Function
#'
#' @noRd
mod_at_a_glance_server <- function(input, output, session){
  ns <- session$ns
  set.seed(122)
  histdata <- rnorm(500)

  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

## To be copied in the UI
# mod_at_a_glance_ui("at_a_glance_ui_1")

## To be copied in the server
# callModule(mod_at_a_glance_server, "at_a_glance_ui_1")

