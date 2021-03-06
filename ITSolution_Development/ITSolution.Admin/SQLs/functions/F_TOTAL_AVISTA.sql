IF EXISTS(
SELECT
      ROUTINE_SCHEMA
    , ROUTINE_NAME
FROM
    INFORMATION_SCHEMA.ROUTINES
WHERE
    ROUTINE_DEFINITION LIKE '%F_TOTAL_AVISTA%' 
 
) BEGIN

	DROP FUNCTION F_TOTAL_AVISTA; 

END 
GO
-- =============================================
-- Author:		Filipe
-- Create date: 08/08/2015
-- Description:	Valor total de compras realizada
-- =============================================
CREATE FUNCTION F_TOTAL_AVISTA (
-- Add the parameters for the function here	
@DataInicial DATETIME, @DataFinal DATETIME)

RETURNS DECIMAL
AS
BEGIN
  -- Declare the return variable here
  DECLARE @TotalAvista DECIMAL

  SET @TotalAvista =

  -- Add the T-SQL statements to compute the return value here
  (SELECT
    SUM(v.TotalVenda) AS 'Total Vendas á Vista'
  FROM Venda v
  JOIN LancamentoFinanceiro lf
    ON v.IdVenda = lf.IdVenda
  JOIN FormaPagamento f
    ON f.IdFormaPagamento = lf.IdFormaPagamento

  WHERE f.IdFormaPagamento = 1
  OR f.NomeFormaPagamento = 'Dinheiro')
  BEGIN

    IF (@TotalAvista IS NULL)
      SET @TotalAvista = 0

  END
  -- Return the result of the function
  RETURN @TotalAvista

END