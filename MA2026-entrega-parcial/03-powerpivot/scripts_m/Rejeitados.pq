// Rejeitados
// Auditoria (fora da estrela): linhas lidas e descartadas, com o motivo. Tudo como texto.
let
    Fonte = cad_Etapa2{[Item = "Rejeitados", Kind = "Table"]}[Data],
    TudoTexto = Table.TransformColumnTypes(Fonte, List.Transform(Table.ColumnNames(Fonte), each {_, type text})),
    Tipos = Table.TransformColumnTypes(TudoTexto, {{"Linha_Origem", Int64.Type}, {"Coluna_Origem", Int64.Type}})
in
    Tipos
