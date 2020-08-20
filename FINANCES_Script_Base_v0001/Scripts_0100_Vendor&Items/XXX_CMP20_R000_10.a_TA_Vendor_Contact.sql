-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			VENDOR_CONTACT
-- // OPERATION:		TABLE
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VENDOR_CONTACT]') AND type in (N'U'))
	DROP TABLE [dbo].[VENDOR_CONTACT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TYPE_VENDOR_CONTACT]') AND type in (N'U'))
	DROP TABLE [dbo].[TYPE_VENDOR_CONTACT]
GO


-- ////////////////////////////////////////////////////////////////
-- //					TYPE_VENDOR_CONTACT				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[TYPE_VENDOR_CONTACT] (
	[K_TYPE_VENDOR_CONTACT]				[INT]			NOT NULL,
	[D_TYPE_VENDOR_CONTACT]				[VARCHAR](100)	NOT NULL,
	[C_TYPE_VENDOR_CONTACT]				[VARCHAR](255)	NOT NULL,
	[S_TYPE_VENDOR_CONTACT]				[VARCHAR](10)	NOT NULL,
	[O_TYPE_VENDOR_CONTACT]				[INT]			NOT NULL,
	[L_TYPE_VENDOR_CONTACT]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[TYPE_VENDOR_CONTACT]
	ADD CONSTRAINT [PK_TYPE_VENDOR_CONTACT]
		PRIMARY KEY CLUSTERED ([K_TYPE_VENDOR_CONTACT])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TYPE_VENDOR_CONTACT_01_DESCRIPCION] 
	   ON [dbo].[TYPE_VENDOR_CONTACT] ( [D_TYPE_VENDOR_CONTACT] )
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TYPE_VENDOR_CONTACT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TYPE_VENDOR_CONTACT]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - TYPE_VENDOR_CONTACT
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_TYPE_VENDOR_CONTACT]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_TYPE_VENDOR_CONTACT			INT,
	@PP_D_TYPE_VENDOR_CONTACT			VARCHAR(100),
	@PP_C_TYPE_VENDOR_CONTACT			VARCHAR(255),
	@PP_S_TYPE_VENDOR_CONTACT			VARCHAR(10),
	@PP_O_TYPE_VENDOR_CONTACT			INT,
	@PP_L_TYPE_VENDOR_CONTACT			INT
AS			
	
	-- ===========================

	INSERT INTO TYPE_VENDOR_CONTACT
			(	[K_TYPE_VENDOR_CONTACT], [D_TYPE_VENDOR_CONTACT], 
				[C_TYPE_VENDOR_CONTACT], [S_TYPE_VENDOR_CONTACT], 
				[O_TYPE_VENDOR_CONTACT], [L_TYPE_VENDOR_CONTACT]		)
	VALUES	
			(	@PP_K_TYPE_VENDOR_CONTACT, @PP_D_TYPE_VENDOR_CONTACT, 
				@PP_C_TYPE_VENDOR_CONTACT, @PP_S_TYPE_VENDOR_CONTACT,
				@PP_O_TYPE_VENDOR_CONTACT, @PP_L_TYPE_VENDOR_CONTACT	)
		
	-- //////////////////////////////////////////////////////////////
GO


EXECUTE [dbo].[PG_CI_TYPE_VENDOR_CONTACT]  0, 139,  0, '(TO DEFINE)'		,'' , '2DFNE', 10 , 1
EXECUTE [dbo].[PG_CI_TYPE_VENDOR_CONTACT]  0, 139,  1, 'PURCHASE'			,'' , 'PURCH', 10 , 1
EXECUTE [dbo].[PG_CI_TYPE_VENDOR_CONTACT]  0, 139,  2, 'SALES'				,'' , 'SALES', 10 , 1
GO


-- ////////////////////////////////////////////////////////////////
-- //					VENDOR_CONTACT				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[VENDOR_CONTACT] (
	[K_VENDOR]						[INT] NOT NULL,			
	[K_CONTACT]						[INT] NOT NULL,
	-- ============================
	[K_TYPE_VENDOR_CONTACT]			[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


--ALTER TABLE [dbo].[VENDOR_CONTACT]
--	ADD CONSTRAINT [PK_VENDOR_CONTACT]
--		PRIMARY KEY CLUSTERED ([K_VENDOR_CONTACT])
--GO


--CREATE UNIQUE NONCLUSTERED 
--	INDEX [UN_VENDOR_CONTACT_01_RFC] 
--	   ON [dbo].[VENDOR_CONTACT] ( [RFC_VENDOR_CONTACT] )
--GO

ALTER TABLE [dbo].[VENDOR_CONTACT] ADD 
	CONSTRAINT [FK_TYPE_VENDOR_CONTACT_01] 
		FOREIGN KEY ( K_TYPE_VENDOR_CONTACT ) 
		REFERENCES [dbo].[TYPE_VENDOR_CONTACT] (K_TYPE_VENDOR_CONTACT )
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[VENDOR_CONTACT] 
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
