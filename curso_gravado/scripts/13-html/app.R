library(shiny)
library(ggplot2)

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", href = "custom.css")
  ),
  h1("Painel de dados da Curso-R"),
  hr(),
  includeMarkdown("descricao.md"),
  plotOutput("grafico"),
  img(
    src = "logo.png", 
    width = "400px",
    style = "display: block; margin: auto;"
  )
)

server <- function(input, output, session) {
  
  output$grafico <- renderPlot({
    tibble::tibble(
      ano = 2015:2023,
      n_alunos = round(50 + (0:8)*100 + runif(9, -50, 50))
    ) |> 
      ggplot(aes(x = ano, y = n_alunos)) +
      geom_col() +
      theme_minimal()
  })
  
}

shinyApp(ui, server)