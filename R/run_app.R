#' Run the Shiny Application
#'
#' @param use_venv Boolean: Should virtual environment be set up when running from local?
#' @param ... A series of options to be used inside the app.
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
#' @importFrom data.table :=
#' @importFrom data.table %between%
#' @importFrom dplyr %>%
run_app <- function(
  use_venv = T,
  ...
) {
  # Should virtual environment be set up when running from local?
  use_venv <<- use_venv
  # Set-up:
  options(
    spinner.color="#9fc9f4",
    spinner.type=8
  )
  # Custome plot theme:
  ggplot2::theme_set(theme_covid_mental()) # global plot theme
  # Global parameters:
  covid_vars <<- list("Cases"="cases", "Deaths"="deaths", "Recovered"="recovered")
  # Python dependencies:
  PYTHON_DEPENDENCIES <<- c('pymongo', 'pandas', 'requests')
  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server
    ),
    golem_opts = list(...)
  )
}
