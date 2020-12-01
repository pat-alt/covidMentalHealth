#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {

  # ------------------ App virtualenv setup (Do not edit) ------------------- #
  if (
    Sys.info()[['user']] == 'shiny' |
    Sys.info()[['user']] == 'rstudio-connect' |
    use_venv == T
  ) {
    virtualenv_dir = Sys.getenv('VIRTUALENV_NAME')
    python_path = Sys.getenv('PYTHON_PATH')

    # Create virtual env and install dependencies
    reticulate::virtualenv_create(envname = virtualenv_dir, python = python_path)
    reticulate::virtualenv_install(virtualenv_dir, packages = PYTHON_DEPENDENCIES, ignore_installed=TRUE)
    reticulate::use_virtualenv(virtualenv_dir, required = T)
  }


  # ------------------ Load data ------------------- #
  covid <<- import_covid() # Covid data is sourced into memory once as it is not very large and this speeds up other processes
  world_map <<- data.table::data.table(ggplot2::map_data("world")) # Load world map data on start up
  # Mapping important countries to COVID data:
  world_map[region=="USA", region:="United States of America"]
  world_map[region=="UK", region:="United Kingdom of Great Britain and Northern Ireland"]


  # ------------------ Load modules ------------------- #
  # List the first level callModules here
  callModule(mod_at_a_glance_server, "at_a_glance")
  callModule(mod_covid_server, "covid")
  callModule(mod_mental_server, "mental")
  callModule(mod_data_server, "data")
  chosen_theme <- callModule(mod_change_theme_server, "theme")
}
