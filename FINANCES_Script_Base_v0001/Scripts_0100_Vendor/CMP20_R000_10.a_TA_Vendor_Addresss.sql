-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		SETTINGS_GENERAL
-- // MODULE:			ALL
-- // OPERATION:		TABLA
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200213
-- ////////////////////////////////////////////////////////////// 

USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ADDRESS_VENDOR]') AND type in (N'U'))
	DROP TABLE [dbo].[ADDRESS_VENDOR]
GO

-- ////////////////////////////////////////////////////////////////
-- //					ADDRESS_VENDOR				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ADDRESS_VENDOR] (
	[K_VENDOR]					[INT] NOT NULL,			
	[K_ADDRESS_VENDOR]			[INT] NOT NULL,			
	[D_ADDRESS_VENDOR_1]		[VARCHAR](255) NOT NULL,			-- STREET
	[D_ADDRESS_VENDOR_2]		[VARCHAR](255) NOT NULL DEFAULT '',	-- COLONY, FRACC, 
	[C_ADDRESS_VENDOR]			[VARCHAR](255) NOT NULL DEFAULT '',
	[O_ADDRESS_VENDOR]			[INT] NOT NULL DEFAULT 10,
	-- ============================
	[CITY]						[VARCHAR](100)	NULL DEFAULT '', 
	[STATE_GEO]					[VARCHAR](100)	NULL DEFAULT '', 
	[POSTAL_CODE]				[VARCHAR](10)	NULL DEFAULT '',
	[NUMBER_EXTERIOR]			[VARCHAR](10)	NULL DEFAULT '',
	[NUMBER_INSIDE]				[VARCHAR](10)	NULL DEFAULT ''
	-- ============================
--	[K_STATE_GEO]				[INT] NOT NULL,	
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[ADDRESS_VENDOR]
	ADD CONSTRAINT [PK_ADDRESS_VENDOR]
		PRIMARY KEY CLUSTERED ([K_ADDRESS_VENDOR])
GO

--ALTER TABLE [dbo].[ADDRESS_VENDOR] ADD 
--	CONSTRAINT [FK_ADDRESS_VENDOR_01] 
--		FOREIGN KEY ( K_VENDOR ) 
--		REFERENCES [dbo].[VENDOR] (K_VENDOR )	
--	ON DELETE CASCADE
--GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[ADDRESS_VENDOR] 
	ADD		[K_USUARIO_ALTA]			[INT] NOT NULL,
			[F_ALTA]					[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]			[INT] NOT NULL,
			[F_CAMBIO]					[DATETIME] NOT NULL,
			[L_BORRADO]					[INT] NOT NULL,
			[K_USUARIO_BAJA]			[INT] NULL,
			[F_BAJA]					[DATETIME] NULL;
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////