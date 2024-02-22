# exemplo de selectInput

library(shiny)

ui <- fluidPage(
  selectInput(
    inputId = "variavel",
    label = "Selecione uma variável",
    choices = c("Variável 1", "Variável 2", "Variável 3")
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)