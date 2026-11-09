// fnNumero
// Converte texto brasileiro em número ("46,2" e "18.128"), sem depender da localidade. Vazio, "-" e texto inválido viram null.
(texto as any) as nullable number =>
let
    T = fnTxt(texto)
in
    if T = null or T = "" or T = "-" then null
    else try Number.FromText(Text.Replace(Text.Replace(T, ".", ""), ",", "."), "en-US") otherwise null
