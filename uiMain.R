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

    ),
    nav_panel(title = "Search Data Based On ID",
                h1("Input ID"),
                textInput(
                    inputId = "kpi",
                    label = "KPI ID",
                    value = "example: N00003",
                    placeholder = "Enter KPI ID for first input"
                    ),

                textInput(
                    inputId = "municipality",
                    label = "Municipality ID",
                    placeholder = "Enter municipality ID for second input"
                    ),

                textInput(
                    inputId = "year",
                    label = "Year",
                    value = "example: 2023",
                    placeholder = "Enter year for third input"
                    ),

                actionButton(
                    inputId = "search",
                    label = "search"
                    ),
                dataTableOutput("idTable")
    ),
    nav_panel(title = "Search Data Based On Topics",
                textInput(
                    inputId = "keywords",
                    label = "keywords",
                    value = "example: Män som tar ut tillfällig föräldrapenning",
                    placeholder = "Enter the keywords you want to search"
                ),

                actionButton(
                    inputId = "search_kw",
                    label = "search keywords"
                ),

                dataTableOutput("kwTable")
    ),
  ),
  id = "main"
)


