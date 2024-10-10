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
