IF EXISTS(
SELECT
      ROUTINE_SCHEMA
    , ROUTINE_NAME
FROM
    INFORMATION_SCHEMA.ROUTINES
WHERE
    ROUTINE_DEFINITION LIKE '%F_TOTAL_CENTRO_CUSTO%' 
 
) BEGIN

	DROP FUNCTION F_TOTAL_CENTRO_CUSTO; 

END 
GO
-- =============================================
-- Author:		Filipe
-- Description:	Total de lanšamentos de um centro de custo 
-- =============================================
CREATE FUNCTION F_TOTAL_CENTRO_CUSTO (@IdCentroCusto INT)
-- Add the parameters for the stored procedure here
RETURNS DECIMAL
BEGIN
  DECLARE @Total DECIMAL;

  SET @Total = (SELECT
    SUM(lf.ValorLancamento)
  FROM LancamentoFinanceiro lf
  JOIN CentroCusto cc
    ON cc.IdCentroCusto = lf.IdCentroCusto

  WHERE cc.IdCentroCusto = @IdCentroCusto)--Fim do calculo

  -- Return the result of the function
  IF (@Total IS NULL)
    SET @Total = 0;

  RETURN @Total

END