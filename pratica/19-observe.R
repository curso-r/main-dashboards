library(shiny)

dados <- readr::read_rds("../dados/pkmn.rds")

ui <- fluidPage(
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
  
}

shinyApp(ui, server)