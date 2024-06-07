library(shiny)

ui <- fluidPage(
  titlePanel("Validação"),
  sidebarLayout(
    sidebarPanel(
      width = 3,
      selectInput(
        inputId = "filme",
        label = "Escolha um filme",
        choices = c("Carregando..." = "")
      ),
      selectInput(
        inputId = "personagem",
        label = "Escolha um personagem",
        choices = c("Carregando..." = ""),
        multiple = TRUE
      )
    ),
    mainPanel(
      width = 9,
      tableOutput("tabela")
    )
  )
)

server <- function(input, output, session) {
  
  dados <- dplyr::starwars |> 
    tidyr::unnest(films)
  
  filmes <- dados |> 
    dplyr::pull(films) |> 
    unique() |> 
    sort()
  
  updateSelectInput(
    inputId = "filme",
    choices = filmes
  )
  
  observe({
    req(input$filme)
    personagens <- dados |> 
      dplyr::filter(films == input$filme) |> 
      dplyr::pull(name) |> 
      sort()
    
    updateSelectInput(
      inputId = "personagem",
      choices = personagens,
      selected = personagens[1]
    )
  })
  
  output$tabela <- renderTable({
    validate(
      need(
        isTruthy(input$personagem),
        "Selecione um personagem para ver a tabela."
      )
    )
    dados |> 
      dplyr::filter(name %in% input$personagem) |> 
      dplyr::select(name:species) |> 
      dplyr::distinct()
  })
  
}

shinyApp(ui, server)







