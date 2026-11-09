// stg_Entr_Estacao_Bruto
// Entradas diárias por estação em formato longo, ainda como texto (uma linha por célula da base).
let
    Raw = fnAba("EntrEstacao"),
    Extraida = fnExtrairDia(Raw),
    ComAba = Table.AddColumn(Extraida, "Aba_Origem", each cad_Abas{[Chave = "EntrEstacao"]}[Aba], type text),
    ComMes = Table.AddColumn(ComAba, "Mes_Num", each List.PositionOf(lst_MesesAbrev, Text.Upper([Mes_Abrev])) + 1, Int64.Type),
    Tipos = Table.TransformColumnTypes(ComMes, {{"Linha_Origem", Int64.Type}, {"Coluna_Origem", Int64.Type}}),
    Ordem = Table.SelectColumns(Tipos, {"Aba_Origem", "Linha_Origem", "Coluna_Origem", "Mes_Abrev", "Mes_Num", "Ano_Titulo",
        "Dia_Bruto", "Cod_Linha", "Sigla_Bruto", "Entrada_Texto"})
in
    Ordem
