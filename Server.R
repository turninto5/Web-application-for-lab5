
library(httr)
library(jsonlite)
library(DT)


rkolada <- setRefClass(
  "rkolada",
  fields = list(
    api = "character",
    kpiData = "character"

  ),
  methods = list(
    initialize = function() {
      .self$api <- "http://api.kolada.se/v2"
      .self$kpiData <- "data/kpi"
    },

    getDataID = function(kpi_id = NA, municipality_id = NA, year = NA) {
    queryUrl <- paste0(.self$api, "/", .self$kpiData, "/", kpi_id, "/municipality/", municipality_id, "/year/", year)
    print(queryUrl)
    response <- GET(queryUrl)
    if (status_code(response) != 200) {
      stop("Error: Unable to fetch data. Status code: ", status_code(response))
    }
    data <- parseJson(response)
    values <- data$values[[1]]
    data$values <- NULL
    data$value <- values$value
    data$gender <- values$gender
    data$status <- values$status
    data$count <- values$count
    return(as.data.frame(data))
    },

    getDataKW = function(entity  = NA, title = NA){
      title_en = URLencode(title)
      queryUrl <- paste0(.self$api, "/", entity, "?title=", title_en)
      print(queryUrl)
      response <- GET(queryUrl)
      if (status_code(response) != 200){
        stop("Error: Unable to fetch data. Status code: ", status_code(response))
      }
      data <- parseJson(response)


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

  observeEvent(input$search_id, {
    data <- kolada$getDataID(kpi_id = input$kpi, municipality_id = input$municipality, year = input$year)
    output$idTable <- renderDataTable({
     datatable(data)
    })
  })

  observeEvent(input$search_kw, {
    data <- kolada$getDataKW(title = input$title, entity = input$entity)
    output$kwTable <-renderDataTable({
      datatable(data)
    })
  })
}



