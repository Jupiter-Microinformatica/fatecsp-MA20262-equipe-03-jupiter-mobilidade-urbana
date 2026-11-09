// cad_Feriados
// Feriados e dias atípicos (Tab_Feriados da Etapa 1).
let
    Fonte = cad_Etapa1{[Item = "Tab_Feriados", Kind = "Table"]}[Data],
    Tipos = Table.TransformColumns(Fonte, {{"Data", each Date.From(_), type date}, {"Nome", Text.Trim, type text}, {"Esfera", Text.Trim, type text}})
in
    Tipos
