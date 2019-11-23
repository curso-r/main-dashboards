library(shiny)

ui <- fluidPage(
  tabsetPanel(
    tabPanel(
      "tab 1",
      sliderInput("num1", "NUM 1", 0, 100, value = 50),
      plotOutput("rnorm")
    ),
    tabPanel(
      title = "tab 2",
      sliderInput("num2", "NUM 2", 0, 100, value = 20),
      plotOutput("runif")
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)