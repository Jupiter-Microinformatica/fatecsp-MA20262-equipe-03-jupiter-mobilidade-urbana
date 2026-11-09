// dCalendario
// Dimensão de datas, gerada pelo período dos parâmetros, com feriados e tipo de dia.
let
    FerData = List.Buffer(cad_Feriados[Data]),
    FerNome = List.Buffer(cad_Feriados[Nome]),
    NomesDia = {"segunda-feira", "terça-feira", "quarta-feira", "quinta-feira", "sexta-feira", "sábado", "domingo"},
    Dias = List.Dates(pDataInicio, Duration.Days(pDataFim - pDataInicio) + 1, #duration(1, 0, 0, 0)),
    Tabela = Table.FromList(Dias, Splitter.SplitByNothing(), {"Data"}, null, ExtraValues.Error),
    ComAno = Table.AddColumn(Tabela, "Ano", each Date.Year([Data]), Int64.Type),
    ComMes = Table.AddColumn(ComAno, "Mes_Num", each Date.Month([Data]), Int64.Type),
    ComNomeMes = Table.AddColumn(ComMes, "Nome_Mes", each cad_Meses[Nome_Mes]{[Mes_Num] - 1}, type text),
    ComTri = Table.AddColumn(ComNomeMes, "Trimestre", each Number.RoundUp([Mes_Num] / 3), Int64.Type),
    ComInicio = Table.AddColumn(ComTri, "Mes_Inicio", each Date.StartOfMonth([Data]), type date),
    ComDiaNum = Table.AddColumn(ComInicio, "Dia_Semana_Num", each Date.DayOfWeek([Data], Day.Monday) + 1, Int64.Type),
    ComDiaNome = Table.AddColumn(ComDiaNum, "Dia_Semana", each NomesDia{[Dia_Semana_Num] - 1}, type text),
    ComFeriado = Table.AddColumn(ComDiaNome, "Feriado", each
        let pos = List.PositionOf(FerData, [Data]) in if pos < 0 then "" else FerNome{pos}, type text),
    ComTipo = Table.AddColumn(ComFeriado, "Tipo_Dia", each
        if [Feriado] <> "" then "Feriado"
        else if [Dia_Semana_Num] = 7 then "Domingo"
        else if [Dia_Semana_Num] = 6 then "Sábado"
        else "Dia útil", type text),
    Tipos = Table.TransformColumnTypes(ComTipo, {{"Data", type date}})
in
    Tipos
