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
      shinydashboard::tabBox(
        tabPanel(
          title = "At a glance",
          fluidRow(
            shinydashboard::box(
              helpText("Here you can monitor recent tweets. Tweets are streamed from Twitter's streaming API and automatically updated every minute."),
              sliderInput(ns("n_tweets"), label="Number of latest tweets", value = 1000, min = 1, max=1000),
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
        ),
        tabPanel(
          title = "Maps",
          fluidRow(
            shinydashboard::box(
              dateRangeInput(ns("date_map"), label = "Date range:", start=Sys.Date()-10, end = Sys.Date()),
              selectInput(ns("variable_map"), label = "Variable:", choices = list("Number of tweets"="n_tweets", "Sentiment"="sentiment")),
              width = 3
            ),
            shinydashboard::box(
              plotly::plotlyOutput((ns("map"))),
              width = 9
            )
          )
        ),
        width = 12
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
    data.table::setnames(tab, c("timestamp", "text"), c("Time", "Tweet"))
    return(tab)
  })

  output$map <- plotly::renderPlotly({
    req(input$date_map)
    latest <- latest_tweets()
    dt_plot <- latest[as.Date(timestamp) == input$date_map]
    if(input$variable_map=="n_tweets") {
      dt_plot <- merge(y=world_map, x=dt_plot, by.y="region", by.x="author_location", all.x = T)
      dt_plot[,value:=length(unique(id)),by=author_location]
      gg <- ggplot2::ggplot(dt_plot, ggplot2::aes(x = long, y = lat, group = group)) +
        ggplot2::geom_polygon(ggplot2::aes(fill = value), color = "white") +
        ggplot2::scale_fill_gradient(low = "#f7b49e", high = "#f74307", name="Count:")
      plotly::ggplotly(gg)
    }
    if (input$variable_map=="sentiment") {
      dt_plot <- prepare_tweet_text(dt_plot)
      dt_plot <- get_sentiment_by(dt_plot, author_location)
      dt_plot <- merge(y=world_map, x=dt_plot, by.y="region", by.x="author_location", all.x = T)
      data.table::setnames(dt_plot, "sentiment", "value")
      gg <- ggplot2::ggplot(dt_plot, ggplot2::aes(x = long, y = lat, group = group)) +
        ggplot2::geom_polygon(ggplot2::aes(fill = value), color = "white") +
        ggplot2::scale_fill_gradient(low = "coral", high = "lightgreen", name="Sentiment:")
      plotly::ggplotly(gg)
    }

  })

}

## To be copied in the UI
# mod_mental_ui("mental_ui_1")

## To be copied in the server
# callModule(mod_mental_server, "mental_ui_1")

