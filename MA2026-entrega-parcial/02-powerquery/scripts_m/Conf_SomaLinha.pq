// Conf_SomaLinha
// Soma das estações e média de dias úteis recalculadas contra os totais oficiais por linha e mês.
let
    Diario = Table.Group(fDemandaDia, {"Data", "Cod_Linha"}, {{"Entradas_Mil", each List.Sum([Entradas_Mil]), type number}}),
    DiarioRede = Table.AddColumn(Table.Group(fDemandaDia, {"Data"}, {{"Entradas_Mil", each List.Sum([Entradas_Mil]), type number}}), "Cod_Linha", each "REDE", type text),
    Todos = Table.Combine({Diario, DiarioRede}),
    ComCal = Table.NestedJoin(Todos, {"Data"}, dCalendario, {"Data"}, "Cal", JoinKind.LeftOuter),
    ExpandeCal = Table.ExpandTableColumn(ComCal, "Cal", {"Mes_Num", "Tipo_Dia"}),
    Soma = Table.Group(ExpandeCal, {"Cod_Linha", "Mes_Num"}, {{"Soma_Estacoes_Mil", each List.Sum([Entradas_Mil]), type number}}),
    SoUteis = Table.SelectRows(ExpandeCal, each [Tipo_Dia] = "Dia útil"),
    Media = Table.Group(SoUteis, {"Cod_Linha", "Mes_Num"}, {{"MDU_Calc_Mil", each List.Average([Entradas_Mil]), type number}}),
    JuntaMedia = Table.NestedJoin(Soma, {"Cod_Linha", "Mes_Num"}, Media, {"Cod_Linha", "Mes_Num"}, "M", JoinKind.LeftOuter),
    ExpandeMedia = Table.ExpandTableColumn(JuntaMedia, "M", {"MDU_Calc_Mil"}),
    JuntaOficial = Table.NestedJoin(ExpandeMedia, {"Cod_Linha", "Mes_Num"}, fLinhaMes, {"Cod_Linha", "Mes_Num"}, "O", JoinKind.LeftOuter),
    ExpandeOficial = Table.ExpandTableColumn(JuntaOficial, "O", {"Entr_Total_Mil", "Entr_MDU_Mil"}),
    DifSoma = Table.AddColumn(ExpandeOficial, "Dif_Soma_Mil", each [Soma_Estacoes_Mil] - [Entr_Total_Mil], type number),
    StatusSoma = Table.AddColumn(DifSoma, "Status_Soma", each if Number.Abs([Dif_Soma_Mil]) <= pTolSomaMil then "OK" else "Soma divergente", type text),
    DifMDU = Table.AddColumn(StatusSoma, "Dif_MDU_Pct", each [MDU_Calc_Mil] / [Entr_MDU_Mil] - 1, type number),
    StatusMDU = Table.AddColumn(DifMDU, "Status_MDU", each if Number.Abs([Dif_MDU_Pct]) <= pTolMDU then "OK" else "MDU divergente", type text),
    Ordenada = Table.Sort(StatusMDU, {{"Cod_Linha", Order.Ascending}, {"Mes_Num", Order.Ascending}})
in
    Ordenada
