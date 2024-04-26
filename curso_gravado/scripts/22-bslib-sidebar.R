library(shiny)
library(ggplot2)

ui <- bslib::page_sidebar(
  sidebar = bslib::sidebar(
    h4("Filtros"),
    selectInput(
      inputId = "num_cilindros",
      label = "Número de cilindros",
      choices = sort(unique(mtcars$cyl))
    )
  ),
  titlePanel("Elementos bslib"),
  bslib::layout_columns(
    col_widths = c(4, 4, 4, 6, 6),
    uiOutput("vb_num_carros", fill = TRUE),
    uiOutput("vb_maior_consumo", fill = TRUE),
    uiOutput(outputId = "vb_menor_consumo", fill = TRUE),
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
        plotOutput("grafico_potencia")
      )
    )
  )
)

server <- function(input, output, session) {
  
  mtcars_filtrada <- reactive({
    mtcars |> 
      dplyr::filter(cyl == input$num_cilindros)
  })
  
  output$vb_num_carros <- renderUI({
    bslib::value_box(
      title = "Número de carros",
      value = nrow(mtcars_filtrada()),
      showcase = bsicons::bs_icon(name = "car-front")
    )
  })
  
  output$vb_maior_consumo <- renderUI({
    valor <- max(mtcars_filtrada()$mpg)
    bslib::value_box(
      title = "Maior consumo",
      value = glue::glue("{valor} milhas/galão"),
      showcase = bsicons::bs_icon(name = "fuel-pump")
    )
  })
  
  output$vb_menor_consumo <- renderUI({
    valor <- min(mtcars_filtrada()$mpg)
    bslib::value_box(
      title = "Menor consumo",
      value = glue::glue("{valor} milhas/galão"),
      showcase = bsicons::bs_icon(name = "speedometer2")
    )
  })
  
  output$grafico_peso <- renderPlot({
    mtcars_filtrada() |> 
      ggplot(aes(x = wt, y = mpg)) +
      geom_point() +
      geom_smooth(se = FALSE) +
      theme_minimal()
  })
  
  output$grafico_potencia <- renderPlot({
    mtcars_filtrada() |> 
      ggplot(aes(x = hp, y = mpg)) +
      geom_point() +
      geom_smooth(se = FALSE) +
      theme_minimal()
  })
  
}

shinyApp(ui, server)