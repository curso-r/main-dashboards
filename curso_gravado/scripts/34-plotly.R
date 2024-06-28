# install.packages("plotly")

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
      textOutput("texto_click_a"),
      textOutput("texto_click_b"),
    ),
    mainPanel(
      # plotOutput("grafico")
      plotly::plotlyOutput("grafico_plotly"),
      plotly::plotlyOutput("grafico_ggplotly")
    )
  )
)

server <- function(input, output, session) {
  
  output$grafico_ggplotly <- plotly::renderPlotly({
    p <- mtcars |>
      dplyr::select(variavel_x = dplyr::any_of(input$variavel)) |>
      ggplot2::ggplot() +
      ggplot2::geom_bar(ggplot2::aes(x = variavel_x)) +
      ggplot2::theme_minimal()
    
    plotly::ggplotly(p, source = "B")
  })
  
  output$grafico_plotly <- plotly::renderPlotly({
    mtcars |> 
      dplyr::select(variavel_x = dplyr::any_of(input$variavel)) |> 
      dplyr::count(variavel_x) |> 
      plotly::plot_ly(
        x = ~variavel_x,
        y = ~n,
        type = "bar",
        source = "A"
      )
  })
  
  output$texto_click_a <- renderText({
    clique <- plotly::event_data(
      event = "plotly_click",
      source = "A"
    )
    
    req(clique)
    
    glue::glue(
      "Existem {clique$y} carros com {input$variavel} = {clique$x}."
    )
  })
  
  output$texto_click_b <- renderText({
    clique <- plotly::event_data(
      event = "plotly_click",
      source = "B"
    )
    
    req(clique)
    
    glue::glue(
      "Existem {clique$y} carros com {input$variavel} = {clique$x}!"
    )
  })
  
}

shinyApp(ui, server)



