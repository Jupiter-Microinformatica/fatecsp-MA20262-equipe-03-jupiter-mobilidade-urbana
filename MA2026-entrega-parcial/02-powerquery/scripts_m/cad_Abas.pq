// cad_Abas
// De-para das abas da base bruta: nome lógico -> nome da aba. Em outro ano, só esta tabela muda.
let
    Tabela = #table(type table [Chave = text, Aba = text], {
        {"EntrEstacao", "Entr. p. Estação 2025"},
        {"PassEstacao", "Pass. p. Estação 2025"},
        {"EntrLinha", "Entr. p. Linha 2025"},
        {"PassLinha", "Pass. p. Linha 2025"},
        {"Oferta", "Oferta - 2025"}
    })
in
    Tabela
