library(shiny)

ui <- fluidPage(
  h1("Primeiro nível"),
  h2("Segundo nível"),
  h3("Terceiro nível"),
  
  hr(),
  
  h4("Quarto nível"),
  h5("Quinto nível"),
  h6("Sexto nível"),
  
  br(),
  
  p("Este é um parágrafo azul", style = "color: blue"),
  
  p("Este é um parágrafo com um hiperlink da", a(href = "http://curso-r.com", "CURSO-R!!"))
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
