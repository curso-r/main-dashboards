library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Exemplo com dois inputs e dois outputs"),
  hr(),
  selectInput(
    inputId = "variavel_A",
    label = "Variável do eixo x do gráfico A",
    choices = names(mtcars),
    selected = "wt"
  ),
  plotOutput(outputId = "grafico_A"),
  hr(),
  selectInput(
    inputId = "variavel_B",
    label = "Variável do eixo x do gráfico B",
    choices = names(mtcars),
    selected = "wt"
  ),
  plotOutput(outputId = "grafico_B"),
)

server <- function(input, output, session) {
  
  output$grafico_A <- renderPlot({
    print("Rodei código do gráfico A")
    mtcars |> 
      ggplot() +
       geom_point(aes(x = .data[[input$variavel_A]], y = mpg))
  })
  
  output$grafico_B <- renderPlot({
    print("Rodei código do gráfico B")
    mtcars |> 
      ggplot() +
      geom_point(aes(x = .data[[input$variavel_B]], y = mpg))
  })
  
}

shinyApp(ui, server)