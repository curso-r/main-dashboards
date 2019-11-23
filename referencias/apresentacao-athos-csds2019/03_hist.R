library(shiny)

ui <- fluidPage(
  "Hello World!",
  
  sliderInput(
    inputId = "num",
    label = "Number of observations: ",
    min = 1,
    max = 100,
    value = 20,
  ),
  
  textInput("title", "Title of the Histogram: "),
  actionButton("update", "Update!"),
  
  plotOutput("hist"),
  verbatimTextOutput("summary"),
  actionButton("write_data", "Write Data as CSV")
)

server <- function(input, output, session) {
  
  data <- eventReactive(input$update, {
    rnorm(input$num)
  })
  
  output$hist <- renderPlot({
    title <- isolate(input$title)
    hist(data(), main = title)
  })
  
  output$summary <- renderPrint({
    summary(data())
  })
  
  observeEvent(input$write_data, {
    write.csv(data(), "data.csv")
    cat("done!\n")
  })
  
  observe({
    print(data())
    print(as.numeric(input$write_data))
  })
}

shinyApp(ui, server)