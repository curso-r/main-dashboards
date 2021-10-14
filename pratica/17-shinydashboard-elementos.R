library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)

imdb <- basesCursoR::pegar_base("imdb")

generos <- imdb |> 
  pull(genero) |> 
  stringr::str_split(", ") |> 
  purrr::flatten_chr() |> 
  unique() |> 
  sort()

ui <- dashboardPage(
  dashboardHeader(title = "IMDB"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informações gerais", tabName = "info"),
      menuItem("Financeiro", tabName = "financeiro"),
      menuItem("Elenco", tabName = "elenco")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "info",
        h2("Informações gerais dos filmes"),
        br(),
        fluidRow(
          infoBoxOutput(
            outputId = "num_filmes",
            width = 4
          ),
          infoBoxOutput(
            outputId = "num_dir",
            width = 4
          ),
          infoBoxOutput(
            outputId = "num_atr",
            width = 4
          ),
        ),
        br(),
        fluidRow(
          column(
            width = 12,
            plotOutput("grafico_filmes_ano")
          )
        )
      ),
      tabItem(
        tabName = "financeiro",
        fluidRow(
          column(
            width = 12,
            h2("Visão geral")
          )
        ),
        br(),
        fluidRow(
          box(
            width = 4,
            selectInput(
              inputId = "fin_genero",
              label = "Selecione um ou mais gêneros",
              multiple = TRUE,
              choices = generos,
              selected = generos[1],
              width = "100%"
            )
          ),
          box(
            width = 8,
            title = "Orçamento vs Receita",
            solidHeader = TRUE,
            status = "primary",
            plotOutput("orc_vs_receita")
          )
        )
      ),
      tabItem(
        tabName = "elenco",
        fluidRow(
          column(
            width = 12,
            h2("Elenco")
          )
        )
        # Lição de casa: dado um ator/atriz (ou diretor(a)), mostrar um
        # gráfico com os filmes feitos por essa pessoa e a nota desses filmes.
      )
    )
  )
)

server <- function(input, output, session) {
  
  output$num_filmes <- renderInfoBox({
    infoBox(
      title = "Número de filmes",
      value = nrow(imdb),
      color = "orange",
      icon = icon("film"),
      fill = TRUE
    )
  })
  
  output$num_dir <- renderInfoBox({
    
    num_dir <- imdb |> 
      pull(direcao) |> 
      stringr::str_split(", ") |> 
      purrr::flatten_chr() |> 
      unique() |> 
      length()
    
    infoBox(
      title = "Número de diretoras(es)",
      value = num_dir,
      fill = TRUE,
      color = "teal",
      icon = icon("hand-point-right")
    )
  })
  
  output$num_atr <- renderInfoBox({
    
    num_atr <- imdb |> 
      pull(elenco) |> 
      stringr::str_split(", ") |> 
      purrr::flatten_chr() |> 
      unique() |> 
      length()
    
    infoBox(
      title = "Número de atores/atrizes diferentes",
      value = num_atr,
      fill = TRUE,
      color = "navy",
      icon = icon("user-friends")
    )
  })
  
  output$grafico_filmes_ano <- renderPlot({
    imdb |> 
      count(ano, sort = TRUE) |> 
      ggplot(aes(x = ano, y = n)) +
      geom_col(color = "black", fill = "black") +
      ggtitle("Número de filmes por ano")
  })
  
  output$orc_vs_receita <- renderPlot({
    imdb |> 
      mutate(genero = stringr::str_split(genero, ", ")) |> 
      tidyr::unnest(genero) |> 
      filter(genero %in% input$fin_genero) |>
      distinct(titulo, .keep_all = TRUE) |> 
      ggplot(aes(x = orcamento, y = receita)) +
      geom_point()
  })
  
  
  
}

shinyApp(ui, server)