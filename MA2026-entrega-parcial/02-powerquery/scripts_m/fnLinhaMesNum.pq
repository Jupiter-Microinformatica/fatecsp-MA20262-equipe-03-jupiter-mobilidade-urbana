// fnLinhaMesNum
// Converte para número as cinco métricas de uma aba por linha e prefixa os nomes (Entr_ ou Pass_).
(tab as table, prefixo as text) as table =>
let
    Num = Table.TransformColumns(tab, {{"Total_Texto", fnNumero}, {"MDU_Texto", fnNumero}, {"MSA_Texto", fnNumero}, {"MDO_Texto", fnNumero}, {"MAX_Texto", fnNumero}}),
    Ren = Table.RenameColumns(Num, {{"Linha_Origem", prefixo & "_Linha_Origem"}, {"Total_Texto", prefixo & "_Total_Mil"},
        {"MDU_Texto", prefixo & "_MDU_Mil"}, {"MSA_Texto", prefixo & "_MSA_Mil"}, {"MDO_Texto", prefixo & "_MDO_Mil"}, {"MAX_Texto", prefixo & "_MAX_Mil"}}),
    Sel = Table.SelectColumns(Ren, {"Cod_Linha", "Mes_Abrev", prefixo & "_Linha_Origem", prefixo & "_Total_Mil", prefixo & "_MDU_Mil",
        prefixo & "_MSA_Mil", prefixo & "_MDO_Mil", prefixo & "_MAX_Mil"})
in
    Sel
