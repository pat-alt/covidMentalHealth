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
        sliderInput(ns("max"),
                    "Maximum Number of Words:",
                    min = 1,  max = 300,  value = 100),
        width = 3
      ),
      shinydashboard::box(
        tableOutput(ns("latest")),
        br(),
        plotly::plotlyOutput(ns("sentiment")),
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
    invalidateLater(60000) # rerun every 60 seconds
    req(input$n_tweets)
    tweets <- import_latest_tweets(n=input$n_tweets)
    return(tweets)
  })

  output$cloud <- renderPlot({
    # Placeholder:
    latest <- latest_tweets()
    tweets_tidy <- prepare_tweet_text(latest)
    dt_plot <- tweets_tidy %>%
      dplyr::inner_join(tidytext::get_sentiments("bing"))
    dt_plot[,n:=.N, by=word]
    set.seed(42)
    dt_plot <- unique(dt_plot[,.(word, n, sentiment)])
    ggplot2::ggplot(dt_plot, ggplot2::aes(label = word, size = n, colour=sentiment)) +
      ggwordcloud::geom_text_wordcloud() +
      ggplot2::scale_size_area(max_size = 15) +
      ggplot2::scale_colour_manual(
        guide=FALSE,
        values = c("coral", "lightgreen")
      )
  })

  output$sentiment <- plotly::renderPlotly({
    # Placeholder:
    latest <- latest_tweets()
    tweets_tidy <- prepare_tweet_text(latest)
    dt_plot <- get_sentiment_by(tweets_tidy, timestamp)
    gg <- ggplot2::ggplot(dt_plot, ggplot2::aes(x=timestamp, y=sentiment, fill=pos_neg)) +
      ggplot2::geom_col() +
      ggplot2::scale_fill_manual(
        guide=FALSE,
        values = c("coral", "lightgreen")
      ) +
      ggplot2::labs(
        x="Time",
        y="Sentiment"
      )
    plotly::ggplotly(gg)
  })

  output$latest <- renderTable({
    latest <- latest_tweets()
    tab <- latest[1:3,.(timestamp, text)]
    data.table::setnames(tab, c("timestamp", "test"))
    return(tab)
  })

}

## To be copied in the UI
# mod_mental_ui("mental_ui_1")

## To be copied in the server
# callModule(mod_mental_server, "mental_ui_1")

