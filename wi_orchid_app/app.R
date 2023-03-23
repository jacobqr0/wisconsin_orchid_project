#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(httr)
library(jsonlite)

# Define the UI for the dashboard
ui <- fluidPage(
    titlePanel("iNaturalist Orchid Search"),
    sidebarLayout(
        sidebarPanel(
            textInput("location", "Enter your location:"),
            actionButton("search", "Search for Orchids")
        ),
        mainPanel(
            leafletOutput("map")
        )
    )
)

# Define the server logic
server <- function(input, output) {
    
    # Define the function to get the orchid data
    get_orchid_data <- function(location) {
        
        # Define the API endpoint and parameters
        endpoint <- "https://api.inaturalist.org/v1/observations"
        params <- list(q = "Orchidaceae", verifiable = TRUE, quality_grade = "research", 
                       lat: input$map_click$lat, lng: input$map_click$lng, radius: 10)
        
        # Make the API call and parse the JSON response
        response <- GET(endpoint, query = params)
        orchid_data <- fromJSON(rawToChar(response$content))
        
        # Return the orchid data
        orchid_data
    }
    
    # Define the function to render the map
    output$map <- renderLeaflet({
        leaflet() %>%
            addTiles() %>%
            setView(0, 0, zoom = 2)
    })
    
    # Define the event for when the user clicks the map
    observeEvent(input$map_click, {
        # Get the orchid data for the clicked location
        orchid_data <- get_orchid_data(input$location)
        
        # Render the orchid data on the map
        leafletProxy("map", data = orchid_data) %>%
            clearMarkers() %>%
            addMarkers(lng = orchid_data$results$longitude,
                       lat = orchid_data$results$latitude,
                       popup = orchid_data$results$scientific_name)
    })
}

# Run the dashboard
shinyApp(ui = ui, server = server)

