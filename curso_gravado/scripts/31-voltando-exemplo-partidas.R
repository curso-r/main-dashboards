library(shiny)

url <- "https://raw.githubusercontent.com/williamorim/brasileirao/master/data-raw/csv/matches.csv"

ui <- fluidPage(
  titlePanel("Os últimos 5 jogos de cada time"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "temporada",
        label = "Temporada",
        choices = c("Carregando..." = "")
      ),
      selectInput(
        inputId = "time",
        label = "Time",
        choices = c("Carregando..." = "")
      )
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
  
  gatilho <- reactiveVal(0)
  
  observe({
    temporadas <- sort(unique(dados$season))
    
    updateSelectInput(
      session = session,
      inputId = "temporada",
      choices = temporadas
    )
    
  })
  
  observeEvent(input$temporada, {
    req(input$temporada)
    
    times <- dados |> 
      dplyr::filter(season == input$temporada) |> 
      dplyr::pull(home) |> 
      unique() |> 
      sort()
    
    if (times[1] == input$time) {
      gatilho(gatilho() + 1)
    }
    
    updateSelectInput(
      session = session,
      inputId = "time",
      choices = times
    )
  })
  
  dados_time <- reactive({
    req(input$time)
    temporada <- isolate(input$temporada)
    gatilho()
    dados |> 
      dplyr::filter(
        season == temporada,
        home == input$time | away == input$time
      ) |> 
      dplyr::arrange(desc(date)) |> 
      dplyr::slice(1:5) 
  })
  
  output$tabela <- renderTable({
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
  })
  
  output$texto <- renderText({
    
    Sys.sleep(1)
    
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
    
  })
  
}

shinyApp(ui, server)








