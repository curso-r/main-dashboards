library(shiny)

ui <- fluidPage(
  "Histograma da distribuição normal",
  sliderInput(
    inputId = "num",
    label = "Selecione o tamanho da amostra",
    min = 1,
    max = 1000,
    value = 100
  ),
  plotOutput(outputId = "hist")
)

server <- function(input, output, session) {
  
  output$hist <- renderPlot({
    amostra <- rnorm(input$num)
    hist(amostra)
  })
    
}

shinyApp(ui, server)