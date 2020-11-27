#' mental UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_mental_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      shinydashboard::box(
        sliderInput(ns("n_tweets"), label="Number of latest tweets", value = 100, min = 1, max=1000),
        sliderInput(ns("freq"),
                    "Minimum Frequency:",
                    min = 1,  max = 50, value = 15),
        sliderInput(ns("max"),
                    "Maximum Number of Words:",
                    min = 1,  max = 300,  value = 100),
        width = 3
      ),
      shinydashboard::box(
        tableOutput(ns("latest")),
        br(),
        plotOutput(ns("cloud")),
        width = 9
      )
    )
  )
}

#' mental Server Function
#'
#' @noRd
mod_mental_server <- function(input, output, session){
  ns <- session$ns

  latest_tweets <- reactive({
    req(input$n_tweets)
    tweets <- import_latest_tweets(n=input$n_tweets)
    return(tweets)
  })

  output$cloud <- renderPlot({
    # Placeholder:
    love_words_small <- ggwordcloud::love_words_small
    set.seed(42)
    ggplot2::ggplot(love_words_small, ggplot2::aes(label = word, size = speakers)) +
      ggwordcloud::geom_text_wordcloud() +
      ggplot2::scale_size_area(max_size = 20) +
      ggplot2::theme_minimal()
  })

  output$latest <- renderTable({
    latest <- latest_tweets()
    tab <- latest[1:3,.(timestamp, text)]
    return(tab)
  })

}

## To be copied in the UI
# mod_mental_ui("mental_ui_1")

## To be copied in the server
# callModule(mod_mental_server, "mental_ui_1")

