#' at_a_glance UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @importFrom data.table %between%
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_at_a_glance_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      shinydashboard::tabBox(
        tabPanel(
          title = "Over time",
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
          title = "Map",
          fluidRow(
            shinydashboard::box(
              dateInput(ns("date_range"), label = "Date:", value=Sys.Date()),
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

#' at_a_glance Server Function
#'
#' @noRd
#'
#' importFrom data.table :=
mod_at_a_glance_server <- function(input, output, session){
  ns <- session$ns

  output$countries <- renderUI({
    req(!is.null(covid))
    countries <- sort(covid[,unique(country)])
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
    dt_plot <- covid[country %in% input$countries &
                     date %between% input$date_range]
    y_lab <- "Cases"
    gg <- ggplot2::ggplot(
      data = dt_plot,
      ggplot2::aes(x=date, y=cases, colour=country)
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
    world_map <- ggplot2::map_data("world")
    gg <- ggplot2::ggplot(world_map, ggplot2::aes(x = long, y = lat, group = group)) +
      ggplot2::geom_polygon(fill="lightgray", colour = "white")
    plotly::ggplotly(gg)
  })

  # output$network <- renderPlot({
  #   dt_wide <- dcast(unique(covid[,.(date,country,cases)]),date~country, value.var = "cases")
  #   for (j in names(dt_wide))
  #     set(dt_wide,which(is.na(dt_wide[[j]])),j,0)
  #   dt_corr <- corrr::correlate(dt_wide[,-1], diagonal = 1)
  #   corrr::network_plot(dt_corr)
  # })
}

