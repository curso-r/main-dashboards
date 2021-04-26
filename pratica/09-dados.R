library(shiny)
library(tidyverse)

ui <- fluidPage(
  sliderInput(
    inputId = "anos",
    label = "Selecione o intervalo de anos",
    min = 1916,
    max = 2016,
    value = c(2000, 2010),
    step = 1,
    sep = ""
  ),
  tableOutput(outputId = "table")
)

server <- function(input, output, session) {
  
  imdb <- read_rds("../dados/imdb.rds")
  
  output$table <- renderTable({
    imdb %>% 
      filter(ano %in% input$anos[1]:input$anos[2]) %>% 
      select(titulo, ano, diretor, receita, orcamento) %>% 
      mutate(lucro = receita - orcamento) %>%
      top_n(20, lucro) %>% 
      arrange(desc(lucro)) %>% 
      mutate_at(vars(lucro, receita, orcamento), ~ scales::dollar(.x))
  })
  
}

shinyApp(ui, server)