library(shiny)

ui <- fluidPage(
  titlePanel("Dois inputs, dois outputs"),
  hr(),
  selectInput(
    inputId = "eixo_x_1",
    label = "Selecione a variável do eixo x do gráfico 1",
    choices = names(mtcars)
  ),
  plotOutput(outputId = "grafico_1"),
  hr(),
  selectInput(
    inputId = "eixo_x_2",
    label = "Selecione a variável do eixo x do gráfico 2",
    choices = names(mtcars)
  ),
  plotOutput(outputId = "grafico_2")
)

server <- function(input, output, session) {
  
  output$grafico_1 <- renderPlot({
    plot(x = mtcars[[input$eixo_x_1]], y = mtcars$mpg)
    print("Rodando o código do gráfico 1")
  })
  
  output$grafico_2 <- renderPlot({
    plot(x = mtcars[[input$eixo_x_2]], y = mtcars$mpg)
    print("Rodando o código do gráfico 2")
  })
  
}

shinyApp(ui, server)










