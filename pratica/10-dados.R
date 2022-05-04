library(shiny)
library(dplyr)

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
  
  imdb <- readr::read_rds("../dados/imdb.rds")
  
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
# 
# 
# library(shiny)
# library(dplyr)
# 
# ui <- fluidPage(
#   uiOutput("slider_periodo"),
#   tableOutput(outputId = "tabela")
# )
# 
# server <- function(input, output, session) {
#   
#   imdb <- readr::read_rds("../dados/imdb.rds")
#   
#   output$slider_periodo <- renderUI({
#     sliderInput(
#       inputId = "periodo",
#       label = "Selecione o período",
#       min = min(imdb$ano, na.rm = TRUE),
#       max = max(imdb$ano, na.rm = TRUE),
#       value = c(2000, 2010),
#       step = 1,
#       sep = ""
#     )
#   })
#   
#   output$tabela <- renderTable({
#     imdb %>%
#       filter(ano %in% input$periodo[1]:input$periodo[2]) %>%
#       mutate(lucro = receita - orcamento) %>%
#       select(
#         titulo,
#         ano,
#         `diretor(a)` = diretor,
#         receita,
#         orcamento,
#         lucro
#       ) %>%
#       slice_max(order_by = lucro, n = 20) %>%
#       arrange(desc(lucro)) %>%
#       mutate(
#         across(
#           c(orcamento, receita, lucro),
#           scales::dollar
#         )
#       )
#   })
#   
# }