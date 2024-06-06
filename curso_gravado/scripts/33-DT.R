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
      DT::dataTableOutput("tabela"),
      textOutput("texto")
    )
  )
)

server <- function(input, output, session) {
  
  tabela <- reactive({
    mtcars[, input$var]
  })
  
  output$tabela <- DT::renderDataTable({
    DT::datatable(
      tabela(),
      selection = "single",
      editable = TRUE
    )
  })
  
  output$texto <- renderText({
    linha <- input$tabela_rows_selected

    carro <- tabela() |>
      dplyr::slice(linha) |>
      rownames()

    paste("Você selecionou o carro", carro)
  })
  
}

shinyApp(ui, server)