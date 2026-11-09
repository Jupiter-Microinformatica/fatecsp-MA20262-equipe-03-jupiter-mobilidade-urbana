# README – Consultas e parâmetros
## Análise do transporte metropolitano de SP (Metrô-SP)

## 1. Descrição dos parâmetros

Os parâmetros permitem configurar os arquivos utilizados e alguns critérios da análise sem precisar alterar diretamente o código das consultas.

| Parâmetro | Descrição |
|---|---|
| `pArquivoBase` | Caminho do arquivo Excel com os dados brutos do Metrô-SP. |
| `pArquivoEtapa1` | Caminho do arquivo Excel produzido na Etapa 1, que contém os cadastros utilizados nesta etapa. |
| `pAno` | Ano de referência utilizado na análise. |
| `pDataInicio` | Data inicial do período considerado. |
| `pDataFim` | Data final do período considerado. |
| `pLimiteDesvio` | Percentual limite usado para identificar valores atípicos em relação à média de referência. |
| `pTolSomaMil` | Tolerância utilizada na conferência da soma de passageiros por linha, em milhares. |
| `pTolMDU` | Tolerância utilizada na conferência da média de dias úteis (MDU). |

## 2. Descrição das consultas

As consultas estão separadas em grupos para facilitar a organização. Algumas são utilizadas como apoio para outras consultas e não precisam ser carregadas em planilhas.

### 01_Parametros

| Consulta | Descrição |
|---|---|
| `pArquivoBase` | Define o caminho do arquivo de dados brutos do Metrô-SP. |
| `pArquivoEtapa1` | Define o caminho do arquivo de cadastros da Etapa 1. |
| `pAno` | Define o ano de referência. |
| `pDataInicio` | Define o início do período analisado. |
| `pDataFim` | Define o fim do período analisado. |
| `pLimiteDesvio` | Define o limite percentual para sinalização de anomalias. |
| `pTolSomaMil` | Define a tolerância para conferência das somas por linha. |
| `pTolMDU` | Define a tolerância para conferência da média de dias úteis. |

### 02_Funcoes

| Consulta | Descrição |
|---|---|
| `fnTxt` | Padroniza textos, tratando espaços e valores textuais. |
| `fnTxtU` | Padroniza textos e os converte para maiúsculas. |
| `fnNumero` | Converte valores numéricos que estão armazenados como texto para número. |
| `fnCodLinha` | Padroniza o código identificador da linha do Metrô. |
| `fnAba` | Localiza e lê uma aba específica da base de dados. |
| `fnBlocoDia` | Auxilia na identificação dos blocos de dados organizados por dia. |
| `fnExtrairDia` | Extrai o número do dia a partir da estrutura da base. |
| `fnExtrairPassEstacao` | Extrai os dados de passageiros transportados por estação. |
| `fnExtrairLinhaMes` | Extrai os dados mensais organizados por linha. |
| `fnLinhaMesNum` | Auxilia na identificação e conversão dos meses associados às linhas. |
| `fnExtrairOferta` | Extrai os dados de oferta, como intervalos e velocidades. |

### 03_Cadastros

| Consulta | Descrição |
|---|---|
| `cad_Etapa1` | Conecta ao arquivo da Etapa 1, que fornece os cadastros utilizados no tratamento. |
| `cad_Abas` | Lista e identifica as abas úteis da base do Metrô-SP. |
| `cad_Meses` | Cadastro dos meses e seus números correspondentes. |
| `lst_MesesAbrev` | Lista as abreviações dos meses usadas para localizar os blocos de dados. |
| `cad_Linhas` | Cadastro das linhas consideradas na análise. |
| `cad_Estacoes` | Cadastro das estações e suas informações de identificação. |
| `cad_DeParaEstacao` | Relaciona os nomes encontrados na base às estações cadastradas, padronizando sua identificação. |
| `cad_Feriados` | Cadastro de feriados utilizado no calendário e nas conferências de dias úteis. |

### 04_Staging

As consultas deste grupo fazem a leitura inicial e organizam os dados em formato de apoio, mantendo os valores ainda como texto.

| Consulta | Descrição |
|---|---|
| `stg_Entr_Estacao_Bruto` | Organiza os dados brutos de entradas de passageiros por estação. |
| `stg_Pass_Estacao_Bruto` | Organiza os dados brutos de passageiros transportados por estação. |
| `stg_Entr_Linha_Bruto` | Organiza os dados brutos de entradas de passageiros por linha. |
| `stg_Pass_Linha_Bruto` | Organiza os dados brutos de passageiros transportados por linha. |
| `stg_Oferta_Bruto` | Organiza os dados brutos de oferta das linhas, incluindo intervalos e velocidades. |

### 05_Saida

Este grupo reúne as tabelas tratadas que serão utilizadas na análise.

| Consulta | Descrição |
|---|---|
| `fDemandaDia` | Tabela principal de demanda diária, com entradas por estação, linha e data, após tratamento e aplicação dos filtros. |
| `Rejeitados` | Registra os dados que não entraram na tabela principal, informando o motivo da rejeição. |
| `fEstacaoMes` | Organiza os dados mensais de demanda por estação. |
| `fLinhaMes` | Organiza os dados mensais de passageiros, entradas e transferências por linha. |
| `fOferta` | Reúne os dados de oferta das linhas, como intervalos e velocidades. |
| `fAnomalias` | Identifica valores que apresentam variações atípicas em relação à média de referência. |
| `dEstacao` | Tabela de dimensão com os dados de identificação das estações. |
| `dLinha` | Tabela de dimensão com os dados de identificação das linhas. |
| `dCalendario` | Tabela de calendário utilizada para relacionar datas e identificar dias úteis, fins de semana e feriados. |

### 06_Conferencia

As consultas deste grupo servem para conferir se os dados foram tratados corretamente e se os totais estão consistentes.

| Consulta | Descrição |
|---|---|
| `Conf_Reconciliacao` | Compara a quantidade de registros de origem com os registros tratados e rejeitados. |
| `Conf_Motivos` | Apresenta a quantidade de registros rejeitados por motivo. |
| `Conf_Estrutura` | Verifica aspectos da estrutura e da leitura dos dados da base. |
| `Conf_SomaLinha` | Confere a soma dos dados por estação em relação aos totais oficiais por linha e compara a média de dias úteis. |
