IF EXISTS(
SELECT
      ROUTINE_SCHEMA
    , ROUTINE_NAME
FROM
    INFORMATION_SCHEMA.ROUTINES
WHERE
    ROUTINE_DEFINITION LIKE '%P_FLUXO_CAIXA_ABERTO%' 
 
) BEGIN

	DROP PROCEDURE P_FLUXO_CAIXA_ABERTO; 

END 
GO
-- =============================================
-- Author:		Filipe
-- Create date: 23/05/2015
-- Description:	Relatorio do fluxo de caixa em aberto
-- Carrega tudo existente no banco
-- =============================================
CREATE PROCEDURE P_FLUXO_CAIXA_ABERTO
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
		cc.CodigoCentroCusto as 'C�digo', 
		cc.NomeCentroCusto as 'Centro Custo', 
	 
		(SELECT [dbo].[F_TOTAL_CENTRO_CUSTO] (cc.IdCentroCusto)) AS 'Total Lan�tos.'	

		INTO #fluxoCaixaPeriodo
	FROM Lancamento lf 
		
		JOIN CentroCusto cc ON cc.IdCentroCusto = lf.IdCentroCusto

	GROUP BY cc.NomeCentroCusto


	-- retorne a tabela temporaria
	SELECT * FROM #fluxoCaixaPeriodo ORDER BY [Centro Custo] DESC
	
END