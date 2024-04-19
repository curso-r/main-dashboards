library(shiny)

url <- "https://raw.githubusercontent.com/williamorim/brasileirao/master/data-raw/csv/matches.csv"

ui <- fluidPage(
  titlePanel("Os últimos 5 jogos de cada time"),
  sidebarLayout(
    sidebarPanel(
      uiOutput(outputId = "select_temporada"),
      uiOutput(outputId = "select_time")
    ),
    mainPanel(
      fluidRow(
        column(
          width = 6,
          tableOutput(outputId = "tabela")
        ),
        column(
          width = 6,
          textOutput(outputId = "texto")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  dados <- readr::read_csv(url)
  
  output$select_temporada <- renderUI({
    temporadas <- sort(unique(dados$season))
    selectInput(
      inputId = "temporada",
      label = "Temporada",
      choices = temporadas
    )
  })
  
  output$select_time <- renderUI({
    browser()
    if (!is.null(input$temporada)) {
      times <- dados |> 
        dplyr::filter(season == input$temporada) |> 
        dplyr::pull(home) |> 
        unique() |> 
        sort()
      selectInput(
        inputId = "time",
        label = "Time",
        choices = times
      )
    } else {
      NULL
    }
  })
  
  dados_time <- reactive({
    if (!is.null(input$time)) {
      dados |> 
        dplyr::filter(
          season == input$temporada,
          home == input$time | away == input$time
        ) |> 
        dplyr::arrange(desc(date)) |> 
        dplyr::slice(1:5) 
    }
    else {
      NULL
    }
  })
  
  output$tabela <- renderTable({
    if (!is.null(dados_time())) {
      dados_time() |> 
        dplyr::mutate(
          date = format(date, "%d/%m/%Y")
        ) |> 
        dplyr::select(
          date,
          home, 
          score,
          away
        )
    } else {
      NULL
    }
  })
  
  output$texto <- renderText({
    if (!is.null(dados_time())) {
      tab <- dados_time() |> 
        tidyr::separate_wider_delim(
          cols = score,
          delim = "x",
          names = c("gols_mandante", "gols_visitante")
        ) |>
        dplyr::mutate(
          flag_vitoria = dplyr::case_when(
            home == input$time & gols_mandante > gols_visitante ~ "ganhou",
            away == input$time & gols_visitante > gols_mandante ~ "ganhou",
            TRUE ~ "perdeu"
          )
        )
      
      num_vitorias <- sum(tab$flag_vitoria == "ganhou")
      
      if (num_vitorias == 0) {
        "{input$time} não ganhou nenhum jogo."
      } else if (num_vitorias == 1) {
        glue::glue("{input$time} venceu 1 jogo nos últimos 5.")
      } else {
        glue::glue("{input$time} venceu {num_vitorias} jogos nos últimos 5.")
      }
    } else {
      NULL
    }
    
  })
  
}

shinyApp(ui, server)








