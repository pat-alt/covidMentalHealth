#' covid UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_covid_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      shinydashboard::tabBox(
        tabPanel(
          title = "At a glance",
          fluidRow(
            shinydashboard::box(
              dateRangeInput(ns("date_range"), label = "Date:", start=Sys.Date()-100, end = Sys.Date()),
              uiOutput(ns("countries")),
              width = 3
            ),
            shinydashboard::box(
              plotly::plotlyOutput((ns("ts"))),
              width = 9
            )
          )
        ),
        tabPanel(
          title = "Maps",
          fluidRow(
            shinydashboard::box(
              dateInput(ns("date_map"), label = "Date:", value=Sys.Date()),
              selectInput(ns("variable_map"), label = "Variable:", choices = list("Cases"="cases", "Deaths"="deaths", "Recovered"="recovered")),
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

#' covid Server Function
#'
#' @noRd
mod_covid_server <- function(input, output, session){
  ns <- session$ns

  output$countries <- renderUI({
    req(!is.null(covid))
    countries <- sort(covid[,unique(country_name)])
    selectInput(
      ns("countries"),
      label = "Choose country",
      choices = countries,
      multiple = T,
      selected = countries[1]
    )
  })

  output$ts <- plotly::renderPlotly({
    req(input$countries, input$date_range)
    dt_plot <- covid[country_name %in% input$countries &
                       date %between% input$date_range]
    y_lab <- "Cases"
    gg <- ggplot2::ggplot(
      data = dt_plot,
      ggplot2::aes(x=date, y=cases, colour=country_name)
    ) +
      ggplot2::scale_color_discrete(
        name="Country:"
      ) +
      ggplot2::geom_line() +
      ggplot2::labs(
        x = NULL,
        y = y_lab
      )
    plotly::ggplotly(gg)
  })

  output$map <- plotly::renderPlotly({
    req(input$date_map)
    dt_plot <- covid[date == input$date_map]
    dt_plot <- merge(y=world_map, x=dt_plot, by.y="region", by.x="country_name", all.x = T)
    dt_plot[,value:=base::get(input$variable_map)]
    gg <- ggplot2::ggplot(dt_plot, ggplot2::aes(x = long, y = lat, group = group)) +
      ggplot2::geom_polygon(ggplot2::aes(fill = value), color = "white")+
      ggplot2::scale_fill_gradient(low = "#f7b49e", high = "#f74307", name="Count:")
    plotly::ggplotly(gg)
  })

}

