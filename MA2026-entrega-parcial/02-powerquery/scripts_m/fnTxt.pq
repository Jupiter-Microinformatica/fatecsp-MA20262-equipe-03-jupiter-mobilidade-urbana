// fnTxt
// Texto aparado (Text.Trim); nulo continua nulo.
(v as any) as nullable text =>
if v = null then null else Text.Trim(Text.From(v))
