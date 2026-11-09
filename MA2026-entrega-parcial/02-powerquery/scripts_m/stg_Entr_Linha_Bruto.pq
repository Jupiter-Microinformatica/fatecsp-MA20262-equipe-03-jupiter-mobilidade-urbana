// stg_Entr_Linha_Bruto
// Entradas por linha e mês, em texto.
let
    Raw = fnAba("EntrLinha"),
    Extraida = fnExtrairLinhaMes(Raw)
in
    Extraida
