// fnBlocoDia
// Extrai UM bloco mensal da aba de entradas por estação (largo -> longo), uma linha por estação e dia.
(raw as table, p as number) as list =>
let
    LinhaCab = Record.ToList(raw{p}),
    LinhaTit = Record.ToList(raw{p - 1}),
    PosDia = List.Select(List.Positions(LinhaCab), (c) => fnTxtU(LinhaCab{c}) = "DIA"),
    Dias = Table.FirstN(Table.Skip(raw, p + 1), (r) => fnTxtU(r[Column1]) <> "TOTAL"),
    DiasValidos = Table.ToRecords(Table.SelectRows(Dias, (r) => (try Number.From(fnTxt(r[Column1])) otherwise null) <> null)),
    PorLinha = List.Transform(PosDia, (d) =>
        let
            TituloL = Text.From(LinhaTit{d}),
            MesAno = Text.BeforeDelimiter(Text.AfterDelimiter(TituloL, " - ", {0, RelativePosition.FromEnd}), " "),
            CodLinha = fnCodLinha(TituloL),
            Resto = List.Skip(LinhaCab, d + 1),
            PosTotal = List.PositionOf(List.Transform(Resto, fnTxtU), "TOTAL"),
            Estacoes = if PosTotal < 0 then {} else List.FirstN(Resto, PosTotal)
        in
            List.Combine(List.Transform(DiasValidos, (r) =>
                let
                    L = Record.ToList(r)
                in
                    List.Transform(List.Positions(Estacoes), (i) =>
                        [Linha_Origem = r[Linha_Origem], Coluna_Origem = d + 2 + i,
                         Mes_Abrev = Text.Start(MesAno, 3), Ano_Titulo = Text.End(MesAno, 4),
                         Dia_Bruto = fnTxt(r[Column1]), Cod_Linha = CodLinha,
                         Sigla_Bruto = fnTxt(Estacoes{i}), Entrada_Texto = fnTxt(L{d + 1 + i})])))
    )
in
    List.Combine(PorLinha)
