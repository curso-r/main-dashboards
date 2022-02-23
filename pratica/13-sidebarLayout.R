library(shiny)

dados <- readr::read_rds("../dados/pkmn.rds")

ui <- fluidPage(
  titlePanel("Shiny com sidebarLayout"),
  sidebarLayout( 
    sidebarPanel(
      selectInput(
        "pokemon",
        label = "Selecione um Pokemon",
        choices = unique(dados$pokemon)
      )
    ),
    mainPanel(
      fluidRow(
        column(
          offset = 4,
          width = 4,
          imageOutput("pkmn")
          # uiOutput("pkmn")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  output$pkmn <- renderImage({
    
    id <- dados |> 
      dplyr::filter(pokemon == input$pokemon) |> 
      dplyr::pull(id) |> 
      stringr::str_pad(width = 3, side = "left", pad = "0")
    
    url <- glue::glue(
      "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/{id}.png"
    )
    
    arquivo <- tempfile(fileext = ".png")
    httr::GET(url, httr::write_disk(arquivo, overwrite = TRUE))
    
    list(
      src = arquivo,
      alt = glue::glue("Quem é este pokemon? É o {input$pokemon}."),
      width = 300
    )
    
  }, deleteFile = TRUE)
  
  # output$pkmn <- renderUI({
  #   
  #   id <- dados |> 
  #     dplyr::filter(pokemon == input$pokemon) |> 
  #     dplyr::pull(id) |> 
  #     stringr::str_pad(width = 3, side = "left", pad = "0")
  #   
  #   url <- glue::glue(
  #     "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/{id}.png"
  #   )
  #   
  #   img(
  #     src = url,
  #     alt = glue::glue("Quem é este pokemon? É o {input$pokemon}."),
  #     width = 300
  #   )
  # })
  
}

shinyApp(ui, server)