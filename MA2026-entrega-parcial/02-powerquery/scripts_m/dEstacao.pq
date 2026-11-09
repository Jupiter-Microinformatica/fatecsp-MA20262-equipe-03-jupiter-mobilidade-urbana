// dEstacao
// Dimensão de estações (chave Cod_Estacao = Linha-Sigla).
let
    Origem = cad_Estacoes,
    Final = Table.SelectColumns(Origem, {"Cod_Estacao", "Cod_Linha", "Sigla", "Estacao", "Ordem_Fonte", "Tipo_Integracao", "Transf_Interna",
        "Linha_Transf_Interna", "Integra_CPTM", "Integra_L4", "Integra_L5", "Primeira_Ocorrencia", "Perfil_Hipotese"})
in
    Final
