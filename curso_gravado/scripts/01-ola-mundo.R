library(shiny)

ui <- fluidPage(
  "Olá, mundo!"
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)