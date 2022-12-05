library(shiny)

ui <- fluidPage(
    title = "Spotify Wrapped into Image",
    actionButton("spotify", "Spotify"), 
    imageOutput("image")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)