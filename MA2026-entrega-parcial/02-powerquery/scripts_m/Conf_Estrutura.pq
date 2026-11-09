// Conf_Estrutura
// Confere se a leitura achou todos os blocos esperados (meses, linhas, estações, dias) e se as tabelas menores têm o tamanho certo.
let
    NMeses = (Date.Year(pDataFim) - Date.Year(pDataInicio)) * 12 + Date.Month(pDataFim) - Date.Month(pDataInicio) + 1,
    NLinhas = Table.RowCount(cad_Linhas),
    NEstacoes = Table.RowCount(cad_Estacoes),
    NDias = Duration.Days(pDataFim - pDataInicio) + 1,
    Stg = stg_Entr_Estacao_Bruto,
    Itens = {
        {"Meses lidos em Entr. p. Estação", Table.RowCount(Table.Distinct(Table.SelectColumns(Stg, {"Mes_Num"}))), NMeses},
        {"Linhas identificadas em Entr. p. Estação", Table.RowCount(Table.Distinct(Table.SelectColumns(Table.SelectRows(Stg, each [Cod_Linha] <> null), {"Cod_Linha"}))), NLinhas},
        {"Estações-linha lidas em Entr. p. Estação", Table.RowCount(Table.Distinct(Table.SelectColumns(Stg, {"Cod_Linha", "Sigla_Bruto"}))), NEstacoes},
        {"Dias lidos em Entr. p. Estação", Table.RowCount(Table.Distinct(Table.SelectColumns(Stg, {"Mes_Num", "Dia_Bruto"}))), NDias},
        {"Linhas de stg_Entr_Estacao_Bruto (estações x dias)", Table.RowCount(Stg), NEstacoes * NDias},
        {"Linhas de fEstacaoMes (estações x meses)", Table.RowCount(fEstacaoMes), NEstacoes * NMeses},
        {"Linhas de fLinhaMes ((linhas + rede) x meses)", Table.RowCount(fLinhaMes), (NLinhas + 1) * NMeses},
        {"Linhas de fOferta (linhas x meses)", Table.RowCount(fOferta), NLinhas * NMeses},
        {"fEstacaoMes com qualidade diferente de OK", Table.RowCount(Table.SelectRows(fEstacaoMes, each [Status_Qualidade] <> "OK")), 0},
        {"fLinhaMes com qualidade diferente de OK", Table.RowCount(Table.SelectRows(fLinhaMes, each [Status_Qualidade] <> "OK")), 0},
        {"fOferta com qualidade diferente de OK", Table.RowCount(Table.SelectRows(fOferta, each [Status_Qualidade] <> "OK")), 0}
    },
    Tabela = #table(type table [Verificacao = text, Encontrado = Int64.Type, Esperado = Int64.Type], Itens),
    ComStatus = Table.AddColumn(Tabela, "Status", each if [Encontrado] = [Esperado] then "OK" else "Divergente", type text)
in
    ComStatus
