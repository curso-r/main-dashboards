# app com um texto como output

library(shiny)

ui <- fluidPage(
  titlePanel("Exemplo com textOutput/renderText"),
  textOutput(outputId = "texto")
)

server <- function(input, output, session) {
  
  output$texto <- renderText({
    versao <- paste0(R.version$major, ".", R.version$minor)
    paste0("A versão do R utilizada é: ", versao)
  })
  
}

shinyApp(ui, server)