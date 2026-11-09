Etapa 3 – Power Pivot e DAX | Análise do transporte metropolitano de SP (Metrô-SP)

Disciplina: Microinformática Aplicada (ILP590) – Fatec São Paulo – 2026/2
Equipe / integrantes:
- Guilherme Fernandes Silva – 20482423014
- Lucas Vinicius Batista Beserra - 20482423025
- Bianca Silva Nunes - 20482423006
- Eduardo Souza Castro - 20482423005
- Murilo José Gonzaga - 20482423007

Tema: análise do histórico de operação das linhas do Metrô de São Paulo, identificando padrões sistemáticos de falhas e oportunidades de otimização.
Fonte dos dados: Transparência do Metrô-SP (2025), linhas 1, 2, 3 e 15.
1. Objetivo da etapa

Esta etapa consiste em montar o Modelo de Dados do projeto no Excel, usando o Power Pivot. Vamos organizar as tabelas da Etapa 2, criar os relacionamentos, incluir a tabela de datas e elaborar as primeiras medidas em DAX. Não vamos tratar ou corrigir dados nesta etapa, pois eles já devem estar preparados. Caso seja encontrado algum erro, a correção precisa ser feita nas etapas anteriores e depois devemos atualizar o arquivo.

2. Como abrir e atualizar o arquivo

1. Abra o arquivo MetroSP_02_PowerQuery.xlsx, referente à Etapa 2. Clique em Dados → Atualizar Tudo, confira se a aba Conferencia apresenta diferença 0, salve o arquivo e feche-o.
2. Abra MetroSP_03_PowerPivot.xlsx. Para trabalhar nele, é necessário ter o Excel para Windows de 64 bits com o suplemento Power Pivot ativado.
3. Em Dados → Obter Dados → Iniciar Editor do Power Query, altere o parâmetro pArquivoEtapa2 para indicar onde o arquivo da Etapa 2 está salvo no seu computador. Esse caminho pode ser diferente para cada integrante.
4. Clique em Dados → Atualizar Tudo. Antes de enviar os arquivos para o repositório, salve e feche o Excel, pois, enquanto ele estiver aberto, pode criar um arquivo temporário ~$...xlsx que não deve ser enviado ao Git.
3. O que está nesta pasta (03-powerpivot/)

4. Modelo de dados

O modelo ficou com 6 tabelas de fato, 3 dimensões e 2 tabelas que ficam fora do modelo estrela. Todas são carregadas a partir da Etapa 2 (cad_Etapa2), sem inserir ou copiar tabelas manualmente.

Relacionamentos (13): todos estão configurados como muitos-para-um, ativos e com a filtragem em uma única direção, partindo das dimensões para as tabelas de fato.

Algumas decisões que tomamos na modelagem:
- Chave da estação = Linha-Sigla (ex.: L1-PSE). Algumas siglas, como ANR, PSO e PSE, aparecem em mais de uma linha. Vila Prudente também está nas linhas 2 e 15. Por isso, para contar as estações físicas, usamos o nome da estação (dEstacao[Estacao]), chegando a 62.
- As linhas "REDE" ficaram fora de fLinhaMes. Como a REDE representa a soma das quatro linhas, mantê-la junto delas faria os valores serem contados duas vezes. Separamos os valores oficiais da REDE em refRedeMes para usar na conferência.
- fDemandaDia[Cod_Linha] não foi relacionado diretamente. A informação da linha já chega pela tabela dEstacao. Criar outro relacionamento poderia gerar caminhos duplicados de filtro.
- As tabelas mensais se relacionam com o calendário pelo primeiro dia do mês. Assim, fEstacaoMes, fLinhaMes e fOferta podem ser analisadas por mês, trimestre ou ano, mas não por dia da semana.
- A tabela de calendário veio da Etapa 2, já com feriados e tipos de dia. Nesta etapa, acrescentamos colunas para ordenação e agrupamento e marcamos a tabela como Tabela de Datas.
- Tipos de dados: os valores em mil ficaram como Decimal Fixo, as datas como Data e os códigos como Texto. A formatação de exibição, como casas decimais, separador de milhar e porcentagem, foi ajustada em Gerenciar Medidas.

5. Medidas DAX

Criamos 48 medidas na tabela fDemandaDia. Os códigos estão reunidos no arquivo dax/medidas_preliminares.dax.

6. Validação com tabelas dinâmicas (aba Validacao)

Montamos tabelas dinâmicas sobre o Modelo de Dados e comparamos com os valores de referência.

Observações:
- A soma das linhas de Transferências é 212.013 mil; a linha REDE oficial da fonte informa 212.015 mil. A diferença é arredondamento da fonte.
- Dias com Medição não soma por linha: a L15 tem 362 dias (três domingos sem dados) e o total da rede tem 365.
- Em uma tabela dinâmica por estação, Passageiros Transportados Mil repete o mesmo valor em todas as linhas. Isso é esperado: fLinhaMes se relaciona com dLinha, não com dEstacao.
- A transferência estimada pelas 4 estações de transferência interna (Sé, Paraíso, Ana Rosa e Vila Prudente) fica a menos de 0,3 mil da transferência oficial por linha, o que confirma que as duas fontes contam a mesma coisa.

7. Resultados da conferência (aba Conferencia)

Na aba Conferencia, comparamos os valores da Etapa 2 com os resultados calculados pelo Modelo de Dados usando VALORCUBO.

8. Teste de linhagem (Etapa 1 → Etapa 2 → Etapa 3)

Para testar se as etapas estão conectadas corretamente, adicionamos quatro datas à Tab_Feriados da Etapa 1, consideradas dias de emenda ou ponto facultativo. Depois, atualizamos os arquivos das Etapas 2 e 3.

Decisão após o teste: decidimos desfazer a adição dos feriados, já que a conexão funcionou.

9. O que o modelo mostra (primeiros indícios)

Os resultados abaixo foram obtidos no modelo e servem como ponto de partida para a próxima etapa. Por enquanto, são indícios e ainda não devem ser tratados como conclusões.

- Demanda: em um dia útil entram em média cerca de 2.263 mil passageiros nas estações; no sábado, 1.307 mil; no domingo, 778 mil. O dia de maior demanda do ano foi 25/11/2025 (terça-feira), com 2.510,9 mil entradas. A terça-feira é o dia útil mais forte.
- Estações mais usadas (entradas no ano): Palmeiras-Barra Funda (42.186 mil), Luz (37.061 mil) e República (35.603 mil).
- Transferências: 23,75% dos passageiros transportados. Na Linha 15 chega a 39,8% e na Linha 1 a 27,5%.
- Uso para lazer (hipótese): Japão-Liberdade apresenta mais movimento no fim de semana do que em dias úteis (109%), enquanto Corinthians-Itaquera apresenta 58%. Vila Madalena (41%) não segue essa hipótese. A classificação das estações por perfil de estudo, lazer ou trabalho é uma hipótese da equipe, não um dado oficial.
- Sinais de falha: foram identificadas 261 quedas atípicas e 136 altas atípicas, concentradas principalmente em 25/12 e 01/01, que são feriados. Também encontramos 40 lacunas distribuídas em seis dias: em três deles a Linha 15 ficou sem dados (21/09, 28/09 e 26/10) e nos outros houve falta de dados em estações da Linha 1 (25/01, 26/01 e 15/02).
- Cobertura de dados: 99,83% das estação-dias têm medição.

10. Uso de IA

Utilizamos uma ferramenta de IA para ajudar a adaptar as orientações do professor ao tema do projeto, elaborar códigos M e DAX e obter valores de referência. Depois, executamos os procedimentos no Excel e comparamos os resultados com os valores calculados.