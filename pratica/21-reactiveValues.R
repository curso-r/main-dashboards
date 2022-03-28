library(shiny)
library(dplyr)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      h3("Remover uma linha"),
      numericInput(
        "linha",
        label = "Escolha uma linha para remover",
        value = 1,
        min = 1,
        max = nrow(mtcars)
      ),
      actionButton("remover", label = "Clique para remover"),
      h3("Adicionar uma linha"),
      numericInput(
        "mpg",
        label = "Escolha o valor de MPG",
        value = 30,
      ),
      actionButton("adicionar", label = "Clique para adicionar"),
    ),
    mainPanel(
      reactable::reactableOutput("tabela")
    )
  )
)

server <- function(input, output, session) {
  
  rv_mtcars <- reactiveVal(value = mtcars)
  
  observeEvent(input$remover, {
    nova_mtcars <- rv_mtcars() %>% 
      slice(-input$linha)
    rv_mtcars(nova_mtcars)
  })
  
  observeEvent(input$adicionar, {
    nova_mtcars <- rv_mtcars() %>% 
      tibble::add_row(mpg = input$mpg,  .before = 1)
    rv_mtcars(nova_mtcars)
  })
  
  output$tabela <- reactable::renderReactable({
    rv_mtcars() %>% 
      select(1:5) %>% 
      reactable::reactable(width = 600)
  })
  
}

shinyApp(ui, server)