library(shiny)
library(ggplot2)

ui <- bslib::page_fillable(
  titlePanel("Elementos bslib"),
  bslib::layout_columns(
    col_widths = c(4, 4, 4, 6, 6),
    bslib::value_box(
      title = "Número de carros",
      value = nrow(mtcars),
      showcase = bsicons::bs_icon("car-front")
    ),
    bslib::value_box(
      title = "Maior consumo",
      value = max(mtcars$mpg),
      showcase = bsicons::bs_icon("fuel-pump")
    ),
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
  
  output$vb_menor_consumo <- renderUI({
    bslib::value_box(
      title = "Menor consumo",
      value = min(mtcars$mpg),
      showcase = bsicons::bs_icon("Speedometer")
    )
  })
  
  output$grafico_peso <- renderPlot({
    mtcars |> 
      ggplot(aes(x = wt, y = mpg)) +
      geom_point() +
      geom_smooth(se = FALSE) +
      theme_minimal()
  })
  
  output$grafico_hp <- renderPlot({
    mtcars |> 
      ggplot(aes(x = hp, y = mpg)) +
      geom_point() +
      geom_smooth(se = FALSE) +
      theme_minimal()
  })
  
}

shinyApp(ui, server)