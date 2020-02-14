-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			VENDOR
-- // OPERATION:		TABLE
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VENDOR]') AND type in (N'U'))
	DROP TABLE [dbo].[VENDOR]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CATEGORY_VENDOR]') AND type in (N'U'))
	DROP TABLE [dbo].[CATEGORY_VENDOR]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STATUS_VENDOR]') AND type in (N'U'))
	DROP TABLE [dbo].[STATUS_VENDOR]
GO




-- ////////////////////////////////////////////////////////////////
-- //					STATUS_VENDOR				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[STATUS_VENDOR] (
	[K_STATUS_VENDOR]				[INT]			NOT NULL,
	[D_STATUS_VENDOR]				[VARCHAR](100)	NOT NULL,
	[C_STATUS_VENDOR]				[VARCHAR](255)	NOT NULL,
	[S_STATUS_VENDOR]				[VARCHAR](10)	NOT NULL,
	[O_STATUS_VENDOR]				[INT]			NOT NULL,
	[L_STATUS_VENDOR]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[STATUS_VENDOR]
	ADD CONSTRAINT [PK_STATUS_VENDOR]
		PRIMARY KEY CLUSTERED ([K_STATUS_VENDOR])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_STATUS_VENDOR_01_DESCRIPCION] 
	   ON [dbo].[STATUS_VENDOR] ( [D_STATUS_VENDOR] )
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_STATUS_VENDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_STATUS_VENDOR]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - STATUS_VENDOR
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_STATUS_VENDOR]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_STATUS_VENDOR				INT,
	@PP_D_STATUS_VENDOR				VARCHAR(100),
	@PP_C_STATUS_VENDOR				VARCHAR(255),
	@PP_S_STATUS_VENDOR				VARCHAR(10),
	@PP_O_STATUS_VENDOR				INT,
	@PP_L_STATUS_VENDOR				INT
AS			
	
	-- ===========================

	INSERT INTO STATUS_VENDOR
			(	[K_STATUS_VENDOR], [D_STATUS_VENDOR], 
				[C_STATUS_VENDOR], [S_STATUS_VENDOR], 
				[O_STATUS_VENDOR], [L_STATUS_VENDOR]		)
	VALUES	
			(	@PP_K_STATUS_VENDOR, @PP_D_STATUS_VENDOR, 
				@PP_C_STATUS_VENDOR, @PP_S_STATUS_VENDOR,
				@PP_O_STATUS_VENDOR, @PP_L_STATUS_VENDOR	 )
GO


EXECUTE [dbo].[PG_CI_STATUS_VENDOR] 0,139,1, 'PRE-REGISTERED',	'', 'PRERE', 10,1
EXECUTE [dbo].[PG_CI_STATUS_VENDOR] 0,139,2, 'ACTIVE',			'', 'ACTVE', 20,1
EXECUTE [dbo].[PG_CI_STATUS_VENDOR] 0,139,3, 'SUSPENDED',		'', 'SUPND', 30,1
EXECUTE [dbo].[PG_CI_STATUS_VENDOR] 0,139,4, 'DROP',			'', 'DROP', 40,1
GO





-- ////////////////////////////////////////////////////////////////
-- //					CATEGORY_VENDOR				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[CATEGORY_VENDOR] (
	[K_CATEGORY_VENDOR]				[INT]			NOT NULL,
	[D_CATEGORY_VENDOR]				[VARCHAR](100)	NOT NULL,
	[C_CATEGORY_VENDOR]				[VARCHAR](255)	NOT NULL,
	[S_CATEGORY_VENDOR]				[VARCHAR](10)	NOT NULL,
	[O_CATEGORY_VENDOR]				[INT]			NOT NULL,
	[L_CATEGORY_VENDOR]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[CATEGORY_VENDOR]
	ADD CONSTRAINT [PK_CATEGORY_VENDOR]
		PRIMARY KEY CLUSTERED ([K_CATEGORY_VENDOR])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_CATEGORY_VENDOR_01_DESCRIPCION] 
	   ON [dbo].[CATEGORY_VENDOR] ( [D_CATEGORY_VENDOR] )
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_CATEGORY_VENDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_CATEGORY_VENDOR]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - CATEGORY_VENDOR
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_CATEGORY_VENDOR]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_CATEGORY_VENDOR			INT,
	@PP_D_CATEGORY_VENDOR			VARCHAR(100),
	@PP_C_CATEGORY_VENDOR			VARCHAR(255),
	@PP_S_CATEGORY_VENDOR			VARCHAR(10),
	@PP_O_CATEGORY_VENDOR			INT,
	@PP_L_CATEGORY_VENDOR			INT
AS			
	
	-- ===========================

	INSERT INTO CATEGORY_VENDOR
			(	[K_CATEGORY_VENDOR], [D_CATEGORY_VENDOR], 
				[C_CATEGORY_VENDOR], [S_CATEGORY_VENDOR], 
				[O_CATEGORY_VENDOR], [L_CATEGORY_VENDOR]		)
	VALUES	
			(	@PP_K_CATEGORY_VENDOR, @PP_D_CATEGORY_VENDOR, 
				@PP_C_CATEGORY_VENDOR, @PP_S_CATEGORY_VENDOR,
				@PP_O_CATEGORY_VENDOR, @PP_L_CATEGORY_VENDOR	)
		
	-- //////////////////////////////////////////////////////////////
GO


EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139,  0, '(POR DEFINIR)'					,'' , 'XDFNR', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139,  1, 'ABOGADOS'							,'' , 'ABOGA', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139,  2, 'ACEITES, GRASAS Y LUBRICANTES'	,'' , 'ACGRS', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139,  3, 'ALIMENTOS'						,'' , 'ALIME', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139,  4, 'ARRENDADORA'						,'' , 'ARREN', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139,  5, 'ASEGURADORA'						,'' , 'ASEGU', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139,  6, 'BANCARIO'							,'' , 'BANCA', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139,  7, 'CAPACITACIÓN'						,'' , 'CAPAC', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139,  8, 'COMUNICACIONES'					,'' , 'COMUN', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139,  9, 'CONSULTORÍA'						,'' , 'CONSU', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 10, 'CONTADURÍA'						,'' , 'CONTA', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 11, 'EQUIPO ELÉCTRICO'					,'' , 'EELEC', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 12, 'EQUIPO INDUSTRIAL'				,'' , 'EINDU', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 13, 'EQUIPO MÉDICO'					,'' , 'EMEDI', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 14, 'FARMACÉUTICO'						,'' , 'FARMA', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 15, 'HOTELES'							,'' , 'HOTEL', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 16, 'IMPRENTA'							,'' , 'IMPRE', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 17, 'LIMPIEZA'							,'' , 'LIMPI', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 18, 'LOGÍSTICA'						,'' , 'LOGIS', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 19, 'MÉDICOS'							,'' , 'MEDIC', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 20, 'MENSAJERÍA'						,'' , 'MENSA', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 21, 'MERCERÍA'							,'' , 'MERCE', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 22, 'PAPELERÍA'						,'' , 'PAPLR', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 23, 'PAQUETERÍA'						,'' , 'PAQTE', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 24, 'PRODUCTOS QUÍMICOS'				,'' , 'PQUIM', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 25, 'REFACCIONES INDUSTRIALES'			,'' , 'RFIND', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 26, 'RENTA DE EQUIPO INDUSTRIAL'		,'' , 'REEQU', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 27, 'SEGURIDAD'						,'' , 'SEGUR', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 28, 'SERIGRAFÍA'						,'' , 'SERIG', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 29, 'SERVICIO DE LABORATORIO'			,'' , 'SLABO', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 30, 'TECNOLOGÍA'						,'' , 'TCNOL', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 31, 'TEXTIL'							,'' , 'TXTIL', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 32, 'TRANSPORTE AÉREO'					,'' , 'TAERE', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORY_VENDOR]  0, 139, 33, 'TRANSPORTE TERRESTRE'				,'' , 'TTERR', 10 , 1

GO


-- ////////////////////////////////////////////////////////////////
-- //					VENDOR				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[VENDOR] (
	[K_VENDOR]						[INT] NOT NULL,			
	[D_VENDOR]						[VARCHAR](100) NOT NULL,
	[C_VENDOR]						[VARCHAR](255) NOT NULL,
	[O_VENDOR]						[INT] NOT NULL,
	-- ============================
	[BUSINESS_NAME]					[VARCHAR](100) NOT NULL, 
	[RFC_VENDOR]					[VARCHAR](100) NOT NULL,
	[EMAIL]							[VARCHAR](100) NOT NULL,
	[PHONE]							[VARCHAR](100) NOT NULL,
	[N_CREDIT_DAYS]					[INT] NULL DEFAULT 30,
	-- ============================
	[TAX_STREET]					[VARCHAR](100) NULL,
	[TAX_NUMBER_EXTERIOR]			[VARCHAR](100) NULL,
	[TAX_NUMBER_INSIDE]				[VARCHAR](100) NULL,
	[TAX_COLONY]					[VARCHAR](100) NULL ,
	[TAX_POPULATION]				[VARCHAR](100) NULL,
	[TAX_POSTAL_CODE]				[VARCHAR](100) NULL,
	[TAX_MUNICIPALITY]				[VARCHAR](100) NULL,
	[TAX_K_STATE]					[INT] NOT NULL,
	-- ============================
	[OFFICE_STREET]					[VARCHAR](100) NULL,
	[OFFICE_NUMBER_EXTERIOR]		[VARCHAR](100) NULL,
	[OFFICE_NUMBER_INSIDE]			[VARCHAR](100) NULL,
	[OFFICE_COLONY]					[VARCHAR](100) NULL ,
	[OFFICE_POPULATION]				[VARCHAR](100) NULL,
	[OFFICE_POSTAL_CODE]			[VARCHAR](100) NULL,
	[OFFICE_MUNICIPALITY]			[VARCHAR](100) NULL,
	[OFFICE_K_STATE]				[INT] NOT NULL,
	-- ============================
	[K_STATUS_VENDOR]				[INT] NOT NULL,
	[K_CATEGORY_VENDOR]				[INT] NOT NULL,
	-- ============================
	[CONTACT_SALES_NAME]			[VARCHAR](100) NULL, 
	[CONTACT_SALES_PHONE]			[VARCHAR](100) NULL,
	[CONTACT_SALES_EMAIL]			[VARCHAR](100) NULL,
	-- ============================
	[CONTACT_PAYMENTS_NAME]			[VARCHAR](100) NULL,
	[CONTACT_PAYMENTS_PHONE]		[VARCHAR](100) NULL,
	[CONTACT_PAYMENTS_EMAIL]		[VARCHAR](100) NULL,
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[VENDOR]
	ADD CONSTRAINT [PK_VENDOR]
		PRIMARY KEY CLUSTERED ([K_VENDOR])
GO


--CREATE UNIQUE NONCLUSTERED 
--	INDEX [UN_VENDOR_01_RFC] 
--	   ON [dbo].[VENDOR] ( [RFC_VENDOR] )
--GO

ALTER TABLE [dbo].[VENDOR] ADD 
	CONSTRAINT [FK_STATUS_VENDOR_01] 
		FOREIGN KEY ( K_STATUS_VENDOR ) 
		REFERENCES [dbo].[STATUS_VENDOR] (K_STATUS_VENDOR ),
	CONSTRAINT [FK_CATEGORY_VENDOR_02] 
		FOREIGN KEY ( K_CATEGORY_VENDOR ) 
		REFERENCES [dbo].[CATEGORY_VENDOR] (K_CATEGORY_VENDOR )
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[VENDOR] 
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
