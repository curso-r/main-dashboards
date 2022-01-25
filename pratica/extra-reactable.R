library(shiny)
library(dplyr)

ui <- fluidPage(
  theme = bslib::bs_theme(version = 4),
  title = titlePanel("Adionar e remover linhas de uma tabela"),
  br(),
  fluidRow(
    column(
      width = 12,
      reactable::reactableOutput("tabela")
    ),
  ),
  br(),
  fluidRow(
    column(
      width = 6,
      class = "text-center",
      actionButton("remover", label = "Remover linhas")
    ),
    column(
      width = 6,
      class = "text-center",
      actionButton("adicionar", label = "Adicionar linha aleatória")
    )
  )
)

server <- function(input, output, session) {
  
  rv_mtcars <- reactiveVal(value = mtcars)
  
  observeEvent(input$remover, {
    req(linha_selecionada())
    nova_mtcars <- rv_mtcars() %>% 
      slice(-linha_selecionada())
    rv_mtcars(nova_mtcars)
  })
  
  observeEvent(input$adicionar, {
    nova_linha <- mtcars[sample(1:nrow(mtcars), 1),]
    nova_mtcars <- rbind(nova_linha, rv_mtcars())
    rv_mtcars(nova_mtcars)
  })
  
  output$tabela <- reactable::renderReactable({
    rv_mtcars() %>% 
      select(1:5) %>% 
      reactable::reactable(
        selection = "multiple"
      )
  })
  
  linha_selecionada <- reactive({
    reactable::getReactableState("tabela", "selected")
  })
  
}

shinyApp(ui, server)