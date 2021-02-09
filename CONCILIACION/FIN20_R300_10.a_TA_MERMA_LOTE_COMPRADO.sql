-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	[DATA_02Pruebas]
-- // MODULO:			EMBARQUES
-- // OPERACION:		MERMA_LOTE_COMPRADO 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MERMA_LOTE_COMPRADO]') AND type in (N'U'))
	DROP TABLE [dbo].[MERMA_LOTE_COMPRADO]
GO


-- //////////////////////////////////////////////////////////////
-- // MERMA_LOTE_COMPRADO
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[MERMA_LOTE_COMPRADO] (
	[K_MERMA_LOTE_COMPRADO]					[INT] IDENTITY (1,1) NOT NULL,
	-- =================================
	[NUMERO_FACTURA]					VARCHAR(50)		NOT NULL,	
	[COLOR]								VARCHAR(50)		NOT NULL,	
	[LOT_CRUST]							VARCHAR(50)		NOT NULL,
	[TOTAL_PIEL]						INT				NOT NULL,		
	[TOTAL_SQFT]						DECIMAL(13,2)	NOT NULL,
	-- =================================	
	[COMENTARIO]						VARCHAR(255)	NOT NULL,	
	[F_MERMA_LOTE_COMPRADO]				DATETIME		NOT NULL
)ON [PRIMARY]	
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[MERMA_LOTE_COMPRADO]
	ADD CONSTRAINT [PK_MERMA_LOTE_COMPRADO]
		PRIMARY KEY CLUSTERED ([K_MERMA_LOTE_COMPRADO])
GO

-- //////////////////////////////////////////////////////////////

/*
ALTER TABLE [dbo].[MERMA_LOTE_COMPRADO] ADD 
	CONSTRAINT [FK_MERMA_LOTE_COMPRADO_01]  
		FOREIGN KEY ([K_ESTATUS_MERMA_LOTE_COMPRADO]) 
		REFERENCES [dbo].[ESTATUS_MERMA_LOTE_COMPRADO] ([K_ESTATUS_MERMA_LOTE_COMPRADO])
	--CONSTRAINT [FK_MERMA_LOTE_COMPRADO_02]  
	--	FOREIGN KEY ([K_ESTATUS_MERMA_LOTE_COMPRADO]) 
	--	REFERENCES [dbo].[ESTATUS_MERMA_LOTE_COMPRADO] ([K_ESTATUS_MERMA_LOTE_COMPRADO]),
	--CONSTRAINT [FK_MERMA_LOTE_COMPRADO_03]  
	--	FOREIGN KEY ([K_ESTATUS_MERMA_LOTE_COMPRADO]) 
	--	REFERENCES [dbo].[ESTATUS_MERMA_LOTE_COMPRADO] ([K_ESTATUS_MERMA_LOTE_COMPRADO])
GO
*/

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[MERMA_LOTE_COMPRADO] 
	ADD		[K_USUARIO_ALTA]				[INT]		NOT NULL,
			[F_ALTA]						[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]				[INT]		NOT NULL,
			[F_CAMBIO]						[DATETIME]	NOT NULL,
			[L_BORRADO]						[INT]		NOT NULL,
			[K_USUARIO_BAJA]				[INT]		NULL,
			[F_BAJA]						[DATETIME]	NULL;
GO


--ALTER TABLE [dbo].[MERMA_LOTE_COMPRADO] ADD 
--	CONSTRAINT [FK_MERMA_LOTE_COMPRADO_USUARIO_ALTA]  
--		FOREIGN KEY ([K_USUARIO_ALTA]) 
--		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
--	CONSTRAINT [FK_MERMA_LOTE_COMPRADO_USUARIO_CAMBIO]  
--		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
--		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
--	CONSTRAINT [FK_MERMA_LOTE_COMPRADO_USUARIO_BAJA]  
--		FOREIGN KEY ([K_USUARIO_BAJA]) 
--		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
--GO





-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
