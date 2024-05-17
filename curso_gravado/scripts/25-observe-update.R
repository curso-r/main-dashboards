library(shiny)

ui <- fluidPage(
  titlePanel("observe + update"),
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
        choices = ""
      )
    ),
    mainPanel(
    )
  )
)

server <- function(input, output, session) {
  
  observe({
    carros <- mtcars |> 
      dplyr::filter(cyl == input$cyl) |> 
      row.names()
    
    updateSelectInput(
      inputId = "carro",
      choices = carros
    )
  })
  
  
  
  
  
}

shinyApp(ui, server)








