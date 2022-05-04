library(shiny)
library(dplyr)
library(ggplot2)

pnud <- abjData::pnud_min

ui <- fluidPage(
  h1("Municípios do Brasil"),
  hr(),
  fluidRow(
    column(
      width = 4,
      selectInput(
        "ano",
        label = "Selecione um ano",
        choices = unique(pnud$ano)
      )
    )
  ),
  hr(),
  fluidRow(
    column(
      width = 6,
      plotly::plotlyOutput("grafico")
    ),
    column(
      width = 6,
      leaflet::leafletOutput("mapa")
    )
  ),
  br(),
  br(),
  fluidRow(
    column(
      width = 12,
      reactable::reactableOutput("tabela")
    )
  ),
  br(),
  br(),
  fluidRow(
    column(
      width = 12,
      echarts4r::echarts4rOutput("echart")
    ),
    column(
      width = 12,
      highcharter::highchartOutput("highchart")
    )
  )
)

server <- function(input, output, session) {

  pnud_filtrada <- reactive({
    pnud %>%
      filter(ano == input$ano)
  })

  # Usando ggplotly

  # output$grafico <- plotly::renderPlotly({
  #
  #   p <- pnud_filtrada() %>%
  #     ggplot(aes(label = muni_nm)) +
  #     geom_point(
  #       aes(x = rdpc, y = espvida, color = regiao_nm, size = pop)
  #     ) +
  #     labs(
  #       x = "Renda per capita",
  #       y = "Expectativa de vida",
  #       color = "",
  #       size = ""
  #     )
  #
  #   plotly::ggplotly(p)
  #
  # })

  # Sem usar ggplotly

  output$grafico <- plotly::renderPlotly({

    plotly::plot_ly(
      pnud_filtrada(),
      x = ~rdpc,
      y = ~espvida,
      color = ~regiao_nm,
      size = ~pop,
      type = "scatter"
    )

  })

  output$mapa <- leaflet::renderLeaflet({


    pnud_filtrada() %>%
      leaflet::leaflet() %>%
      leaflet::addTiles() %>%
      leaflet::addAwesomeMarkers(
        lng = ~lon,
        lat = ~lat,
        icon = leaflet::awesomeIcons(
          icon = "picture",
          library = "glyphicon",
          markerColor = "orange"
        ),
        popup = ~muni_nm,
        clusterOptions = leaflet::markerClusterOptions()
      )

  })

  output$tabela <- reactable::renderReactable({

    pnud_filtrada() %>%
      select(
        muni_id,
        muni_nm,
        uf_sigla,
        regiao_nm,
        idhm,
        espvida,
        rdpc,
        gini,
        pop
      ) %>%
      reactable::reactable(
        striped = TRUE,
        highlight = TRUE,
        theme = reactable::reactableTheme(
          stripedColor = "grey"
        ),
        columns = list(
          muni_id = reactable::colDef(
            name = "ID"
          ),
          muni_nm = reactable::colDef("Município", minWidth = 100),
          uf_sigla = reactable::colDef("UF"),
          regiao_nm = reactable::colDef("Região"),
          idhm = reactable::colDef("IDH-M", format =  reactable::colFormat(digits = 3)),
          espvida = reactable::colDef("Exp. Vida", format = reactable::colFormat(digits = 2)),
          rdpc = reactable::colDef("Renda", format =  reactable::colFormat(currency = "BRL")),
          gini = reactable::colDef("Gini", format = reactable::colFormat(digits = 2)),
          pop = reactable::colDef("População", format = reactable::colFormat(
            digits = 2, separators = TRUE, locales = "pt-BR"
          ))
        )
      )

  })

  output$echart <- echarts4r::renderEcharts4r({
    pnud_filtrada() %>%
      group_by(regiao_nm) %>%
      summarise(idhm_medio = mean(idhm, na.rm = TRUE)) %>%
      arrange(idhm_medio) %>%
      echarts4r::e_chart(x = regiao_nm) %>%
      echarts4r::e_bar(serie = idhm_medio)
  })

  output$highchart <- highcharter::renderHighchart({
    pnud_filtrada() %>%
      group_by(regiao_nm) %>%
      summarise(idhm_medio = mean(idhm, na.rm = TRUE)) %>%
      arrange(idhm_medio) %>%
      highcharter::hchart(
        "column",
        highcharter::hcaes(
          x = regiao_nm,
          y = idhm_medio
        )
      )
  })

}

shinyApp(ui, server)
