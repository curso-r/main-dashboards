library(shiny)

ui <- fluidPage(
  "Resultado do sorteio",
  sliderInput(
    inputId = "tamanho",
    label = "Selecione o tamanho da amostra",
    min = 1,
    max = 1000,
    value = 100
  ),
  plotOutput(outputId = "grafico"),
  textOutput(outputId = "resultado")
)

server <- function(input, output, session) {
  
  amostra <- sample(1:10, input$tamanho, replace = TRUE)
  
  output$grafico <- renderPlot({
    amostra |> 
      table() |> 
      barplot()
  })
  
  output$resultado <- renderText({
    contagem <- table(amostra)
    mais_freq <- names(contagem[which.max(contagem)])
    glue::glue("O valor mais sorteado foi o {mais_freq}.")
  })
}

shinyApp(ui, server)