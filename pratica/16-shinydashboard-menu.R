library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "IMDB"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Página 1", tabName = "pag1"),
      menuItem("Página 2", tabName = "pag2"),
      menuItem("Página 3", tabName = "pag3")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "pag1",
        h2("Conteúdo da página 1")
      ),
      tabItem(
        tabName = "pag2",
        h2("Conteúdo da página 2")
      ),
      tabItem(
        tabName = "pag3",
        h2("Conteúdo da página 3")
      )
    )
  )
)

server <- function(input, output, session) {

  
}

shinyApp(ui, server)