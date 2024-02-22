library(shiny)
library(ggplot2)

ui <- fluidPage(
  selectInput(
    inputId = "variavel",
    label = "Selecione uma variável",
    choices = names(mtcars)
  ),
  plotOutput(outputId = "plot"),
  plotOutput(outputId = "ggplot")
)

server <- function(input, output, session) {
  
  output$plot <- renderPlot({
    plot(x = mtcars[[input$variavel]], y = mtcars$mpg)
  })
  
  output$ggplot <- renderPlot({
    mtcars |> 
      ggplot(aes(x = .data[[input$variavel]], y = mpg)) +
      geom_point()
  })
  
}

shinyApp(ui, server)