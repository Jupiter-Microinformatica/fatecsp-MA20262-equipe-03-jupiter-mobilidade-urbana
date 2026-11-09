// stg_Pass_Estacao_Bruto
// Passageiros por estação (média de dias úteis) em formato longo, ainda como texto.
let
    Raw = fnAba("PassEstacao"),
    Extraida = fnExtrairPassEstacao(Raw),
    ComAba = Table.AddColumn(Extraida, "Aba_Origem", each cad_Abas{[Chave = "PassEstacao"]}[Aba], type text),
    Tipos = Table.TransformColumnTypes(ComAba, {{"Linha_Origem", Int64.Type}, {"Coluna_Origem", Int64.Type}})
in
    Tipos
