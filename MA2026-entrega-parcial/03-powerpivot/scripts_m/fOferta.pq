// fOferta
// Fato: intervalo mínimo entre trens e velocidade comercial por linha e mês.
let
    Fonte = cad_Etapa2{[Item = "fOferta", Kind = "Table"]}[Data],
    Tipos = Table.TransformColumnTypes(Fonte, {
        {"Mes_Inicio", type date}, {"Mes_Num", Int64.Type}, {"Cod_Linha", type text},
        {"Intervalo_Min_Seg", type number}, {"Vel_Comercial_Kmh", type number}, {"Status_Qualidade", type text}})
in
    Tipos
