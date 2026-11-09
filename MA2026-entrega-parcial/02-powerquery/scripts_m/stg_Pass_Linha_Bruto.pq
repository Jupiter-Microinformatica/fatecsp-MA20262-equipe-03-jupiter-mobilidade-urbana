// stg_Pass_Linha_Bruto
// Passageiros transportados por linha e mês, em texto.
let
    Raw = fnAba("PassLinha"),
    Extraida = fnExtrairLinhaMes(Raw)
in
    Extraida
