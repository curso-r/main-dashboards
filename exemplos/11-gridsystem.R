quadrado <- function(text = "") {
  div(
    style = "background: purple; height: 100px; text-align: center; color: white; font-size: 24px;", 
    text
  )
}

ui <- fluidPage(
  fluidRow(
    column(width = 2, quadrado(1)),
    column(width = 4, quadrado(2))
  ),
  fluidRow(
    column(width = 1, quadrado(3)),
    column(width = 3, offset = 8, quadrado(4))
  ),
  fluidRow(
    column(width = 1, quadrado(5)),
    column(width = 1, quadrado(6)),
    column(width = 1, quadrado(7)),
    column(width = 1, quadrado(8)),
    column(width = 1, quadrado(9)),
    column(width = 1, quadrado(10)),
    column(width = 1, quadrado(11)),
    column(width = 1, quadrado(12)),
    column(width = 1, quadrado(13)),
    column(width = 1, quadrado(14)),
    column(width = 1, quadrado(15)),
    column(width = 1, quadrado(16))
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)