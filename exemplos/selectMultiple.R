library(shiny)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
  selectInput(
    inputId = "empresa",
    label = "Selecione uma ou mais empresas",
    choices = sort(unique(nycflights13::flights$carrier)),
    multiple = TRUE,
    selected = "9E"
  ),
  br(),
  plotOutput("grafico")
)

server <- function(input, output, session) {
  
  output$grafico <- renderPlot({
    req(input$empresa)
    nycflights13::flights %>% 
      mutate(data = lubridate::make_date(year, month, day)) %>%
      filter(carrier %in% input$empresa) %>% 
      count(data, carrier) %>% 
      ggplot(aes(x = data, y = n, color = carrier)) +
      geom_line() +
      theme_minimal() +
      labs(
        y = "Número de voos", 
        x = "Data", 
        title = "Número de voos por empresa ao longo de 2013"
      )
  })
  
}

shinyApp(ui, server)