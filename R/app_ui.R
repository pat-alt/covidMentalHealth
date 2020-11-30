#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here
    shinydashboard::dashboardPage(
      shinydashboard::dashboardHeader(
        title = "Covid vs. mental health",
        tags$li(
          shinyWidgets::dropdownButton(
            change_theme_dropdown(id = "theme", defaultTheme = "grey_dark"),
            icon = icon("palette"),
            right = T
          ),
          class = "dropdown"
        )
      ),
      shinydashboard::dashboardSidebar(
        shinydashboard::sidebarMenu(
          shinydashboard::menuItem("Dashboard", tabName = "at_a_glance", icon = icon("dashboard")),
          shinydashboard::menuItem("Data", tabName = "data", icon = icon("database"))
        )
      ),
      shinydashboard::dashboardBody(
        dashboardthemes::shinyDashboardThemes(
          theme = "grey_dark"
        ),
        # To allow user to change CSS:
        mod_change_theme_ui("theme"),
        shinydashboard::tabItems(
          # First tab content
          shinydashboard::tabItem(
            tabName = "at_a_glance",
            mod_at_a_glance_ui("at_a_glance")
          ),

          # Second tab content
          shinydashboard::tabItem(
            tabName = "data",
            mod_data_ui("data")
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'dashboard'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

