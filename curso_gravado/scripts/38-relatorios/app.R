library(shiny)

# install.packages("pokemon")

dados <- pokemon::pokemon_ptbr

ui <- fluidPage(
  titlePanel("Gerando relatórios"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "pokemon",
        label = "Selecione um pokemon",
        choices = unique(dados$pokemon)
      ),
      actionButton("visualizar", "Visualizar relatório"),
      downloadButton("baixar", "Baixar relatório")
    ),
    mainPanel(
      uiOutput("preview")
    )
  )
)
  
server <- function(input, output, session) {
  
  iframe <- eventReactive(input$visualizar, {
    rmarkdown::render(
      input = "relatorio.Rmd",
      output_file = "www/relatorio.html",
      params = list(pokemon = input$pokemon)
    )
    
    tags$iframe(
      src = "relatorio.html",
      width = "100%",
      height = 600
    )
  })
  
  output$preview <- renderUI({
    req(iframe())
    iframe()
  })
  
  output$baixar <- downloadHandler(
    filename = function() {
      glue::glue("relatorio_{input$pokemon}.pdf")
    },
    content = function(file) {
      
      withProgress(message = "Gerando o HTML...", {
        
        incProgress(0.2)
        
        arquivo_html <- tempfile(fileext = ".html")
        
        rmarkdown::render(
          input = "relatorio.Rmd",
          output_file = arquivo_html,
          params = list(pokemon = input$pokemon)
        )
        
        incProgress(0.4, message = "Gerando o PDF...")
        
        pagedown::chrome_print(
          input = arquivo_html,
          output = file
        )
      })
      
    }
  )
  
}

shinyApp(ui, server)










