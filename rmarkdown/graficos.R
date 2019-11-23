library(tidyverse)
imdb <- read_rds("dados/imdb.rds")

# Gráfico 1
imdb %>%
  filter(!is.na(balanco)) %>% 
  mutate(
    lucro = ifelse(balanco <= 0, "Não", "Sim")
  ) %>%
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita, color = lucro)) +
  labs(x = "Orçamento", y = "Arrecadação", color = "Houve lucro?") +
  scale_y_continuous(label = scales::dollar_format()) +
  scale_x_continuous(label = scales::dollar_format()) +
  theme_minimal()


# Gráfico 2
imdb %>%
  filter(classificacao %in% c("Livre", "A partir de 13 anos")) %>%
  mutate(
    orcamento = orcamento/1000000,
    ano_cat = ifelse(ano < 2000, "Antigos", "Recentes"),
    ano_class = paste(classificacao, ano_cat, sep = "/")
  ) %>%
  ggplot() +
  geom_point(aes(x = orcamento, y = nota_imdb, color = ano_class)) +
  facet_grid(ano_cat ~ classificacao) +
  scale_x_continuous(label = scales::dollar_format()) +
  labs(
    x = "Orçamento (em milhões de dólares)", 
    y = "Nota IMDB", 
    color = "Classificação/Lançamento"
  ) +
  theme_minimal() 

# Gráfico 3
imdb %>% 
  count(diretor) %>% 
  arrange(desc(n)) %>% 
  filter(!is.na(diretor)) %>% 
  top_n(10, n) %>%
  mutate(
    diretor = fct_reorder(diretor, n)
  ) %>% 
  ggplot(aes(x = diretor, y = n)) +
  geom_col(
    color = "black",
    fill = "#ffa500"
  ) +
  geom_text(aes(y = n + 1, label = n)) +
  labs(y = "Número de filmes") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5)) 

# Gráfico 4
imdb %>% 
  filter(!is.na(diretor)) %>%
  group_by(diretor) %>% 
  filter(n() >= 15) %>%
  ungroup() %>% 
  mutate(
    diretor = fct_reorder(diretor, balanco, .fun = max, na.rm = TRUE)
  ) %>% 
  ggplot() +
  geom_boxplot(aes(x = diretor, y = balanco, fill = diretor)) +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5)) +
  scale_y_continuous(label = scales::dollar_format()) +
  labs(x = "Diretor", y = "Balanço", fill = "Diretor") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5))
