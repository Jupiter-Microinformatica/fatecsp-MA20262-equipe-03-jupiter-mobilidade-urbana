// fLinhaMes
// Fato: entradas, transportados e transferências por linha e mês. Sem as linhas REDE (evita somar duas vezes).
let
    Fonte = cad_Etapa2{[Item = "fLinhaMes", Kind = "Table"]}[Data],
    Tipos = Table.TransformColumnTypes(Fonte, {
        {"Mes_Inicio", type date}, {"Mes_Num", Int64.Type}, {"Cod_Linha", type text},
        {"Entr_Total_Mil", Int64.Type}, {"Entr_MDU_Mil", Int64.Type}, {"Entr_MSA_Mil", Int64.Type}, {"Entr_MDO_Mil", Int64.Type}, {"Entr_MAX_Mil", Int64.Type},
        {"Pass_Total_Mil", Int64.Type}, {"Pass_MDU_Mil", Int64.Type}, {"Pass_MSA_Mil", Int64.Type}, {"Pass_MDO_Mil", Int64.Type}, {"Pass_MAX_Mil", Int64.Type},
        {"Transf_Total_Mil", Int64.Type}, {"Transf_MDU_Mil", Int64.Type}, {"Transf_MSA_Mil", Int64.Type}, {"Transf_MDO_Mil", Int64.Type},
        {"Status_Qualidade", type text}, {"Entr_Linha_Origem", Int64.Type}, {"Pass_Linha_Origem", Int64.Type}}),
    SemRede = Table.SelectRows(Tipos, each [Cod_Linha] <> "REDE")
in
    SemRede
