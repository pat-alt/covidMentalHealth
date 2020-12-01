#' Run the Shiny Application
#'
#' @param ... A series of options to be used inside the app.
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  ...
) {
  readRenviron(".Renviron")
  # Set-up:
  options(
    spinner.color="#9fc9f4",
    spinner.type=8
  )
  reticulate::use_python('/usr/bin/python')
  covid <<- import_covid() # Covid data is sourced into memory once as it is not very large and this speeds up other processes
  world_map <<- data.table::data.table(ggplot2::map_data("world")) # Load world map data on start up
  # Mapping important countries to COVID data:
  world_map[region=="USA", region:="United States of America"]
  world_map[region=="UK", region:="United Kingdom of Great Britain and Northern Ireland"]
  # Custome plot theme:
  ggplot2::theme_set(theme_covid_mental()) # global plot theme
  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server
    ),
    golem_opts = list(...)
  )
}
