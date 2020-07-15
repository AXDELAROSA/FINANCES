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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ADDRESS_GEO]') AND type in (N'U'))
	DROP TABLE [dbo].[ADDRESS_GEO]
GO


-- ////////////////////////////////////////////////////////////////
-- //					ADDRESS_GEO				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[ADDRESS_GEO] (
	[K_ADDRESS_GEO]				[INT] NOT NULL,			
	[D_ADDRESS_GEO_1]			[VARCHAR](255) NOT NULL,	--street
	[D_ADDRESS_GEO_2]			[VARCHAR](255) NOT NULL,	--colony, fracc, 
	[C_ADDRESS_GEO]				[VARCHAR](255) NOT NULL,
	[O_ADDRESS_GEO]				[INT] NOT NULL,
	-- ============================
	[CITY]						[VARCHAR](100) NOT NULL, 
	[POSTAL_CODE]				[VARCHAR](10) NULL,
	[NUMBER_EXTERIOR]			[VARCHAR](100) NULL,
	[NUMBER_INSIDE]				[VARCHAR](100) NULL,
	-- ============================
	[K_STATE_GEO]				[INT] NOT NULL,	
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[ADDRESS_GEO]
	ADD CONSTRAINT [PK_ADDRESS_GEO]
		PRIMARY KEY CLUSTERED ([K_ADDRESS_GEO])
GO


--CREATE UNIQUE NONCLUSTERED 
--	INDEX [UN_ADDRESS_GEO_01_RFC] 
--	   ON [dbo].[ADDRESS_GEO] ( [RFC_ADDRESS_GEO] )
--GO

--ALTER TABLE [dbo].[ADDRESS_GEO] ADD 
--	CONSTRAINT [FK_STATE_GEO_01] 
--		FOREIGN KEY ( K_STATE_GEO ) 
--		REFERENCES [dbo].[STATE_GEO] (K_STATE_GEO )
--GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[ADDRESS_GEO] 
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
