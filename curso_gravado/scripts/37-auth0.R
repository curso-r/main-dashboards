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

auth0::shinyAppAuth0(ui, server)

# auth0::use_auth0()
# usethis::edit_r_environ()

# options(shiny.port = 8080)
# shiny::runApp("exemplos/auth0/")

# http://localhost:8080 to the "Allowed Callback URLs", 
# "Allowed Web Origins" and "Allowed Logout URLs"