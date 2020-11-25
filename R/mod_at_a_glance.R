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
      shinydashboard::box(plotOutput(ns("plot1"), height = 250)),
      shinydashboard::box(
        title = "Controls",
        sliderInput(ns("slider"), "Number of observations:", 1, 100, 50)
      ),
      shinydashboard::box(
        title = "Tweets",
        sliderInput(ns("n_tweets"), "Number of tweets:", 1, 1000, 20),
        DT::DTOutput(ns("tweets"))
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

  output$tweets <- DT::renderDT({
    tweets <- import_tweets(input$n_tweets)
    return(tweets)
  })
}

