library(shiny)

ui <- fluidPage(
  titlePanel("Exemplo com textInput"),
  textInput(
    inputId = "nome",
    label = "Digite o seu nome",
    value = ""
  ),
  textOutput(
    outputId = "saudacao"
  )
)

server <- function(input, output, session) {
  
  output$saudacao <- renderText({
    paste0("Olá, ", input$nome, ", como vai?")
  })
  
}

shinyApp(ui, server)