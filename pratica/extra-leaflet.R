library(shiny)
library(leaflet)

ui <- fluidPage(
  fluidRow(
    column(
      width = 6,
      br(),
      br(),
      leafletOutput("mapa")
    ),
    column(
      width = 6,
      br(),
      br(),
      htmlOutput("info")
    )
  )
)

server <- function(input, output, session) {
  
  dados <- quakes %>% 
    dplyr::mutate(id = 1:dplyr::n()) %>% 
    dplyr::slice(1:50)
  
  output$mapa <- renderLeaflet({
    dados %>% 
      leaflet() %>% 
      addTiles() %>%
      addMarkers(
        ~long,
        ~lat,
        layerId = ~id
        # popup = ~as.character(mag),
        # label = ~as.character(mag)
      )
  })
  
  output$info <- renderUI({
    
    req(input$mapa_marker_click)
    
    linha <- dados %>% 
      dplyr::filter(id == input$mapa_marker_click$id)
    
    tagList(
      p(
        strong("Profundidade:"), glue::glue("{linha$depth} Km")
      ),
      p(
        strong("Magnitude:"), glue::glue("{linha$mag} na escala Richter")
      ),
      p(
        strong("Reportado por:"), glue::glue("{linha$stations} estações")
      )
      
    )
  })
  
}

shinyApp(ui, server)