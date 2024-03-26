library(shiny)
library(dplyr)

imdb <- readr::read_rds(here::here("dados/imdb.rds"))
# Só vai rodar no momento do Run App
# Pode ser acessada na UI

ui <- fluidPage(
  sliderInput(
    inputId = "periodo",
    label = "Período",
    min = min(imdb$ano, na.rm = TRUE),
    max = max(imdb$ano, na.rm = TRUE),
    value = c(2010, 2020),
    step = 1,
    sep = ""
  ),
  tableOutput(outputId = "tabela")
)

server <- function(input, output, session) {
  
  imdb <- readr::read_rds(here::here("dados/imdb.rds"))
  # Vai rodar toda vez que alguém acessar o seu app
  # Não pode ser acessada na UI
  
  output$tabela <- renderTable({
    imdb |> 
      filter(ano %in% input$periodo[1]:input$periodo[2]) |> 
      select(titulo, ano, direcao, receita, orcamento) |> 
      mutate(lucro = receita - orcamento) |>
      slice_max(n = 20, order_by = lucro) |> 
      arrange(desc(lucro)) |>
      mutate(
        ano = as.integer(ano),
        across(
          c(lucro, receita, orcamento),
          ~ scales::dollar(.x)
        )
      )
  })
  
}

shinyApp(ui, server)
