library(shiny)
library(shinydashboard)

library(shiny)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)