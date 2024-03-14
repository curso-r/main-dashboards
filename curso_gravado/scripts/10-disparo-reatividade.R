library(shiny)

ui <- fluidPage(
  textInput(inputId = "entrada", label = "Escreva um texto"),
  textOutput(outputId = "saida")
)

server <- function(input, output, session) {
  
  texto <- reactive({
    print("passei por aqui")
    input$entrada
  })
  
  output$saida <- renderText({
    # texto()
    input$entrada
  })
}

shinyApp(ui, server)