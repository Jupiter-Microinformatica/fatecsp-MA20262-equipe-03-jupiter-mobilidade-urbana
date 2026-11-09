// MetroSP - Etapa 3 (Power Pivot) - medidas preliminares

// ==================== A. Demanda por estação e dia ====================
// Quantos passageiros (em mil) entraram nas estações?  [Formato: Número, 1 casa]
Entradas Mil :=
    SUM ( fDemandaDia[Entradas_Mil] )

// Quantos passageiros entraram (em unidades)? Versão com iterador.  [Formato: Número, inteiro, milhar]
Entradas :=
    SUMX ( fDemandaDia; fDemandaDia[Entradas_Mil] * 1000 )

// Quantas medições (estação x dia) válidas existem?  [Formato: Número, inteiro, milhar]
Estações-Dia :=
    COUNTROWS ( fDemandaDia )

// Em quantos dias distintos há medição?  [Formato: Número, inteiro]
Dias com Medição :=
    DISTINCTCOUNT ( fDemandaDia[Data] )

// Quantas estações-linha têm medição?  [Formato: Número, inteiro]
Estações com Medição :=
    DISTINCTCOUNT ( fDemandaDia[Cod_Estacao] )

// Quanto, em média, uma estação recebe por dia (mil)?  [Formato: Número, 2 casas]
Média por Estação-Dia Mil :=
    DIVIDE ( [Entradas Mil]; [Estações-Dia] )

// Qual a entrada total média por dia no recorte (mil)?  [Formato: Número, 1 casa]
Média Diária Mil :=
    AVERAGEX ( VALUES ( dCalendario[Data] ); [Entradas Mil] )

// Qual a média de dias úteis (MDU), calculada mês a mês e depois promediada (mil)?  [Formato: Número, 1 casa]
Entradas MDU Mil :=
    AVERAGEX (
        VALUES ( dCalendario[Mes_Inicio] );
        CALCULATE ( [Média Diária Mil]; dCalendario[Tipo_Dia] = "Dia útil" )
    )

// Qual foi o dia de maior demanda no recorte (mil)?  [Formato: Número, 1 casa]
Maior Dia Mil :=
    MAXX ( VALUES ( dCalendario[Data] ); [Entradas Mil] )

// Quanto o fim de semana representa de um dia útil? (proxy de uso de lazer)  [Formato: Porcentagem, 1 casa]
Razão FDS / Dia Útil :=
    DIVIDE (
        CALCULATE ( [Média Diária Mil]; dCalendario[Tipo_Dia] IN { "Sábado"; "Domingo" } );
        CALCULATE ( [Média Diária Mil]; dCalendario[Tipo_Dia] = "Dia útil" )
    )

// Qual a posição da estação (pelo nome) em entradas?  [Formato: Número, inteiro]
Ranking Estação :=
    IF (
        HASONEVALUE ( dEstacao[Estacao] );
        RANKX ( ALLSELECTED ( dEstacao[Estacao] ); [Entradas Mil] )
    )

// A média de dias úteis cresceu ou caiu em relação ao mês anterior?  [Formato: Porcentagem, 1 casa]
Cresc. MoM % (MDU) :=
    VAR Atual = [Entradas MDU Mil]
    VAR Anterior =
        CALCULATE ( [Entradas MDU Mil]; DATEADD ( dCalendario[Data]; -1; MONTH ) )
    RETURN
        IF ( NOT ISBLANK ( Atual ); DIVIDE ( Atual - Anterior; Anterior ) )


// ==================== B. Linhas e transferências ====================
// Quantos passageiros foram transportados (inclui transferências, em mil)?  [Formato: Número, inteiro, milhar]
Passageiros Transportados Mil :=
    SUM ( fLinhaMes[Pass_Total_Mil] )

// Quantas entradas a fonte oficial informa por linha (mil)?  [Formato: Número, inteiro, milhar]
Entradas Oficiais Mil :=
    SUM ( fLinhaMes[Entr_Total_Mil] )

// Quantas transferências entre linhas ocorreram (transportados - entradas, mil)?  [Formato: Número, inteiro, milhar]
Transferências Mil :=
    SUM ( fLinhaMes[Transf_Total_Mil] )

// Que parte dos passageiros transportados é transferência?  [Formato: Porcentagem, 1 casa]
% Transferência :=
    DIVIDE ( [Transferências Mil]; [Passageiros Transportados Mil] )

// A soma das estações reproduz o total oficial da linha?  [Formato: Porcentagem, 2 casas]
% Entradas Estação vs Oficial :=
    DIVIDE ( [Entradas Mil]; [Entradas Oficiais Mil] )

// Qual a pressão de demanda por km de linha (mil passageiros por km)?  [Formato: Número, 1 casa]
Passageiros por km Mil :=
    DIVIDE ( [Passageiros Transportados Mil]; SUM ( dLinha[Extensao_Km] ) )

// Qual a média mensal de passageiros por estação em dias úteis (mil)?  [Formato: Número, 1 casa]
Passageiros MDU Mil :=
    AVERAGEX (
        VALUES ( dCalendario[Mes_Inicio] );
        CALCULATE ( SUM ( fEstacaoMes[Passageiros_MDU_Mil] ) )
    )

// Quantos passageiros fazem transferência interna nas 4 estações de integração (MDU, mil)?  [Formato: Número, 1 casa]
Transf. Interna MDU Mil :=
    CALCULATE (
        [Passageiros MDU Mil] - [Entradas MDU Mil];
        dEstacao[Tipo_Integracao] = "Interna Metrô"
    )

// Qual a transferência (MDU) segundo os totais oficiais por linha (mil)?  [Formato: Número, 1 casa]
Transf. MDU Oficial Mil :=
    AVERAGEX (
        VALUES ( dCalendario[Mes_Inicio] );
        CALCULATE ( SUM ( fLinhaMes[Transf_MDU_Mil] ) )
    )


// ==================== C. Sinais de falha e lacunas ====================
// Quantas entradas fogem do padrão (queda ou alta)?  [Formato: Número, inteiro]
Sinais Atípicos :=
    COUNTROWS ( fAnomalias )

// Quantas quedas atípicas houve?  [Formato: Número, inteiro]
Sinais de Queda :=
    CALCULATE ( COUNTROWS ( fAnomalias ); fAnomalias[Status_Desvio] = "Queda atípica" )

// Quantas altas atípicas houve?  [Formato: Número, inteiro]
Sinais de Alta :=
    CALCULATE ( COUNTROWS ( fAnomalias ); fAnomalias[Status_Desvio] = "Alta atípica" )

// Em quantos dias distintos houve queda atípica?  [Formato: Número, inteiro]
Dias com Queda :=
    CALCULATE ( DISTINCTCOUNT ( fAnomalias[Data] ); fAnomalias[Status_Desvio] = "Queda atípica" )

// Qual a maior queda em relação à média de referência?  [Formato: Porcentagem, 1 casa]
Maior Queda % :=
    MIN ( fAnomalias[Desvio_Pct] )

// Quantas estação-dias ficaram sem medição (vazio, traço ou zero)?  [Formato: Número, inteiro]
Qtd Lacunas :=
    COUNTROWS ( fLacunas )

// Em quantos dias distintos houve lacuna?  [Formato: Número, inteiro]
Dias com Lacuna :=
    DISTINCTCOUNT ( fLacunas[Data] )

// Que parte das estação-dias tem medição válida?  [Formato: Porcentagem, 2 casas]
Cobertura de Dados % :=
    DIVIDE ( [Estações-Dia]; [Estações-Dia] + [Qtd Lacunas] )


// ==================== D. Rede e oferta ====================
// Qual o intervalo médio entre trens (segundos)?  [Formato: Número, 1 casa]
Intervalo Médio (s) :=
    AVERAGE ( fOferta[Intervalo_Min_Seg] )

// Qual a velocidade comercial média (km/h)?  [Formato: Número, 1 casa]
Velocidade Comercial Média (km/h) :=
    AVERAGE ( fOferta[Vel_Comercial_Kmh] )

// Quantas estações físicas existem (sem contar a transferência duas vezes)?  [Formato: Número, inteiro]
Qtd Estações Únicas :=
    DISTINCTCOUNT ( dEstacao[Estacao] )

// Quantas estações têm transferência interna entre linhas do Metrô?  [Formato: Número, inteiro]
Qtd Estações de Transferência :=
    CALCULATE ( DISTINCTCOUNT ( dEstacao[Estacao] ); dEstacao[Transf_Interna] = "Sim" )


// ==================== E. Conferência ====================
// Linhas aceitas no modelo (= Etapa 2).  [Formato: Número, inteiro]
Conf Linhas fDemandaDia :=
    COUNTROWS ( fDemandaDia )

// Linhas rejeitadas (= Etapa 2).  [Formato: Número, inteiro]
Conf Linhas Rejeitados :=
    COUNTROWS ( Rejeitados )

// Linhas lidas = aceitas + rejeitadas (= Etapa 2).  [Formato: Número, inteiro]
Conf Linhas Lidas :=
    [Conf Linhas fDemandaDia] + [Conf Linhas Rejeitados]

// Medições sem estação no cadastro (deve ser 0).  [Formato: Número, inteiro]
Conf Demanda sem Estação :=
    COUNTROWS ( FILTER ( fDemandaDia; ISBLANK ( RELATED ( dEstacao[Estacao] ) ) ) ) + 0

// Medições com data fora do calendário (deve ser 0).  [Formato: Número, inteiro]
Conf Demanda sem Data :=
    COUNTROWS ( FILTER ( fDemandaDia; ISBLANK ( RELATED ( dCalendario[Mes_Num] ) ) ) ) + 0

// Linhas de fEstacaoMes sem estação (deve ser 0).  [Formato: Número, inteiro]
Conf EstacaoMes sem Estação :=
    COUNTROWS ( FILTER ( fEstacaoMes; ISBLANK ( RELATED ( dEstacao[Estacao] ) ) ) ) + 0

// Linhas de fEstacaoMes sem mês no calendário (deve ser 0).  [Formato: Número, inteiro]
Conf EstacaoMes sem Mês :=
    COUNTROWS ( FILTER ( fEstacaoMes; ISBLANK ( RELATED ( dCalendario[Mes_Num] ) ) ) ) + 0

// Linhas de fLinhaMes sem linha no cadastro (deve ser 0).  [Formato: Número, inteiro]
Conf LinhaMes sem Linha :=
    COUNTROWS ( FILTER ( fLinhaMes; ISBLANK ( RELATED ( dLinha[Linha] ) ) ) ) + 0

// Linhas de fLinhaMes sem mês no calendário (deve ser 0).  [Formato: Número, inteiro]
Conf LinhaMes sem Mês :=
    COUNTROWS ( FILTER ( fLinhaMes; ISBLANK ( RELATED ( dCalendario[Mes_Num] ) ) ) ) + 0

// Linhas de fOferta sem linha no cadastro (deve ser 0).  [Formato: Número, inteiro]
Conf Oferta sem Linha :=
    COUNTROWS ( FILTER ( fOferta; ISBLANK ( RELATED ( dLinha[Linha] ) ) ) ) + 0

// Chaves primárias repetidas nas dimensões (deve ser 0).  [Formato: Número, inteiro]
Conf PK Duplicada :=
    ( COUNTROWS ( dEstacao ) - DISTINCTCOUNT ( dEstacao[Cod_Estacao] ) )
        + ( COUNTROWS ( dLinha ) - DISTINCTCOUNT ( dLinha[Cod_Linha] ) )
        + ( COUNTROWS ( dCalendario ) - DISTINCTCOUNT ( dCalendario[Data] ) )

// O iterador reproduz a soma simples de Entradas Mil (deve ser 0).  [Formato: Número, 2 casas]
Conf Dif Entradas :=
    ROUND ( [Entradas] / 1000 - [Entradas Mil]; 2 )

// Soma das 4 linhas - linha REDE oficial (entradas, mil). Esperado: 1 (arredondamento da fonte).  [Formato: Número, inteiro]
Conf Dif Rede Entradas :=
    SUM ( fLinhaMes[Entr_Total_Mil] ) - SUM ( refRedeMes[Entr_Total_Mil] )

// Soma das 4 linhas - linha REDE oficial (passageiros, mil). Esperado: -1 (arredondamento da fonte).  [Formato: Número, inteiro]
Conf Dif Rede Passageiros :=
    SUM ( fLinhaMes[Pass_Total_Mil] ) - SUM ( refRedeMes[Pass_Total_Mil] )

// 1 se a diferença com a REDE oficial passa de 2 mil (deve ser 0).  [Formato: Número, inteiro]
Conf Rede Fora da Tolerância :=
    IF (
        ABS ( [Conf Dif Rede Entradas] ) > 2 || ABS ( [Conf Dif Rede Passageiros] ) > 2;
        1;
        0
    )

