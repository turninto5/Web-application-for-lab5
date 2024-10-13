
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

  GetKpiSearchData = function(kpi_id = NA) {
    .self$kpiData <- getKpiData(kpi_id)
    return(.self$kpiData)
  },

  GetAllData = function(kpi_id = NA, municipality = NA, year = NA) {
    # /v2/data/kpi/<KPI>/municipality/<MUNICIPALITY_ID>/year/<PERIOD> 
    municipalityData <- getManicipalityData(municipality)
    queryUrl <- paste0(.self$api, "/data/kpi/", URLencode(kpi_id), "/municipality/", URLencode(municipalityData[["id"]]), "/year/", URLencode(year))
    
    response <- .self$apiRequest(queryUrl)
    print(response)
    if(!is.data.frame(response)){
      response <- as.data.frame(response)
    }
    return(response)
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
      print(response)
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

  # Reactive value to track which table to show
  currentTable <- reactiveVal("main")

  observeEvent(input$search, {
    print(currentTable())
    data <- kolada$GetKpiSearchData(kpi_id = input$kpi)

      
    output$demo <- renderDataTable({
     datatable(data, selection = "single")
    })
    currentTable("main")
  })

  observeEvent(input$demo_rows_selected, {
        print(currentTable())
    selected <- input$demo_rows_selected  # Get selected row index
    if (!is.null(selected)) {
      # Display the selected row data (you can customize what to do with it)

    print(selected)
    # Fetch the original KPI data again
    kpiData <- kolada$kpiData
    
    # Retrieve the selected row's data from the data table
    selectedData <- kpiData[selected, ]

    data <- kolada$GetAllData(kpi_id = selectedData[["id"]], 
      municipality = input$municipality, 
      year = input$year
    )
    # Update the current table to "details"
    currentTable("details")
    output$detailsTable <- renderPrint({
        print(data)  # Print the selected data
      })
      }else {
      currentTable("main")
    } 
  })

  # Render the appropriate table based on the currentTable value
  output$mainTable <- renderUI({
    if (currentTable() == "main") {
      DTOutput("demo")
    } else {
      NULL  # Render nothing if not on the main table
    }
  })

  output$detailsTableUI <- renderUI({
    if (currentTable() == "details") {
      verbatimTextOutput("detailsTable")  
    } else {
      NULL  # Render nothing if not on the details table
    }
  })
}

