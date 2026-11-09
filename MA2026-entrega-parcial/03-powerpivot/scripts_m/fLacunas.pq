// fLacunas
// Fato: estação-dias sem medição (vazio, traço ou zero), tirados de Rejeitados.
let
    Fonte = cad_Etapa2{[Item = "Rejeitados", Kind = "Table"]}[Data],
    Tipos = Table.TransformColumnTypes(Fonte, {
        {"Aba_Origem", type text}, {"Linha_Origem", Int64.Type}, {"Coluna_Origem", Int64.Type}, {"Data", type date},
        {"Cod_Estacao", type text}, {"Entrada_Texto", type text}, {"Motivo", type text}}),
    SoLacunas = Table.SelectRows(Tipos, each List.Contains({"Entrada vazia", "Entrada com traço", "Entrada zero"}, [Motivo])
        and [Data] <> null and [Cod_Estacao] <> null),
    Colunas = Table.SelectColumns(SoLacunas, {"Data", "Cod_Estacao", "Motivo", "Entrada_Texto", "Linha_Origem", "Coluna_Origem"})
in
    Colunas
