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
    shinydashboard::box(
      width = 12,
      fluidRow(
        column(
          helpText("Tweets related to mental health are streamed from Twitter's streaming API and automatically updated every minute."),
          width = 6
        ),
        column(
          shinydashboard::infoBoxOutput(ns("countdown"), width = 12),
          width = 6
        )
      ),
      shinydashboard::tabBox(
        tabPanel(
          title = "At a glance",
          fluidRow(
            shinydashboard::box(
              sliderInput(ns("n_tweets"), label="Number of latest tweets", value = 1000, min = 1, max=10000),
              sliderInput(ns("max_words"),
                          "Maximum number of words (cloud):",
                          min = 1,  max = 300,  value = 50),
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
                uiOutput(ns("date_range_map")),
                width = 6
              ),
              column(
                selectInput(ns("variable_map"), label = "Variable:", choices = list("Number of tweets"="n_tweets", "Sentiment"="sentiment")),
                width = 6
              ),
              width = 12
            ),
            shinydashboard::box(
              shinycssloaders::withSpinner(
                ggiraph::girafeOutput((ns("map")))
              ),
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

  output$date_range_map <- renderUI({
    latest <<- latest_tweets()
    max_date <- max(as.Date(latest$timestamp))
    dateRangeInput(ns("date_range_map"), label = "Date range:", start=Sys.Date()-10, end = max_date)
  })

  # Countdown to next update:
  timer <- reactiveVal(60)

  # Output the time left.
  output$countdown <- shinydashboard::renderInfoBox({
    req(input$n_tweets)
    shinydashboard::infoBox(
      title = "Twitter stream",
      subtitle = "Time until tweets are next updated",
      icon = icon("stopwatch"),
      value = lubridate::seconds_to_period(timer())
    )
  })

  # Observer that invalidates every second:
  observe({
    invalidateLater(1000, session)
    isolate({
      timer(timer()-1)
    })
  })

  latest_tweets <- reactive({
    invalidateLater(60000) # rerun every 60 seconds
    req(input$n_tweets)
    timer(55)
    tweets <- import_latest_tweets(n=input$n_tweets)
    return(tweets)
  })

  output$cloud <- renderPlot({
    req(input$max_words)
    latest <- latest_tweets()
    tweets_tidy <- prepare_tweet_text(latest)
    dt_plot <- tweets_tidy %>%
      dplyr::inner_join(tidytext::get_sentiments("bing"))
    dt_plot <- unique(dt_plot[,.(.N, sentiment=sentiment), by=.(word)])
    data.table::setorder(dt_plot, -N)
    dt_plot <- head(dt_plot, input$max_words)
    set.seed(42)
    dt_plot <- unique(dt_plot[,.(word, N, sentiment)])
    ggplot2::ggplot(dt_plot, ggplot2::aes(label = word, size = N, colour=sentiment)) +
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
    gg <- ggplot2::ggplot(dt_plot) +
      ggplot2::geom_smooth(ggplot2::aes(x=timestamp, y=sentiment), fill="coral") +
      ggiraph::geom_point_interactive(
        colour="coral",
        ggplot2::aes(
          x=timestamp,
          y=sentiment,
          tooltip = sprintf(
            "Sentiment: %f\nTime stamp: %s",
            sentiment,
            as.character(timestamp)
          )
        )
      ) +
      ggplot2::labs(
        x="Time",
        y="Sentiment"
      )
    my_girafe(gg, 6, 2)
  })

  output$latest <- renderTable({
    latest <- latest_tweets()
    latest <- latest[order(-timestamp)]
    tab <- head(latest[,.(timestamp, text)],3)
    data.table::setnames(tab, c("timestamp", "text"), c("Time", "Tweet"))
    tab[,Time:=as.character(Time)]
    return(tab)
  })

  output$map <- ggiraph::renderGirafe({
    req(input$date_range_map)
    latest <- latest_tweets()
    dt_plot <- latest[as.Date(timestamp) %between% input$date_range_map]
    if(input$variable_map=="n_tweets") {
      dt_plot <- merge(y=world_map, x=dt_plot, by.y="region", by.x="parse_author_location", all = T, allow.cartesian = T)
      dt_plot[,value:=length(unique(text[!is.na(text)])),by=parse_author_location]
      dt_plot <- dt_plot[!is.na(group)]
      gg <- ggplot2::ggplot(dt_plot, ggplot2::aes(x = long, y = lat)) +
        ggiraph::geom_polygon_interactive(ggplot2::aes(
          fill = value, group = group,
          tooltip = sprintf(
            "Count: %f\nCountry: %s",
            value,
            parse_author_location
          ),
          data_id = value
        ), color = NA) +
        ggplot2::scale_fill_gradient(low = "#f7b49e", high = "#f74307", name="Number of tweets:") +
        ggplot2::labs(
          x="",
          y=""
        ) +
        theme_maps()
      return(my_girafe(gg, 6, 2.5))
    }
    if (input$variable_map=="sentiment") {
      dt_plot <- prepare_tweet_text(dt_plot)
      dt_plot <- get_sentiment_by(dt_plot, parse_author_location)
      dt_plot <- merge(y=world_map, x=dt_plot, by.y="region", by.x="parse_author_location", all = T)
      data.table::setnames(dt_plot, "sentiment", "value")
      dt_plot <- dt_plot[!is.na(group)]
      gg <- ggplot2::ggplot(dt_plot, ggplot2::aes(x = long, y = lat)) +
        ggiraph::geom_polygon_interactive(ggplot2::aes(
          fill = value, group = group,
          tooltip = sprintf(
            "Sentiment: %f\nCountry: %s",
            value,
            parse_author_location
          ),
          data_id = value
        ), color = NA) +
        ggplot2::scale_fill_gradient(low = "coral", high = "lightblue", name="Sentiment:") +
        ggplot2::labs(
          x="",
          y=""
        ) +
        theme_maps()
      return(my_girafe(gg, 6, 2.5))
    }

  })

}


