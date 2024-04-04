library(shiny)

ui <- fluidPage(
  titlePanel("Sidebar Layout"),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      varSelectInput(
        inputId = "variavel",
        label = "Selecione uma variável",
        data = mtcars
      )
    ),
    mainPanel = mainPanel(
      plotOutput("grafico")
    )
  )
)

server <- function(input, output, session) {
  
  output$grafico <- renderPlot({
    plot(x = mtcars[[input$variavel]], y = mtcars[["mpg"]])
  })
  
}

shinyApp(ui, server)