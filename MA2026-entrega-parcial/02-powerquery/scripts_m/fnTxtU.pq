// fnTxtU
// Texto aparado em MAIÚSCULAS; nulo vira "" (para comparações).
(v as any) as text =>
if v = null then "" else Text.Upper(Text.Trim(Text.From(v)))
