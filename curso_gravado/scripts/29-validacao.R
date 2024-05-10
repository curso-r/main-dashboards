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
  
  
  filmes <- dplyr::starwars |> 
    tidyr::unnest(films) |> 
    pull(films) |>
    unique() |> 
    sort()
  
  updateSelectInput(
    session, 
    "filme",
    choices = filmes
  )
  
  observe({
    req(input$filme)
    personagens <- dplyr::starwars |> 
      tidyr::unnest(films) |> 
      filter(films == input$filme) |> 
      pull(name) |> 
      sort()
    updateSelectInput(session, "personagem", choices = personagens)
  })
  
  output$tabela <- renderTable({
    validate(need(
      isTruthy(input$personagem),
      "Escolha ao menos um personagem."
    ))
    dplyr::starwars |> 
      dplyr::filter(name %in% input$personagem) |>
      dplyr::select(
        name:species
      )
  })
  
}

shinyApp(ui, server)