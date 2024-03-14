# App que utiliza uma base filtrada em dois outputs

library(shiny)

ui <- fluidPage(
  titlePanel("Avaliando consumo de gasolina dos carros"),
  selectInput(
    inputId = "cyl",
    label = "Número de cilindros",
    choices = sort(unique(mtcars$cyl))
  ),
  textOutput(outputId = "menor_valor"),
  textOutput(outputId = "maior_valor")
)

server <- function(input, output, session) {
  
  base_filtrada <- mtcars |> 
    dplyr::filter(cyl == input$cyl)
  
  output$menor_valor <- renderText({
    carro <- base_filtrada |> 
      dplyr::slice_min(order_by = mpg, n = 1, with_ties = FALSE) |> 
      tibble::rownames_to_column(var = "nome_carro") |> 
      dplyr::pull(nome_carro)
    
    glue::glue("O carro com menor consumo é: {carro}")
  })
  
  output$maior_valor <- renderText({
    carro <- base_filtrada |> 
      dplyr::slice_max(order_by = mpg, n = 1, with_ties = FALSE) |> 
      tibble::rownames_to_column(var = "nome_carro") |> 
      dplyr::pull(nome_carro)
    
    glue::glue("O carro com maior consumo é: {carro}")
  })
  
}

shinyApp(ui, server)









