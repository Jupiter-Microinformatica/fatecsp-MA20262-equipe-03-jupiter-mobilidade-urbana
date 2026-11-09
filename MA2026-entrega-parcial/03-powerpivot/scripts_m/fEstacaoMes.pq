// fEstacaoMes
// Fato: passageiros por estação e mês (média de dias úteis, mil).
let
    Fonte = cad_Etapa2{[Item = "fEstacaoMes", Kind = "Table"]}[Data],
    Tipos = Table.TransformColumnTypes(Fonte, {
        {"Mes_Inicio", type date}, {"Mes_Num", Int64.Type}, {"Cod_Estacao", type text},
        {"Passageiros_MDU_Mil", Currency.Type}, {"Status_Qualidade", type text}, {"Aba_Origem", type text},
        {"Linha_Origem", Int64.Type}, {"Coluna_Origem", Int64.Type}})
in
    Tipos
