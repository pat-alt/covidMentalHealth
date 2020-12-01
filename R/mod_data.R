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
          title = "Covid",
          fluidPage(
            DT::DTOutput(ns("covid"))
          )
        ),
        tabPanel(
          title = "Tweets",
          fluidPage(
            DT::DTOutput(ns("tweets"))
          )
        ),
        width = 12
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
    tweets <- import_latest_tweets(10000)
    tweets <- tweets[,.(timestamp, author, parse_author_location, text)]
    data.table::setnames(
      tweets,
      c("timestamp", "author", "parse_author_location", "text"),
      c("Time", "Author", "Location", "Tweet")
    )
    return(tweets)
  })

  output$covid <- DT::renderDT({
    tab <- covid[,.(country_name, date, cases, deaths, recovered)]
    data.table::setnames(
      tab,
      c("country_name", "date", "cases", "deaths", "recovered"),
      c("Country", "Date", "Cases", "Deaths", "Recovered")
    )
    return(tab)
  })

}


