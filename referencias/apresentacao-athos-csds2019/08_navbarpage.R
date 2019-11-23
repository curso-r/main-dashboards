library(shiny)
library(magrittr)

quadrado <- function(text = "") {
  div(style = "background: purple; height: 100px; text-align: center; color: white; font-size: 24px;", text)
}


ui <- navbarPage(
  title = "My Navbar Page!",
  tabPanel("tab 1", quadrado("OLA")),
  tabPanel("tab 2", quadrado("HELLO")),
  tabPanel("tab 3", quadrado("HOLLA")),
  tabPanel("tab 4", quadrado("Last tab"))
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)