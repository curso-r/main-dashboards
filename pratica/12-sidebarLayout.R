library(shiny)
library(tidyverse)

ui <- fluidPage(
  titlePanel("Shiny com sidebarLayout"),
  sidebarLayout( 
    sidebarPanel(
      sliderInput(
        "num",
        "Número de observações:",
        min = 0,
        max = 1000,
        value = 500
      )
    ),
    mainPanel(
      plotOutput("hist")
    )
  )
)

server <- function(input, output, session) {
  
  imdb <- read_rds(path = "../dados/imdb.rds")
  
  output$hist <- renderPlot({
    amostra <- rnorm(input$num)
    hist(amostra)
  })
  
}

shinyApp(ui, server)