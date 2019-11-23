library(shiny)
library(magrittr)

ui <- pageWithSidebar(
  headerPanel = headerPanel("Hello Shiny!"),
  
  sidebarPanel(
    sliderInput("num", "Sample size:", min = 0, max = 150, value = 50)
  ),
  
  mainPanel(
    plotOutput("iris_plot")
  )
)

server <- function(input, output, session) {
  
  output$iris_plot <- renderPlot({
    ggplot(iris %>% sample_n(input$num)) + geom_point(aes(x = Petal.Width, y = Sepal.Length))
  })
}

shinyApp(ui, server)