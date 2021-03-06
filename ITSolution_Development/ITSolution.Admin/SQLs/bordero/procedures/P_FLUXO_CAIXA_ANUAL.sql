IF EXISTS(
SELECT
      ROUTINE_SCHEMA
    , ROUTINE_NAME
FROM
    INFORMATION_SCHEMA.ROUTINES
WHERE
    ROUTINE_DEFINITION LIKE '%P_FLUXO_CAIXA_ANUAL%' 
 
) BEGIN

	DROP PROCEDURE P_FLUXO_CAIXA_ANUAL; 

END 
GO 
-- =============================================
-- Author:		Filipe
-- Create date: 23/05/2015
-- Description:	Relatorio do fluxo de caixa anual
-- =============================================
CREATE PROCEDURE P_FLUXO_CAIXA_ANUAL (@Ano INT)
	-- No parameter Add the parameters for the stored procedure here (
 
AS
BEGIN
 
DECLARE @Janeiro INT SET @Janeiro = 1
	DECLARE @Fevereiro INT SET @Fevereiro = 2
	DECLARE @Marco INT SET @Marco = 3
	DECLARE @Abril INT SET @Abril = 4
	DECLARE @Maio INT SET @Maio = 5
	DECLARE @Junho INT SET @Junho = 6
	DECLARE @Julho INT SET @Julho = 7
	DECLARE @Agosto INT SET @Agosto = 8
	DECLARE @Setembro INT SET @Setembro = 9
	DECLARE @Outubro INT SET @Outubro = 10
	DECLARE @Novembro INT SET @Novembro = 11
	DECLARE @Dezembro INT SET @Dezembro = 12    
	
	-- Insert statements for procedure here	
	SELECT 
		cc.CodigoCentroCusto as 'Código', 
		cc.NomeCentroCusto as 'Centro Custo', 
	 
		  (  SELECT F_TOTAL_CENTRO_CUSTO_POR_MES (@Janeiro, @Ano, sc.IdContaCusto )) AS 'Janeiro' ,	
		  (  SELECT F_TOTAL_CENTRO_CUSTO_POR_MES (@Fevereiro, @Ano, sc.IdContaCusto )) AS 'Fevereiro', 
		  (  SELECT F_TOTAL_CENTRO_CUSTO_POR_MES (@Marco, @Ano, sc.IdContaCusto )) AS 'Março', 
		  (  SELECT F_TOTAL_CENTRO_CUSTO_POR_MES (@Abril, @Ano, sc.IdContaCusto )) AS 'Abril', 
		  (  SELECT F_TOTAL_CENTRO_CUSTO_POR_MES (@Maio, @Ano, sc.IdContaCusto )) AS 'Maio', 
		  (  SELECT F_TOTAL_CENTRO_CUSTO_POR_MES (@Julho, @Ano, sc.IdContaCusto )) AS 'Junho', 
		  (  SELECT F_TOTAL_CENTRO_CUSTO_POR_MES (@Junho, @Ano, sc.IdContaCusto )) AS 'Julho', 
		  (  SELECT F_TOTAL_CENTRO_CUSTO_POR_MES (@Agosto, @Ano, sc.IdContaCusto )) AS 'Agosto', 
		  (  SELECT F_TOTAL_CENTRO_CUSTO_POR_MES (@Setembro, @Ano, sc.IdContaCusto )) AS 'Setembro', 
		  (  SELECT F_TOTAL_CENTRO_CUSTO_POR_MES (@Outubro, @Ano, sc.IdContaCusto )) AS 'Outubro', 
		  (  SELECT F_TOTAL_CENTRO_CUSTO_POR_MES (@Novembro, @Ano, sc.IdContaCusto )) AS 'Novembro', 
		  (  SELECT F_TOTAL_CENTRO_CUSTO_POR_MES (@Dezembro, @Ano, sc.IdContaCusto )) AS 'Dezembro', 
		  (	SELECT F_TOTAL_CENTRO_CUSTO_POR_ANO ( sc.IdContaCusto, @Ano)) AS 'Total'
	
	--Crie uma tabela temporaria
	INTO #fluxoCxAnualTemp

	FROM Lancamento lf 
		
		JOIN CentroCusto cc ON cc.IdCentroCusto = lf.IdCentroCusto

	WHERE DATEPART(YEAR, l.DataLancamento) = @Ano 
 
	-- nao liste o caixa final do dia
	AND cc.IdCentroCusto <> 6
	GROUP BY cc.NomeCentroCusto
	
	-- retorne a tabela temporaria
	SELECT * FROM #fluxoCxAnualTemp ORDER BY [Centro Custo] DESC
	DROP TABLE 	#fluxoCxAnualTemp
END