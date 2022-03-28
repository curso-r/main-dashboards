library(shiny)

ui <- fluidPage(
  h1("Esse é o título do meu app!", align = "center"),
  hr(),
  h3("Sobre"),
  p("Lorem ipsum", tags$em("dolor sit amet", .noWS = "after"), ", consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
  p(strong("Lorem ipsum dolor"), "sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
  hr(),
  img(src = "logo.png", width = 400, style = "display: block; margin: auto;")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)