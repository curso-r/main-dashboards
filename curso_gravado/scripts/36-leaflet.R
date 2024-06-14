# https://rstudio.github.io/leaflet
# https://rstudio.github.io/leaflet/articles/shiny.html 

# municipios <- abjData::pnud_min |> 
#   dplyr::filter(ano == 2010) |> 
#   dplyr::select(muni_id, uf_sigla, muni_nm, idhm, lat, lon) |> 
#   dplyr::arrange(uf_sigla, muni_nm)
# 
# readr::write_csv(municipios, "curso_gravado/scripts/municipios.csv")

dados <- readr::read_csv("municipios.csv")

library(shiny)

ui <- fluidPage(
  titlePanel("Leaflet"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "estado",
        label = "Selecione o estado",
        choices = unique(dados$uf_sigla)
      ),
      selectInput(
        inputId = "muni",
        label = "Selecione o município",
        choices = "",
        multiple = TRUE
      ),
      textOutput("texto")
    ),
    mainPanel(
      leaflet::leafletOutput("mapa")
    )
  )
)

server <- function(input, output, session) {
  
  observe({
    municipios <- dados |>
      dplyr::filter(uf_sigla == input$estado) |>
      dplyr::select(muni_nm, muni_id) |> 
      tibble::deframe()
    
    updateSelectInput(
      session = session,
      inputId = "muni",
      choices = municipios,
      selected = municipios[1]
    )
  })
  
  output$mapa <- leaflet::renderLeaflet({
    dados |> 
      dplyr::filter(muni_id %in% input$muni) |>
      leaflet::leaflet() |>
      leaflet::addTiles() |>
      leaflet::addMarkers(
        lng = ~lon,
        lat = ~lat,
        layerId = ~muni_id,
        popup = ~paste(muni_nm, "<br>", "IDHM: ", idhm)
      )
  })
  
  output$texto <- renderText({
    clique <- input$mapa_marker_click
    
    req(clique)
    
    muni <- dados |> 
      dplyr::filter(muni_id == clique$id) |>
      dplyr::pull(muni_nm)
    
    glue::glue("Você clicou no município {muni}")
    
  })
  
}

shinyApp(ui, server)