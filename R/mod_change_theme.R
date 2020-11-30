change_theme_dropdown <- function(id, dropDownLabel = "Change Theme", defaultTheme = "grey_light")
{
  changeThemeChoices <- c(
    "Light" = "grey_light",
    "Dark" = "grey_dark"
  )

  ns <- NS(id)
  dropdown <- tagList(
    selectizeInput(
      inputId = ns("dbxChangeTheme"),
      label = dropDownLabel,
      choices = changeThemeChoices,
      selected = defaultTheme
    )
  )

  return(dropdown)
}

#' change_theme UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_change_theme_ui <- function(id){
  ns <- NS(id)
  themeOutput <- tagList(
    uiOutput(ns("uiChangeTheme"))
  )
  return(themeOutput)
}

#' change_theme Server Function
#'
#' @noRd
mod_change_theme_server <- function(input, output, session){
  ns <- session$ns
  observeEvent(
    input$dbxChangeTheme,
    {
      output$uiChangeTheme <- renderUI({
        dashboardthemes::shinyDashboardThemes(theme = input$dbxChangeTheme)
      })
    }
  )
}

