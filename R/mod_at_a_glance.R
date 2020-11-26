#' at_a_glance UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_at_a_glance_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      shinydashboard::box(
        title = "Covid case numbers",
        plotOutput(ns("plot"))
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
  covid <- reactive({
    import_covid(10000)
  })

  output$plot <- renderPlot({
    req(!is.null(covid()))
    covid <- covid()
    covid[,date:=as.Date(last_update, format="%Y-%m-%dT%H:%M:%S")]
    covid_loc <<- covid
    ggplot2::ggplot(
      data = covid,
      ggplot2::aes(x=date, y=cases, colour=country)
    ) +
      ggplot2::scale_color_discrete(
        name="Country:"
      ) +
      ggplot2::geom_line()
  })
}

