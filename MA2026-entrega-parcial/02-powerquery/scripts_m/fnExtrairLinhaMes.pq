// fnExtrairLinhaMes
// Extrai as abas por linha (blocos "Mês | Total | MDU | MSA | MDO | MAX") para formato longo, uma linha por linha e mês.
(raw as table) as table =>
let
    Linhas = Table.ToRecords(raw),
    // posições (linha, coluna) onde aparece o cabeçalho "Mês"
    Cabecalhos = List.Combine(List.Transform(List.Positions(Linhas), (p) =>
        let
            L = Record.ToList(Linhas{p})
        in
            List.Transform(List.Select(List.Positions(L), (c) => fnTxtU(L{c}) = "MÊS"), (c) => {p, c}))),
    Registros = List.Combine(List.Transform(Cabecalhos, (pc) =>
        let
            p = pc{0},
            c = pc{1},
            Titulo = Text.From(Record.ToList(Linhas{p - 1}){c}),
            CodLinha = fnCodLinha(Titulo),
            Meses = Table.FirstN(Table.Skip(raw, p + 1), (r) => List.Contains(lst_MesesAbrev, fnTxtU(Record.ToList(r){c})))
        in
            List.Transform(Table.ToRecords(Meses), (r) =>
                let
                    L = Record.ToList(r)
                in
                    [Linha_Origem = r[Linha_Origem], Coluna_Origem = c + 1, Cod_Linha = CodLinha,
                     Mes_Abrev = fnTxt(L{c}), Total_Texto = fnTxt(L{c + 1}), MDU_Texto = fnTxt(L{c + 2}),
                     MSA_Texto = fnTxt(L{c + 3}), MDO_Texto = fnTxt(L{c + 4}), MAX_Texto = fnTxt(L{c + 5})]))),
    Tabela = Table.FromRecords(Registros)
in
    Tabela
