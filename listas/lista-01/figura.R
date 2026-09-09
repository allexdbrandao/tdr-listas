
dados <- read.csv("airquality.csv")

# Grafico PDF
pdf("figura.pdf", width = 7, height = 5)

# boxplot Wind por mes
boxplot(
  Wind ~ Month,
  data = dados,
  xlab = "Mês",
  ylab = "Velocidade do Vento (mph)",
  main = "Distribuição da Velocidade do Vento por Mês",
  col = "lightblue",
  border = "darkblue"
)

dev.off()
