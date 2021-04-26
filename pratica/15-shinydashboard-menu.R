library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "IMDB"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informações gerais", tabName = "info"),
      menuItem("Orçamentos", tabName = "orcamentos"),
      menuItem("Receitas", tabName = "receitas")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "info",
        h1("Informações gerais dos filmes")
      ),
      tabItem(
        tabName = "orcamentos",
        h1("Analisando os orçamentos")
      ),
      tabItem(
        tabName = "receitas",
        h1("Analisando as receitas")
      )
    )
  )
)

server <- function(input, output, session) {

  
}

shinyApp(ui, server)