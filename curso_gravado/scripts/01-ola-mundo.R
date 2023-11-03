library(shiny)

# user interface (interface de usuário)
ui <- fluidPage(
  "Olá, mundo!"
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)