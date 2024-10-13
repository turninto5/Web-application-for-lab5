library(shiny)
library(bslib)

uiMain <- page_fillable(
  navset_card_tab(
    nav_panel(title = "Start",
                h1("Introduction"),
                p("Kolada is an open and free database with over 6000 key figures and several different analysis functions.
                The purpose is to support the work of analysis, comparisons and follow-up in municipalities and regions."),
                p("This Shiny application access data via API from Kolada, implementing search data in some specific topics and data ID.
                And if you want to learn further information"),
                a("Go to Kolada", href = "https://www.kolada.se")


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


