library(shiny)

ui <- fluidPage(
  shiny::fileInput(
    inputId = "upload", 
    label = "Selecione um arquivo",
    multiple = FALSE,
    accept = ".rds",
    buttonLabel = "Procure",
    placeholder = "Selecione um arquivo..."
  ),
  br(),
  plotOutput("grafico")
)

server <- function(input, output, session) {
  
  output$grafico <- renderPlot({
    
    tab <- readRDS(input$upload$datapath)
    
    variavel <- tab[,5]
    
    if (is.numeric(variavel)) {
      hist(variavel)
    } else {
      variavel %>% 
        table() %>%
        barplot()
    }
    
  })
  
}

shinyApp(ui, server)