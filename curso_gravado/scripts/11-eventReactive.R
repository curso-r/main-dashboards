library(shiny)

ui <- fluidPage(
  titlePanel("Preencha o formulário"),
  hr(),
  textInput(
    inputId = "nome",
    label = "Nome",
    value = "",
    placeholder = "João da Silva"
  ),
  dateInput(
    inputId = "data_nascimento",
    label = "Data de nascimento",
    max = Sys.Date(),
    value = Sys.Date(),
    language = "pt-BR",
    format = "dd-mm-yyyy"
  ),
  selectInput(
    inputId = "estado",
    label = "UF",
    choices = c("Pará", "Rio de Janeiro", "Matro Grosso", "Ceará")
  ),
  actionButton(
    inputId = "enviar",
    label = "Enviar"
  ),
  hr(),
  textOutput(outputId = "saida")
)

server <- function(input, output, session) {
  
  # valores_enviados <- eventReactive(input$enviar, {
  #   glue::glue(
  #     "Nome: {input$nome} — 
  #     Data nascimento: {input$data_nascimento} —
  #     Estado: {input$estado}"
  #   )
  # })
  
  valores_enviados <- reactive({
    glue::glue(
      "Nome: {input$nome} — 
      Data nascimento: {input$data_nascimento} —
      Estado: {input$estado}"
    )
  }) |> 
    bindEvent(input$enviar)
  
  output$saida <- renderText({
    valores_enviados()
  }) 
  
}

shinyApp(ui, server)