library(shiny)

ui <- bslib::page_navbar(
  title = "bslib Navbar",
  bslib::nav_panel(
    title = "Página 1",
    titlePanel("Conteúdo página 1")
  ),
  bslib::nav_panel(
    title = "Página 2",
    bslib::layout_sidebar(
      sidebar = bslib::sidebar(
        h5("Sidebar página 2")
      ),
      titlePanel("Conteúdo página 2")
    )
  ),
  bslib::nav_menu(
    title = "Várias páginas",
    bslib::nav_panel(
      title = "Página 3",
      titlePanel("Conteúdo página 3")
    ),
    bslib::nav_panel(
      title = "Página 4",
      titlePanel("Conteúdo página 4")
    ),
    bslib::nav_panel(
      title = "Página 5",
      titlePanel("Conteúdo página 5")
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)