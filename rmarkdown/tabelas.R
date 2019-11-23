library(tidyverse)
imdb <- read_rds("dados/imdb.rds")

# Tabela 1

imdb %>% 
  filter(diretor == "Quentin Tarantino") %>%
  arrange(ano) %>%
  select(`Título` = titulo, Ano = ano)
