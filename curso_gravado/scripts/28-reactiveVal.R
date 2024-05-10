library(shiny)
library(dplyr)

ui <- fluidPage(
  titlePanel("Cadastro de clientes"),
  sidebarLayout(
    sidebarPanel(
      h3("Adicionar cliente"),
      textInput(
        "nome",
        label = "Nome",
        value = ""
      ),
      textInput(
        "email",
        label = "E-mail",
        value = ""
      ),
      actionButton("adicionar", label = "Adicionar cliente"),
      hr(),
      h3("Remover cliente"),
      selectInput(
        "id",
        label = "ID do cliente",
        choices = c("Carregando..." = "")
      ),
      actionButton("remover", label = "Remover cliente")
    ),
    mainPanel(
      tableOutput("tabela")
    )
  )
)

server <- function(input, output, session) {
  
  tab_clientes <- reactiveVal(tibble::tibble(
    id = 0L,
    nome = "Fulano",
    email = "fulano@gmail.com"
  ))
  
  observe({
    clientes <- tab_clientes() |> 
      dplyr::pull(id)
    
    updateSelectInput(
      session,
      "id",
      choices = clientes
    )
  })
  
  observeEvent(input$remover, {
    if (!input$id %in% tab_clientes()$id) {
      showModal(modalDialog(
        title = "Erro",
        "ID não encontrado",
        footer = modalButton("Fechar"),
        easyClose = TRUE
      ))
    } else {
      nova_tab <- tab_clientes() |> 
        dplyr::filter(id != input$id)
      tab_clientes(nova_tab)
    }
  })
  
  observeEvent(input$adicionar, {
    novo_id <- max(tab_clientes()$id) + 1L
    nova_tab <- tab_clientes() |> 
      tibble::add_row(id = novo_id, nome = input$nome, email = input$email, .before = 1)
    tab_clientes(nova_tab)
  })
  
  output$tabela <- renderTable({
    tab_clientes()
  })
  
}

shinyApp(ui, server)