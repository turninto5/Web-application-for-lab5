
library(httr)
library(jsonlite)


rkolada <- setRefClass(
  "rkolada",
  fields = list(
    api = "character",
    kpiData = "character"

  ),
  methods = list(
    # constructor
    initialize = function() {
      .self$api <- "http://api.kolada.se/v2"
      .self$kpiData <- "data/kpi"
    },

    GetKpiData = function(kpi_id = NA, municipality_id = NA, year = NA) {

    # Construct the full API URL using provided KPI ID, Municipality ID, and Year
    queryUrl <- paste0(.self$api, "/", .self$kpiData, "/", kpi_id,"/year/", year)
    # https://api.kolada.se/v2/data/kpi/N00003/year/2023

    # Make the GET request to the Kolada API
    response <- GET(queryUrl)

    # Check if the request was successful
    if (status_code(response) != 200) {
      stop("Error: Unable to fetch data. Status code: ", status_code(response))
    }

    data <- parseJson(response)

    # Return the structured KPI data as a data frame
    return(as.data.frame(data))
  },

  parseJson = function(response){
    # Parse the JSON response into an R list
    dataJson <- content(response, as = "text", encoding = "UTF-8")
    dataList <- fromJSON(dataJson)

    # Extract the relevant KPI data from the JSON structure
    if (length(dataList$values) == 0) {
      return("No data available for the specified query.")
    }

    # Convert the KPI data into a data frame for easier analysis
    return(dataList$values)
  }
  )

)


server <- function(input, output) {
  kolada <- rkolada$new()

  observeEvent(input$search, {
    data <- kolada$GetKpiData(kpi_id = input$kpi, municipality_id = input$municipality, year = input$year)

    output$demo <- renderDataTable({
     datatable(data)
    })
  })
}

