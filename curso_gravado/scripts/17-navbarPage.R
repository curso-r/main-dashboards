library(shiny)

ui <- navbarPage(
  title = "navbar Page",
  tabPanel(
    title = "Página 1",
    titlePanel("Título da página 1"),
    fluidRow(
      column(
        width = 6,
        plotOutput("grafico1")
      ),
      column(
        width = 6,
        tableOutput("tabela")
      )
    )
  ),
  tabPanel(
    title = "Página 2",
    titlePanel("Título da página 2"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "variavel",
          label = "Selecione uma variável",
          choices = names(mtcars)
        )
      ),
      mainPanel(
        plotOutput("grafico2")
      )
    )
  ),
  navbarMenu(
    title = "Várias páginas",
    tabPanel(
      title = "Página 3",
      titlePanel("Título da página 3")
    ),
    tabPanel(
      title = "Página 4",
      titlePanel("Título da página 4")
    ),
    tabPanel(
      title = "Página 5",
      titlePanel("Título da página 5")
    )
  )
)

server <- function(input, output, session) {
  
  output$grafico1 <- renderPlot({
    plot(x = mtcars[["wt"]], y = mtcars[["mpg"]])
  })
  
  output$grafico2 <- renderPlot({
    plot(x = mtcars[[input$variavel]], y = mtcars[["mpg"]])
  })
  
  output$tabela <- renderTable({
    mtcars |> 
      dplyr::filter(mpg > mean(mpg))
  })
  
}

shinyApp(ui, server)








