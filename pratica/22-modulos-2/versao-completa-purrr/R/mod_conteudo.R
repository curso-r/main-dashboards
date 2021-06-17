conteudoUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 12,
        uiOutput(ns("titulo"))
      )
    ),
    br(),
    fluidRow(
      column(
        width = 4,
        selectInput(
          ns("pokemon"),
          label = "Selecione um pokémon",
          choices = c("Carregando" = "")
        ),
        uiOutput(ns("img_pokemon"))
      ),
      column(
        width = 8,
        plotOutput(ns("grafico_habilidades"))
      )
    ),
    br(),
    fluidRow(
      column(
        width = 12,
        plotOutput(ns("grafico_freq"))
      )
    )
  )
}

conteudoServer <- function(id, tipo, pokemon) {
  moduleServer(id, function(input, output, session) {

    tab_pokemon <- pokemon |>
        filter(tipo_1 == tipo)

    cor <- tab_pokemon |>
      pull(cor_1) |>
      unique()

    output$titulo <- renderUI({
      h2(
        paste("Pokémon do tipo ", tipo),
        style = paste("color: ", cor, ";")
      )
    })

    observe({
      pkmns <- tab_pokemon |>
        pull(pokemon) |>
        unique()

      updateSelectInput(
        session,
        "pokemon",
        choices = pkmns
      )
    })

    output$img_pokemon <- renderUI({
      req(input$pokemon)
      url <- pokemon |>
        filter(pokemon == input$pokemon) |>
        pull(url_imagem)

      img(src = url, width = "300px")
    })



    output$grafico_habilidades <- renderPlot({

      req(input$pokemon)

      tab_pokemon_escolhido <- tab_pokemon |>
        filter(pokemon == input$pokemon) |>
        tidyr::pivot_longer(
          names_to = "habilidade",
          values_to = "valor",
          cols = ataque:velocidade
        )

      tab_pokemon |>
        tidyr::pivot_longer(
          names_to = "habilidade",
          values_to = "valor",
          cols = ataque:velocidade
        ) |>
        ggplot(aes(y = habilidade, x = valor, fill = habilidade)) +
        ggridges::geom_density_ridges(
          show.legend = FALSE,
          alpha = 0.8
        ) +
        geom_point(
          aes(x = valor, y = habilidade),
          data = tab_pokemon_escolhido,
          show.legend = FALSE,
          shape = 4,
          alpha = 0.9,
          size = 5
        ) +
        labs(y = "Habilidade", x = "Valor") +
        theme_minimal()
    })

    output$grafico_freq <- renderPlot({
      tab_pokemon |>
        count(id_geracao) |>
        ggplot(aes(x = id_geracao, y = n)) +
        geom_col(fill = cor) +
        labs(x = "Geração", y = "Número de pokémon") +
        theme_minimal()
    })


  })
}
