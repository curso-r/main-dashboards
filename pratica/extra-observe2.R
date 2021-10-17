library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)

dados <- readr::read_rds("../dados/pkmn.rds")

ui <- fluidPage(
  titlePanel("Pokemon vs resto da geração"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "geracao",
        label = "Selecione uma geração",
        choices = unique(dados$id_geracao)
      ),
      selectInput(
        "pokemon",
        label = "Selecione um Pokemon",
        choices = c("Carregando..." = "")
      )
    ),
    mainPanel(
      fluidRow(
        column(
          offset = 4,
          width = 4,
          imageOutput("pkmn")
        )
      )
    )
  ),
  fluidRow(
    column(
      width = 12,
      plotOutput("grafico")
    )
  )
)

server <- function(input, output, session) {
  
  observe({
    opcoes <- dados |> 
      dplyr::filter(id_geracao == input$geracao) |> 
      dplyr::pull(pokemon) 
    
    updateSelectInput(
      session,
      "pokemon",
      choices = opcoes
    )
  })
  
  output$pkmn <- renderImage({
    
    req(input$pokemon)
    
    id <- dados |> 
      dplyr::filter(pokemon == input$pokemon) |> 
      dplyr::pull(id) |> 
      stringr::str_pad(width = 3, side = "left", pad = "0")
    
    url <- glue::glue(
      "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/{id}.png"
    )
    
    arquivo <- tempfile(fileext = ".png")
    download.file(url, arquivo)
    
    list(
      src = arquivo,
      alt = glue::glue("Quem é este pokemon? É o {input$pokemon}."),
      width = 300
    )
    
  }, deleteFile = TRUE)
  
  output$grafico <- renderPlot({
    req(input$pokemon)
    Sys.sleep(1) # usar isolate 
    dados |> 
      mutate(
        id_geracao == input$geracao,
        ind_pkmn = ifelse(pokemon == input$pokemon, input$pokemon, "Média da geração"),
        ind_pkmn = forcats::fct_relevel(ind_pkmn, input$pokemon)
      ) |> 
      pivot_longer(
        cols = hp:velocidade,
        names_to = "status",
        values_to = "valor"
      ) |> 
      group_by(ind_pkmn, status) |> 
      summarise(
        valor = mean(valor, na.rm = TRUE)
      ) |> 
      ggplot(aes(x = status, fill = ind_pkmn, y = valor)) +
      geom_col(position = "dodge") +
      theme_minimal()
  })
  
}

shinyApp(ui, server)