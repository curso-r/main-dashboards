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
    withProgress(message = "Gerando gráfico...", {
      incProgress(0.1, message = "Arruando base...")
      Sys.sleep(1)
      incProgress(0.3, message = "Criando colunas...")
      Sys.sleep(2)
      incProgress(0.4, message = "Gerando gráfico...")
      Sys.sleep(1)
      plot(x = mtcars[[input$variavel]], y = mtcars$mpg)
      incProgress(0.1)
    })
  })
  
}

shinyApp(ui, server)






