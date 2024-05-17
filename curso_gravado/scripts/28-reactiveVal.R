library(shiny)

ui <- fluidPage(
  titlePanel("Cadastro de clientes"),
  sidebarLayout(
    sidebarPanel(
      h4("Adicionar novo cliente"),
      textInput(
        inputId = "nome",
        label = "nome",
        value = ""
      ),
      textInput(
        inputId = "email",
        label = "E-mail",
        value = ""
      ),
      actionButton(
        inputId = "adicionar",
        label = "Adicionar cliente"
      ),
      hr(),
      h4("Remover um cliente"),
      selectInput(
        inputId = "id",
        label = "ID do cliente",
        choices = ""
      ),
      actionButton(
        inputId = "remover",
        label = "Remover cliente"
      )
    ),
    mainPanel(
      tableOutput("tabela")
    )
  )
)

server <- function(input, output, session) {
 
  tab_clientes <- reactiveVal(tibble::tibble(
    id = 1L,
    nome = "William Amorim",
    email = "william@email.com"
  ))
  
  observeEvent(input$adicionar, {
    novo_id <- as.integer(max(tab_clientes()$id) + 1)
    nova_tabela <- tab_clientes() |> 
      tibble::add_row(id = novo_id, nome = input$nome, email = input$email)
    
    tab_clientes(nova_tabela)
    
    showModal(
      modalDialog(
        title = "Sucesso",
        "Cliente adicionado com sucesso"
      )
    )
  })
  
  output$tabela <- renderTable({
    tab_clientes()
  })
  
  observe({
    ids <- sort(tab_clientes()$id)
    
    updateSelectInput(
      inputId = "id",
      choices = ids
    )
  })
  
  observeEvent(input$remover, {
    
    nova_tabela <- tab_clientes() |> 
      dplyr::filter(id != input$id)
    
    tab_clientes(nova_tabela)
    
  })
   
  
  
}

shinyApp(ui, server)






