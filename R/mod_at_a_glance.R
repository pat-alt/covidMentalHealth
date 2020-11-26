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
  output$tweets <- DT::renderDT({
    tweets <- import_tweets(input$n_tweets)
    return(tweets)
  })
}

