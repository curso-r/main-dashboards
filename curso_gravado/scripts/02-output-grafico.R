# app com um gráfico como output

library(shiny)
library(ggplot2)

ui <- fluidPage(
  plotOutput(outputId = "plot"),
  plotOutput(outputId = "ggplot")
)

server <- function(input, output, session) {
  
  output$plot <- renderPlot({
    plot(x = mtcars$wt, y = mtcars$mpg)
  })
  
  output$ggplot <- renderPlot({
    mtcars |> 
      ggplot() +
      geom_point(aes(x = wt, y = mpg))
  })
  
}

shinyApp(ui, server)