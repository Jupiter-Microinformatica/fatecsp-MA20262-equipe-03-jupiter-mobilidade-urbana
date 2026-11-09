// cad_Estacoes
// Estações por linha (Tab_Estacoes da Etapa 1). Só lê as colunas digitadas e refaz as colunas de fórmula.
let
    Fonte = cad_Etapa1{[Item = "Tab_Estacoes", Kind = "Table"]}[Data],
    SoDigitadas = Table.SelectColumns(Fonte, {"Cod_Linha", "Sigla", "Estacao", "Ordem_Fonte", "Transf_Interna", "Linha_Transf_Interna",
        "Integra_CPTM", "Integra_L4", "Integra_L5", "Primeira_Ocorrencia", "Perfil_Hipotese"}),
    Tipos = Table.TransformColumnTypes(SoDigitadas, {{"Cod_Linha", type text}, {"Sigla", type text}, {"Estacao", type text},
        {"Ordem_Fonte", Int64.Type}, {"Transf_Interna", type text}, {"Linha_Transf_Interna", type text}, {"Integra_CPTM", type text},
        {"Integra_L4", type text}, {"Integra_L5", type text}, {"Primeira_Ocorrencia", type text}, {"Perfil_Hipotese", type text}}),
    ComChave = Table.AddColumn(Tipos, "Cod_Estacao", each [Cod_Linha] & "-" & [Sigla], type text),
    ComTipo = Table.AddColumn(ComChave, "Tipo_Integracao", each
        if [Transf_Interna] = "Sim" then "Interna Metrô"
        else if [Integra_CPTM] = "Sim" or [Integra_L4] = "Sim" or [Integra_L5] = "Sim" then "Externa (CPTM/L4/L5)"
        else "Sem transferência", type text)
in
    ComTipo
