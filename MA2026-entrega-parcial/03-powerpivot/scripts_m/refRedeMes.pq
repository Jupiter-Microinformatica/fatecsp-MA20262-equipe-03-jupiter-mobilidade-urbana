// refRedeMes
// Totais oficiais da REDE por mês. Fora da estrela (sem relacionamento): só para conferir a soma das linhas.
let
    Fonte = cad_Etapa2{[Item = "fLinhaMes", Kind = "Table"]}[Data],
    Tipos = Table.TransformColumnTypes(Fonte, {
        {"Mes_Inicio", type date}, {"Mes_Num", Int64.Type}, {"Cod_Linha", type text},
        {"Entr_Total_Mil", Int64.Type}, {"Entr_MDU_Mil", Int64.Type}, {"Pass_Total_Mil", Int64.Type}, {"Pass_MDU_Mil", Int64.Type},
        {"Transf_Total_Mil", Int64.Type}, {"Transf_MDU_Mil", Int64.Type}}),
    SoRede = Table.SelectRows(Tipos, each [Cod_Linha] = "REDE"),
    Colunas = Table.SelectColumns(SoRede, {"Mes_Inicio", "Mes_Num", "Cod_Linha", "Entr_Total_Mil", "Entr_MDU_Mil", "Pass_Total_Mil", "Pass_MDU_Mil", "Transf_Total_Mil", "Transf_MDU_Mil"})
in
    Colunas
