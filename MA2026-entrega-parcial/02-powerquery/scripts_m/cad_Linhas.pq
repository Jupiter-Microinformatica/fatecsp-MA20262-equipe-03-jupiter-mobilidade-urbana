// cad_Linhas
// Linhas do Metrô (Tab_Linhas da Etapa 1).
let
    Fonte = cad_Etapa1{[Item = "Tab_Linhas", Kind = "Table"]}[Data],
    Tipos = Table.TransformColumnTypes(Fonte, {{"Cod_Linha", type text}, {"Linha", type text}, {"Cor", type text},
        {"Inicio_Operacao", Int64.Type}, {"Estacoes_Linha", Int64.Type}, {"Extensao_Km", type number}, {"Vel_Max_Kmh", Int64.Type}})
in
    Tipos
