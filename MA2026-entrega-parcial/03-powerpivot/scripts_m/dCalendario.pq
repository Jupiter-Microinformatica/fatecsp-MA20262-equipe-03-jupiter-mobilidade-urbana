// dCalendario
// Dimensão de datas (365 dias, contínua), lida da Etapa 2, com colunas de ordenação e agrupamento.
let
    Fonte = cad_Etapa2{[Item = "dCalendario", Kind = "Table"]}[Data],
    Tipos = Table.TransformColumnTypes(Fonte, {
        {"Data", type date}, {"Ano", Int64.Type}, {"Mes_Num", Int64.Type}, {"Nome_Mes", type text}, {"Trimestre", Int64.Type},
        {"Mes_Inicio", type date}, {"Dia_Semana_Num", Int64.Type}, {"Dia_Semana", type text}, {"Feriado", type text}, {"Tipo_Dia", type text}}),
    FeriadoSemNulo = Table.TransformColumns(Tipos, {{"Feriado", each if _ = null then "" else _, type text}}),
    NomeMesProprio = Table.TransformColumns(FeriadoSemNulo, {{"Nome_Mes", Text.Proper, type text}}),
    MesAbrev = Table.AddColumn(NomeMesProprio, "Mes_Abrev", each Text.Start([Nome_Mes], 3), type text),
    AnoMes = Table.AddColumn(MesAbrev, "AnoMes", each Date.ToText([Data], "yyyy-MM"), type text),
    TrimTxt = Table.AddColumn(AnoMes, "Trimestre_Txt", each "T" & Text.From([Trimestre]), type text),
    FimDeSemana = Table.AddColumn(TrimTxt, "FimDeSemana", each if [Dia_Semana_Num] >= 6 then "Sim" else "Não", type text),
    EhFeriado = Table.AddColumn(FimDeSemana, "Eh_Feriado", each if [Feriado] <> "" then "Sim" else "Não", type text),
    TipoOrdem = Table.AddColumn(EhFeriado, "Tipo_Dia_Ordem", each
        if [Tipo_Dia] = "Dia útil" then 1 else if [Tipo_Dia] = "Sábado" then 2 else if [Tipo_Dia] = "Domingo" then 3 else 4, Int64.Type)
in
    TipoOrdem
