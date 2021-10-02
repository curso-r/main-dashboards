library(shiny)

ui <- fluidPage(
  textInput("entrada", "texto"),
  textOutput("texto")
)

server <- function(input, output, session) {
  a <- reactive({
    print("TESTE")
    input$entrada
  })
  
  output$texto <- renderText({
    a()
  })
}

shinyApp(ui, server)