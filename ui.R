library(shiny)
library(DT)



ui <- fluidPage(
  titlePanel("Shiny App with Sidebar"),

  sidebarLayout(
    sidebarPanel(
      textInput(
        inputId = "kpi",
        label = "KPI search",
        value = "Skatt",
        placeholder = "Enter KPI ID for first input"),

      actionButton(inputId = "search",
                   label = "search"),

      textInput(
        inputId = "municipality",
        value = "Lund",
        label = "Municipality search",
        placeholder = "Enter municipality ID for second input"),

      textInput(
        inputId = "year",
        label = "Year",
        value = "2009",
        placeholder = "Enter year for third input")
    ),

    mainPanel(
      h3("The data you selected:"),
      uiOutput("mainTable"),  # Use UI output for the main table
      uiOutput("detailsTableUI")  # Use UI output for the details table

    )
  )
)


