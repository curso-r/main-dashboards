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
    inputId = "salvar",
    label = "Salvar"
  )
)

server <- function(input, output, session) {
  
  observeEvent(input$salvar, {
    tibble::tibble(
      nome = input$nome,
      data_nascimento = input$data_nascimento,
      estado = input$estado
    ) |> 
      write.table(
        "dados.txt",
        append = TRUE,
        sep = ",",
        row.names = FALSE,
        col.names = FALSE
      )
  })
  
}

shinyApp(ui, server)