library(shiny)

ui <- fluidPage(
  titlePanel("Validação"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "cyl",
        label = "Número de cilindros",
        choices = sort(unique(mtcars$cyl))
      ),
      selectInput(
        inputId = "carro",
        label = "Carro",
        choices = c("Carregando..." = "")
      ),
    ),
    mainPanel(
    )
  )
)

server <- function(input, output, session) {
  
  observe({
    carros <- mtcars |> 
      dplyr::filter(cyl == input$cyl) |>
      rownames() |> 
      sort()
    updateSelectInput(
      session,
      "carro",
      choices = carros
    )
  })
  
}

shinyApp(ui, server)