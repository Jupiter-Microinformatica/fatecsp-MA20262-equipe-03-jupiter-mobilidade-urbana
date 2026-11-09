// fnExtrairDia
// Percorre a aba de entradas por estação: acha cada cabeçalho "DIA" e junta os blocos de todos os meses e linhas.
(raw as table) as table =>
let
    Col1 = Table.Column(raw, "Column1"),
    Cabecalhos = List.Select(List.Positions(Col1), (p) => fnTxtU(Col1{p}) = "DIA"),
    Registros = List.Combine(List.Transform(Cabecalhos, (p) => fnBlocoDia(raw, p)))
in
    Table.FromRecords(Registros)
