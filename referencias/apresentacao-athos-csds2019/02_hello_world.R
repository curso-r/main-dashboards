library(shiny)

ui <- fluidPage(
  h1("Normal Distribution Histogram"),
  
  sliderInput(inputId = "num", label = "Sample size: ", min = 1, max = 100, value = 50),
  textInput("title", label = "Insert Histogram Title: "),
  hr(),
  plotOutput("hist"),
  verbatimTextOutput("summary")
)

server <- function(input, output, session) {
  
  output$hist <- renderPlot({
    hist(rnorm(input$num), main = input$title)   
  })
  
  output$summary <- renderPrint({
    summary(rnorm(input$num))
  })
}

shinyApp(ui, server)