library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "var", 
        label = "Variável", 
        choices = names(mtcars), 
        selected = c("mpg", "cyl", "wt"),
        multiple = TRUE
      )
    ),
    mainPanel(
      reactable::reactableOutput("tabela"),
      textOutput("texto")
    )
  )
)

server <- function(input, output, session) {
  
  tabela <- reactive({
    mtcars[, input$var]
  })
  
  output$tabela <- reactable::renderReactable({
    reactable::reactable(
      tabela()
      # striped = TRUE,
      # pagination = FALSE,
      # defaultPageSize = 8,
      # filterable = TRUE,
      # searchable = TRUE,
      # selection = "single"
    )
  })
  
  # output$texto <- renderText({
  #   linha <- reactable::getReactableState(outputId = "tabela", name = "selected")
  #   
  #   carro <- tabela() |> 
  #     dplyr::slice(linha) |> 
  #     rownames()
  #   
  #   paste("Você selecionou o carro", carro)
  # })
  
}

shinyApp(ui, server)