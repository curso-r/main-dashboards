library(shiny)
library(ggplot2)

ui <- bslib::page_fillable(
  titlePanel("Elementos bslib"),
  bslib::layout_columns(
    col_widths = c(4, 4, 4, 6, 6),
    bslib::value_box(
      title = "Número de carros",
      value = nrow(mtcars),
      showcase = bsicons::bs_icon(name = "car-front")
    ),
    bslib::value_box(
      title = "Maior consumo",
      value = glue::glue("{max(mtcars$mpg)} milhas/galão"),
      showcase = bsicons::bs_icon(name = "fuel-pump")
    ),
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
  
  output$vb_menor_consumo <- renderUI({
    bslib::value_box(
      title = "Menor consumo",
      value = glue::glue("{min(mtcars$mpg)} milhas/galão"),
      showcase = bsicons::bs_icon(name = "speedometer2")
    )
  })
  
  output$grafico_peso <- renderPlot({
    mtcars |> 
      ggplot(aes(x = wt, y = mpg)) +
      geom_point() +
      geom_smooth(se = FALSE) +
      theme_minimal()
  })
  
  output$grafico_potencia <- renderPlot({
    mtcars |> 
      ggplot(aes(x = hp, y = mpg)) +
      geom_point() +
      geom_smooth(se = FALSE) +
      theme_minimal()
  })
  
}

shinyApp(ui, server)