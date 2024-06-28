# install.packages("leaflet")

library(shiny)

dados <- readr::read_csv(
  here::here(
    "curso_gravado/scripts/municipios.csv"
  )
)

ui <- fluidPage(
  titlePanel("Leaflet"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "estado",
        label = "Estado",
        choices = sort(unique(dados$uf_sigla))
      ),
      selectInput(
        inputId = "municipio",
        label = "Município",
        choices = c("Carregando..." = "")
      )
    ),
    mainPanel(
      leaflet::leafletOutput("mapa"),
      textOutput("texto")
    )
  )
)

server <- function(input, output, session) {
  
  observe({
    municipios <- dados |> 
      dplyr::filter(uf_sigla == input$estado) |> 
      dplyr::distinct(muni_nm, muni_id) |> 
      tibble::deframe()
    
    updateSelectInput(
      inputId = "municipio",
      choices = municipios
    )
  })
  
  output$mapa <- leaflet::renderLeaflet({
    dados |> 
      dplyr::filter(
        muni_id == input$municipio
      ) |> 
      leaflet::leaflet() |> 
      leaflet::addTiles() |> 
      leaflet::addMarkers(
        lng = ~lon,
        lat = ~lat,
        layerId = ~muni_id,
        popup = ~paste("<b>Município</b>:", muni_nm, "<br>", "<b>IDHM</b>:", idhm)
      )
  })
  
  output$texto <- renderText({
    clique <- input$mapa_marker_click
    
    req(clique)
    
    municipio <- dados |> 
      dplyr::filter(muni_id == clique$id) |> 
      dplyr::pull(muni_nm)
    
    glue::glue("O município clicado foi {municipio}.")
  })
  
}

shinyApp(ui, server)







