library(shiny)

ui <- bslib::page_fluid(
  titlePanel("Shiny com bslib"),
  bslib::layout_columns(
    col_widths = c(4, 8),
    selectInput(
      inputId = "cyl",
      label = "Número de cilindros",
      choices = sort(unique(mtcars$cyl))
    ),
    tagList(
      tableOutput("tabela")
    )
  )
)

# ui <- fluidPage(
#   titlePanel("Shiny com bslib"),
#   fluidRow(
#     column(
#       width = 4,
#       selectInput(
#         inputId = "cyl",
#         label = "Número de cilindros",
#         choices = sort(unique(mtcars$cyl))
#       )
#     ),
#     column(
#       width = 8,
#       tableOutput("tabela")
#     )
#   )
# )

server <- function(input, output, session) {
  
  output$tabela <- renderTable({
    mtcars |> 
      dplyr::filter(cyl == input$cyl)
  })
  
}

shinyApp(ui, server)