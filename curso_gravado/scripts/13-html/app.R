library(shiny)
library(ggplot2)

ui <- fluidPage(
  h1("Painel de dados da Curso-R"),
  hr(),
  p("Este painel de dados oferece uma visualização abrangente 
    e intuitiva, possibilitando uma análise detalhada de 
    métricas e tendências chave. Com gráficos interativos e 
    atualizações em tempo real, facilita o rastreamento de 
    desempenho e a identificação de oportunidades de melhoria, 
    apoiando decisões baseadas em dados."),
  # includeMarkdown("descricao.md"),
  plotOutput("grafico"),
  img(
    src = "logo.png",
    width = "400px"
  )
)

server <- function(input, output, session) {
  output$grafico <- renderPlot(
    tibble::tibble(
      ano = 2015:2023,
      n_alunos = round(50 + (1:9)*100 + runif(9, -30, 30))
    ) |> 
      ggplot(aes(x = ano, y = n_alunos)) +
      geom_col() +
      theme_minimal()
  )
}

shinyApp(ui, server)