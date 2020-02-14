-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		SETTINGS_GENERAL
-- // MODULE:			ALL
-- // OPERATION:		TABLA
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200213
-- ////////////////////////////////////////////////////////////// 

--USE [SETTINGS_GENERAL]
USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CONTACT]') AND type in (N'U'))
	DROP TABLE [dbo].[CONTACT]
GO


-- ////////////////////////////////////////////////////////////////
-- //					CONTACT				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[CONTACT] (
	[K_CONTACT]				[INT] NOT NULL,			
	[FIRST_NAME]			[VARCHAR](255) NOT NULL,
	[MIDDLE_NAME]			[VARCHAR](255) NOT NULL,
	[LAST_NAME]				[VARCHAR](255) NOT NULL,
	[C_CONTACT]				[VARCHAR](500) NULL,
	-- ============================
	[EMAIL]					[VARCHAR](100) NOT NULL,
	[PHONE]					[VARCHAR](25) NULL
	-- ============================
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[CONTACT]
	ADD CONSTRAINT [PK_CONTACT]
		PRIMARY KEY CLUSTERED ([K_CONTACT])
GO


--CREATE UNIQUE NONCLUSTERED 
--	INDEX [UN_CONTACT_01_RFC] 
--	   ON [dbo].[CONTACT] ( [RFC_CONTACT] )
--GO

--ALTER TABLE [dbo].[CONTACT] ADD 
--	CONSTRAINT [FK_STATE_GEO_01] 
--		FOREIGN KEY ( K_STATE_GEO ) 
--		REFERENCES [dbo].[STATE_GEO] (K_STATE_GEO )
--GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[CONTACT] 
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
