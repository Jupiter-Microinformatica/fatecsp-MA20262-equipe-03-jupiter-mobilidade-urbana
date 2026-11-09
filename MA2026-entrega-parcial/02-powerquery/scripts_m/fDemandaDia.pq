// fDemandaDia
// Fato principal: entradas (mil) por estação e dia. Só medidas válidas (> 0); o resto vai para Rejeitados.
let
    Origem = stg_Entr_Estacao_Bruto,
    // ---------- chave, data e valor (tudo calculado a partir dos textos originais) ----------
    ComChave = Table.AddColumn(Origem, "Cod_Estacao", each
        if [Cod_Linha] = null or [Sigla_Bruto] = null then null else [Cod_Linha] & "-" & [Sigla_Bruto], type text),
    ComData = Table.AddColumn(ComChave, "Data", each
        try #date(Number.From([Ano_Titulo]), [Mes_Num], Number.From([Dia_Bruto])) otherwise null, type nullable date),
    ComValor = Table.AddColumn(ComData, "Entradas_Mil", each fnNumero([Entrada_Texto]), type nullable number),
    // ---------- filtros, na mesma ordem do diagnóstico de Rejeitados ----------
    ComLinhaIdentificada = Table.SelectRows(ComValor, each [Cod_Linha] <> null),
    SemEntradaVazia = Table.SelectRows(ComLinhaIdentificada, each [Entrada_Texto] <> null and [Entrada_Texto] <> ""),
    SemTraco = Table.SelectRows(SemEntradaVazia, each [Entrada_Texto] <> "-"),
    SemValorInvalido = Table.SelectRows(SemTraco, each [Entradas_Mil] <> null),
    SoPositivas = Table.SelectRows(SemValorInvalido, each [Entradas_Mil] > 0),
    SemDataInvalida = Table.SelectRows(SoPositivas, each [Data] <> null),
    NoPeriodo = Table.SelectRows(SemDataInvalida, each [Data] >= pDataInicio and [Data] <= pDataFim),
    Chaves = List.Buffer(cad_Estacoes[Cod_Estacao]),
    ComCadastro = Table.SelectRows(NoPeriodo, each List.Contains(Chaves, [Cod_Estacao])),
    // ---------- duplicidade: uma estação só pode ter um valor por dia ----------
    OrdemOriginal = Table.Buffer(Table.Sort(ComCadastro, {{"Linha_Origem", Order.Ascending}, {"Coluna_Origem", Order.Ascending}})),
    SemDuplicatas = Table.Distinct(OrdemOriginal, {"Data", "Cod_Estacao"}),
    FormatoFinal = Table.SelectColumns(SemDuplicatas, {"Data", "Cod_Linha", "Cod_Estacao", "Entradas_Mil", "Aba_Origem", "Linha_Origem", "Coluna_Origem"}),
    Tipos = Table.TransformColumnTypes(FormatoFinal, {{"Data", type date}, {"Cod_Linha", type text}, {"Cod_Estacao", type text}, {"Entradas_Mil", type number}})
in
    Tipos
