// fnAba
// Lê uma aba da base bruta (sem cabeçalho) e numera as linhas: Linha_Origem = número da linha no Excel.
(chave as text) as table =>
let
    NomeAba = cad_Abas{[Chave = chave]}[Aba],
    Fonte = Excel.Workbook(File.Contents(pArquivoBase), null, true),
    Dados = Fonte{[Item = NomeAba, Kind = "Sheet"]}[Data],
    ComLinha = Table.AddIndexColumn(Dados, "Linha_Origem", 1, 1, Int64.Type)
in
    ComLinha
