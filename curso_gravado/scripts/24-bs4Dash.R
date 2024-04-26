library(shiny)

ui <- bs4Dash::bs4DashPage(
  help = NULL,
  header = bs4Dash::bs4DashNavbar(
    title = "bs4Dash"
  ),
  sidebar = bs4Dash::bs4DashSidebar(
    bs4Dash::bs4SidebarMenu(
      bs4Dash::bs4SidebarMenuItem(
        text = "Página 1",
        tabName = "pagina_1",
        icon = icon("user")
      ),
      bs4Dash::bs4SidebarMenuItem(
        text = "Página 2",
        tabName = "pagina_2",
        icon = icon("car-side")
      ),
      bs4Dash::bs4SidebarMenuItem(
        text = "Várias páginas",
        bs4Dash::bs4SidebarMenuSubItem(
          text = "Página 3",
          tabName = "pagina_3"
        ),
        bs4Dash::bs4SidebarMenuSubItem(
          text = "Página 4",
          tabName = "pagina_4"
        ),
        bs4Dash::bs4SidebarMenuSubItem(
          text = "Página 5",
          tabName = "pagina_5"
        )
      )
    )
  ),
  body = bs4Dash::bs4DashBody(
    bs4Dash::bs4TabItems(
      bs4Dash::bs4TabItem(
        tabName = "pagina_1",
        titlePanel("Conteúdo página 1")
      ),
      bs4Dash::bs4TabItem(
        tabName = "pagina_2",
        titlePanel("Conteúdo página 2"),
        plotOutput("pg_2_grafico")
      ),
      bs4Dash::bs4TabItem(
        tabName = "pagina_3",
        titlePanel("Conteúdo página 3"),
        fluidRow(
          column(
            width = 3,
            plotOutput("pg_3_grafico")
          ),
          column(
            width = 9,
            tableOutput("pg_3_tabela")
          )
        )
      ),
      bs4Dash::bs4TabItem(
        tabName = "pagina_4",
        titlePanel("Conteúdo página 4")
      ),
      bs4Dash::bs4TabItem(
        tabName = "pagina_5",
        titlePanel("Conteúdo página 5")
      )
    )
  )
)


server <- function(input, output, session) {
  
  output$pg_2_grafico <- renderPlot({
    plot(x = 1:10, y = 1:10)
  })
  
  output$pg_3_grafico <- renderPlot({
    plot(x = 1:10, y = 10:1)
  })
  
  output$pg_3_tabela <- renderTable(
    mtcars
  )
  
}

shinyApp(ui, server)