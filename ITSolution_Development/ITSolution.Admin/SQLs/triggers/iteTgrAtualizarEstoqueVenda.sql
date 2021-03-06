USE dbBalcao_Homol
GO 
/****** Object:  Trigger [dbo].[Tgr_Balcao_AtualizarEstoque]    Script Date: 29/07/2015 21:22:47 ******/
 
CREATE TRIGGER [dbo].[Tgr_Balcao_AtualizarEstoqueVenda]
--Na tabela de venda
ON [dbo].[ItemVenda]
--Ao Inserir 
FOR INSERT
AS

--Faça
BEGIN

	DECLARE @IdNewVenda INT, 
			@IdNewProdutoVenda INT,
			@QtdeNewProdutoVenda DECIMAL,
			@QtdeNew DECIMAL

	SELECT 
		--Selecione a ultima Pk  da da inserida da tabela 
		@IdNewVenda = IdVendaItem,
		--Selecione a a ultima Fk do ultimo produto inserido da tabela de venda
		@IdNewProdutoVenda = IdProdutoItem,
		--Selecione a ultima quantidade ultimo produto inserido da tabela de venda
		@QtdeNewProdutoVenda = Quantidade 
	FROM INSERTED
	
	--Verifica se a Pk da venda está marcada como vendida
	SET @IdNewVenda = (SELECT v.IdVenda FROM Venda v WHERE v.IdVenda = @IdNewVenda AND v.StatusVenda = 'Efetivada')
	
	--Se for nula então não foi efetivada
	IF (@IdNewProdutoVenda IS NULL)
		 -- Return the result of the function
		SET @IdNewVenda = 0

	if(@IdNewVenda > 0)
		BEGIN
			--Atualizando o estoque do produto 
			UPDATE 
				Produto 
				--Subtraia a quantidade dos itens existentes pela que foi vendida
				SET 
					--Subtraia a quantidade dos itens existentes pela que foi vendida
					Produto.QuantidadeProduto = (p.QuantidadeProduto - @QtdeNewProdutoVenda)
			FROM
				ItemVenda iv
	 
			INNER JOIN Produto p 
				ON p.IdProduto = iv.IdProdutoItem

			INNER JOIN Venda v 
				ON iv.IdVendaItem = v.IdVenda 
			--Atualize o produto da venda especifica daquele produto especifico 
 			WHERE iv.IdVendaItem = @IdNewVenda AND p.IdProduto = @IdNewProdutoVenda

		END
END