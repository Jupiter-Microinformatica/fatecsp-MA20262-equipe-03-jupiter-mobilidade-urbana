// fLinhaMes
// Entradas, passageiros transportados e transferências por linha (e rede) e mês, em mil.
let
    Entr = fnLinhaMesNum(stg_Entr_Linha_Bruto, "Entr"),
    Pass = fnLinhaMesNum(stg_Pass_Linha_Bruto, "Pass"),
    Mescla = Table.NestedJoin(Entr, {"Cod_Linha", "Mes_Abrev"}, Pass, {"Cod_Linha", "Mes_Abrev"}, "P", JoinKind.LeftOuter),
    ExpandePass = Table.ExpandTableColumn(Mescla, "P", {"Pass_Linha_Origem", "Pass_Total_Mil", "Pass_MDU_Mil", "Pass_MSA_Mil", "Pass_MDO_Mil", "Pass_MAX_Mil"}),
    ComMes = Table.AddColumn(ExpandePass, "Mes_Num", each List.PositionOf(lst_MesesAbrev, Text.Upper([Mes_Abrev])) + 1, Int64.Type),
    ComInicio = Table.AddColumn(ComMes, "Mes_Inicio", each try #date(pAno, [Mes_Num], 1) otherwise null, type nullable date),
    // transferência entre linhas = passageiros transportados - entradas (mesma lógica da Etapa 1)
    TransfTotal = Table.AddColumn(ComInicio, "Transf_Total_Mil", each if [Pass_Total_Mil] = null or [Entr_Total_Mil] = null then null else [Pass_Total_Mil] - [Entr_Total_Mil], type nullable number),
    TransfMDU = Table.AddColumn(TransfTotal, "Transf_MDU_Mil", each if [Pass_MDU_Mil] = null or [Entr_MDU_Mil] = null then null else [Pass_MDU_Mil] - [Entr_MDU_Mil], type nullable number),
    TransfMSA = Table.AddColumn(TransfMDU, "Transf_MSA_Mil", each if [Pass_MSA_Mil] = null or [Entr_MSA_Mil] = null then null else [Pass_MSA_Mil] - [Entr_MSA_Mil], type nullable number),
    TransfMDO = Table.AddColumn(TransfMSA, "Transf_MDO_Mil", each if [Pass_MDO_Mil] = null or [Entr_MDO_Mil] = null then null else [Pass_MDO_Mil] - [Entr_MDO_Mil], type nullable number),
    ComStatus = Table.AddColumn(TransfMDO, "Status_Qualidade", each
        if [Cod_Linha] = null then "Linha não identificada"
        else if [Pass_Total_Mil] = null or [Entr_Total_Mil] = null then "Valor ausente"
        else if [Mes_Inicio] = null then "Mês inválido"
        else "OK", type text),
    FormatoFinal = Table.SelectColumns(ComStatus, {"Mes_Inicio", "Mes_Num", "Cod_Linha",
        "Entr_Total_Mil", "Entr_MDU_Mil", "Entr_MSA_Mil", "Entr_MDO_Mil", "Entr_MAX_Mil",
        "Pass_Total_Mil", "Pass_MDU_Mil", "Pass_MSA_Mil", "Pass_MDO_Mil", "Pass_MAX_Mil",
        "Transf_Total_Mil", "Transf_MDU_Mil", "Transf_MSA_Mil", "Transf_MDO_Mil", "Status_Qualidade", "Entr_Linha_Origem", "Pass_Linha_Origem"})
in
    FormatoFinal
