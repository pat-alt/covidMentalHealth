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
          title = "Global track record",
          fluidPage(
            shinydashboard::box(
              uiOutput(ns("stats")),
              width = 12
            ),
            shinydashboard::box(
              column(
                uiOutput(ns("date_map")),
                width = 6
              ),
              column(
                selectInput(ns("variable_map"), label = "Variable:", choices = covid_vars),
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
        tabPanel(
          title = "Timeline",
          fluidPage(
            shinydashboard::box(
              column(
                selectInput(ns("variable"), label = "Variable:", choices = covid_vars),
                width = 3
              ),
              column(
                dateRangeInput(ns("date_range"), label = "Date range time line:", start=Sys.Date()-100, end = Sys.Date()),
                width = 3
              ),
              column(
                dateRangeInput(ns("date_range_growth"), label = "Average growth rate over:", start=Sys.Date()-100, end = Sys.Date()),
                width = 3
              ),
              column(
                uiOutput(ns("countries")),
                width = 3
              ),
              width=12
            ),
            shinydashboard::box(
              shinycssloaders::withSpinner(
                ggiraph::girafeOutput((ns("ts")))
              ),
              width = 6
            ),
            shinydashboard::box(
              shinycssloaders::withSpinner(
                ggiraph::girafeOutput((ns("growth")))
              ),
              width = 6
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

  output$date_map <- renderUI({
    max_date <- max(covid$date)
    dateInput(ns("date_map"), label = "Date:", value=max_date)
  })

  output$stats <- renderUI({
    req(input$date_map)
    stats <- covid[date==input$date_map,.(
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
      selected = c("Spain", "Germany", "France", "Netherlands", "Belgium")
    )
  })

  output$ts <- ggiraph::renderGirafe({
    req(input$countries, input$date_range, input$variable)
    dt_plot <- covid[country_name %in% input$countries &
                       date %between% input$date_range]
    y_lab <- names(covid_vars)[which(covid_vars==input$variable)]
    data.table::setnames(dt_plot, input$variable, "value")
    gg <- ggplot2::ggplot(
      data = dt_plot,
      ggplot2::aes(x=date, y=value, colour=country_name)
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

  output$growth <- ggiraph::renderGirafe({
    req(input$countries, input$date_range_growth)
    dt_plot <- covid[country_name %in% input$countries &
                       date %between% input$date_range_growth]
    y_lab <- sprintf(
      "%s per day (average)",
      names(covid_vars)[which(covid_vars==input$variable)]
    )
    data.table::setnames(dt_plot, input$variable, "value")
    dt_plot[,value:=mean(c(NA,diff(value)),na.rm=T),by=.(country, country_name)]
    gg <- ggplot2::ggplot(
      data = dt_plot,
      ggplot2::aes(x=country_name, y=value, fill=country_name)
    ) +
      ggplot2::scale_fill_discrete(
        name="Country:",
        guide=F
      ) +
      ggiraph::geom_bar_interactive(ggplot2::aes(
        tooltip=sprintf(
          "Country: %s\nCount: %f",
          country_name,
          value
        )
      ), stat="identity") +
      ggplot2::labs(
        x = NULL,
        y = y_lab
      ) +
      ggplot2::coord_flip() +
      ggplot2::theme(
        axis.text.x=ggplot2::element_blank(),
        axis.ticks.x=ggplot2::element_blank()
      )
    my_girafe(gg, 6, 4)
  })

  output$map <- ggiraph::renderGirafe({
    req(input$date_map)
    dt_plot <- covid[date == input$date_map]
    dt_plot <- merge(y=world_map, x=dt_plot, by.y="region", by.x="country_name", all = T)
    dt_plot[,value:=base::get(input$variable_map)]
    dt_plot <- dt_plot[!is.na(group)]
    gg <- ggplot2::ggplot(dt_plot, ggplot2::aes(x = long, y = lat)) +
      ggiraph::geom_polygon_interactive(ggplot2::aes(
        fill = value, group = group,
        tooltip = sprintf(
          "Count: %f\nCountry: %s",
          value,
          country_name
        ),
        data_id = value
      ), color = NA) +
      ggplot2::scale_fill_gradient(low = "#f7b49e", high = "#f74307", name="Count:") +
      ggplot2::labs(
        x="",
        y=""
      ) +
      theme_maps()
    my_girafe(gg, 6, 2.5)
  })

}

