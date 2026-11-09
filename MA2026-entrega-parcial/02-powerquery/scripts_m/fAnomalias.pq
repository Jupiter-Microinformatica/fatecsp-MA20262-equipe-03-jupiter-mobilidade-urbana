// fAnomalias
// Sinais indiretos de falha: entradas que fogem mais de pLimiteDesvio da média da mesma estação, mês e tipo de dia.
let
    Base = fDemandaDia,
    ComCal = Table.NestedJoin(Base, {"Data"}, dCalendario, {"Data"}, "Cal", JoinKind.LeftOuter),
    ExpandeCal = Table.ExpandTableColumn(ComCal, "Cal", {"Mes_Num", "Tipo_Dia"}),
    // média de referência por estação, mês e tipo de dia (só entradas > 0, como na Etapa 1)
    Referencia = Table.Group(ExpandeCal, {"Cod_Estacao", "Mes_Num", "Tipo_Dia"},
        {{"Media_Ref_Mil", each List.Average([Entradas_Mil]), type number}, {"N_Dias_Ref", each Table.RowCount(_), Int64.Type}}),
    Mescla = Table.NestedJoin(ExpandeCal, {"Cod_Estacao", "Mes_Num", "Tipo_Dia"}, Referencia, {"Cod_Estacao", "Mes_Num", "Tipo_Dia"}, "Ref", JoinKind.LeftOuter),
    ExpandeRef = Table.ExpandTableColumn(Mescla, "Ref", {"Media_Ref_Mil", "N_Dias_Ref"}),
    Desvio = Table.AddColumn(ExpandeRef, "Desvio_Pct", each
        if [Media_Ref_Mil] = null or [Media_Ref_Mil] = 0 then null else Number.Round([Entradas_Mil] / [Media_Ref_Mil] - 1, 6), type nullable number),
    Status = Table.AddColumn(Desvio, "Status_Desvio", each
        if [Desvio_Pct] = null then "Sem referência"
        else if [Desvio_Pct] < -pLimiteDesvio then "Queda atípica"
        else if [Desvio_Pct] > pLimiteDesvio then "Alta atípica"
        else "OK", type text),
    Sinais = Table.SelectRows(Status, each [Status_Desvio] = "Queda atípica" or [Status_Desvio] = "Alta atípica"),
    FormatoFinal = Table.SelectColumns(Sinais, {"Data", "Cod_Linha", "Cod_Estacao", "Mes_Num", "Tipo_Dia", "Entradas_Mil", "Media_Ref_Mil", "N_Dias_Ref",
        "Desvio_Pct", "Status_Desvio", "Linha_Origem", "Coluna_Origem"})
in
    FormatoFinal
