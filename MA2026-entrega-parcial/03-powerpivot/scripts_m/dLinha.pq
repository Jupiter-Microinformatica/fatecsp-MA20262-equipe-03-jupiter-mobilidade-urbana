// dLinha
// Dimensão de linhas (PK Cod_Linha). Numero_Linha serve para ordenar L1, L2, L3, L15.
let
    Fonte = cad_Etapa2{[Item = "dLinha", Kind = "Table"]}[Data],
    Tipos = Table.TransformColumnTypes(Fonte, {
        {"Cod_Linha", type text}, {"Linha", type text}, {"Cor", type text}, {"Inicio_Operacao", Int64.Type},
        {"Estacoes_Linha", Int64.Type}, {"Extensao_Km", type number}, {"Vel_Max_Kmh", Int64.Type}}),
    Numero = Table.AddColumn(Tipos, "Numero_Linha", each Number.From(Text.AfterDelimiter([Cod_Linha], "L")), Int64.Type)
in
    Numero
