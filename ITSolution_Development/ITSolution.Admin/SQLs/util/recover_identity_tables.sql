DECLARE @COMANDO VARCHAR(40);
DECLARE @PK VARCHAR(40);

SET @COMANDO = 'DBCC CHECKIDENT ( ';
-- '''' apos a virgula eh igual ao apostrofe '
-- ''palavra concatena o apostrofe na palavra

--Gera o comando para restaurar o valor da identity da tabela
SELECT

  
  iif(IDENT_CURRENT(t.name) is null, '0', IDENT_CURRENT(t.name)) AS 'MAX ID',
  

    CONCAT(@COMANDO, '''', t.name, '''', ',', ' RESEED, ', ISNULL(IDENT_CURRENT(t.name), 0), ' )', ';') AS 'COMMAND RESULT'

FROM sys.tables t
WHERE t.name NOT LIKE 'ITS%' 

-- nao mexo nessas tabelas
AND t.name <> 'Cfops'
AND t.name <> 'TipoImposto'
AND t.name <> 'TipoLogradouro'
AND t.name <> 'UnidadeFederacao'
AND t.name <> 'Municipios' 
AND t.name <> 'ModeloDocumentoFiscal'
AND t.name <> 'ImpostosRegraFiscal'
AND t.name <> 'FaixaContribuicaoEncargos'
AND t.name <> 'SituacaoDocumentoFiscal'  

  --sem pk
  AND t.name <> 'ItemManutencao'
  AND t.name <> 'ItemVenda'
  AND t.name <> 'NotaFiscalItem'
  AND t.name <> 'InscricaoStFilial' 

AND t.name <> 'EmpresaMatriz'
AND t.name <> 'EmpresaFilial'
AND t.name <> 'CentroCusto'
AND t.name <> 'UnidadeMedida'
AND t.name <> 'LocaisEstoque'
AND t.name <> 'Usuario'
AND t.name <> 'GrupoUsuario'
AND t.name <> 'FormaPagamento'
AND t.name <> 'Parametro'
AND t.name <> 'GrupoEvento'

AND t.name <> 'CategoriaProduto' --ordenar as sequencia
AND t.name <> 'EventosGrupo' --ordenar sequencia
AND t.name <> 'Evento' --ordenar sequencia
AND t.name <> 'GrupoEvento' --ordenar sequencia
AND t.name <> 'sysdiagrams' 
AND t.name <> '__MigrationHistory'
AND t.name <> 'SkinDevExpress'

ORDER BY IDENT_CURRENT(t.name)


-- Nao tem identity
-- DBCC CHECKIDENT ( 'ItemVenda', RESEED, 0 );
-- DBCC CHECKIDENT ( 'ItemManutencao', RESEED, 0 );
-- DBCC CHECKIDENT ( 'InscricaoStFilial', RESEED, 0 );
-- DBCC CHECKIDENT ( 'Parametro', RESEED, 0 );
