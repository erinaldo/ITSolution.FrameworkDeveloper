CREATE TRIGGER Tgr_Balcao_AtualizarStatusVenda
--Na tabela de venda
ON dbo.Parcela
--Ao atualizar
AFTER  UPDATE
AS

--Faça
BEGIN

 DECLARE 
   @IdVenda INT,
   @TotalParcelas int,
   @CountQuitadas int,
   @DataPagamento DATETIME

 --Selecione a ultima Pk da venda da tabela 
 SET @IdVenda = (SELECT IdVendaParcela FROM INSERTED)
 
 --Total de Parcelas da Venda
 SET @TotalParcelas = (select count(*) from Parcela 
       where IdVendaParcela = @IdVenda)
 
 --Parcelas quitadas
 SET @CountQuitadas = (select count(*) from Parcela 
       where IdVendaParcela = @IdVenda and DataPagamento is not null)

 --Se for nula então as parcela dessa venda foram pagas
 IF (@CountQuitadas = @TotalParcelas)
  BEGIN
 	SET @DataPagamento = (
					SELECT MIN(DataVencimento)
					FROM 
						Parcela 
					WHERE 
						DataPagamento IS NULL AND IdVendaParcela = @IdVenda
				)
  UPDATE 
		Venda 
	SET  Venda.StatusVenda = 4 ---quitada
	--Atualize a venda especifica da parcela especifica
	WHERE Venda.IdVenda = @IdVenda 
    END
 ELSE
	--Busque a primeira parcela que ainda nao foi paga
	SET @DataPagamento = (
					SELECT MIN(DataVencimento)
					FROM 
						Parcela 
					WHERE 
						DataPagamento IS NULL AND IdVendaParcela = @IdVenda
				)
	--Atualize a data do pagamento da venda
	--Sera a data da próxima parcela
  IF (SELECT COUNT(*) FROM Parcela WHERE IdVendaParcela = @IdVenda AND Parcela.DataPagamento IS NULL) > 0
    BEGIN

	UPDATE Venda SET DataVencimento = @DataPagamento WHERE IdVenda = @IdVenda
END
    ELSE
    BEGIN
    	SET @DataPagamento = (
					SELECT MAX(DataVencimento) 
					FROM 
						Parcela 
					WHERE 
						IdVendaParcela = @IdVenda AND DataPagamento is NOT null
				)
  UPDATE Venda SET DataVencimento = @DataPagamento WHERE IdVenda = @IdVenda
	    END
END
GO