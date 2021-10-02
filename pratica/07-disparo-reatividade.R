library(shiny)

ui <- fluidPage(
  textInput(inputId = "entrada", label = "Escreva um texto"),
  textOutput(outputId = "saida")
)

server <- function(input, output, session) {
  a <- reactive({
    print(input$entrada)
    input$entrada
  })
  
  output$saida <- renderText({
    # a()
    input$entrada
  })
}

shinyApp(ui, server)