-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			ITEMS
-- // OPERATION:		TABLA
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200206
-- ////////////////////////////////////////////////////////////// 

USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ITEM]') AND type in (N'U'))
	DROP TABLE [dbo].[ITEM]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UNIT_OF_ITEM]') AND type in (N'U'))
	DROP TABLE [dbo].[UNIT_OF_ITEM]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TYPE_ITEM]') AND type in (N'U'))
	DROP TABLE [dbo].[TYPE_ITEM]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STATUS_ITEM]') AND type in (N'U'))
	DROP TABLE [dbo].[STATUS_ITEM]
GO




-- ////////////////////////////////////////////////////////////////
-- //					STATUS_ITEM				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[STATUS_ITEM] (
	[K_STATUS_ITEM]				[INT]			NOT NULL,
	[D_STATUS_ITEM]				[VARCHAR](100)	NOT NULL,
	[C_STATUS_ITEM]				[VARCHAR](255)	NOT NULL,
	[S_STATUS_ITEM]				[VARCHAR](10)	NOT NULL,
	[O_STATUS_ITEM]				[INT]			NOT NULL,
	[L_STATUS_ITEM]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[STATUS_ITEM]
	ADD CONSTRAINT [PK_STATUS_ITEM]
		PRIMARY KEY CLUSTERED ([K_STATUS_ITEM])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_STATUS_ITEM_01_DESCRIPCION] 
	   ON [dbo].[STATUS_ITEM] ( [D_STATUS_ITEM] )
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_STATUS_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_STATUS_ITEM]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - STATUS_ITEM
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_STATUS_ITEM]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_STATUS_ITEM				INT,
	@PP_D_STATUS_ITEM				VARCHAR(100),
	@PP_C_STATUS_ITEM				VARCHAR(255),
	@PP_S_STATUS_ITEM				VARCHAR(10),
	@PP_O_STATUS_ITEM				INT,
	@PP_L_STATUS_ITEM				INT
AS			
	
	-- ===========================

	INSERT INTO STATUS_ITEM
			(	[K_STATUS_ITEM], [D_STATUS_ITEM], 
				[C_STATUS_ITEM], [S_STATUS_ITEM], 
				[O_STATUS_ITEM], [L_STATUS_ITEM]		)
	VALUES	
			(	@PP_K_STATUS_ITEM, @PP_D_STATUS_ITEM, 
				@PP_C_STATUS_ITEM, @PP_S_STATUS_ITEM,
				@PP_O_STATUS_ITEM, @PP_L_STATUS_ITEM	 )
GO


EXECUTE [dbo].[PG_CI_STATUS_ITEM] 0,139,1, 'ACTIVO',			'', 'ACTVO', 10,1
EXECUTE [dbo].[PG_CI_STATUS_ITEM] 0,139,2, 'INACTIVO',			'', 'INACT', 20,1
GO





-- ////////////////////////////////////////////////////////////////
-- //					TYPE_ITEM				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[TYPE_ITEM] (
	[K_TYPE_ITEM]				[INT]			NOT NULL,
	[D_TYPE_ITEM]				[VARCHAR](100)	NOT NULL,
	[C_TYPE_ITEM]				[VARCHAR](255)	NOT NULL,
	[S_TYPE_ITEM]				[VARCHAR](10)	NOT NULL,
	[O_TYPE_ITEM]				[INT]			NOT NULL,
	[L_TYPE_ITEM]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[TYPE_ITEM]
	ADD CONSTRAINT [PK_TYPE_ITEM]
		PRIMARY KEY CLUSTERED ([K_TYPE_ITEM])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TYPE_ITEM_01_DESCRIPCION] 
	   ON [dbo].[TYPE_ITEM] ( [D_TYPE_ITEM] )
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TYPE_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TYPE_ITEM]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - TYPE_ITEM
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_TYPE_ITEM]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_TYPE_ITEM			INT,
	@PP_D_TYPE_ITEM			VARCHAR(100),
	@PP_C_TYPE_ITEM			VARCHAR(255),
	@PP_S_TYPE_ITEM			VARCHAR(10),
	@PP_O_TYPE_ITEM			INT,
	@PP_L_TYPE_ITEM			INT
AS			
	
	-- ===========================

	INSERT INTO TYPE_ITEM
			(	[K_TYPE_ITEM], [D_TYPE_ITEM], 
				[C_TYPE_ITEM], [S_TYPE_ITEM], 
				[O_TYPE_ITEM], [L_TYPE_ITEM]		)
	VALUES	
			(	@PP_K_TYPE_ITEM, @PP_D_TYPE_ITEM, 
				@PP_C_TYPE_ITEM, @PP_S_TYPE_ITEM,
				@PP_O_TYPE_ITEM, @PP_L_TYPE_ITEM	)
		
	-- //////////////////////////////////////////////////////////////
GO


EXECUTE [dbo].[PG_CI_TYPE_ITEM]  0, 139,  0, '(POR DEFINIR)'	,'' , 'XDFNR', 10 , 1
EXECUTE [dbo].[PG_CI_TYPE_ITEM]  0, 139,  1, 'PRODUCTO'			,'' , 'PRODC', 10 , 1
EXECUTE [dbo].[PG_CI_TYPE_ITEM]  0, 139,  2, 'SERVICIO'			,'' , 'SERVI', 10 , 1
GO

-- ////////////////////////////////////////////////////////////////
-- //					UNIT_CLASS				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[UNIT_CLASS] (
	[K_UNIT_CLASS]				[INT]			NOT NULL,
	[D_UNIT_CLASS]				[VARCHAR](100)	NOT NULL,
	[C_UNIT_CLASS]				[VARCHAR](255)	NOT NULL,
	[S_UNIT_CLASS]				[VARCHAR](10)	NOT NULL,
	[O_UNIT_CLASS]				[INT]			NOT NULL,
	[L_UNIT_CLASS]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[UNIT_CLASS]
	ADD CONSTRAINT [PK_UNIT_CLASS]
		PRIMARY KEY CLUSTERED ([K_UNIT_CLASS])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_UNIT_CLASS_01_DESCRIPCION] 
	   ON [dbo].[UNIT_CLASS] ( [D_UNIT_CLASS] )
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_UNIT_CLASS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_UNIT_CLASS]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - UNIT_CLASS
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_UNIT_CLASS]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_UNIT_CLASS			INT,
	@PP_D_UNIT_CLASS			VARCHAR(100),
	@PP_C_UNIT_CLASS			VARCHAR(255),
	@PP_S_UNIT_CLASS			VARCHAR(10),
	@PP_O_UNIT_CLASS			INT,
	@PP_L_UNIT_CLASS			INT
AS			
	
	-- ===========================

	INSERT INTO UNIT_CLASS
			(	[K_UNIT_CLASS], [D_UNIT_CLASS], 
				[C_UNIT_CLASS], [S_UNIT_CLASS], 
				[O_UNIT_CLASS], [L_UNIT_CLASS]		)
	VALUES	
			(	@PP_K_UNIT_CLASS, @PP_D_UNIT_CLASS, 
				@PP_C_UNIT_CLASS, @PP_S_UNIT_CLASS,
				@PP_O_UNIT_CLASS, @PP_L_UNIT_CLASS	)
		
	-- //////////////////////////////////////////////////////////////
GO

EXECUTE [dbo].[PG_CI_UNIT_CLASS]  0, 139,  0, '(POR DEFINIR)'	,''	, 'XDFNR', 10 , 1
EXECUTE [dbo].[PG_CI_UNIT_CLASS]  0, 139,  1, 'CAPACIDAD'		,''	, 'CAPAC', 10 , 1
EXECUTE [dbo].[PG_CI_UNIT_CLASS]  0, 139,  2, 'LONGITUD'		,''	, 'LONGI', 10 , 1
EXECUTE [dbo].[PG_CI_UNIT_CLASS]  0, 139,  3, 'PESO'			,''	, 'PESO' , 10 , 1
EXECUTE [dbo].[PG_CI_UNIT_CLASS]  0, 139,  4, 'SUPERFICIE'		,''	, 'SUPRF', 10 , 1
EXECUTE [dbo].[PG_CI_UNIT_CLASS]  0, 139,  5, 'VOLUMEN'			,''	, 'VOLUM', 10 , 1
GO



-- ////////////////////////////////////////////////////////////////
-- //					UNIT_OF_ITEM				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[UNIT_OF_ITEM] (
	[K_UNIT_OF_ITEM]			[INT]			NOT NULL,
	[D_UNIT_OF_ITEM]			[VARCHAR](100)	NOT NULL,
	[C_UNIT_OF_ITEM]			[VARCHAR](255)	NOT NULL,
	[S_UNIT_OF_ITEM]			[VARCHAR](10)	NOT NULL,
	[O_UNIT_OF_ITEM]			[INT]			NOT NULL,
	[L_UNIT_OF_ITEM]			[INT]			NOT NULL,
	-- ===========================
	[K_UNIT_CLASS]				[INT]			NOT NULL,
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[UNIT_OF_ITEM]
	ADD CONSTRAINT [PK_UNIT_OF_ITEM]
		PRIMARY KEY CLUSTERED ([K_UNIT_OF_ITEM])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_UNIT_OF_ITEM_01_DESCRIPCION] 
	   ON [dbo].[UNIT_OF_ITEM] ( [D_UNIT_OF_ITEM] )
GO

ALTER TABLE [dbo].[UNIT_OF_ITEM] ADD 
	CONSTRAINT [FK_UNIT_CLASS_01] 
		FOREIGN KEY ( [K_UNIT_CLASS] ) 
		REFERENCES [dbo].[UNIT_CLASS] ( [K_UNIT_CLASS] )
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_UNIT_OF_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_UNIT_OF_ITEM]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - UNIT_OF_ITEM
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_UNIT_OF_ITEM]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_UNIT_OF_ITEM			INT,
	@PP_D_UNIT_OF_ITEM			VARCHAR(100),
	@PP_C_UNIT_OF_ITEM			VARCHAR(255),
	@PP_S_UNIT_OF_ITEM			VARCHAR(10),
	@PP_O_UNIT_OF_ITEM			INT,
	@PP_L_UNIT_OF_ITEM			INT,
	-- ===========================
	@PP_K_UNIT_CLASS			INT
AS			
	
	-- ===========================

	INSERT INTO UNIT_OF_ITEM
			(	[K_UNIT_OF_ITEM], [D_UNIT_OF_ITEM], 
				[C_UNIT_OF_ITEM], [S_UNIT_OF_ITEM], 
				[O_UNIT_OF_ITEM], [L_UNIT_OF_ITEM],
				[K_UNIT_CLASS]						)
	VALUES	
			(	@PP_K_UNIT_OF_ITEM, @PP_D_UNIT_OF_ITEM, 
				@PP_C_UNIT_OF_ITEM, @PP_S_UNIT_OF_ITEM,
				@PP_O_UNIT_OF_ITEM, @PP_L_UNIT_OF_ITEM,	
				@PP_K_UNIT_CLASS						)
		
	-- //////////////////////////////////////////////////////////////
GO


EXECUTE [dbo].[PG_CI_UNIT_OF_ITEM]  0, 139,  0, '(POR DEFINIR)'	,''		, 'XDFNR', 10 , 1, 0
EXECUTE [dbo].[PG_CI_UNIT_OF_ITEM]  0, 139,  1, 'KILOGRAMO'		,'kg'	, 'KILOG', 10 , 1, 3
EXECUTE [dbo].[PG_CI_UNIT_OF_ITEM]  0, 139,  2, 'LIBRA'			,'lb'	, 'LITRO', 10 , 1, 3
EXECUTE [dbo].[PG_CI_UNIT_OF_ITEM]  0, 139,  3, 'LITRO'			,'L'	, 'LITRO', 10 , 1, 1
EXECUTE [dbo].[PG_CI_UNIT_OF_ITEM]  0, 139,  4, 'METRO'			,'m'	, 'METRO', 10 , 1, 2
EXECUTE [dbo].[PG_CI_UNIT_OF_ITEM]  0, 139,  5, 'GALON'			,'gal'	, 'GALON', 10 , 1, 1
EXECUTE [dbo].[PG_CI_UNIT_OF_ITEM]  0, 139,  6, 'ONZA'			,'oz'	, 'ONZA',  10 , 1, 3
EXECUTE [dbo].[PG_CI_UNIT_OF_ITEM]  0, 139,  7, 'PIEZA'			,''		, 'PIEZA', 10 , 1, 0
EXECUTE [dbo].[PG_CI_UNIT_OF_ITEM]  0, 139,  8, 'PIE'			,'ft'	, 'PIE',   10 , 1, 2
EXECUTE [dbo].[PG_CI_UNIT_OF_ITEM]  0, 139,  9, 'PULGADA'		,'in'	, 'PLGAD', 10 , 1, 2
EXECUTE [dbo].[PG_CI_UNIT_OF_ITEM]  0, 139,  10, 'SERVICIO'		,''		, 'SERVI', 10 , 1, 0
GO


-- ////////////////////////////////////////////////////////////////
-- //					ITEM				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[ITEM] (
	[K_ITEM]						[INT] NOT NULL,
	[D_ITEM]						[VARCHAR](100)	NOT NULL,
	[O_ITEM]						[INT] NOT NULL,
	 -- ============================	
	[MODEL_ITEM]					[VARCHAR](100)	NOT NULL,
	[PRICE_ITEM]					[DECIMAL](10,4) NOT NULL,			
	-- ============================	
	[K_STATUS_ITEM]					[INT] NOT NULL,			
	[K_TYPE_ITEM]					[INT] NOT NULL,
	[K_UNIT_OF_ITEM]				[INT] NOT NULL,
	-- ============================	
	[K_CURRENCY]					[INT] NOT NULL,			
	[K_SUPPLIER]					[INT] NOT NULL,
	-- ============================	
	[QUANTITY_MINIMUM_REQUIERED]	[INT] NOT NULL	
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[ITEM]
	ADD CONSTRAINT [PK_ITEM]
		PRIMARY KEY CLUSTERED ([K_ITEM])
GO


ALTER TABLE [dbo].[ITEM] ADD 
	CONSTRAINT [FK_STATUS_ITEM_01] 
		FOREIGN KEY ( [K_STATUS_ITEM] ) 
		REFERENCES [dbo].[STATUS_ITEM] ( [K_STATUS_ITEM] ),
	CONSTRAINT [FK_TYPE_ITEM_02] 
		FOREIGN KEY ( [K_TYPE_ITEM] ) 
		REFERENCES [dbo].[TYPE_ITEM] ( [K_TYPE_ITEM] ),
	CONSTRAINT [FK_UNIT_OF_ITEM_03] 
		FOREIGN KEY ( [K_UNIT_OF_ITEM] ) 
		REFERENCES [dbo].[UNIT_OF_ITEM] ( [K_UNIT_OF_ITEM] ),
	CONSTRAINT [FK_CURRENCY_04] 
		FOREIGN KEY ( [K_CURRENCY] ) 
		REFERENCES [dbo].[CURRENCY] ( [K_CURRENCY] ),
	CONSTRAINT [FK_SUPPLIER_05] 
		FOREIGN KEY ( [K_SUPPLIER] ) 
		REFERENCES [dbo].[SUPPLIER] ( [K_SUPPLIER] )
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[ITEM] 
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
