
library(httr)
library(jsonlite)


rkolada <- setRefClass(
  "rkolada",
  fields = list(
    api = "character",
    kpiData = "data.frame",
    manicipalityData = "data.frame"
  ),
  methods = list(
    # constructor
    initialize = function() {
      .self$api <- "http://api.kolada.se/v2"
    },

    GetData = function(kpi_id = NA, municipality_id = NA, year = NA) {
    # /v2/data/kpi/<KPI>/municipality/<MUNICIPALITY_ID>/year/<PERIOD> 
    .self$kpiData <- getKpiData(kpi_id)
    .self$manicipalityData <- getManicipalityData(municipality_id)
    # TODO: have a mechanism to choose kpi
    # queryUrl <- paste0(.self$api, "/kpi/", URLencode(.self$kpiData$id[1]), "/manicipality/", URLencode(.self$manicipalityData[["id"]]), "/year/", URLencode(year))
    return(.self$kpiData)
  },

  getKpiData = function(kpiString){
    if(!is.character(kpiString)){
      print("Error: Shitty Kpi name")
    }
    queryUrl <- paste0(.self$api, "/kpi?title=", URLencode(kpiString))
    .self$kpiData <- (.self$apiRequest(queryUrl))
  },

  getManicipalityData = function(municipalityString){
  queryUrl <- paste0(.self$api, "/municipality?title=", URLencode(municipalityString))
  return(.self$apiRequest(queryUrl))
  },


  apiRequest = function(queryUrl){
  # Make the GET request to the Kolada API
    response <- GET(queryUrl)
    # Check if the request was successful
    if (status_code(response) != 200) {
      sprintf("Error: Unable to fetch data. Status code: ", status_code(response))
    }
    data <- .self$parseJson(response)
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
    data <- kolada$GetData(kpi_id = input$kpi, municipality_id = input$municipality, year = input$year)

    output$demo <- renderDataTable({
     datatable(data)
    })
  })
}

