# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
###################################
#### CURRENT FILE: DEV SCRIPT #####
###################################

# Engineering

## Dependencies ----
## Add one line by package you want to add as dependency
usethis::use_package( "ggplot2" )
usethis::use_package( "ggiraph" )
usethis::use_package( "plotly" )
usethis::use_package( "maps" )
usethis::use_package( "ggwordcloud" )
usethis::use_package( "shinydashboard" )
usethis::use_package( "shinydashboardPlus" )
usethis::use_package( "dashboardthemes" )
usethis::use_package( "data.table" , min_version = T)
usethis::use_package( "shinyWidgets" )
usethis::use_package( "reticulate" )
usethis::use_package( "waiter" )
usethis::use_package( "dplyr" )
usethis::use_package( "tidytext" )
usethis::use_package( "shinycssloader" )

## Add modules ----
## Create a module infrastructure in R/
golem::add_module( name = "at_a_glance" ) # Name of the module
golem::add_module( name = "covid" ) # Name of the module
golem::add_module( name = "mental" ) # Name of the module
golem::add_module( name = "data" ) # Name of the module
golem::add_module( name = "change_theme" )

## Add helper functions ----
## Creates ftc_* and utils_*
golem::add_fct( "import_tweets" )
golem::add_fct( "import_latest_tweets" )
golem::add_fct( "import_covid" )
golem::add_fct( "install_py_dependencies" )
golem::add_utils( "complete_dt" )
golem::add_fct( "prepare_tweet_text" )
golem::add_fct( "get_sentiment" )
golem::add_fct( "plot_theme" )
golem::add_fct( "theme_maps" )
golem::add_fct( "my_girafe" )

## External resources
## Creates .js and .css files at inst/app/www
#golem::add_js_file( "script" )
#golem::add_js_handler( "handlers" )
#golem::add_css_file( "custom" )

## Add internal datasets ----
## If you have data in your package
#usethis::use_data_raw( name = "my_dataset", open = FALSE )

## Tests ----
## Add one line by test you want to create
#usethis::use_test( "app" )

# Documentation

## Vignette ----
#usethis::use_vignette("dashboard")
#devtools::build_vignettes()

## Code coverage ----
## (You'll need GitHub there)
#usethis::use_github()
#usethis::use_travis()
#usethis::use_appveyor()

# You're now set! ----
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")

