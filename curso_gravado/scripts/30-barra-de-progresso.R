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
    withProgress(message = "Construindo gráfico...", {
      Sys.sleep(1)
      incProgress(0.1, message = "Importando base de dados...")
      Sys.sleep(1)
      incProgress(0.2, message = "Criando tabela do gráfico...")
      Sys.sleep(1)
      incProgress(0.6, message = "Gerando o gráfico...")
      plot(x = mtcars[[input$variavel]], y = mtcars$mpg)
      Sys.sleep(1)
    })
    
  })
  
}

shinyApp(ui, server)






