IF EXISTS(
SELECT
      ROUTINE_SCHEMA
    , ROUTINE_NAME
FROM
    INFORMATION_SCHEMA.ROUTINES
WHERE
    ROUTINE_DEFINITION LIKE '%P_CAIXA_OPERACIONAL_ANUAL%' 
 
) BEGIN

	DROP PROCEDURE P_CAIXA_OPERACIONAL_ANUAL; 

END 
GO
-- =============================================
-- Author:		Filipe
-- Create date: 23/05/2015
-- Description:	Relatorio do total do caixa operacional de cada mes do ano
-- =============================================
CREATE PROCEDURE [dbo].[P_CAIXA_OPERACIONAL_ANUAL]
(
	-- No parameter Add the parameters for the stored procedure here (
	@Ano INT
)
 
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
	DECLARE @v_totalCxJaneiro DECIMAL
	DECLARE @v_totalCxFevereiro DECIMAL
	DECLARE @v_totalCxMarco DECIMAL
	DECLARE @v_totalCxAbril DECIMAL
	DECLARE @v_totalCxMaio DECIMAL
	DECLARE @v_totalCxJunho DECIMAL
	DECLARE @v_totalCxJulho DECIMAL
	DECLARE @v_totalCxAgosto DECIMAL
	DECLARE @v_totalCxSetembro DECIMAL
	DECLARE @v_totalCxOutubro DECIMAL
	DECLARE @v_totalCxNovembro DECIMAL
	DECLARE @v_totalCxDezembro DECIMAL
			
	SET @v_totalCxJaneiro = (SELECT ([dbo].[itsFuncTotalCaixaOperacionalPorMes] ( @Janeiro,@Ano)))
	SET @v_totalCxFevereiro	= (SELECT ([dbo].[itsFuncTotalCaixaOperacionalPorMes] (@Fevereiro,@Ano)))
	SET @v_totalCxMarco  = (SELECT ([dbo].[itsFuncTotalCaixaOperacionalPorMes] ( @Marco,@Ano)))
	SET @v_totalCxAbril =  (SELECT ([dbo].[itsFuncTotalCaixaOperacionalPorMes] ( @Abril,@Ano)))
	SET @v_totalCxMaio = (SELECT ([dbo].[itsFuncTotalCaixaOperacionalPorMes] ( @Maio,@Ano)))
	SET @v_totalCxJunho = (SELECT ([dbo].[itsFuncTotalCaixaOperacionalPorMes] ( @Junho,@Ano)))
	SET @v_totalCxJulho = (SELECT ([dbo].[itsFuncTotalCaixaOperacionalPorMes] ( @Julho,@Ano)))
	SET @v_totalCxAgosto = (SELECT ([dbo].[itsFuncTotalCaixaOperacionalPorMes] ( @Agosto,@Ano)))
	SET @v_totalCxSetembro = (SELECT ([dbo].[itsFuncTotalCaixaOperacionalPorMes] ( @Setembro,@Ano)))
	SET @v_totalCxOutubro = (SELECT ([dbo].[itsFuncTotalCaixaOperacionalPorMes] ( @Outubro,@Ano)))
	SET @v_totalCxNovembro = (SELECT ([dbo].[itsFuncTotalCaixaOperacionalPorMes] ( @Novembro,@Ano)))
	SET @v_totalCxDezembro = (SELECT ([dbo].[itsFuncTotalCaixaOperacionalPorMes] ( @Dezembro,@Ano)))

	SELECT 'CAIXA OPERACIONAL',  'CAIXA OPERACIONAL',
		@v_totalCxJaneiro ,	 
		@v_totalCxFevereiro ,	 
		@v_totalCxMarco ,
		@v_totalCxAbril ,	 
		@v_totalCxMaio ,	 
		@v_totalCxJunho ,	 
		@v_totalCxJulho ,
		@v_totalCxAgosto ,	
		@v_totalCxSetembro ,	
		@v_totalCxOutubro ,
		@v_totalCxNovembro ,	 
		@v_totalCxDezembro, 
		SUM( @v_totalCxJaneiro + @v_totalCxFevereiro + @v_totalCxMarco + @v_totalCxAbril + @v_totalCxMaio +
			@v_totalCxJunho + @v_totalCxJulho + @v_totalCxAgosto + @v_totalCxSetembro + @v_totalCxOutubro +
			@v_totalCxNovembro + @v_totalCxDezembro )

 END