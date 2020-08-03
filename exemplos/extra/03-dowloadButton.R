library(shiny)

ui <- fluidPage(
  downloadButton(
    "download",
    label = "Download da base"
  )
)

server <- function(input, output, session) {
  
  output$download <- downloadHandler(
    filename = "mtcars.csv",
    content = function(file) {
      write.csv(mtcars, file)
    }
  )
  
}

shinyApp(ui, server)