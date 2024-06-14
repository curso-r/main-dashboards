# https://plotly.com/r/

library(shiny)

ui <- fluidPage(
  titlePanel("Plotly"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "variavel",
        label = "Selecione a variável",
        choices = c("cyl", "vs", "am", "gear")
      ),
      textOutput("texto_click")
    ),
    mainPanel(
      plotly::plotlyOutput("grafico_plotly"),
      plotly::plotlyOutput("grafico_ggplotly"),
    )
  )
)

server <- function(input, output, session) {
  
  output$grafico_plotly <- plotly::renderPlotly({
    mtcars |>
      dplyr::select(x = dplyr::one_of(input$variavel)) |> 
      dplyr::count(x) |>
      plotly::plot_ly(
        x = ~x,
        y = ~n,
        type = "bar",
        source = "grafico_plotly"
      )
  })
  
  output$grafico_ggplotly <- plotly::renderPlotly({
    p <- mtcars |>
      dplyr::select(x = dplyr::one_of(input$variavel)) |> 
      dplyr::count(x) |>
      ggplot2::ggplot(ggplot2::aes(x = x, y = n)) +
      ggplot2::geom_col() +
      ggplot2::theme_minimal()
    plotly::ggplotly(p, source = "grafico_ggplotly")
  })
  
  output$texto_click <- renderText({
    clique <- plotly::event_data("plotly_click", source = "grafico_plotly")
    req(clique)
    variavel <- isolate(input$variavel)
    glue::glue("Existem {clique$y} carros com {variavel} = {clique$x}.")
  })
  
}

shinyApp(ui, server)