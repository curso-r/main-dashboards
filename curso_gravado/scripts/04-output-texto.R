# app com um texto como output

library(shiny)

ui <- fluidPage(
  titlePanel("Exemplo com textOutput/renderText"),
  textOutput(outputId = "texto")
)

server <- function(input, output, session) {
  
  output$texto <- renderText({
    glue::glue(
      "A minha versão do R é: {R.version$major}.{R.version$minor}"
    )
  })
  
}

shinyApp(ui, server)