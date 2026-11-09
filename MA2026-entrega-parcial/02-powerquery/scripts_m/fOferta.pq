// fOferta
// Intervalo mínimo entre trens (s) e velocidade comercial (km/h) por linha e mês.
let
    Origem = stg_Oferta_Bruto,
    ComValor = Table.AddColumn(Origem, "Valor", each fnNumero([Valor_Texto]), type nullable number),
    Sel = Table.SelectColumns(ComValor, {"Cod_Linha", "Mes_Abrev", "Metrica", "Valor"}),
    Pivotada = Table.Pivot(Sel, List.Distinct(Sel[Metrica]), "Metrica", "Valor"),
    ComMes = Table.AddColumn(Pivotada, "Mes_Num", each List.PositionOf(lst_MesesAbrev, Text.Upper([Mes_Abrev])) + 1, Int64.Type),
    ComInicio = Table.AddColumn(ComMes, "Mes_Inicio", each try #date(pAno, [Mes_Num], 1) otherwise null, type nullable date),
    ComStatus = Table.AddColumn(ComInicio, "Status_Qualidade", each
        if [Cod_Linha] = null then "Linha não identificada"
        else if [Intervalo_Min_Seg] = null or [Vel_Comercial_Kmh] = null then "Valor ausente"
        else if [Mes_Inicio] = null then "Mês inválido"
        else "OK", type text),
    FormatoFinal = Table.SelectColumns(ComStatus, {"Mes_Inicio", "Mes_Num", "Cod_Linha", "Intervalo_Min_Seg", "Vel_Comercial_Kmh", "Status_Qualidade"})
in
    FormatoFinal
