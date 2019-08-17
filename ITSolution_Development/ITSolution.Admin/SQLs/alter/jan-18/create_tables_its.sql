﻿USE dbBalcao_DEV

CREATE TABLE dbo.ITS_CONTRACT (
  IdContrato INT IDENTITY
 ,IdCliente INT NOT NULL
 ,DataAdesao DATE NOT NULL
 ,DataEncerramento DATE NULL
 ,ValorMensalidade DECIMAL(18, 2) NOT NULL
 ,CONSTRAINT [PK_dbo.ITS_CONTRACT] PRIMARY KEY CLUSTERED (IdContrato)
) ON [PRIMARY]
GO

ALTER TABLE dbo.ITS_CONTRACT
ADD CONSTRAINT [FK_dbo.ITS_CONTRACT_dbo.CliFor_IdCliente] FOREIGN KEY (IdCliente) REFERENCES dbo.CliFor (IdCliFor)
GO

CREATE TABLE dbo.ITS_LICENSE (
  IdLicense INT IDENTITY
 ,IdCliente INT NOT NULL
 ,CONSTRAINT [PK_dbo.ITS_LICENSE] PRIMARY KEY CLUSTERED (IdLicense)
) ON [PRIMARY]
GO

ALTER TABLE dbo.ITS_LICENSE
ADD CONSTRAINT [FK_dbo.ITS_LICENSE_dbo.CliFor_IdCliente] FOREIGN KEY (IdCliente) REFERENCES dbo.CliFor (IdCliFor)
GO

CREATE TABLE dbo.ITS_MENU (
  IdMenu INT IDENTITY
 ,NomeMenu VARCHAR(300) NULL
 ,MenuPai INT NOT NULL
 ,Status BIT NOT NULL
 ,ItsLicense_IdLicense INT NULL
 ,CONSTRAINT [PK_dbo.ITS_MENU] PRIMARY KEY CLUSTERED (IdMenu)
) ON [PRIMARY]
GO

ALTER TABLE dbo.ITS_MENU
ADD CONSTRAINT [FK_dbo.ITS_MENU_dbo.ITS_LICENSE_ItsLicense_IdLicense] FOREIGN KEY (ItsLicense_IdLicense) REFERENCES dbo.ITS_LICENSE (IdLicense)
GO