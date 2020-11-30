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
              width = 4
            ),
            shinydashboard::box(
              tableOutput(ns("latest")),
              width = 8
            )
          ),
          fluidRow(
            column(
              shinycssloaders::withSpinner(
                ggiraph::girafeOutput(ns("sentiment"), height = 200)
              ),
              width = 12
            ),
            column(
              shinycssloaders::withSpinner(
                plotOutput(ns("cloud"))
              ),
              width = 12
            )
          )
        ),
        tabPanel(
          title = "Maps",
          fluidRow(
            shinydashboard::box(
              column(
                dateRangeInput(ns("date_map"), label = "Date range:", start=Sys.Date()-10, end = Sys.Date()),
                width = 6
              ),
              column(
                selectInput(ns("variable_map"), label = "Variable:", choices = list("Number of tweets"="n_tweets", "Sentiment"="sentiment")),
                width = 6
              ),
              width = 12
            ),
            shinydashboard::box(
              ggiraph::girafeOutput((ns("map"))),
              width = 12
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
    dt_plot[,n:=.N, by=.(word)]
    set.seed(42)
    dt_plot <- unique(dt_plot[,.(word, n, sentiment)])
    ggplot2::ggplot(dt_plot, ggplot2::aes(label = word, size = n, colour=sentiment)) +
      ggwordcloud::geom_text_wordcloud() +
      ggplot2::scale_size_area(max_size = 15) +
      ggplot2::scale_colour_manual(
        guide=FALSE,
        values = c("coral", "lightblue")
      )
  })

  output$sentiment <- ggiraph::renderGirafe({
    # Placeholder:
    latest <- latest_tweets()
    tweets_tidy <- prepare_tweet_text(latest)
    dt_plot <- get_sentiment_by(tweets_tidy, timestamp)
    gg <- ggplot2::ggplot(dt_plot, ggplot2::aes(x=timestamp, y=sentiment, tooltip=sentiment)) +
      ggiraph::geom_col_interactive(fill="coral") +
      ggiraph::geom_smooth_interactive(fill="coral") +
      ggplot2::labs(
        x="Time",
        y="Sentiment"
      )
    my_girafe(gg, 6, 2)
  })

  output$latest <- renderTable({
    latest <- latest_tweets()
    tab <- latest[1:3,.(timestamp, text)]
    data.table::setnames(tab, c("timestamp", "text"), c("Time", "Tweet"))
    tab[,Time:=as.character(Time)]
    return(tab)
  })

  output$map <- ggiraph::renderGirafe({
    req(input$date_map)
    latest <- latest_tweets()
    dt_plot <- latest[as.Date(timestamp) == input$date_map]
    if(input$variable_map=="n_tweets") {
      dt_plot <- merge(y=world_map, x=dt_plot, by.y="region", by.x="author_location", all.x = T)
      dt_plot[,value:=length(unique(id)),by=author_location]
      dt_plot <- dt_plot[!is.na(group)]
      gg <- ggplot2::ggplot(dt_plot, ggplot2::aes(x = long, y = lat)) +
        ggiraph::geom_polygon_interactive(ggplot2::aes(fill = value, group = group, tooltip = value, data_id = value), color = NA) +
        ggplot2::scale_fill_gradient(low = "#f7b49e", high = "#f74307") +
        ggplot2::labs(
          x="",
          y=""
        ) +
        theme_maps()
      return(my_girafe(gg, 6, 2.5))
    }
    if (input$variable_map=="sentiment") {
      dt_plot <- prepare_tweet_text(dt_plot)
      dt_plot <- get_sentiment_by(dt_plot, author_location)
      dt_plot <- merge(y=world_map, x=dt_plot, by.y="region", by.x="author_location", all.x = T)
      data.table::setnames(dt_plot, "sentiment", "value")
      dt_plot <- dt_plot[!is.na(group)]
      gg <- ggplot2::ggplot(dt_plot, ggplot2::aes(x = long, y = lat)) +
        ggiraph::geom_polygon_interactive(ggplot2::aes(fill = value, group = group, tooltip = value, data_id = value), color = NA) +
        ggplot2::scale_fill_gradient(low = "coral", high = "lightblue") +
        ggplot2::labs(
          x="",
          y=""
        ) +
        theme_maps()
      return(my_girafe(gg, 6, 2.5))
    }

  })

}


