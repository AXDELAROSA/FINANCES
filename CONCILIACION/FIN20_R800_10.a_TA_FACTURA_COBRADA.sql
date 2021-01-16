-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	[DATA_02Pruebas]
-- // MODULO:			EMBARQUES
-- // OPERACION:		FACTURA_COBRADA 
-- //////////////////////////////////////////////////////////////
-- // Autor:			FEG
-- // Fecha creación:	12/11/2020
-- ////////////////////////////////////////////////////////////// 

USE [DATA_02]
GO

-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACTURA_COBRADA]') AND type in (N'U'))
	DROP TABLE [dbo].[FACTURA_COBRADA]
GO


-- //////////////////////////////////////////////////////////////
-- // FACTURA_COBRADA
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[FACTURA_COBRADA] (
	[K_FACTURA_COBRADA]					[INT] IDENTITY (1,1) NOT NULL,
	-- =================================
	[NUMERO_FACTURA]					INT				NOT NULL,	
	-- =================================	
	[F_FACTURA_COBRADA]					DATETIME		NOT NULL
)ON [PRIMARY]	
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[FACTURA_COBRADA]
	ADD CONSTRAINT [PK_FACTURA_COBRADA]
		PRIMARY KEY CLUSTERED ([K_FACTURA_COBRADA])
GO

-- //////////////////////////////////////////////////////////////

/*
ALTER TABLE [dbo].[FACTURA_COBRADA] ADD 
	CONSTRAINT [FK_FACTURA_COBRADA_01]  
		FOREIGN KEY ([K_ESTATUS_FACTURA_COBRADA]) 
		REFERENCES [dbo].[ESTATUS_FACTURA_COBRADA] ([K_ESTATUS_FACTURA_COBRADA])
	--CONSTRAINT [FK_FACTURA_COBRADA_02]  
	--	FOREIGN KEY ([K_ESTATUS_FACTURA_COBRADA]) 
	--	REFERENCES [dbo].[ESTATUS_FACTURA_COBRADA] ([K_ESTATUS_FACTURA_COBRADA]),
	--CONSTRAINT [FK_FACTURA_COBRADA_03]  
	--	FOREIGN KEY ([K_ESTATUS_FACTURA_COBRADA]) 
	--	REFERENCES [dbo].[ESTATUS_FACTURA_COBRADA] ([K_ESTATUS_FACTURA_COBRADA])
GO
*/

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[FACTURA_COBRADA] 
	ADD		[K_USUARIO_ALTA]				[INT]		NOT NULL,
			[F_ALTA]						[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]				[INT]		NOT NULL,
			[F_CAMBIO]						[DATETIME]	NOT NULL,
			[L_BORRADO]						[INT]		NOT NULL,
			[K_USUARIO_BAJA]				[INT]		NULL,
			[F_BAJA]						[DATETIME]	NULL;
GO


--ALTER TABLE [dbo].[FACTURA_COBRADA] ADD 
--	CONSTRAINT [FK_FACTURA_COBRADA_USUARIO_ALTA]  
--		FOREIGN KEY ([K_USUARIO_ALTA]) 
--		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
--	CONSTRAINT [FK_FACTURA_COBRADA_USUARIO_CAMBIO]  
--		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
--		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
--	CONSTRAINT [FK_FACTURA_COBRADA_USUARIO_BAJA]  
--		FOREIGN KEY ([K_USUARIO_BAJA]) 
--		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
--GO





-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
