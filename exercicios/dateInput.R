library(shiny)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
  dateInput(
    inputId = "data",
    label = "Escolha o dia",
    value = "2013-01-01",
    min =  "2013-01-01",
    max =  "2013-12-31",
    format = "dd-mm-yyyy"
  ),
  br(),
  "Tabela descritiva",
  tableOutput("tabela"),
  plotOutput("grafico")
)

server <- function(input, output, session) {
  
  output$tabela <- renderTable({
    nycflights13::flights %>% 
      mutate(data = lubridate::make_date(year, month, day)) %>%
      filter(data == input$data) %>% 
      mutate(
        across(contains("delay"), ~ifelse(. < 0, 0, .))
      ) %>% 
      summarise(
        `Número de voos` = n(),
        `Atraso médio de partida (min)` = mean(dep_delay, na.rm = TRUE),
        `Atraso médio de chegada (min)` = mean(arr_delay, na.rm = TRUE)
      )
  })
  
  output$grafico <- renderPlot({
    nycflights13::flights %>% 
      mutate(data = lubridate::make_date(year, month, day)) %>%
      filter(data == input$data) %>% 
      ggplot(aes(x = carrier, fill = carrier)) +
      geom_bar(show.legend = FALSE) +
      theme_minimal() +
      labs(
        y = "Número de voos", 
        x = "Empresa", 
        title = "Número de voos por empresa"
      )
  })
  
}

shinyApp(ui, server)