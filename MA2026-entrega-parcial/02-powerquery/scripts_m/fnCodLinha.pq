// fnCodLinha
// Descobre o código da linha (L1, L2, L3, L15 ou REDE) a partir de um título ou cabeçalho da base.
(texto as nullable text) as nullable text =>
let
    T = if texto = null then "" else Text.Upper(Text.Trim(texto)),
    Achadas = List.Select(Table.ToRecords(cad_Linhas), each Text.Contains(T, Text.Upper([Linha])))
in
    if Text.StartsWith(T, "REDE") then "REDE"
    else if List.IsEmpty(Achadas) then null
    else Achadas{0}[Cod_Linha]
