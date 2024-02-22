# App para visualizar o resultado de um sorteio

library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Resultado de um sorteio"),
  sliderInput(
    inputId = "tamanho_amostra",
    label = "Selecione o tamanho da amostra",
    min = 1,
    max = 1000,
    value = 100
  ),
  plotOutput(outputId = "grafico"),
  textOutput(outputId = "texto")
)

server <- function(input, output, session) {
  
  amostra <- sample(1:10, size = input$tamanho_amostra, replace = TRUE)
  
  output$grafico <- renderPlot({
    tibble::tibble(
      valores = amostra
    ) |> 
      ggplot() +
      geom_bar(aes(x = valores)) +
      scale_x_continuous(breaks = 1:10)
  })
  
  output$texto <- renderText({
    valor_mais_freq <- tibble::tibble(
      valores = amostra
    ) |> 
      dplyr::count(valores, sort = TRUE) |> 
      dplyr::slice(1) |> 
      dplyr::pull(valores)
    
    glue::glue("O valor mais frequente é: {valor_mais_freq}.")
    
  })
  
}

shinyApp(ui, server)










