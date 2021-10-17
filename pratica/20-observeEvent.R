library(shiny)

ui <- fluidPage(
  textInput("email", "Informe seu e-mail"),
  actionButton("enviar", "Enviar dados")
)

server <- function(input, output, session) {
  
  observeEvent(input$enviar, {
    write(input$email, "emails.txt", append = TRUE)
  })
}

shinyApp(ui, server)