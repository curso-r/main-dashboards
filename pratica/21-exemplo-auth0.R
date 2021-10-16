library(shiny)
library(auth0)

ui <- fluidPage(
  selectInput(
    "variavel",
    label = "Selecione uma variável", 
    choices = names(mtcars)
  ), 
  plotOutput("grafico"),
  auth0::logoutButton()
)

server <- function(input, output, session) {
  output$grafico <- renderPlot({
    hist(mtcars[,input$variavel])
  })
}

auth0::shinyAppAuth0(ui, server)

# auth0::use_auth0()
# usethis::edit_r_environ()

# options(shiny.port = 8080)
# shiny::runApp("exemplos/auth0/")

# http://localhost:8080 to the "Allowed Callback URLs", 
# "Allowed Web Origins" and "Allowed Logout URLs"