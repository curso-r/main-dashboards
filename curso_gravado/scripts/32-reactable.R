# install.packages("reactable")

library(shiny)

ui <- fluidPage(
  titlePanel("Reactable"),
  sidebarLayout(
    sidebarPanel(
      varSelectInput(
        inputId = "variaveis",
        label = "Variável",
        data = mtcars,
        multiple = TRUE,
        selected = c("mpg", "cyl", "wt")
      )
    ),
    mainPanel(
      reactable::reactableOutput("tabela"),
      textOutput("carro")
    )
  )
)

server <- function(input, output, session) {
  
  tabela <- reactive({
    variaveis <- as.character(input$variaveis)
    mtcars |> 
      dplyr::select(dplyr::any_of(variaveis))
  })
  
  output$tabela <- reactable::renderReactable({
    tabela() |> 
      reactable::reactable(
        striped = TRUE,
        pagination = TRUE,
        defaultPageSize = 10,
        filterable = TRUE,
        searchable = TRUE,
        selection = "single",
        defaultSelected = 1
      )
  })
  
  output$carro <- renderText({
    
    num_linha <- reactable::getReactableState(
      outputId = "tabela",
      name = "selected"
    )
    
    req(num_linha)
    
    carro <- tabela() |> 
      dplyr::slice(num_linha) |> 
      rownames()
    
    glue::glue("O carro selecionado é o {carro}.")
    
  })
  
}

shinyApp(ui, server)