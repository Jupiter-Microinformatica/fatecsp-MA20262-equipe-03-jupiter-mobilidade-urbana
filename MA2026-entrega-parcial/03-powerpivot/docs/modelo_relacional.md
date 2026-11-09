# Modelo relacional – MetroSP (Etapa 3)

Fonte dos dados: Transparência do Metrô-SP, 2025 (linhas L1, L2, L3 e L15). Todas as tabelas vêm do arquivo `MetroSP_02_PowerQuery.xlsx`; nada é limpo nesta etapa.

## Tabelas e granularidade

| Tabela | Tipo | Grão (1 linha = ...) | Chave | Linhas |
|---|---|---|---|---|
| `fDemandaDia` | fato | uma estação-linha em um dia (medida válida > 0) | `Cod_Estacao` + `Data` | 24.050 |
| `fEstacaoMes` | fato | uma estação-linha em um mês (média de dias úteis, mil) | `Cod_Estacao` + `Mes_Inicio` | 792 |
| `fLinhaMes` | fato | uma linha em um mês (valores oficiais, mil). **Sem as linhas REDE** | `Cod_Linha` + `Mes_Inicio` | 48 |
| `fOferta` | fato | uma linha em um mês (intervalo e velocidade) | `Cod_Linha` + `Mes_Inicio` | 48 |
| `fAnomalias` | fato | um sinal de queda ou alta atípica (estação-dia) | `Cod_Estacao` + `Data` | 397 |
| `fLacunas` | fato | uma estação-dia sem medição (vazio, traço ou zero) | `Cod_Estacao` + `Data` | 40 |
| `dEstacao` | dimensão | uma estação em uma linha (chave **Linha-Sigla**) | `Cod_Estacao` | 66 |
| `dLinha` | dimensão | uma linha do Metrô | `Cod_Linha` | 4 |
| `dCalendario` | dimensão | um dia do ano (contínua, 01/01 a 31/12/2025) | `Data` | 365 |
| `Rejeitados` | auditoria (fora da estrela) | uma célula da base descartada na Etapa 2, com motivo | `Linha_Origem` + `Coluna_Origem` | 40 |
| `refRedeMes` | referência (fora da estrela) | a REDE oficial em um mês | `Mes_Inicio` | 12 |

Por que a chave da estação é Linha-Sigla: ANR, PSO e PSE existem em duas linhas e Vila Prudente aparece nas linhas 2 e 15. A estação física (62) é contada pelo nome (`dEstacao[Estacao]`).

## Relacionamentos (13)

Todos **muitos para um**, filtro em **direção única** (da dimensão para o fato), todos **ativos**.

| # | Lado "muitos" (fato) | Lado "um" (dimensão) |
|---|---|---|
| 1 | `fDemandaDia[Cod_Estacao]` | `dEstacao[Cod_Estacao]` |
| 2 | `dEstacao[Cod_Linha]` | `dLinha[Cod_Linha]  (dimensão para dimensão: dLinha filtra dEstacao)` |
| 3 | `fDemandaDia[Data]` | `dCalendario[Data]` |
| 4 | `fEstacaoMes[Cod_Estacao]` | `dEstacao[Cod_Estacao]` |
| 5 | `fEstacaoMes[Mes_Inicio]` | `dCalendario[Data]` |
| 6 | `fLinhaMes[Cod_Linha]` | `dLinha[Cod_Linha]` |
| 7 | `fLinhaMes[Mes_Inicio]` | `dCalendario[Data]` |
| 8 | `fOferta[Cod_Linha]` | `dLinha[Cod_Linha]` |
| 9 | `fOferta[Mes_Inicio]` | `dCalendario[Data]` |
| 10 | `fAnomalias[Cod_Estacao]` | `dEstacao[Cod_Estacao]` |
| 11 | `fAnomalias[Data]` | `dCalendario[Data]` |
| 12 | `fLacunas[Cod_Estacao]` | `dEstacao[Cod_Estacao]` |
| 13 | `fLacunas[Data]` | `dCalendario[Data]` |

Nenhuma tabela tem dois caminhos para a mesma dimensão. Por isso `fDemandaDia[Cod_Linha]` **não** é relacionado (a linha chega por `dEstacao`): relacioná-lo criaria ambiguidade.

## Decisões do modelo

- **REDE fora de `fLinhaMes`.** A rede é a soma das 4 linhas. Se as linhas REDE ficassem na tabela, qualquer SUM mensal contaria tudo em dobro e `Cod_Linha = "REDE"` não existe em `dLinha`. Elas ficam em `refRedeMes`, só para conferência.
- **Fatos mensais ligam em `dCalendario[Data]` pelo primeiro dia do mês** (`Mes_Inicio`), como a tabela de metas do modelo do professor. Cruzar `fEstacaoMes`, `fLinhaMes` ou `fOferta` com atributos de **dia** (dia da semana, tipo de dia) devolve valores errados ou vazios. Use mês, trimestre ou ano.
- **`fLacunas` e `fAnomalias`** são os sinais indiretos de falha: a base não traz ocorrências.
- **Medidas não aditivas** (média, MDU, razão) são medidas, não colunas: `Entradas MDU Mil`, `Razão FDS / Dia Útil`, `Média Diária Mil`.

## Perguntas do projeto e onde respondê-las

| Pergunta | Linhas / colunas da tabela dinâmica | Medidas |
|---|---|---|
| Momento de maior demanda (sem hora do dia: só dia e mês) | `dCalendario[Dia_Semana]`, `Tipo_Dia`, `Nome_Mes` | `Média Diária Mil`, `Maior Dia Mil`, `Entradas MDU Mil` |
| Passageiros por linha | `dLinha[Linha]` (+ `Mes_Abrev`) | `Entradas Mil`, `Passageiros Transportados Mil`, `Passageiros por km Mil` |
| Estações mais usadas ao longo do tempo | `dEstacao[Estacao]` x `dCalendario[Mes_Abrev]` | `Entradas Mil`, `Ranking Estação`, `Cresc. MoM % (MDU)` |
| Estudo, lazer, trabalho (proxy, **não oficial**) | `dEstacao[Perfil_Hipotese]` | `Razão FDS / Dia Útil` |
| Transferências | `dLinha[Linha]`, `dEstacao[Estacao]` (só as 4 de transferência interna) | `Transferências Mil`, `% Transferência`, `Transf. Interna MDU Mil` |
| Padrões de falha (sinais indiretos) | `dLinha[Linha]`, `dCalendario[Nome_Mes]`, `dEstacao[Estacao]` | `Sinais de Queda`, `Dias com Queda`, `Qtd Lacunas`, `Dias com Lacuna`, `Cobertura de Dados %` |
| Oportunidades de otimização | `dLinha[Linha]` | `Intervalo Médio (s)`, `Velocidade Comercial Média (km/h)`, `Passageiros por km Mil` |
