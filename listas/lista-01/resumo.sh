#!/bin/bash
set -euo pipefail

# Recusa a rodar quando faltar argumento
if [ "$#" -lt 2 ]; then
    echo "Uso: $0 <arquivo.csv> <numero_da_coluna>" >&2
    exit 1
fi

# 1. Separador: vírgula
	# Codificação: ASCII
	# Cabeçalho: Sim
# 2. São 154 linhas no arquivo, sendo 153 observações.
# 3. 42 linhas com ao menos um NA.
# 4. Coluna escolhida 3.


ARQUIVO="$1"
COLUNA="$2"

# o nome da coluna, lido do cabeçalho do próprio arquivo
NOME_COLUNA=$(head -n 1 "$ARQUIVO" | cut -d, -f"$COLUNA" | tr -d '"\r')
echo "Coluna: $NOME_COLUNA"

# o número de observações;
TOTAL_OBS=$(tail -n +2 "$ARQUIVO" | wc -l)
echo "Observações: $TOTAL_OBS"

# quantos valores da coluna são NA;
QTD_NA=$(tail -n +2 "$ARQUIVO" | cut -d, -f"$COLUNA" | grep -c "NA" || true)
echo "Valores NA: $QTD_NA"

# a média da coluna por mês, com o número de dias medidos em cada um.
echo "Média por mês:"
awk -F, -v c="$COLUNA" '
NR > 1 {
    val = $c
    mes = $5
    
    if (val != "NA" && val != "") {
        soma[mes] += val
        medidos[mes]++
    }
    total_dias[mes]++
}
END {
    for (m = 5; m <= 9; m++) {
        if (m in total_dias) {
            if (medidos[m] > 0) {
                media = soma[m] / medidos[m]
                printf "Mês %d: %.2f (medidos: %d/%d dias)\n", m, media, medidos[m], total_dias[m]
            } else {
                printf "Mês %d: NA (medidos: 0/%d dias)\n", m, total_dias[m]
            }
        }
    }
}' "$ARQUIVO"
