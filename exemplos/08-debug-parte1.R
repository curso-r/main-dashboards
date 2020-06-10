library(shiny)

ui <- fluidPage(
  "Histograma da distribuição normal",
  sliderInput(
    inputId = "num",
    label = "Selecione o tamanho da amostra",
    min = 1,
    max = 1000,
    value = 100,
  ),
  textInput(inputId = "titulo", label = "Título do gráfico"),
  actionButton("atualizar", "Gerar gráfico"),
  plotOutput(outputId = "hist"),
  "Tabela com sumário"
  tableOutput(outputId = "sumario")
)

server <- function(input, output, session) {
  
  amostra <- reactive({
    rnorm(input$num)
  })
  
  titulo <- eventReactive(input$atualizar, ignoreNULL = FALSE, {
    input$titulos
  })
  
  output$hist <- renderPlot({
    hist(amostra, main = titulo())
  })
  
  output$sumario <- renderPlot({
    data.frame(
      media = mean(amostra()),
      dp = dp(amostra()),
      min = min(amostra()),
      max = max(amostra())
    )
  })
  
}

shinyApp(ui, server)