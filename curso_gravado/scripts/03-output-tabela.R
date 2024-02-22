# app com uma tabela como output

library(shiny)

ui <- fluidPage(
  titlePanel("Exemplo com outputTable/renderTable"),
  tableOutput(outputId = "tabela")
)

server <- function(input, output, session) {
  
  output$tabela <- renderTable({
    mtcars |> 
      dplyr::group_by(cyl) |> 
      dplyr::summarise(
        mpg = mean(mpg)
      ) |> 
      dplyr::rename(
        `Número de cilindros` = cyl,
        `Consumo de combustível (milhas/galão)` = mpg
      )
  })
  
}

shinyApp(ui, server)