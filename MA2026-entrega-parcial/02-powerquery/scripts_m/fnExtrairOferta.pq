// fnExtrairOferta
// Extrai a aba de oferta (intervalo mínimo e velocidade comercial) para formato longo.
(raw as table) as table =>
let
    Linhas = Table.ToRecords(raw),
    Cabecalhos = List.Select(List.Positions(Linhas), (p) => fnTxtU(Record.ToList(Linhas{p}){0}) = "MÊS"),
    Registros = List.Combine(List.Transform(Cabecalhos, (p) =>
        let
            LCab = Record.ToList(Linhas{p}),
            TituloBloco = Text.Upper(Text.From(Record.ToList(Linhas{p - 1}){0})),
            MetricaBloco = if Text.Contains(TituloBloco, "INTERVALO") then "Intervalo_Min_Seg"
                           else if Text.Contains(TituloBloco, "VELOCIDADE") then "Vel_Comercial_Kmh"
                           else "Desconhecida",
            ColsLinha = List.Select(List.Positions(LCab), (c) => c > 0 and fnCodLinha(fnTxt(LCab{c})) <> null),
            Meses = Table.FirstN(Table.Skip(raw, p + 1), (r) => List.Contains(lst_MesesAbrev, fnTxtU(Record.ToList(r){0})))
        in
            List.Combine(List.Transform(Table.ToRecords(Meses), (r) =>
                let
                    L = Record.ToList(r)
                in
                    List.Transform(ColsLinha, (c) =>
                        [Linha_Origem = r[Linha_Origem], Coluna_Origem = c + 1, Cod_Linha = fnCodLinha(fnTxt(LCab{c})),
                         Mes_Abrev = fnTxt(L{0}), Metrica = MetricaBloco, Valor_Texto = fnTxt(L{c})])))
    )),
    Tabela = Table.FromRecords(Registros)
in
    Tabela
