// fDemandaDia
// Fato principal: entradas (mil) por estação e dia.
let
    Fonte = cad_Etapa2{[Item = "fDemandaDia", Kind = "Table"]}[Data],
    Tipos = Table.TransformColumnTypes(Fonte, {
        {"Data", type date}, {"Cod_Linha", type text}, {"Cod_Estacao", type text},
        {"Entradas_Mil", Currency.Type}, {"Aba_Origem", type text},
        {"Linha_Origem", Int64.Type}, {"Coluna_Origem", Int64.Type}})
in
    Tipos
