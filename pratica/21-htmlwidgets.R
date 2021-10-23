library(shiny)
library(shinydashboard)

library(plotly)
library(reactable)
library(leaflet)

# remotes::install_github("abjur/abjData")

pnud <- abjData::pnud_min %>% 
  dplyr::filter(ano == "2010")

ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "PNUD-MUNI"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informações gerais", tabName = "info")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "info",
        h2("Informações gerais dos municípios"),
        br(),
        fluidRow(
          infoBoxOutput(
            outputId = "num_muni",
            width = 4
          ),
          infoBoxOutput(
            outputId = "maior_idhm",
            width = 4
          ),
          infoBoxOutput(
            outputId = "menor_idhm",
            width = 4
          ),
        ),
        
        shiny::fluidRow(
          shinydashboard::box(
            width = 6,
            title = "Renda e expectativa de vida",
            plotly::plotlyOutput("grafico")
          ),
          shinydashboard::box(
            width = 6,
            title = "Mapa",
            leaflet::leafletOutput("mapa")
          )
        ),
        fluidRow(
          shinydashboard::box(
            width = 12,
            title = "Dados",
            reactable::reactableOutput("tabela")
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  output$num_muni <- renderInfoBox({
    infoBox(
      title = "Número de municípios",
      value = dplyr::n_distinct(pnud$muni_id),
      color = "orange",
      icon = icon("film"),
      fill = TRUE
    )
  })
  
  output$maior_idhm <- renderInfoBox({
    

    infoBox(
      title = "Maior IDHM",
      subtitle = pnud$muni_nm[which.max(pnud$idhm)],
      value = max(pnud$idhm), 
      fill = TRUE,
      color = "teal",
      icon = icon("hand-point-right")
    )
  })
  
  output$menor_idhm <- renderInfoBox({
    
    infoBox(
      title = "Menor IDHM",
      subtitle = pnud$muni_nm[which.min(pnud$idhm)],
      value = min(pnud$idhm), 
      fill = TRUE,
      color = "teal",
      icon = icon("hand-point-right")
    )
  })
  
  
  output$grafico <- plotly::renderPlotly({
    p <- pnud %>% 
      ggplot() +
      aes(rdpc, espvida, colour = regiao_nm, size = pop/1e6) +
      geom_point() +
      scale_colour_viridis_d(begin = .2, end = .8) +
      theme_minimal(12) +
      labs(
        x = "Renda per capita",
        y = "Expectativa de vida",
        colour = "Região",
        size = "População"
      )
    p
    ggplotly(p)
  })
  
  output$mapa <- leaflet::renderLeaflet({
    
    pnud %>% 
      leaflet() %>% 
      addTiles() %>% 
      addMarkers(
        lng = ~lon,
        lat = ~lat,
        popup = ~muni_nm, 
        clusterOptions = markerClusterOptions()
      )
    
  })
  
  output$tabela <- reactable::renderReactable({
    
    pnud %>% 
      dplyr::arrange(dplyr::desc(idhm)) %>% 
      dplyr::select(
        muni_id, muni_nm, uf_sigla, regiao_nm, idhm,
        espvida, rdpc, gini, pop
      ) %>% 
      reactable::reactable(
        columns = list(
          muni_id = colDef("ID"),
          muni_nm = colDef("Município", minWidth = 100),
          uf_sigla = colDef("UF"),
          regiao_nm = colDef("Região"),
          idhm = colDef("IDH-M", format = colFormat(digits = 3)),
          espvida = colDef("Exp. Vida"),
          rdpc = colDef("Renda", format = colFormat(currency = "BRL")),
          gini = colDef("Gini", format = colFormat(digits = 2)),
          pop = colDef("População", format = colFormat(
            digits = 2, separators = TRUE, locales = "pt-BR"
          ))
        ),
        striped = TRUE,
        compact = TRUE, 
        highlight = TRUE
      )
    
    
  })
  
}

shinyApp(ui, server)