// fAnomalias
// Fato: sinais indiretos de falha (quedas e altas atípicas).
let
    Fonte = cad_Etapa2{[Item = "fAnomalias", Kind = "Table"]}[Data],
    Tipos = Table.TransformColumnTypes(Fonte, {
        {"Data", type date}, {"Cod_Linha", type text}, {"Cod_Estacao", type text}, {"Mes_Num", Int64.Type}, {"Tipo_Dia", type text},
        {"Entradas_Mil", Currency.Type}, {"Media_Ref_Mil", type number}, {"N_Dias_Ref", Int64.Type}, {"Desvio_Pct", type number},
        {"Status_Desvio", type text}, {"Linha_Origem", Int64.Type}, {"Coluna_Origem", Int64.Type}})
in
    Tipos
