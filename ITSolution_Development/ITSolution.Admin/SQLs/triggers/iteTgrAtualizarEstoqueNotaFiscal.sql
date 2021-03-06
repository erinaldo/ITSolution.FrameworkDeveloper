USE dbBalcao
GO 
/****** Object:  Trigger [dbo].[Tgr_Balcao_AtualizarEstoque]    Script Date: 29/07/2015 21:22:47 ******/
 
CREATE TRIGGER [dbo].[Tgr_Balcao_AtualizarEstoqueNotaFiscal]
--Na tabela de Entrada
ON [dbo].[ItemEntrada]
--Ao inserir 
FOR INSERT
AS

--Faça
BEGIN

	DECLARE @IdNewEntrada INT, 
			@IdNewProdutoEntrada INT,
			@QtdeNewProdutoEntrada DECIMAL,
			@PrecoCompraProdutoEntrada DECIMAL
	
	SELECT 
		--Selecione a ultima Pk  da da inserida da tabela 
		@IdNewEntrada =  IdEntradaNf,  
	
		--Selecione a a ultima Fk do ultimo produto inserido da tabela de Entrada
		@IdNewProdutoEntrada =   IdProdutoEntrada,
	
		--Selecione a ultima quantidade ultimo produto inserido da tabela de Entrada
		@QtdeNewProdutoEntrada =  Quantidade,
	
		--Selecione o ultimo preco de compra do produto inserido da tabela de Entrada
		@PrecoCompraProdutoEntrada =  ValorUnitario
	--Tabela que ocorreu a inserção		
	FROM INSERTED


	--Verifica se a Pk da venda está marcada como vendida
	SET @IdNewEntrada = (SELECT en.IdEntrada FROM Entrada en WHERE en.IdEntrada = @IdNewEntrada AND en.StatusNota = 'Ativo')
	
	--Se for nula então não foi efetivada
	IF (@IdNewProdutoEntrada IS NULL)
		 -- Return the result of the function
		SET @IdNewEntrada = 0

	IF(@IdNewEntrada > 0)

		UPDATE 
			Produto 
			--Adicione a quantidade dos itens existentes pela que foi entrada
			SET  Produto.QuantidadeProduto = (QuantidadeProduto + @QtdeNewProdutoEntrada),
			-- atualize o preço de compra
				Produto.PrecoCompra = @PrecoCompraProdutoEntrada,
				--PrecoCompra      100%
				--x                Margem
				Produto.PrecoVenda = @PrecoCompraProdutoEntrada + (@PrecoCompraProdutoEntrada * MargemLucro)/100
		FROM
			ItemEntrada ie
	 
		INNER JOIN Produto p 
			ON p.IdProduto = ie.IdProdutoEntrada

		INNER JOIN Entrada en 
			ON ie.IdEntradaNf = en.IdEntrada 
		--Atualize o produto da Entrada especifica daquele produto especifico 
 		WHERE ie.IdEntradaNf = @IdNewEntrada AND p.IdProduto = @IdNewProdutoEntrada
 
END