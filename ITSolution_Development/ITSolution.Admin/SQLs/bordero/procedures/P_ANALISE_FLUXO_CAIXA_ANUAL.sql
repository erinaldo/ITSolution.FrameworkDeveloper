IF EXISTS (SELECT
    ROUTINE_SCHEMA,
    ROUTINE_NAME
  FROM INFORMATION_SCHEMA.ROUTINES
  WHERE ROUTINE_DEFINITION LIKE '%P_ANALISE_FLUXO_CAIXA_ANUAL%')
BEGIN

  DROP PROCEDURE P_ANALISE_FLUXO_CAIXA_ANUAL;

END
GO
-- =============================================
-- Author:		Filipe
-- Create date: 23/05/2015
-- Description:	Analise do fluxo de caixa anual
-- =============================================
CREATE PROCEDURE P_ANALISE_FLUXO_CAIXA_ANUAL
-- No parameter Add the parameters for the stored procedure here 
(@Ano INT)
AS
BEGIN

  --DECLARE @Ano INT SET @Ano = 2015
  --Declaracao de variaveis
  --Constante para os meses do ano
  DECLARE @Janeiro INT,
          @Fevereiro INT,
          @Marco INT,
          @Abril INT,
          @Maio INT,
          @Junho INT,
          @Julho INT,
          @Agosto INT,
          @Setembro INT,
          @Outubro INT,
          @Novembro INT,
          @Dezembro INT

  --Valores das constantes
  SET @Janeiro = 1
  SET @Fevereiro = 2
  SET @Marco = 3
  SET @Abril = 4
  SET @Maio = 5
  SET @Junho = 6
  SET @Julho = 7
  SET @Agosto = 8
  SET @Setembro = 9
  SET @Outubro = 10
  SET @Novembro = 11
  SET @Dezembro = 12


  --Tabela para os totais por conta de custo
  SELECT
    cc.CodigoCentroCusto AS 'Código',
    cc.NomeCentroCusto AS 'Centro Custo',


    (SELECT
      [dbo].[F_TOTAL_CENTRO_CUSTO_POR_MES](@Janeiro, @Ano, cc.IdCentroCusto))
    AS 'Janeiro',
    (SELECT
      [dbo].[F_TOTAL_CENTRO_CUSTO_POR_MES](@Fevereiro, @Ano, cc.IdCentroCusto))
    AS 'Fevereiro',
    (SELECT
      [dbo].[F_TOTAL_CENTRO_CUSTO_POR_MES](@Marco, @Ano, cc.IdCentroCusto))
    AS 'Marco',
    (SELECT
      [dbo].[F_TOTAL_CENTRO_CUSTO_POR_MES](@Abril, @Ano, cc.IdCentroCusto))
    AS 'Abril',
    (SELECT
      [dbo].[F_TOTAL_CENTRO_CUSTO_POR_MES](@Maio, @Ano, cc.IdCentroCusto))
    AS 'Maio',
    (SELECT
      [dbo].[F_TOTAL_CENTRO_CUSTO_POR_MES](@Julho, @Ano, cc.IdCentroCusto))
    AS 'Junho',
    (SELECT
      [dbo].[F_TOTAL_CENTRO_CUSTO_POR_MES](@Junho, @Ano, cc.IdCentroCusto))
    AS 'Julho',
    (SELECT
      [dbo].[F_TOTAL_CENTRO_CUSTO_POR_MES](@Agosto, @Ano, cc.IdCentroCusto))
    AS 'Agosto',
    (SELECT
      [dbo].[F_TOTAL_CENTRO_CUSTO_POR_MES](@Setembro, @Ano, cc.IdCentroCusto))
    AS 'Setembro',
    (SELECT
      [dbo].[F_TOTAL_CENTRO_CUSTO_POR_MES](@Outubro, @Ano, cc.IdCentroCusto))
    AS 'Outubro',
    (SELECT
      [dbo].[F_TOTAL_CENTRO_CUSTO_POR_MES](@Novembro, @Ano, cc.IdCentroCusto))
    AS 'Novembro',
    (SELECT
      [dbo].[F_TOTAL_CENTRO_CUSTO_POR_MES](@Dezembro, @Ano, cc.IdCentroCusto))
    AS 'Dezembro',
    (SELECT
      [dbo].[F_TOTAL_CENTRO_CUSTO_POR_ANO](cc.IdCentroCusto, @Ano))
    AS 'Total'
  --Crie uma tabela temporaria para o total por centro de custo
  INTO #TotalContas

  FROM Lancamento lf

  JOIN CentroCusto cc
    ON cc.IdCentroCusto = lf.IdCentroCusto

  WHERE DATEPART(YEAR, l.DataLancamento) = @Ano
  -- nao liste o caixa final do dia
  AND cc.IdCentroCusto <> 6
  GROUP BY cc.NomeCentroCusto

  DECLARE @TabReceb TABLE (
    [Codigo] VARCHAR(100),
    [Centro Custo] VARCHAR(100),
    [Janeiro] DECIMAL,
    [Fevereiro] DECIMAL,
    [Marco] DECIMAL,
    [Abril] DECIMAL,
    [Maio] DECIMAL,
    [Junho] DECIMAL,
    [Julho] DECIMAL,
    [Agosto] DECIMAL,
    [Setembro] DECIMAL,
    [Outubro] DECIMAL,
    [Novembro] DECIMAL,
    [Dezembro] DECIMAL,
    [Total] DECIMAL
  )
  INSERT INTO @TabReceb EXEC [dbo].[P_DESPESAS_OPERACIONAIS_ANUAL] @Ano

  --Calcula o percentual
  SELECT
    cc.Codigo,
    cc.[Centro Custo],

    CASE
      WHEN (cc.Janeiro = 0) THEN 0
      WHEN (cc.Janeiro != 0) THEN
        --Divisao para calculo porcentagem 
        (cc.Janeiro / tr.Janeiro)
    END 'Janeiro',

    CASE
      WHEN (cc.Fevereiro = 0) THEN 0
      WHEN (cc.Fevereiro != 0) THEN
        --Divisao para calculo porcentagem 
        (cc.Fevereiro / tr.Fevereiro)
    END 'Fevereiro',

    CASE
      WHEN (cc.Marco = 0) THEN 0
      WHEN (cc.Marco != 0) THEN
        --Divisao para calculo porcentagem 
        (cc.Marco / tr.Marco)
    END 'Março',

    CASE
      WHEN (cc.Abril = 0) THEN 0
      WHEN (cc.Abril != 0) THEN
        --Divisao para calculo porcentagem 
        (cc.Abril / tr.Abril)
    END 'Abril',

    CASE
      WHEN (cc.Maio = 0) THEN 0
      WHEN (cc.Maio != 0) THEN
        --Divisao para calculo porcentagem 
        (cc.Maio / tr.Maio)

    END 'Maio',

    CASE
      WHEN (cc.Junho = 0) THEN 0
      WHEN (cc.Junho != 0) THEN
        --Divisao para calculo porcentagem 
        (cc.Junho / tr.Junho)
    END 'Junho',

    CASE
      WHEN (cc.Julho = 0) THEN 0
      WHEN (cc.Julho != 0) THEN
        --Divisao para calculo porcentagem 
        (cc.Julho / tr.Julho)
    END 'Julho',

    CASE
      WHEN (cc.Agosto = 0) THEN 0
      WHEN (cc.Agosto != 0) THEN
        --Divisao para calculo porcentagem 
        (cc.Agosto / tr.Agosto)

    END 'Agosto',

    CASE
      WHEN (cc.Setembro = 0) THEN 0
      WHEN (cc.Setembro != 0) THEN
        --Divisao para calculo porcentagem 
        (cc.Setembro / tr.Setembro)

    END 'Setembro',

    CASE
      WHEN (cc.Outubro = 0) THEN 0
      WHEN (cc.Outubro != 0) THEN
        --Divisao para calculo porcentagem 
        (cc.Outubro / tr.Outubro)

    END 'Outubro',

    CASE
      WHEN (cc.Novembro = 0) THEN 0
      WHEN (cc.Novembro != 0) THEN
        --Divisao para calculo porcentagem 
        (cc.Novembro / tr.Novembro)
    END 'Novembro',

    CASE
      WHEN (cc.Dezembro = 0) THEN 0
      WHEN (cc.Dezembro != 0) THEN
        --Divisao para calculo porcentagem 
        (cc.Dezembro / tr.Dezembro)
    END 'Dezembro',

    CASE
      WHEN (cc.Total = 0) THEN 0
      WHEN (cc.Total != 0) THEN
        --Divisao para calculo porcentagem 
        (cc.Total / tr.Total)
    END 'Total'

  --Crie uma tabela temporaria
  INTO #analiseFluxoCxTemp

  FROM #TotalContas sc,
       @TabReceb tr

  --Parseando a procedure para transformar em um select para calcular o percentual do caixa bruto e despesas operacionais
  BEGIN

    DECLARE @TabCaixaBruto TABLE (
      [Codigo] VARCHAR(100),
      [Centro Custo] VARCHAR(200),
      [Janeiro] DECIMAL,
      [Fevereiro] DECIMAL,
      [Marco] DECIMAL,
      [Abril] DECIMAL,
      [Maio] DECIMAL,
      [Junho] DECIMAL,
      [Julho] DECIMAL,
      [Agosto] DECIMAL,
      [Setembro] DECIMAL,
      [Outubro] DECIMAL,
      [Novembro] DECIMAL,
      [Dezembro] DECIMAL,
      [Total] DECIMAL
    )
    DECLARE @TabCaixaOperacional TABLE (
      [Codigo] VARCHAR(100),
      [Centro Custo] VARCHAR(200),
      [Janeiro] DECIMAL,
      [Fevereiro] DECIMAL,
      [Marco] DECIMAL,
      [Abril] DECIMAL,
      [Maio] DECIMAL,
      [Junho] DECIMAL,
      [Julho] DECIMAL,
      [Agosto] DECIMAL,
      [Setembro] DECIMAL,
      [Outubro] DECIMAL,
      [Novembro] DECIMAL,
      [Dezembro] DECIMAL,
      [Total] DECIMAL
    )
    --Insere a procedure na tabela temporaria do caixa bruto
    INSERT @TabCaixaBruto EXEC [dbo].[itsProCaixaBrutoAnual] @Ano
    --Insere a procedure na tabela temporaria do caixa bruto
    INSERT @TabCaixaOperacional EXEC [dbo].[itsProCaixaOperacionalAnual] @Ano

    --Anexando a linha do 'caixaBruto'
    --Da procedure na tabela temporaria
    INSERT INTO #analiseFluxoCxTemp
        SELECT
          cc.Codigo,
          cc.[Centro Custo],
          CASE
            WHEN (cc.Janeiro = 0) THEN 0
            WHEN (cc.Janeiro != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Janeiro / tr.Janeiro)
          END 'Janeiro',

          CASE
            WHEN (cc.Fevereiro = 0) THEN 0
            WHEN (cc.Fevereiro != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Fevereiro / tr.Fevereiro)
          END 'Fevereiro',

          CASE
            WHEN (cc.Marco = 0) THEN 0
            WHEN (cc.Marco != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Marco / tr.Marco)
          END 'Março',

          CASE
            WHEN (cc.Abril = 0) THEN 0
            WHEN (cc.Abril != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Abril / tr.Abril)
          END 'Abril',

          CASE
            WHEN (cc.Maio = 0) THEN 0
            WHEN (cc.Maio != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Maio / tr.Maio)

          END 'Maio',

          CASE
            WHEN (cc.Junho = 0) THEN 0
            WHEN (cc.Junho != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Junho / tr.Junho)
          END 'Junho',

          CASE
            WHEN (cc.Julho = 0) THEN 0
            WHEN (cc.Julho != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Julho / tr.Julho)
          END 'Julho',

          CASE
            WHEN (cc.Agosto = 0) THEN 0
            WHEN (cc.Agosto != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Agosto / tr.Agosto)

          END 'Agosto',

          CASE
            WHEN (cc.Setembro = 0) THEN 0
            WHEN (cc.Setembro != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Setembro / tr.Setembro)

          END 'Setembro',

          CASE
            WHEN (cc.Outubro = 0) THEN 0
            WHEN (cc.Outubro != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Outubro / tr.Outubro)

          END 'Outubro',

          CASE
            WHEN (cc.Novembro = 0) THEN 0
            WHEN (cc.Novembro != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Novembro / tr.Novembro)
          END 'Novembro',

          CASE
            WHEN (cc.Dezembro = 0) THEN 0
            WHEN (cc.Dezembro != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Dezembro / tr.Dezembro)
          END 'Dezembro',

          CASE
            WHEN (cc.Total = 0) THEN 0
            WHEN (cc.Total != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Total / tr.Total)
          END 'Total'

        FROM @TabReceb tr,
             @TabCaixaBruto sc


    --Anexando a linha do 'operacional'
    --Da procedure na tabela temporaria
    INSERT INTO #analiseFluxoCxTemp
        SELECT

          cc.[Centro Custo],
          cc.Conta,
          CASE
            WHEN (cc.Janeiro = 0) THEN 0
            WHEN (cc.Janeiro != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Janeiro / tr.Janeiro)
          END 'Janeiro',

          CASE
            WHEN (cc.Fevereiro = 0) THEN 0
            WHEN (cc.Fevereiro != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Fevereiro / tr.Fevereiro)
          END 'Fevereiro',

          CASE
            WHEN (cc.Marco = 0) THEN 0
            WHEN (cc.Marco != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Marco / tr.Marco)
          END 'Março',

          CASE
            WHEN (cc.Abril = 0) THEN 0
            WHEN (cc.Abril != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Abril / tr.Abril)
          END 'Abril',

          CASE
            WHEN (cc.Maio = 0) THEN 0
            WHEN (cc.Maio != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Maio / tr.Maio)

          END 'Maio',

          CASE
            WHEN (cc.Junho = 0) THEN 0
            WHEN (cc.Junho != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Junho / tr.Junho)
          END 'Junho',

          CASE
            WHEN (cc.Julho = 0) THEN 0
            WHEN (cc.Julho != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Julho / tr.Julho)
          END 'Julho',

          CASE
            WHEN (cc.Agosto = 0) THEN 0
            WHEN (cc.Agosto != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Agosto / tr.Agosto)

          END 'Agosto',

          CASE
            WHEN (cc.Setembro = 0) THEN 0
            WHEN (cc.Setembro != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Setembro / tr.Setembro)

          END 'Setembro',

          CASE
            WHEN (cc.Outubro = 0) THEN 0
            WHEN (cc.Outubro != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Outubro / tr.Outubro)

          END 'Outubro',

          CASE
            WHEN (cc.Novembro = 0) THEN 0
            WHEN (cc.Novembro != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Novembro / tr.Novembro)
          END 'Novembro',

          CASE
            WHEN (cc.Dezembro = 0) THEN 0
            WHEN (cc.Dezembro != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Dezembro / tr.Dezembro)
          END 'Dezembro',

          CASE
            WHEN (cc.Total = 0) THEN 0
            WHEN (cc.Total != 0) THEN
              --Divisao para calculo porcentagem 
              (cc.Total / tr.Total)
          END 'Total'
        FROM @TabReceb tr,
             @TabCaixaOperacional sc

  END


  -- retorne a tabela temporaria
  SELECT
    *
  FROM #analiseFluxoCxTemp
  ORDER BY [Centro Custo] DESC

  DROP TABLE #TotalContas
  DROP TABLE #analiseFluxoCxTemp

END