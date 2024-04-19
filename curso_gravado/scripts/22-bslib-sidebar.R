library(shiny)
library(ggplot2)

ui <- bslib::page_sidebar(
  sidebar = bslib::sidebar(
    h5("Filtros"),
    selectInput(
      inputId = "cyl",
      label = "Número de cilindros",
      choices = sort(unique(mtcars$cyl))
    )
  ),
  titlePanel("Elementos bslib"),
  bslib::layout_columns(
    col_widths = c(4, 4, 4, 6, 6),
    uiOutput("vb_carros", fill = TRUE),
    uiOutput("vb_maior_consumo", fill = TRUE),
    uiOutput("vb_menor_consumo", fill = TRUE),
    bslib::card(
      bslib::card_header(
        bslib::card_title("Consumo vs peso")
      ),
      bslib::card_body(
        plotOutput("grafico_peso")
      )
    ),
    bslib::card(
      bslib::card_header(
        bslib::card_title("Consumo vs potência")
      ),
      bslib::card_body(
        plotOutput("grafico_hp")
      )
    )
  )
)

server <- function(input, output, session) {
  
  dados_filtrados <- reactive({
    mtcars |> 
      dplyr::filter(cyl == input$cyl)
  })
  
  output$vb_carros <- renderUI({
    bslib::value_box(
      title = "Número de carros",
      value = nrow(dados_filtrados()),
      showcase = bsicons::bs_icon("car-front")
    )
  })
  
  output$vb_maior_consumo <- renderUI({
    bslib::value_box(
      title = "Maior consumo",
      value = max(dados_filtrados()$mpg),
      showcase = bsicons::bs_icon("fuel-pump")
    )
  })
  
  output$vb_menor_consumo <- renderUI({
    bslib::value_box(
      title = "Menor consumo",
      value = min(dados_filtrados()$mpg),
      showcase = bsicons::bs_icon("Speedometer")
    )
  })
  
  output$grafico_peso <- renderPlot({
    dados_filtrados() |> 
      ggplot(aes(x = wt, y = mpg)) +
      geom_point() +
      geom_smooth(se = FALSE) +
      theme_minimal()
  })
  
  output$grafico_hp <- renderPlot({
    dados_filtrados() |> 
      dplyr::filter(cyl == input$cyl) |> 
      ggplot(aes(x = hp, y = mpg)) +
      geom_point() +
      geom_smooth(se = FALSE) +
      theme_minimal()
  })
  
}

shinyApp(ui, server)