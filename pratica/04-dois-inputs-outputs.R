library(shiny)

variaveis <- names(mtcars)

ui <- fluidPage(
  selectInput(
    inputId = "variavel_A",
    label = "Variável A",
    choices = variaveis
  ),
  plotOutput(outputId = "histograma_A"),
  selectInput(
    inputId = "variavel_B",
    label = "Variável B",
    choices = variaveis,
    selected = variaveis[2],
  ),
  plotOutput(outputId = "histograma_B")
)

server <- function(input, output, session) {
  
  output$histograma_A <- renderPlot({
    print("Gerando histograma A...")
    hist(mtcars[[input$variavel_A]], main = "Histograma A")
  })
  
  output$histograma_B <- renderPlot({
    print("Gerando histograma B...")
    hist(mtcars[[input$variavel_B]], main = "Histograma B")
  })
  
}

shinyApp(ui, server)