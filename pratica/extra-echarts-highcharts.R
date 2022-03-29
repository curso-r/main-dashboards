library(shiny)
library(dplyr)

ssp <- readr::read_rds("../dados/ssp.rds")

ui <- fluidPage(
  titlePanel("Echarts e Highcharts"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "cidade",
        "Cidade",
        choices = unique(ssp$municipio_nome)
      ),
      shinyWidgets::pickerInput(
        "delegacias",
        "Delegacia",
        choices = c("Carregando" = ""),
        multiple = TRUE,
        options = shinyWidgets::pickerOptions(
          actionsBox = TRUE,
          selectAllText = "Selecionar todas",
          deselectAllText = "Remover todas"
        )
      )
    ),
    mainPanel(
      echarts4r::echarts4rOutput("echart"),
      br(),
      highcharter::highchartOutput("highchart")
    )
  )
)

server <- function(input, output, session) {
  
  observe({
    delegacias <- ssp %>% 
      dplyr::filter(municipio_nome == input$cidade) %>% 
      dplyr::pull(delegacia_nome) %>% 
      unique()
    
    shinyWidgets::updatePickerInput(
      session = session,
      inputId = "delegacias",
      choices = delegacias,
      selected = delegacias
    )
  })
  
  tab_grafico <- reactive({
    ssp %>% 
      dplyr::filter(
        municipio_nome == isolate(input$cidade),
        delegacia_nome %in% input$delegacias
      ) %>%
      dplyr::mutate(
        data = lubridate::make_date(
          year = ano,
          month = mes,
          day = 1
        )
      ) %>% 
      dplyr::group_by(data) %>% 
      dplyr::summarise(
        num_casos = sum(furto_veiculos, na.rm = TRUE)
      )
     
  })
  
  output$echart <- echarts4r::renderEcharts4r({
    req(nrow(tab_grafico()) > 0)
    tab_grafico() %>% 
      echarts4r::e_chart(x = data) %>% 
      echarts4r::e_line(serie = num_casos)
  })
  
  output$highchart <- highcharter::renderHighchart({
    req(nrow(tab_grafico()) > 0)
    tab_grafico() %>% 
      highcharter::hchart(
        "line",
        highcharter::hcaes(
          x = data,
          y = num_casos
        )
      )
  })
  
}

shinyApp(ui, server)