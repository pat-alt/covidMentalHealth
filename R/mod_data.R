#' data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      shinydashboard::tabBox(
        title = "Data by source",
        id = "data_by_source",
        tabPanel(
          title = "Tweets",
          sliderInput(ns("n_tweets"), "Number of tweets:", 1, 1000, 20),
          DT::DTOutput(ns("tweets"))
        ),
        tabPanel(
          title = "Covid",
          sliderInput(ns("n_covid"), "Number of rows:", 1, 1000, 20),
          DT::DTOutput(ns("covid"))
        )
      )
    )
  )
}

#' data Server Function
#'
#' @noRd
mod_data_server <- function(input, output, session){
  ns <- session$ns

  output$tweets <- DT::renderDT({
    tweets <- import_tweets(input$n_tweets)
    return(tweets)
  })

  output$covid <- DT::renderDT({
    covid <- import_covid(input$n_covid)
    return(covid)
  })

}


