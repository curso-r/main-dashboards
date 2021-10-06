library(shiny)
library(shinydashboard)
library(tidyverse)

ui <- dashboardPage(
  dashboardHeader(title = "IMDB"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informações gerais", tabName = "info"),
      menuItem("Orçamentos", tabName = "orcamentos"),
      menuItem("Receitas", tabName = "receitas")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "info",
        h1("Informações gerais dos filmes"),
        br(),
        fluidRow(
          infoBoxOutput(
            outputId = "num_filmes",
            width = 4
          ),
          infoBoxOutput(
            outputId = "num_diretores",
            width = 4
          ),
          infoBoxOutput(
            outputId = "num_atores",
            width = 4
          )
        )
      ),
      tabItem(
        tabName = "orcamentos",
        h1("Analisando os orçamentos"),
        br(),
        box(
          width = 12,
          selectInput(
            inputId = "genero_orcamento",
            label = "Selecione um genero",
            choices = c("Action", "Comedy", "Romance"),
            width = "25%"
          )
        ),
        box(
          width = 6,
          title = "Série do orçamento",
          solidHeader = TRUE,
          status = "primary",
          plotOutput("serie_orcamento")
        )
        
      ),
      tabItem(
        tabName = "receitas",
        h1("Analisando as receitas")
      )
    )
  )
)

server <- function(input, output, session) {
  
  imdb <- read_rds("../dados/imdb.rds")
  
  output$num_filmes <- renderInfoBox({
    infoBox(
      title = "Número de filmes",
      value = nrow(imdb),
      icon = icon("film"),
      fill = TRUE
    )
  })
  
  output$num_diretores <- renderInfoBox({
    infoBox(
      title = "Número de diretores",
      value = n_distinct(imdb$diretor),
      fill = TRUE,
      icon = icon("hand-point-right")
    )
  })
  
  output$num_atores <- renderInfoBox({
    
    num_atores <- imdb %>% 
      select(starts_with("ator")) %>% 
      pivot_longer(cols = ator_1:ator_3) %>% 
      distinct(value) %>% 
      nrow()
    
    infoBox(
      title = "Número de atores",
      value = num_atores,
      fill = TRUE,
      icon = icon("user-friends")
    )
  })
  
  output$serie_orcamento <- renderPlot({
    imdb %>% 
      filter(str_detect(generos, input$genero_orcamento)) %>% 
      group_by(ano) %>% 
      summarise(orcamento_medio = mean(orcamento)) %>% 
      filter(!is.na(orcamento_medio)) %>% 
      ggplot(aes(x = ano, y = orcamento_medio)) +
      geom_line()
  })
  
  
  
}

shinyApp(ui, server)