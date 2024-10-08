#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(DT)



ui <- fluidPage(
  titlePanel("Shiny App with Sidebar"),

  sidebarLayout(
    sidebarPanel(
      textInput(
        inputId = "kpi",
        label = "KPI ID",
        value = "N00003",
        placeholder = "Enter KPI ID for first input"),

      textInput(
        inputId = "municipality",
        label = "Municipality ID",
        value = "",
        placeholder = "Enter municipality ID for second input"),

      textInput(
        inputId = "year",
        label = "Year",
        value = "2023",
        placeholder = "Enter year for third input"),

      actionButton(inputId = "search",
                   label = "search")
      ),

    mainPanel(
      h3("The data you selected:"),
      dataTableOutput("demo")
    )
  )
)



server <- function(input, output, session) {

  source("Server.R")
  observeEvent(input$search, {
    kolada <- rkolada()
    data <- kolada$GetKpiData(kpi_id = input$kpi, municipality_id = input$municipality, year = input$year)
    output$demo <- renderDataTable({
      datatable(data)})
  })
}


shinyApp(ui = ui, server = server)
