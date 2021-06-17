library(shiny)
library(ggplot2)
library(dplyr)

ui <- navbarPage(
  title = "Pokémon",
  tabPanel(
    "Água",
    conteudoUI("agua")
  ),
  tabPanel(
    "Fogo",
    conteudoUI("fogo")
  ),
  tabPanel(
    "Grama",
    conteudoUI("grama")
  )
)

server <- function(input, output, session) {

  conteudoServer("agua", "água")
  conteudoServer("fogo", "fogo")
  conteudoServer("grama", "grama")

}

shinyApp(ui, server)
