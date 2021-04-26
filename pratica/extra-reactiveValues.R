library(shiny)

ui <- fluidPage(
  actionButton("botao", label = "Clique aqui"),
  br(),
  plotOutput("grafico1"),
  plotOutput("grafico2")
)

server <- function(input, output, session) {
  
  bases <- reactiveValues(base1 = ggplot2::diamonds, base2 = mtcars)
  
  observeEvent(input$botao, {
    
    bases$base1 <- dplyr::sample_frac(ggplot2::diamonds, size = 0.5)
    bases$base2 <- dplyr::sample_frac(mtcars, size = 0.5)
    
  })
  
  output$grafico1 <- renderPlot({
    
    hist(bases$base1$price)
    
  })
  
  output$grafico2 <- renderPlot({
    
    hist(bases$base2$mpg)
    
  })
}

shinyApp(ui, server)