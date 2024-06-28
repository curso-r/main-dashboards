library(shiny)

ui <- fluidPage(
  titlePanel("Echarts"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "variavel",
        label = "Selecione a variável",
        choices = c("cyl", "vs", "am", "gear")
      ),
      textOutput("texto_click"),
      hr(),
      auth0::logoutButton()
    ),
    mainPanel(
      echarts4r::echarts4rOutput("grafico")
    )
  )
)

server <- function(input, output, session) {
  output$grafico <- echarts4r::renderEcharts4r({
    mtcars |>
      dplyr::select(x = dplyr::one_of(input$variavel)) |> 
      dplyr::count(x) |>
      dplyr::mutate(x = as.character(x)) |> 
      echarts4r::e_charts(x) |>
      echarts4r::e_bar(serie = n) |> 
      echarts4r::e_legend(show = FALSE) |> 
      echarts4r::e_x_axis(
        name = input$variavel,
        nameLocation = "center",
        nameGap = 30
      )
  })
  
  output$texto_click <- renderText({
    clique <- input$grafico_clicked_data
    req(clique)
    variavel <- isolate(input$variavel)
    glue::glue("Existem {clique$value[2]} carros com {variavel} = {clique$value[1]}.")
  })
}

auth0::shinyAppAuth0(ui, server, options = list(port = 8080))

# Usar auth0

# 0. Criar um aplicativo no serviço Auth0

# 1. Trocar shinyApp() por auth0::shinyAppAuth0
# install.packages("auth0")

# 2. Rodar auth0::use_auth0()

# 3. Preencher o _auth0.yml

# 4. Criar cridenciais no .renviron
# usethis::edit_r_environ(scope = "project")

# 5. Colocar http://localhost:8080 em
# - Allowed Callback URLs 
# - Allowed Logout URLs
# - Allowed Web Origins

# 6. Rodar o app na porta 8080
# options = list(port = 8080)

# 7. Colocar botão de logout
# auth0::logoutButton()
