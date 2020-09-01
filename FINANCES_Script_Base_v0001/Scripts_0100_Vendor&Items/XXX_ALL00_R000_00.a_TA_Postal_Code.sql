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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POSTAL_CODE]') AND type in (N'U'))
	DROP TABLE [dbo].[POSTAL_CODE]
GO
-- select * from postal_code

-- ////////////////////////////////////////////////////////////////
-- //					POSTAL_CODE				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[POSTAL_CODE] (
	[K_POSTAL_CODE]				[INT] NOT NULL,			
	[K_COUNTRY]					[INT] NOT NULL,	
	[K_STATE_GEO]				[INT] NOT NULL,	
	[K_CITY]					[INT] NOT NULL,	
	-- ============================	
	[D_POSTAL_CODE]				[VARCHAR](255) NOT NULL,
	-- ============================
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


--ALTER TABLE [dbo].[POSTAL_CODE]
--	ADD CONSTRAINT [PK_POSTAL_CODE]
--		PRIMARY KEY CLUSTERED ([K_POSTAL_CODE])
--GO


--CREATE UNIQUE NONCLUSTERED 
--	INDEX [UN_POSTAL_CODE_01_RFC] 
--	   ON [dbo].[POSTAL_CODE] ( [RFC_POSTAL_CODE] )
--GO

--ALTER TABLE [dbo].[POSTAL_CODE] ADD 
--	CONSTRAINT [FK_STATE_GEO_01] 
--		FOREIGN KEY ( K_STATE_GEO ) 
--		REFERENCES [dbo].[STATE_GEO] (K_STATE_GEO )
--GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[POSTAL_CODE] 
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
