library(shiny)


# Módulos -----------------------------------------------------------------

# Histograma

histograma_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(
      ns("variavel_x"),
      "Selecione uma variável",
      choices = names(mtcars)
    ),
    br(),
    plotOutput(ns("grafico"))
  )
}

histograma_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$grafico <- renderPlot({
      hist(mtcars[[input$variavel_x]])
    })
    
  })
}

# Dispersão

dispersao_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 6,
        selectInput(
          ns("variavel_x"),
          "Selecione o eixo x",
          choices = names(mtcars)
        )
      ),
      column(
        width = 6,
        selectInput(
          ns("variavel_y"),
          "Selecione o eixo y",
          choices = names(mtcars)
        )
      )
    ),
    br(),
    fluidRow(
      column(
        width = 12,
        plotOutput(ns("grafico"))
      )
    )
  )
}

dispersao_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$grafico <- renderPlot({
      plot(mtcars[[input$variavel_x]], mtcars[[input$variavel_y]])
    })
    
  })
}

# App ---------------------------------------------------------------------

ui <- fluidPage(
  h1("Treinando a construção de módulos"),
  br(),
  fluidRow(
    column(
      width = 6,
      histograma_ui("histograma")
    ),
    fluidRow(
      column(
        width = 6,
        dispersao_ui("dispersao")
      )
    )
  )
)

server <- function(input, output, session) {
  
  histograma_server("histograma")
  
  dispersao_server("dispersao")
}

shinyApp(ui, server)
