-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			VENDOR_ADDRES
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VENDOR_ADDRES]') AND type in (N'U'))
	DROP TABLE [dbo].[VENDOR_ADDRES]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TYPE_VENDOR_ADDRES]') AND type in (N'U'))
	DROP TABLE [dbo].[TYPE_VENDOR_ADDRES]
GO


-- ////////////////////////////////////////////////////////////////
-- //					TYPE_VENDOR_ADDRES				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[TYPE_VENDOR_ADDRES] (
	[K_TYPE_VENDOR_ADDRES]				[INT]			NOT NULL,
	[D_TYPE_VENDOR_ADDRES]				[VARCHAR](100)	NOT NULL,
	[C_TYPE_VENDOR_ADDRES]				[VARCHAR](255)	NOT NULL,
	[S_TYPE_VENDOR_ADDRES]				[VARCHAR](10)	NOT NULL,
	[O_TYPE_VENDOR_ADDRES]				[INT]			NOT NULL,
	[L_TYPE_VENDOR_ADDRES]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[TYPE_VENDOR_ADDRES]
	ADD CONSTRAINT [PK_TYPE_VENDOR_ADDRES]
		PRIMARY KEY CLUSTERED ([K_TYPE_VENDOR_ADDRES])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TYPE_VENDOR_ADDRES_01_DESCRIPCION] 
	   ON [dbo].[TYPE_VENDOR_ADDRES] ( [D_TYPE_VENDOR_ADDRES] )
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TYPE_VENDOR_ADDRES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TYPE_VENDOR_ADDRES]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - TYPE_VENDOR_ADDRES
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_TYPE_VENDOR_ADDRES]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_TYPE_VENDOR_ADDRES			INT,
	@PP_D_TYPE_VENDOR_ADDRES			VARCHAR(100),
	@PP_C_TYPE_VENDOR_ADDRES			VARCHAR(255),
	@PP_S_TYPE_VENDOR_ADDRES			VARCHAR(10),
	@PP_O_TYPE_VENDOR_ADDRES			INT,
	@PP_L_TYPE_VENDOR_ADDRES			INT
AS			
	
	-- ===========================

	INSERT INTO TYPE_VENDOR_ADDRES
			(	[K_TYPE_VENDOR_ADDRES], [D_TYPE_VENDOR_ADDRES], 
				[C_TYPE_VENDOR_ADDRES], [S_TYPE_VENDOR_ADDRES], 
				[O_TYPE_VENDOR_ADDRES], [L_TYPE_VENDOR_ADDRES]		)
	VALUES	
			(	@PP_K_TYPE_VENDOR_ADDRES, @PP_D_TYPE_VENDOR_ADDRES, 
				@PP_C_TYPE_VENDOR_ADDRES, @PP_S_TYPE_VENDOR_ADDRES,
				@PP_O_TYPE_VENDOR_ADDRES, @PP_L_TYPE_VENDOR_ADDRES	)
		
	-- //////////////////////////////////////////////////////////////
GO


EXECUTE [dbo].[PG_CI_TYPE_VENDOR_ADDRES]  0, 139,  0, '(TO DEFINE)'			,'' , '2DFNE', 10 , 1
EXECUTE [dbo].[PG_CI_TYPE_VENDOR_ADDRES]  0, 139,  1, 'FISCAL'				,'' , 'FISCL', 10 , 1
EXECUTE [dbo].[PG_CI_TYPE_VENDOR_ADDRES]  0, 139,  2, 'OFFICE'				,'' , 'OFFIC', 10 , 1
EXECUTE [dbo].[PG_CI_TYPE_VENDOR_ADDRES]  0, 139,  3, 'WAREHOUSE'			,'' , 'WRHOU', 10 , 1
GO


-- ////////////////////////////////////////////////////////////////
-- //					VENDOR_ADDRES				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[VENDOR_ADDRES] (
	[K_VENDOR]						[INT] NOT NULL,			
	[K_ADDRESS]						[INT] NOT NULL,
	-- ============================
	[K_TYPE_VENDOR_ADDRES]			[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


--ALTER TABLE [dbo].[VENDOR_ADDRES]
--	ADD CONSTRAINT [PK_VENDOR_ADDRES]
--		PRIMARY KEY CLUSTERED ([K_VENDOR_ADDRES])
--GO


--CREATE UNIQUE NONCLUSTERED 
--	INDEX [UN_VENDOR_ADDRES_01_RFC] 
--	   ON [dbo].[VENDOR_ADDRES] ( [RFC_VENDOR_ADDRES] )
--GO

ALTER TABLE [dbo].[VENDOR_ADDRES] ADD 
	CONSTRAINT [FK_TYPE_VENDOR_ADDRES_01] 
		FOREIGN KEY ( K_TYPE_VENDOR_ADDRES ) 
		REFERENCES [dbo].[TYPE_VENDOR_ADDRES] (K_TYPE_VENDOR_ADDRES )
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[VENDOR_ADDRES] 
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
