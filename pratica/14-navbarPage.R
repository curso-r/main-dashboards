library(shiny)

ui <- navbarPage(
  title = "Shiny com navbarPage",
  tabPanel(
    title = "Tela 1",
    h2("Conteúdo da tela 1")
  ),
  tabPanel(
    title = "Tela 2",
    h2("Conteúdo da tela 2")
  ),
  navbarMenu(
    title = "Várias telas",
    tabPanel(
      title = "Tela 3",
      h2("Conteúdo da tela 3")
    ),
    tabPanel(
      title = "Tela 4",
      h2("Conteúdo da tela 4")
    ),
    tabPanel(
      title = "Tela 5",
      h2("Conteúdo da tela 5")
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)