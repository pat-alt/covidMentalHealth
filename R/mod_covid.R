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
          fluidPage(
            shinydashboard::box(
              title = "Global trackrecord",
              uiOutput(ns("stats")),
              width = 12
            ),
            shinydashboard::box(
              title = "Timeline by country",
              column(
                dateRangeInput(ns("date_range"), label = "Date:", start=Sys.Date()-100, end = Sys.Date()),
                width = 6
              ),
              column(
                uiOutput(ns("countries")),
                width = 6
              ),
              width=12
            ),
            shinydashboard::box(
              shinycssloaders::withSpinner(
                ggiraph::girafeOutput((ns("ts")))
              ),
              width = 12
            )
          )
        ),
        tabPanel(
          title = "Maps",
          fluidPage(
            shinydashboard::box(
              column(
                dateInput(ns("date_map"), label = "Date:", value=Sys.Date()),
                width = 6
              ),
              column(
                selectInput(ns("variable_map"), label = "Variable:", choices = list("Cases"="cases", "Deaths"="deaths", "Recovered"="recovered")),
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

#' covid Server Function
#'
#' @noRd
mod_covid_server <- function(input, output, session){
  ns <- session$ns

  output$stats <- renderUI({
    stats <- covid[date==Sys.Date(),.(
      cases=sum(cases, na.rm=T),
      deaths=sum(deaths, na.rm=T),
      recovered=sum(recovered, na.rm=T)
    )]
    tagList(
      shinydashboard::infoBox(
        "Cases:",
        value = stats$cases,
        icon = icon("users"),
        color = "aqua",
        width = 4
      ),
      shinydashboard::infoBox(
        "Deaths:",
        value = stats$deaths,
        icon = icon("skull-crossbones"),
        color = "red",
        width = 4
      ),
      shinydashboard::infoBox(
        "Recovered:",
        value = stats$recovered,
        icon = icon("heart"),
        color = "green",
        width = 4
      )
    )
  })

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

  output$ts <- ggiraph::renderGirafe({
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
      ggiraph::geom_line_interactive(ggplot2::aes(tooltip=country_name)) +
      ggplot2::labs(
        x = NULL,
        y = y_lab
      )
    my_girafe(gg, 6, 4)
  })

  output$map <- ggiraph::renderGirafe({
    req(input$date_map)
    dt_plot <- covid[date == input$date_map]
    dt_plot <- merge(y=world_map, x=dt_plot, by.y="region", by.x="country_name", all.x = T)
    dt_plot[,value:=base::get(input$variable_map)]
    dt_plot <- dt_plot[!is.na(group)]
    gg <- ggplot2::ggplot(dt_plot, ggplot2::aes(x = long, y = lat)) +
      ggiraph::geom_polygon_interactive(ggplot2::aes(fill = value, group = group, tooltip = value, data_id = value), color = NA) +
      ggplot2::scale_fill_gradient(low = "#f7b49e", high = "#f74307") +
      ggplot2::labs(
        x="",
        y=""
      ) +
      theme_maps()
    my_girafe(gg, 6, 2.5)
  })

}

