library(shiny)

ui <- bslib::page_fillable(
  titlePanel("Elementos bslib"),
  plotOutput("grafico_1"),
  plotOutput("grafico_2", fill = FALSE)
)

server <- function(input, output, session) {
  
  output$grafico_1 <- renderPlot({
    plot(x = mtcars$wt, y = mtcars$mpg)
  })
  
  output$grafico_2 <- renderPlot({
    plot(x = mtcars$wt, y = mtcars$mpg)
  })
  
}

shinyApp(ui, server)