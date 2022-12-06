library(shiny)
library(spotifyr)
library(tidyverse)
library(cld2)
library(openai)

source("helpers.R")

ui <- fluidPage(
    title = "Spotify Wrapped into Image",
    actionButton("spotify", "Spotify"), 
    shinycssloaders::withSpinner(uiOutput("image"))
    # tableOutput("table")
)

server <- function(input, output, session) {
    
    top_tracks <- eventReactive(input$spotify, {
        
        get_my_top_artists_or_tracks(type = "tracks", limit = 50)
        
    }, ignoreInit = TRUE)
    
    top_tracks_clean <- reactive({
        req(top_tracks())
        clean_top_tracks(top_tracks())
    })
    
    # output$table <- renderTable({
    #     req(top_tracks())
    #     
    #     top_tracks() %>% 
    #         select(name)
    # })
    
    # observe({
    #     print(top_tracks_clean())
    # })
    
    output$image <- renderUI({
        
        req(top_tracks_clean())
        
        validate(
            need(
                !create_moderation(top_tracks_clean())$results$flagged, 
                "Oops, your song names violate OpenAI policy."
            )
        )
        
        tags$img(
            src = create_image(top_tracks_clean(), size = "256x256")$data$url
        )
    })
}

shinyApp(ui, server)
