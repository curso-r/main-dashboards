library(shiny)

ui <- fluidPage(
  titlePanel("Barra de progresso"),
  sidebarLayout(
    sidebarPanel(
      varSelectInput(
        inputId = "variavel",
        label = "Eixo x",
        data = mtcars
      )
    ),
    mainPanel(
      plotOutput("grafico")
    )
  )
)

server <- function(input, output, session) {
  
  output$grafico <- renderPlot({
    
    withProgress(message = "Coletando os dados...", {
      Sys.sleep(1)
      incProgress(1/3, message = "Manipulando dados...")
      Sys.sleep(1)
      incProgress(1/3, message = "Gerando gráfico...")
      Sys.sleep(1)
      plot(x = mtcars[[input$variavel]], y = mtcars$mpg)
      incProgress(1/3)
    })
    
  })
  
}

shinyApp(ui, server)