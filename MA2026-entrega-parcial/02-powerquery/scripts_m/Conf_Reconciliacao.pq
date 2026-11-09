// Conf_Reconciliacao
// Prova de que nenhuma linha se perdeu: lidas - aceitas - rejeitadas = 0.
let
    Lidas = Table.RowCount(stg_Entr_Estacao_Bruto),
    Aceitas = Table.RowCount(fDemandaDia),
    Rejeitadas = Table.RowCount(Rejeitados),
    Resultado = #table(type table [Indicador = text, Linhas = Int64.Type], {
        {"1. Linhas lidas (entradas por estação, todas as células)", Lidas},
        {"2. Aceitas em fDemandaDia", Aceitas},
        {"3. Registradas em Rejeitados", Rejeitadas},
        {"4. Diferença (1 - 2 - 3): deve ser 0", Lidas - Aceitas - Rejeitadas}})
in
    Resultado
