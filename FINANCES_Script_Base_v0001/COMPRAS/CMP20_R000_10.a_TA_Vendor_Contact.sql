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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CONTACT_VENDOR]') AND type in (N'U'))
	DROP TABLE [dbo].[CONTACT_VENDOR]
GO

-- ////////////////////////////////////////////////////////////////
-- //					CONTACT_VENDOR				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[CONTACT_VENDOR] (
	[K_VENDOR]					[INT] NOT NULL,		
	[K_CONTACT_VENDOR]			[INT] NOT NULL,			
	[1_FIRST_NAME]				[VARCHAR](255)	NOT NULL DEFAULT '',
	[1_MIDDLE_NAME]				[VARCHAR](255)	NOT NULL DEFAULT '',
	[2_FIRST_NAME]				[VARCHAR](255)	NOT NULL DEFAULT '',
	[2_MIDDLE_NAME]				[VARCHAR](255)	NOT NULL DEFAULT '',
	[C_CONTACT_VENDOR]			[VARCHAR](500)	NOT NULL DEFAULT '',
	-- ============================
	[1_EMAIL]					[VARCHAR](100)	NULL DEFAULT '',
	[1_PHONE]					[VARCHAR](25)	NULL DEFAULT '',
	[2_EMAIL]					[VARCHAR](100)	NULL DEFAULT '',
	[2_PHONE]					[VARCHAR](25)	NULL DEFAULT ''
	-- ============================
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[CONTACT_VENDOR]
	ADD CONSTRAINT [PK_CONTACT_VENDOR]
		PRIMARY KEY CLUSTERED ([K_CONTACT_VENDOR])
GO

ALTER TABLE [dbo].[CONTACT_VENDOR] ADD 
	CONSTRAINT [FK_CONTACT_VENDOR_01] 
		FOREIGN KEY ( K_VENDOR ) 
		REFERENCES [dbo].[VENDOR] (K_VENDOR )
	ON DELETE CASCADE
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[CONTACT_VENDOR] 
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
