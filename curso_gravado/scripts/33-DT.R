# install.packages("DT")

library(shiny)

ui <- fluidPage(
  titlePanel("DT"),
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
      DT::DTOutput("tabela"),
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
  
  output$tabela <- DT::renderDT({
    tabela() |> 
      DT::datatable(
        selection = "single",
        editable = TRUE
      )
  })
  
  output$carro <- renderText({
    linha <- input$tabela_rows_selected
    
    carro <- tabela() |> 
      dplyr::slice(linha) |> 
      rownames()
    
    glue::glue("Você selecionou o carro {carro}.")
  })
  
}













shinyApp(ui, server)