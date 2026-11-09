// cad_DeParaEstacao
// De-para de nomes de estação (Tab_DePara_Estacao da Etapa 1) com chaves em MAIÚSCULAS.
let
    Fonte = cad_Etapa1{[Item = "Tab_DePara_Estacao", Kind = "Table"]}[Data],
    SoDigitadas = Table.SelectColumns(Fonte, {"Nome_Origem", "Cod_Linha", "Sigla_Origem"}),
    Tipos = Table.TransformColumnTypes(SoDigitadas, {{"Nome_Origem", type text}, {"Cod_Linha", type text}, {"Sigla_Origem", type text}}),
    ComNome = Table.AddColumn(Tipos, "Chave_Nome", each [Cod_Linha] & "|" & Text.Upper(Text.Trim([Nome_Origem])), type text),
    ComCod = Table.AddColumn(ComNome, "Cod_Estacao", each [Cod_Linha] & "-" & Text.Trim([Sigla_Origem]), type text)
in
    ComCod
