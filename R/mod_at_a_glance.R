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

  )
}

#' at_a_glance Server Function
#'
#' @noRd
#'
#' importFrom data.table :=
mod_at_a_glance_server <- function(input, output, session){
  ns <- session$ns


}

