## code to prepare `mapa_drilldown` dataset goes here

# install.packages("geojsonio)
# install.packages("geojsonlint")
# devtools::install_github("rpradosiqueira/brazilmaps")

library(dplyr)

shape_estados <- brazilmaps::get_brmap("State") %>% 
  select(nome, cod_estado = State, geometry)
  
shape_cidades <- brazilmaps::get_brmap("City") %>% 
  select(nome, cod_cidade = City, cod_estado = State, geometry)

criar_lista_geojson <- function(cod, nome_estado, tab_geo) {
  
  tab <- tab_geo %>% 
    filter(cod_estado == cod) %>% 
    select(cod_estado, nome, cod_cidade) %>% 
    mutate(value = 1:n())
  
  tab_mapa <- tab_geo %>% 
    filter(cod_estado == cod) %>%
    sf::st_simplify(
      preserveTopology = TRUE,
      dTolerance = 0.01
    ) %>%
    sf::as_Spatial() %>%
    geojsonio::geojson_json()
  
  list(
    id = cod,
    name = nome_estado,
    mapData = tab_mapa,
    joinBy = "cod_cidade",
    data = highcharter::list_parse(tab)
  )
}

lista_geojson <- purrr::map2(
  unique(shape_estados$cod_estado),
  unique(shape_estados$nome),
  criar_lista_geojson,
  tab_geo = shape_cidades
)

tab_geo_estados <- shape_estados %>% 
  sf::st_simplify(
    preserveTopology = TRUE,
    dTolerance = 0.01
  ) %>%
  sf::as_Spatial() %>%
  geojsonio::geojson_json()

tab <- shape_estados %>% 
  tibble::as_tibble() %>% 
  select(nome, cod_estado) %>% 
  mutate(
    value = 1:n(),
    drilldown = cod_estado
  )
  
highcharter::highchart(type = "map") %>% 
  highcharter::hc_add_series(
    name = "Brasil",
    data = tab,
    mapData = tab_geo_estados,
    joinBy = "cod_estado",
    dataLabels = list(
      enabled = TRUE, 
      format = '{point.nome}'
    )
  ) %>% 
  highcharter::hc_drilldown(
    series = lista_geojson
  ) %>% 
  highcharter::hc_legend(enabled = FALSE) %>% 
  highcharter::hc_tooltip(
    pointFormat = "{point.nome}",
    headerFormat = NULL
  )

usethis::use_data(mapa_drilldown, overwrite = TRUE)
