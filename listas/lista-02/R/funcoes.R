## Leitura do CSV acrescentando o nome do mês como fator.
ler_dados <- function(caminho) {
  dados <- read.csv(caminho)

  nomes_meses <- c(
    "Maio", "Junho", "Julho", "Agosto",
    "Setembro", "Outubro", "Novembro", "Dezembro"
  )

  dados$Month <- factor(
    dados$Month,
    levels = 5:12,
    labels = nomes_meses
  )

  dados
}


## Média mensal das variáveis Wind e Temp.
resumir_dados <- function(dados) {
  medias <- aggregate(
    cbind(Wind, Temp) ~ Month,
    data = dados,
    FUN = function(x) mean(x, na.rm = TRUE)
  )

  medias
}


## Ajuste de modelo linear Wind em função de Temp.
modelar_dados <- function(dados) {
  lm(Wind ~ Temp, data = dados)
}


## Dispersão com a reta ajustada com figura em PNG.
desenhar_dispersao <- function(dados, modelo, caminho) {
  png(caminho, width = 800, height = 600)

  plot(
    dados$Temp,
    dados$Wind,
    xlab = "Temperatura (°F)",
    ylab = "Velocidade do vento (mph)",
    main = "Velocidade do vento em função da temperatura"
  )

  abline(modelo)

  dev.off()

  caminho
}
