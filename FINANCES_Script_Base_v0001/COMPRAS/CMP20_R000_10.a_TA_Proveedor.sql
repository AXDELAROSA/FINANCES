-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			COMPRAS
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROVIDER]') AND type in (N'U'))
	DROP TABLE [dbo].[PROVIDER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CATEGORY_PROVIDER]') AND type in (N'U'))
	DROP TABLE [dbo].[CATEGORY_PROVIDER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STATUS_PROVIDER]') AND type in (N'U'))
	DROP TABLE [dbo].[STATUS_PROVIDER]
GO




-- ////////////////////////////////////////////////////////////////
-- //					STATUS_PROVIDER				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[STATUS_PROVIDER] (
	[K_STATUS_PROVIDER]				[INT]			NOT NULL,
	[D_STATUS_PROVIDER]				[VARCHAR](100)	NOT NULL,
	[C_STATUS_PROVIDER]				[VARCHAR](255)	NOT NULL,
	[S_STATUS_PROVIDER]				[VARCHAR](10)	NOT NULL,
	[O_STATUS_PROVIDER]				[INT]			NOT NULL,
	[L_STATUS_PROVIDER]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[STATUS_PROVIDER]
	ADD CONSTRAINT [PK_STATUS_PROVIDER]
		PRIMARY KEY CLUSTERED ([K_STATUS_PROVIDER])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_STATUS_PROVIDER_01_DESCRIPCION] 
	   ON [dbo].[STATUS_PROVIDER] ( [D_STATUS_PROVIDER] )
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_STATUS_PROVIDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_STATUS_PROVIDER]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - STATUS_PROVIDER
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_STATUS_PROVIDER]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_STATUS_PROVIDER				INT,
	@PP_D_STATUS_PROVIDER				VARCHAR(100),
	@PP_C_STATUS_PROVIDER				VARCHAR(255),
	@PP_S_STATUS_PROVIDER				VARCHAR(10),
	@PP_O_STATUS_PROVIDER				INT,
	@PP_L_STATUS_PROVIDER				INT
AS			
	
	-- ===========================

	INSERT INTO STATUS_PROVIDER
			(	[K_STATUS_PROVIDER], [D_STATUS_PROVIDER], 
				[C_STATUS_PROVIDER], [S_STATUS_PROVIDER], 
				[O_STATUS_PROVIDER], [L_STATUS_PROVIDER]		)
	VALUES	
			(	@PP_K_STATUS_PROVIDER, @PP_D_STATUS_PROVIDER, 
				@PP_C_STATUS_PROVIDER, @PP_S_STATUS_PROVIDER,
				@PP_O_STATUS_PROVIDER, @PP_L_STATUS_PROVIDER	 )
GO


EXECUTE [dbo].[PG_CI_STATUS_PROVIDER] 0,139,1, 'PREREGISTRO',	'', 'PREGT', 10,1
EXECUTE [dbo].[PG_CI_STATUS_PROVIDER] 0,139,2, 'ACTIVO',		'', 'ACTVO', 20,1
EXECUTE [dbo].[PG_CI_STATUS_PROVIDER] 0,139,3, 'SUSPENDIDO',	'', 'SUPND', 30,1
EXECUTE [dbo].[PG_CI_STATUS_PROVIDER] 0,139,4, 'BAJA',		'', 'BAJA', 40,1
GO





-- ////////////////////////////////////////////////////////////////
-- //					CATEGORY_PROVIDER				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[CATEGORY_PROVIDER] (
	[K_CATEGORY_PROVIDER]				[INT]			NOT NULL,
	[D_CATEGORY_PROVIDER]				[VARCHAR](100)	NOT NULL,
	[C_CATEGORY_PROVIDER]				[VARCHAR](255)	NOT NULL,
	[S_CATEGORY_PROVIDER]				[VARCHAR](10)	NOT NULL,
	[O_CATEGORY_PROVIDER]				[INT]			NOT NULL,
	[L_CATEGORY_PROVIDER]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[CATEGORY_PROVIDER]
	ADD CONSTRAINT [PK_CATEGORY_PROVIDER]
		PRIMARY KEY CLUSTERED ([K_CATEGORY_PROVIDER])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_CATEGORY_PROVIDER_01_DESCRIPCION] 
	   ON [dbo].[CATEGORY_PROVIDER] ( [D_CATEGORY_PROVIDER] )
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_CATEGORY_PROVIDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_CATEGORY_PROVIDER]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - CATEGORY_PROVIDER
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_CATEGORY_PROVIDER]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_CATEGORY_PROVIDER			INT,
	@PP_D_CATEGORY_PROVIDER			VARCHAR(100),
	@PP_C_CATEGORY_PROVIDER			VARCHAR(255),
	@PP_S_CATEGORY_PROVIDER			VARCHAR(10),
	@PP_O_CATEGORY_PROVIDER			INT,
	@PP_L_CATEGORY_PROVIDER			INT
AS			
	
	-- ===========================

	INSERT INTO CATEGORY_PROVIDER
			(	[K_CATEGORY_PROVIDER], [D_CATEGORY_PROVIDER], 
				[C_CATEGORY_PROVIDER], [S_CATEGORY_PROVIDER], 
				[O_CATEGORY_PROVIDER], [L_CATEGORY_PROVIDER]		)
	VALUES	
			(	@PP_K_CATEGORY_PROVIDER, @PP_D_CATEGORY_PROVIDER, 
				@PP_C_CATEGORY_PROVIDER, @PP_S_CATEGORY_PROVIDER,
				@PP_O_CATEGORY_PROVIDER, @PP_L_CATEGORY_PROVIDER	)
		
	-- //////////////////////////////////////////////////////////////
GO


EXECUTE [dbo].[PG_CI_CATEGORY_PROVIDER]  0, 139,  0, '(POR DEFINIR)',	'' , 'XDFNR', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_PROVIDER]  0, 139,  1, 'GAS' ,				'' , 'GAS'	, 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_PROVIDER]  0, 139,  2, 'FLETE' ,			'' , 'FLETE', 20 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_PROVIDER]  0, 139,  3, 'COMUNICACIONES' ,	'' , 'COMM', 30 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_PROVIDER]  0, 139,  4, 'MENSAJERIA' ,		'' , 'MNSJE', 40 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_PROVIDER]  0, 139,  5, 'COMPUTO' ,			'' , 'COMPT', 50 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_PROVIDER]  0, 139,  6, 'PAPELERIA' ,		'' , 'PAPEL', 60 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_PROVIDER]  0, 139,  7, 'AVION' ,			'' , 'AVION', 70 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_PROVIDER]  0, 139,  8, 'HOTELES' ,			'' , 'HOTLS', 80 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_PROVIDER]  0, 139,  9, 'ALIMENTOS' ,		'' , 'ALIMT', 90 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_PROVIDER]  0, 139, 10, 'TRANSPORTE' ,		'' , 'TRANS', 100 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_PROVIDER]  0, 139, 11, 'SUPERMERCADO' ,	'' , 'SMCDO', 110 , 1
GO


-- ////////////////////////////////////////////////////////////////
-- //					PROVIDER				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[PROVIDER] (
	[K_PROVIDER]						[INT] NOT NULL,
	[D_PROVIDER]						[VARCHAR](100) NOT NULL,
	[C_PROVIDER]						[VARCHAR](255) NOT NULL,
	[S_PROVIDER]						[VARCHAR](10) NOT NULL,
	[O_PROVIDER]						[INT] NOT NULL,
	-- ============================
	[RAZON_SOCIAL]						[VARCHAR](100) NOT NULL, 
	[RFC_PROVIDER]						[VARCHAR](100)  NOT NULL,
	[CURP]								[VARCHAR](100) NOT NULL,
	[CORREO]							[VARCHAR](100) NOT NULL,
	[TELEFONO]							[VARCHAR](100) NOT NULL,
	[N_DIAS_CREDITO]					[INT] NOT NULL,
	-- ============================
	[FISCAL_CALLE]						[VARCHAR](100) NOT NULL,
	[FISCAL_NUMERO_EXTERIOR]			[VARCHAR](100) NOT NULL,
	[FISCAL_NUMERO_INTERIOR]			[VARCHAR](100) NOT NULL,
	[FISCAL_COLONIA]					[VARCHAR](100) NOT NULL ,
	[FISCAL_POBLACION]					[VARCHAR](100) NOT NULL,
	[FISCAL_CP]							[VARCHAR](100) NOT NULL,
	[FISCAL_MUNICIPIO]					[VARCHAR](100) NOT NULL,
	[FISCAL_K_ESTADO]					[INT] NOT NULL,
	-- ============================
	[OFICINA_CALLE]						[VARCHAR](100) NOT NULL,
	[OFICINA_NUMERO_EXTERIOR]			[VARCHAR](100) NOT NULL,
	[OFICINA_NUMERO_INTERIOR]			[VARCHAR](100) NOT NULL,
	[OFICINA_COLONIA]					[VARCHAR](100) NOT NULL ,
	[OFICINA_POBLACION]					[VARCHAR](100) NOT NULL,
	[OFICINA_CP]						[VARCHAR](100) NOT NULL,
	[OFICINA_MUNICIPIO]					[VARCHAR](100) NOT NULL,
	[OFICINA_K_ESTADO]					[INT] NOT NULL,
	-- ============================
	[K_STATUS_PROVIDER]					[INT] NOT NULL,
	[K_CATEGORY_PROVIDER]				[INT] NOT NULL,
	-- ============================
	[CONTACTO_VENTA]					[VARCHAR](100) NOT NULL, 
	[CONTACTO_VENTA_TELEFONO]			[VARCHAR](100) NOT NULL,
	[CONTACTO_VENTA_CORREO]				[VARCHAR](100) NOT NULL,
	-- ============================
	[CONTACTO_PAGO]						[VARCHAR](100) NOT NULL,
	[CONTACTO_PAGO_TELEFONO]			[VARCHAR](100) NOT NULL,
	[CONTACTO_PAGO_CORREO]				[VARCHAR](100) NOT NULL,
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PROVIDER]
	ADD CONSTRAINT [PK_PROVIDER]
		PRIMARY KEY CLUSTERED ([K_PROVIDER])
GO

/*

CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_PROVIDER_01_RFC] 
	   ON [dbo].[PROVIDER] ( [RFC] )
GO

*/


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PROVIDER] 
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
