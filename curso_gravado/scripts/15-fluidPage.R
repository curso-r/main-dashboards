library(shiny)

ui <- fluidPage(
  titlePanel("Fluid Page"),
  fluidRow(
    column(
      width = 4,
      # selectInput(
      #   inputId = "variavel",
      #   label = "Selecione uma variável",
      #   choices = names(mtcars)
      # ),
      varSelectInput(
        inputId = "variavel",
        label = "Selecione uma variável",
        data = mtcars
      )
    ),
    column(
      width = 8,
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