# exemplo de selectInput

library(shiny)

ui <- fluidPage(
  selectInput(
    inputId = "eixo_x",
    label = "Variável do eixo x",
    choices = names(mtcars)
  ),
  plotOutput(outputId = "grafico")
)

server <- function(input, output, session) {
  
  output$grafico <- renderPlot({
    plot(y = mtcars$mpg, x = mtcars[[input$eixo_x]])
  })
  
}

shinyApp(ui, server)