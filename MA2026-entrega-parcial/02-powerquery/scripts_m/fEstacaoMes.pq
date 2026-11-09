// fEstacaoMes
// Passageiros por estação e mês (média de dias úteis, mil). Despivotada: um mês por linha.
let
    Origem = stg_Pass_Estacao_Bruto,
    ComChaveNome = Table.AddColumn(Origem, "Chave_Nome", each
        if [Cod_Linha] = null then null else [Cod_Linha] & "|" & Text.Upper(Text.Trim([Nome_Bruto])), type nullable text),
    Mescla = Table.NestedJoin(ComChaveNome, {"Chave_Nome"}, cad_DeParaEstacao, {"Chave_Nome"}, "DePara", JoinKind.LeftOuter),
    ExpandeEstacao = Table.ExpandTableColumn(Mescla, "DePara", {"Cod_Estacao"}, {"Cod_Estacao"}),
    ComMes = Table.AddColumn(ExpandeEstacao, "Mes_Num", each List.PositionOf(lst_MesesAbrev, Text.Upper([Mes_Abrev])) + 1, Int64.Type),
    ComInicio = Table.AddColumn(ComMes, "Mes_Inicio", each try #date(pAno, [Mes_Num], 1) otherwise null, type nullable date),
    ComValor = Table.AddColumn(ComInicio, "Passageiros_MDU_Mil", each fnNumero([Passageiros_Texto]), type nullable number),
    ComStatus = Table.AddColumn(ComValor, "Status_Qualidade", each
        if [Cod_Estacao] = null then "Sem correspondência"
        else if [Passageiros_MDU_Mil] = null then "Valor não numérico"
        else if [Mes_Inicio] = null then "Mês inválido"
        else "OK", type text),
    FormatoFinal = Table.SelectColumns(ComStatus, {"Mes_Inicio", "Mes_Num", "Cod_Estacao", "Passageiros_MDU_Mil", "Status_Qualidade", "Aba_Origem", "Linha_Origem", "Coluna_Origem"}),
    Tipos = Table.TransformColumnTypes(FormatoFinal, {{"Mes_Inicio", type date}, {"Cod_Estacao", type text}, {"Passageiros_MDU_Mil", type number}})
in
    Tipos
