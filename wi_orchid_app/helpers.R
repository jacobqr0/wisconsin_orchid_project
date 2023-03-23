# Define the function to get the orchid data
get_orchid_data <- function(location) {
  
  # Define the API endpoint and parameters
  endpoint <- "https://api.inaturalist.org/v1/observations"
  params <- list(q = "Orchidaceae", verifiable = TRUE, quality_grade = "research", 
                 lat = location[[1]], lng = location[[2]], radius = 1000)
  
  # Make the API call and parse the JSON response
  response <- GET(endpoint, query = params)
  orchid_data <- fromJSON(rawToChar(response$content))
  
  # Return the orchid data
  orchid_data
}

# Test the orchid data function 
location <- list(47.765529, -90.313098)
out <-  get_orchid_data(location)

frame <- out["results"]
