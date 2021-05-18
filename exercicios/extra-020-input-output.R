# Boxplots da base diamonds
# 
# Faça um shiny app para visualizarmos boxplots da base diamonds.
# 
# O seu app deve ter dois inputs e um output:
#   
#   1. o primeiro input deve ser uma caixa de seleção das variáveis 
#     numéricas da base (será o eixo y do gráfico).
# 
#   2. o segundo input deve ser uma caixa de seleção das variáveis 
#    categóricas da base (será o eixo x do gráfico).
# 
#   3. o output deve ser um gráfico com os boxplots da variável 
#    escolhida em (1) para cada categoria da variável escolhida em (2).
# 
# Para acessar a base diamonds, carrrege o pacote ggplot2
# 

library(ggplto2)

# 
# ou rode 
# 

ggplot2::diamonds