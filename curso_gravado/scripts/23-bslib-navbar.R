library(shiny)

ui <- bslib::page_navbar(
  title = "bslib Navbar",
  bslib::nav_panel(
    title = "Página 1",
    titlePanel("Conteúdo da página 1")
  ),
  bslib::nav_panel(
    title = "Página 2",
    bslib::layout_sidebar(
      sidebar = bslib::sidebar(
        h4("Sidebar da página 2")
      ),
      titlePanel("Conteúdo da página 2")
    )
  ),
  bslib::nav_menu(
    title = "Várias páginas",
    bslib::nav_panel(
      title = "Página 3",
      titlePanel("Conteúdo da página 3")
    ),
    bslib::nav_panel(
      title = "Página 4",
      titlePanel("Conteúdo da página 4")
    ),
    bslib::nav_panel(
      title = "Página 5",
      titlePanel("Conteúdo da página 5")
    ),
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)