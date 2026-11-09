// fnExtrairPassEstacao
// Extrai a aba de passageiros por estação (um mês por coluna) em formato longo.
(raw as table) as table =>
let
    Col1 = Table.Column(raw, "Column1"),
    Cabecalhos = List.Select(List.Positions(Col1), (p) => fnTxtU(Col1{p}) = "ESTAÇÃO"),
    Registros = List.Combine(List.Transform(Cabecalhos, (p) =>
        let
            LinhaCab = Record.ToList(raw{p}),
            CodLinha = fnCodLinha(Text.From(raw{p - 1}[Column1])),
            PosMeses = List.Select(List.Positions(LinhaCab), (c) => List.Contains(lst_MesesAbrev, fnTxtU(LinhaCab{c}))),
            Estacoes = Table.SelectRows(
                Table.FirstN(Table.Skip(raw, p + 1), (r) => fnTxtU(r[Column1]) <> "TOTAL"),
                (r) => fnTxt(r[Column1]) <> null and fnTxt(r[Column1]) <> "")
        in
            List.Combine(List.Transform(Table.ToRecords(Estacoes), (r) =>
                let
                    L = Record.ToList(r)
                in
                    List.Transform(PosMeses, (c) =>
                        [Linha_Origem = r[Linha_Origem], Coluna_Origem = c + 1, Cod_Linha = CodLinha,
                         Nome_Bruto = Text.From(r[Column1]), Mes_Abrev = fnTxt(LinhaCab{c}),
                         Passageiros_Texto = fnTxt(L{c})])))
    ))
in
    Table.FromRecords(Registros)
