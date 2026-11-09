// cad_Meses
// Meses (Tab_Meses da Etapa 1).
let
    Fonte = cad_Etapa1{[Item = "Tab_Meses", Kind = "Table"]}[Data],
    Tipos = Table.TransformColumnTypes(Fonte, {{"Mes_Num", Int64.Type}, {"Abrev", type text}, {"Nome_Mes", type text}, {"Trimestre", Int64.Type}})
in
    Tipos
