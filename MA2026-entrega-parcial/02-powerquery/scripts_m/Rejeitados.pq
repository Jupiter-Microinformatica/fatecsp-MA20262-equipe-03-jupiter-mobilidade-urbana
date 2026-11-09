// Rejeitados
// Toda célula da base que não chegou a fDemandaDia, com o motivo (lacunas, zeros e traços incluídos).
let
    Origem = stg_Entr_Estacao_Bruto,
    // 1. linhas lidas que NÃO estão em fDemandaDia (junção anti esquerda)
    Mescla = Table.NestedJoin(Origem, {"Linha_Origem", "Coluna_Origem"}, fDemandaDia, {"Linha_Origem", "Coluna_Origem"}, "Aceita", JoinKind.LeftAnti),
    SoRejeitadas = Table.RemoveColumns(Mescla, {"Aceita"}),
    Chaves = List.Buffer(cad_Estacoes[Cod_Estacao]),
    // 2. mesma ordem de regras de fDemandaDia: o primeiro teste que falha é o motivo
    Diagnostico = (r as record) as text =>
        let
            Txt = r[Entrada_Texto],
            Valor = fnNumero(Txt),
            Data = try #date(Number.From(r[Ano_Titulo]), r[Mes_Num], Number.From(r[Dia_Bruto])) otherwise null,
            Cod = if r[Cod_Linha] = null or r[Sigla_Bruto] = null then null else r[Cod_Linha] & "-" & r[Sigla_Bruto]
        in
            if r[Cod_Linha] = null then "Linha não identificada"
            else if Txt = null or Txt = "" then "Entrada vazia"
            else if Txt = "-" then "Entrada com traço"
            else if Valor = null then "Valor não numérico"
            else if Valor = 0 then "Entrada zero"
            else if Valor < 0 then "Entrada negativa"
            else if Data = null then "Data inválida"
            else if Data < pDataInicio or Data > pDataFim then "Data fora do período"
            else if not List.Contains(Chaves, Cod) then "Estação não cadastrada"
            else "Linha duplicada",
    ComMotivo = Table.AddColumn(SoRejeitadas, "Motivo", each Diagnostico(_), type text),
    ComData = Table.AddColumn(ComMotivo, "Data", each
        try #date(Number.From([Ano_Titulo]), [Mes_Num], Number.From([Dia_Bruto])) otherwise null, type nullable date),
    ComCod = Table.AddColumn(ComData, "Cod_Estacao", each
        if [Cod_Linha] = null or [Sigla_Bruto] = null then null else [Cod_Linha] & "-" & [Sigla_Bruto], type nullable text),
    Colunas = Table.SelectColumns(ComCod, {"Aba_Origem", "Linha_Origem", "Coluna_Origem", "Data", "Cod_Estacao", "Entrada_Texto", "Motivo"}),
    Ordenada = Table.Sort(Colunas, {{"Linha_Origem", Order.Ascending}, {"Coluna_Origem", Order.Ascending}})
in
    Ordenada
