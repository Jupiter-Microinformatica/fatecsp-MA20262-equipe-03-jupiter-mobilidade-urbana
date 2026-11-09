// dEstacao
// Dimensão de estações (PK Cod_Estacao = Linha-Sigla).
let
    Fonte = cad_Etapa2{[Item = "dEstacao", Kind = "Table"]}[Data],
    Tipos = Table.TransformColumnTypes(Fonte, {
        {"Cod_Estacao", type text}, {"Cod_Linha", type text}, {"Sigla", type text}, {"Estacao", type text}, {"Ordem_Fonte", Int64.Type},
        {"Tipo_Integracao", type text}, {"Transf_Interna", type text}, {"Linha_Transf_Interna", type text},
        {"Integra_CPTM", type text}, {"Integra_L4", type text}, {"Integra_L5", type text},
        {"Primeira_Ocorrencia", type text}, {"Perfil_Hipotese", type text}})
in
    Tipos
