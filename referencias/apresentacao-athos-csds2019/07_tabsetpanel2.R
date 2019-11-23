library(shiny)

ui <- ui <- fluidPage(
  
  titlePanel("Tabsets"),
  
  sidebarLayout(
    
    sidebarPanel(
      sliderInput("num", "Sample size: ", 0, 1000, 500)
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("plot")), 
        tabPanel("Summary", verbatimTextOutput("summary")), 
        tabPanel("Table", tableOutput("table"))
      )
    )
  )
)

server <- function(input, output, session) {
  
  data <- reactive({
    rnorm(input$num)
  })
  
  output$plot <- renderPlot({
    hist(data())
  })
  
  output$summary <- renderPrint({
    summary(data())
  })
  
  output$table <- renderTable({
    data()
  })
}

shinyApp(ui, server)