library(shiny)

ui <- fluidPage(
  "Formulário",
  textInput(
    inputId = "nome",
    label = "Digite seu nome"
  ),
  numericInput(
    inputId = "idade",
    label = "Idade",
    value = 30,
    min = 18,
    max = NA,
    step = 1
  ),
  textInput(inputId = "estado", label = "Estado onde vive"),
  actionButton("botao", "Enviar"),
  br(),
  "Resposta",
  textOutput(outputId = "resposta")
)

server <- function(input, output, session) {
  
  frase <- eventReactive(input$botao,{
    glue::glue("Olá! Eu sou {input$nome}, tenho {input$idade} e 
               moro em/no {input$estado}.")
  })
  
  output$resposta <- renderText({
    frase()
  })
  
}

shinyApp(ui, server)

# E se a gente quisesse salvar esses valores em uma base de dados?