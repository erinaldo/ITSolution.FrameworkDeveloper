﻿/**
*
* Coloque as alterações em ordem predatas e comentadas
*
*
*/

--17/01/2016 | Gercy | Criação de campo para armazenar o arquivo depois de publicar o pacote
ALTER TABLE ITS_PACKAGE
  ADD ArquivoFinal VARBINARY(MAX) NULL;
CREATE TABLE ITS_PACKAGE (
  IdPacote INT IDENTITY,
  NumeroPacote VARCHAR(9) NULL,
  Descricao VARCHAR(500) NULL,
  Sintoma VARCHAR(2000) NULL,
  Tratamento VARCHAR(2000) NULL,
  DataPublicacao DATETIME NULL,
  DataCriacao DATETIME NOT NULL,
  Status INT NULL,
  CONSTRAINT [PK_dbo.ITS_PACKAGE] PRIMARY KEY CLUSTERED (IdPacote)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE TABLE ITS_PACKAGE_ANEXO (
  IdAnexo INT IDENTITY,
  IdPacote INT NOT NULL,
  DataAnexo DATETIME NOT NULL,
  IdentificacaoAnexo VARCHAR(50) NULL,
  PathFile VARCHAR(255) NULL,
  FileName VARCHAR(255) NULL,
  DataFile VARBINARY(MAX) NULL,
  CONSTRAINT [PK_dbo.ITS_PACKAGE_ANEXO] PRIMARY KEY CLUSTERED (IdAnexo),
  CONSTRAINT [FK_dbo.ITS_PACKAGE_ANEXO_dbo.ITS_PACKAGE_IdPacote] FOREIGN KEY (IdPacote) REFERENCES dbo.ITS_PACKAGE (IdPacote)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX IDX_FILENAME_PKG
ON ITS_PACKAGE_ANEXO (IdPacote, FileName)
ON [PRIMARY]
GO

CREATE INDEX IX_IdPacote
ON ITS_PACKAGE_ANEXO (IdPacote)
ON [PRIMARY]
GO

CREATE TABLE ITS_UPDATE_INFO (
  IdUpdate NVARCHAR(128) NOT NULL,
  NumeroPacote NVARCHAR(MAX) NULL,
  DescricaoUpdate NVARCHAR(MAX) NULL,
  DataAplicacao DATETIME NOT NULL,
  LogAplicacao NVARCHAR(MAX) NULL,
  CONSTRAINT [PK_dbo.ITS_UPDATE_INFO] PRIMARY KEY CLUSTERED (IdUpdate)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO