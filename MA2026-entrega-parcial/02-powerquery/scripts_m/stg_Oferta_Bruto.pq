// stg_Oferta_Bruto
// Oferta (intervalo e velocidade) em formato longo, em texto.
let
    Raw = fnAba("Oferta"),
    Extraida = fnExtrairOferta(Raw)
in
    Extraida
