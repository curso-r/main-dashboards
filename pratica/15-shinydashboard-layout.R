library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("", tabName = "")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("")
    )
  )
)

server <- function(input, output, session) {

}

shinyApp(ui, server)