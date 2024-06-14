library(shiny)

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
    withProgress(message = "Gerando relatório...", {
      incProgress(0.3)
      rmarkdown::render(
        input = "relatorio.Rmd",
        output_dir = "www",
        params = list(pokemon = input$pokemon)
      )
      incProgress(0.4)
      tags$iframe(
        src = "relatorio.html",
        width = "100%",
        height = 600
      )
    })
  })
  
  output$preview <- renderUI({
    req(iframe())
    iframe()
  })
  
  output$baixar <- downloadHandler(
    filename = function() {glue::glue("relatorio_{input$pokemon}.pdf")},
    content = function(file) {
      
      arquivo_html <- tempfile(fileext = ".html")
      
      withProgress(message = "Gerando relatório...", {
        
        incProgress(0.3)
        
        rmarkdown::render(
          input = "relatorio.Rmd",
          output_file = arquivo_html,
          params = list(pokemon = input$pokemon)
        )
        
        incProgress(0.4)
        
        pagedown::chrome_print(
          input = arquivo_html,
          output = file
        )
        
      })
      
    }
  )
  
}

shinyApp(ui, server)