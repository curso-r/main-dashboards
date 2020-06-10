library(shiny)
library(shinydashboard)
library(tidyverse)

ui <- dashboardPage(
  dashboardHeader(),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Página 1", tabName = "pag1")
      )
    ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "pag1",
        tabBox(
          height = "200px",
          tabPanel(
            title = "Aba 1",
            ...
          ),
          tabPanel(
            title = "Aba 2",
            ...
          ),
          tabPanel(
            title = "Aba 3",
            ...
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)