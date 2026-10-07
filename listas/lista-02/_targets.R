library(targets)

source("R/funcoes.R")

list(
  tar_target(
    arquivo_dados,
    "dados/airquality.csv",
    format = "file"
  ),

  tar_target(
    dados,
    ler_dados(arquivo_dados)
  ),

  tar_target(
    medias,
    resumir_dados(dados)
  ),

  tar_target(
    modelo,
    modelar_dados(dados)
  ),

  tar_target(
    figura,
    desenhar_dispersao(
      dados,
      modelo,
      "saidas/dispersao.png"
    ),
    format = "file"
  ),

  tar_target(
    arquivo_medias,
    {
      dir.create("saidas", showWarnings = FALSE)
      write.csv(medias, "saidas/medias.csv", row.names = FALSE)
      "saidas/medias.csv"
    },
    format = "file"
  ),

  tar_target(
    relatorio,
    {
      force(dados)
      force(medias)
      force(modelo)
      force(figura)

      system2("quarto", c("render", "relatorio.qmd"))

      "relatorio.html"
    },
    format = "file"
  )
)
