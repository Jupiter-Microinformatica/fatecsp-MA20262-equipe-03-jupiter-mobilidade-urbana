// lst_MesesAbrev
// Lista das abreviações de mês em MAIÚSCULAS (JAN ... DEZ).
List.Buffer(List.Transform(cad_Meses[Abrev], Text.Upper))
