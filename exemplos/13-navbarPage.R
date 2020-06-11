library(shiny)

ui <- navbarPage(
  title = "Shiny com navbarPage",
  tabPanel(
    title = "Análise descritiva",
    selectInput(
      inputId = "var",
      label = "Selecione uma variável",
      choices = names(mtcars[,-1])
    ),
    selectInput(
      inputId = "var2",
      label = "Selecione uma variável",
      choices = names(mtcars[,-1])
    ),
    plotOutput("grafico_disp")
  ),
  navbarMenu(
    title = "Resultado dos modelos",
    tabPanel(
      title = "Regressão linear",
      h2("Resultados do modelo de regressão linear")
    ),
    tabPanel(
      title = "Árvores de decisão",
      h2("Resultados das árvores de decisão")
    ),
    tabPanel(
      title = "Floresta aleatória",
      h2("Resultados das floresta aleatória")
    )
  )
)

server <- function(input, output, session) {
  
  output$grafico_disp <- renderPlot({
    mtcars %>% 
      select(mpg, xvar = input$var) %>% 
      ggplot(aes(x = xvar, y = mpg)) +
      geom_point() +
      labs(x = input$var)
  })
  
}

shinyApp(ui, server)