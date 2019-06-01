credit <- recipes::credit_data

credit %>% 
  rename(
    status = Status,
    tempo_empresa = Seniority,
    moradia = Home,
    tempo_emprestimo = Time,
    idade = Age,
    estado_civil = Marital,
    registros = Records,
    trabalho = Job,
    despesas = Expenses,
    renda = Income,
    ativos = Assets,
    dividas = Debt,
    valor_emprestimo = Amount,
    preco_do_bem = Price
  ) %>% 
  mutate(
    status = ifelse(status == "good", "bom", "ruim"),
    moradia = case_when(
      is.na(moradia) ~ NA_character_,
      moradia == "ignore" ~ NA_character_,
      moradia == "other" ~ "outras",
      moradia == "owner" ~ "própria",
      moradia == "parents" ~ "pais",
      moradia == "priv" ~ "priv",
      moradia == "rent" ~ "alugada",
      TRUE ~ "ERRADO"
    ),
    registros = ifelse(registros == "yes", "sim", "não"),
    estado_civil = case_when(
      is.na(estado_civil) ~ NA_character_,
      estado_civil == "divorced" ~ "divorciada(o)",
      estado_civil == "married" ~ "casada(o)",
      estado_civil == "separated" ~ "separada(o)",
      estado_civil == "single" ~ "solteira(o)",
      estado_civil == "widow" ~ "viúva(o)",
      TRUE ~ "ERRADO"
    ),
    trabalho = case_when(
      is.na(trabalho) ~ NA_character_,
      trabalho == "fixed" ~ "fixo",
      trabalho == "freelance" ~ "autônomo",
      trabalho == "others" ~ "outros",
      trabalho == "partime" ~ "meio período",
      TRUE ~ "ERRADO"
    )
  ) %>% 
  write_rds("dados/credit.rds")
