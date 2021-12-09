-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			HEADER_PURCHASE_ORDER
-- // OPERATION:		TABLE
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200224
-- ////////////////////////////////////////////////////////////// 

-- USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOG_HEADER_PURCHASE_ORDER]') AND type in (N'U'))
	DROP TABLE [dbo].[LOG_HEADER_PURCHASE_ORDER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOG_DETAILS_PURCHASE_ORDER]') AND type in (N'U'))
	DROP TABLE [dbo].[LOG_DETAILS_PURCHASE_ORDER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DETAILS_BLANKET_PURCHASE_ORDER]') AND type in (N'U'))
	DROP TABLE [dbo].[DETAILS_BLANKET_PURCHASE_ORDER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DETAILS_PURCHASE_ORDER]') AND type in (N'U'))
	DROP TABLE [dbo].[DETAILS_PURCHASE_ORDER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEADER_PURCHASE_ORDER]') AND type in (N'U'))
	DROP TABLE [dbo].[HEADER_PURCHASE_ORDER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STATUS_PURCHASE_ORDER]') AND type in (N'U'))
	DROP TABLE [dbo].[STATUS_PURCHASE_ORDER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DELIVERY_PURCHASE_ORDER]') AND type in (N'U'))
	DROP TABLE [dbo].[DELIVERY_PURCHASE_ORDER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PO_COMENTARIO_LOG]') AND type in (N'U'))
	DROP TABLE [dbo].[PO_COMENTARIO_LOG]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PO_PRICE_LOG]') AND type in (N'U'))
	DROP TABLE [dbo].[PO_PRICE_LOG]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PO_PARTIAL_CLOSED_LOG]') AND type in (N'U'))
	DROP TABLE [dbo].[PO_PARTIAL_CLOSED_LOG]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FILTRO_ORDENES_COMPLETAS]') AND type in (N'U'))
	DROP TABLE [dbo].[FILTRO_ORDENES_COMPLETAS]
GO


-- //////////////////////////////////////////////////////////////
-- // COMENTARIO_LOG PARA EL CIERRE PARCIAL DE PO
-- //////////////////////////////////////////////////////////////
CREATE TABLE [dbo].[FILTRO_ORDENES_COMPLETAS] (
	[K_FILTRO_ORDENES_COMPLETAS]		[INT]	NOT NULL,
	-- =================================	
	[D_FILTRO_ORDENES_COMPLETAS]			[VARCHAR](MAX)	NOT NULL DEFAULT'',
	[S_FILTRO_ORDENES_COMPLETAS]			[VARCHAR](MAX)	NOT NULL DEFAULT'',
	-- =================================
	[C_FILTRO_ORDENES_COMPLETAS]			[VARCHAR](MAX)	NOT NULL DEFAULT'',
	[O_FILTRO_ORDENES_COMPLETAS]			INT DEFAULT 10,
	[L_FILTRO_ORDENES_COMPLETAS]			INT DEFAULT 1,	
	-- =================================	
)ON [PRIMARY]	
GO
-- //////////////////////////////////////////////////////
ALTER TABLE [dbo].[FILTRO_ORDENES_COMPLETAS]
	ADD CONSTRAINT [PK_FILTRO_ORDENES_COMPLETAS]
		PRIMARY KEY CLUSTERED ([K_FILTRO_ORDENES_COMPLETAS])
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - FILTRO_ORDENES_COMPLETAS
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_FILTRO_ORDENES_COMPLETAS]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_FILTRO_ORDENES_COMPLETAS				INT,
	@PP_D_FILTRO_ORDENES_COMPLETAS				VARCHAR(100),
	@PP_C_FILTRO_ORDENES_COMPLETAS				VARCHAR(255),
	@PP_S_FILTRO_ORDENES_COMPLETAS				VARCHAR(100),
	@PP_O_FILTRO_ORDENES_COMPLETAS				INT,
	@PP_L_FILTRO_ORDENES_COMPLETAS				INT
AS			
	
	-- ===========================

	INSERT INTO FILTRO_ORDENES_COMPLETAS
			(	[K_FILTRO_ORDENES_COMPLETAS], [D_FILTRO_ORDENES_COMPLETAS], 
				[C_FILTRO_ORDENES_COMPLETAS], [S_FILTRO_ORDENES_COMPLETAS], 
				[O_FILTRO_ORDENES_COMPLETAS], [L_FILTRO_ORDENES_COMPLETAS]		)
	VALUES	
			(	@PP_K_FILTRO_ORDENES_COMPLETAS, @PP_D_FILTRO_ORDENES_COMPLETAS, 
				@PP_C_FILTRO_ORDENES_COMPLETAS, @PP_S_FILTRO_ORDENES_COMPLETAS,
				@PP_O_FILTRO_ORDENES_COMPLETAS, @PP_L_FILTRO_ORDENES_COMPLETAS	 )
GO


--EXECUTE [dbo].[PG_CI_FILTRO_ORDENES_COMPLETAS] 0,0,0, '( SIN DEFINIR )',		'', '', 00,0
EXECUTE [dbo].[PG_CI_FILTRO_ORDENES_COMPLETAS] 0,0,1, 'PURCHASES',			'', '', 10,1
EXECUTE [dbo].[PG_CI_FILTRO_ORDENES_COMPLETAS] 0,0,2, 'PAYMENTS',			'', '', 20,1
GO



-- //////////////////////////////////////////////////////////////
-- // COMENTARIO_LOG PARA EL CIERRE PARCIAL DE PO
-- //////////////////////////////////////////////////////////////
CREATE TABLE [dbo].[PO_PARTIAL_CLOSED_LOG] (
	[K_PO_PARTIAL_CLOSED_LOG]			[INT] IDENTITY (1,1)	NOT NULL,
	-- =================================	
	[K_HEADER_PURCHASE_ORDER]			[INT]			NOT NULL,
	[C_PO_PARTIAL_CLOSED_LOG]			[VARCHAR](MAX)	NOT NULL DEFAULT'',
	-- =================================
	[K_USUARIO]							[INT]			NOT NULL,
	[F_PO_PARTIAL_CLOSED_LOG]			[DATETIME]		NOT NULL
	-- =================================	
)ON [PRIMARY]	
GO
-- //////////////////////////////////////////////////////
ALTER TABLE [dbo].[PO_PARTIAL_CLOSED_LOG]
	ADD CONSTRAINT [PK_PO_PARTIAL_CLOSED_LOG]
		PRIMARY KEY CLUSTERED ([K_PO_PARTIAL_CLOSED_LOG])
GO

-- //////////////////////////////////////////////////////////////
-- // COMENTARIO_LOG	AL CAMBIO DE PRECIO
-- //////////////////////////////////////////////////////////////
CREATE TABLE [dbo].[PO_PRICE_LOG] (
	[K_PO_PRICE_LOG]					[INT] IDENTITY (1,1)	NOT NULL,
	-- =================================	
	[K_PO_PRICE]						[INT]			NOT NULL,
	[K_ITEM]							[INT]			NOT NULL,
	[UNIT_PRICE]						[DECIMAL] (10,4) NOT NULL,
	[C_PO_PRICE_LOG]					[VARCHAR](MAX)	NOT NULL DEFAULT '',
	-- =================================
	[K_USUARIO]							[INT]			NOT NULL,
	[F_CHANGE_PRICE]					[DATETIME]		NOT NULL
	-- =================================	
)ON [PRIMARY]	
GO
-- //////////////////////////////////////////////////////
ALTER TABLE [dbo].[PO_PRICE_LOG]
	ADD CONSTRAINT [PK_PO_PRICE_LOG]
		PRIMARY KEY CLUSTERED ([K_PO_PRICE_LOG])
GO

--		ALTER TABLE [dbo].[PO_PRICE_LOG]										
--		ADD		[UNIT_PRICE_HISTORY]	[DECIMAL] (10,4) NOT NULL DEFAULT 0
--		GO																		
-- //////////////////////////////////////////////////////////////
-- // PUESTO_COMENTARIO_LOG
-- //////////////////////////////////////////////////////////////
CREATE TABLE [dbo].[PO_COMENTARIO_LOG] (
	[K_PO_COMENTARIO_LOG]				[INT] IDENTITY (1,1)	NOT NULL,
	-- =================================	
	[K_HEADER_PURCHASE_ORDER]			[INT]			NOT NULL,
	[C_PO_COMENTARIO_LOG]				[VARCHAR](MAX)	NOT NULL,
	-- =================================
	[K_USUARIO]							[INT]			NOT NULL,
	[F_COMENTARIO]						[DATETIME]		NOT NULL
	-- =================================	
)ON [PRIMARY]	
GO
-- //////////////////////////////////////////////////////
ALTER TABLE [dbo].[PO_COMENTARIO_LOG]
	ADD CONSTRAINT [PK_PO_COMENTARIO_LOG]
		PRIMARY KEY CLUSTERED ([K_PO_COMENTARIO_LOG])
GO

-- ////////////////////////////////////////////////////////////////
-- //					DELIVERY_PURCHASE_ORDER				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[DELIVERY_PURCHASE_ORDER] (
	[K_DELIVERY_PURCHASE_ORDER]				[INT]			NOT NULL,
	[D_DELIVERY_PURCHASE_ORDER]				[VARCHAR](100)	NOT NULL,
	[C_DELIVERY_PURCHASE_ORDER]				[VARCHAR](255)	NOT NULL,
	[S_DELIVERY_PURCHASE_ORDER]				[VARCHAR](100)	NOT NULL,
	[O_DELIVERY_PURCHASE_ORDER]				[INT]			NOT NULL,
	[L_DELIVERY_PURCHASE_ORDER]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[DELIVERY_PURCHASE_ORDER]
	ADD CONSTRAINT [PK_DELIVERY_PURCHASE_ORDER]
		PRIMARY KEY CLUSTERED ([K_DELIVERY_PURCHASE_ORDER])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_DELIVERY_PURCHASE_ORDER_01_DESCRIPCION] 
	   ON [dbo].[DELIVERY_PURCHASE_ORDER] ( [D_DELIVERY_PURCHASE_ORDER] )
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_DELIVERY_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_DELIVERY_PURCHASE_ORDER]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - DELIVERY_PURCHASE_ORDER
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_DELIVERY_PURCHASE_ORDER]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_DELIVERY_PURCHASE_ORDER				INT,
	@PP_D_DELIVERY_PURCHASE_ORDER				VARCHAR(100),
	@PP_C_DELIVERY_PURCHASE_ORDER				VARCHAR(255),
	@PP_S_DELIVERY_PURCHASE_ORDER				VARCHAR(100),
	@PP_O_DELIVERY_PURCHASE_ORDER				INT,
	@PP_L_DELIVERY_PURCHASE_ORDER				INT
AS			
	
	-- ===========================

	INSERT INTO DELIVERY_PURCHASE_ORDER
			(	[K_DELIVERY_PURCHASE_ORDER], [D_DELIVERY_PURCHASE_ORDER], 
				[C_DELIVERY_PURCHASE_ORDER], [S_DELIVERY_PURCHASE_ORDER], 
				[O_DELIVERY_PURCHASE_ORDER], [L_DELIVERY_PURCHASE_ORDER]		)
	VALUES	
			(	@PP_K_DELIVERY_PURCHASE_ORDER, @PP_D_DELIVERY_PURCHASE_ORDER, 
				@PP_C_DELIVERY_PURCHASE_ORDER, @PP_S_DELIVERY_PURCHASE_ORDER,
				@PP_O_DELIVERY_PURCHASE_ORDER, @PP_L_DELIVERY_PURCHASE_ORDER	 )
GO


EXECUTE [dbo].[PG_CI_DELIVERY_PURCHASE_ORDER] 0,0,0, 'SIN DEFINIR',				'', '', 00,1
EXECUTE [dbo].[PG_CI_DELIVERY_PURCHASE_ORDER] 0,0,1, 'PEARL LEATHER MÉXICO',	'', '', 10,1
EXECUTE [dbo].[PG_CI_DELIVERY_PURCHASE_ORDER] 0,0,2, 'BODEGA / WAREHOUSE',		'', '11323 Rojas Dr. EL PASO, Texas 79936', 20,1
EXECUTE [dbo].[PG_CI_DELIVERY_PURCHASE_ORDER] 0,0,3, 'DEFINED BY USER',			'', '', 30,1
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_DELIVERY_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_DELIVERY_PURCHASE_ORDER]
GO

-- ////////////////////////////////////////////////////////////////
-- //					STATUS_PURCHASE_ORDER				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[STATUS_PURCHASE_ORDER] (
	[K_STATUS_PURCHASE_ORDER]				[INT]			NOT NULL,
	[D_STATUS_PURCHASE_ORDER]				[VARCHAR](100)	NOT NULL,
	[C_STATUS_PURCHASE_ORDER]				[VARCHAR](255)	NOT NULL,
	[S_STATUS_PURCHASE_ORDER]				[VARCHAR](10)	NOT NULL,
	[O_STATUS_PURCHASE_ORDER]				[INT]			NOT NULL,
	[L_STATUS_PURCHASE_ORDER]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[STATUS_PURCHASE_ORDER]
	ADD CONSTRAINT [PK_STATUS_PURCHASE_ORDER]
		PRIMARY KEY CLUSTERED ([K_STATUS_PURCHASE_ORDER])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_STATUS_PURCHASE_ORDER_01_DESCRIPCION] 
	   ON [dbo].[STATUS_PURCHASE_ORDER] ( [D_STATUS_PURCHASE_ORDER] )
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_STATUS_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_STATUS_PURCHASE_ORDER]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - STATUS_PURCHASE_ORDER
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_STATUS_PURCHASE_ORDER]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_STATUS_PURCHASE_ORDER				INT,
	@PP_D_STATUS_PURCHASE_ORDER				VARCHAR(100),
	@PP_C_STATUS_PURCHASE_ORDER				VARCHAR(255),
	@PP_S_STATUS_PURCHASE_ORDER				VARCHAR(10),
	@PP_O_STATUS_PURCHASE_ORDER				INT,
	@PP_L_STATUS_PURCHASE_ORDER				INT
AS				
	-- ===========================
	INSERT INTO STATUS_PURCHASE_ORDER
			(	[K_STATUS_PURCHASE_ORDER], [D_STATUS_PURCHASE_ORDER], 
				[C_STATUS_PURCHASE_ORDER], [S_STATUS_PURCHASE_ORDER], 
				[O_STATUS_PURCHASE_ORDER], [L_STATUS_PURCHASE_ORDER]		)
	VALUES	
			(	@PP_K_STATUS_PURCHASE_ORDER, @PP_D_STATUS_PURCHASE_ORDER, 
				@PP_C_STATUS_PURCHASE_ORDER, @PP_S_STATUS_PURCHASE_ORDER,
				@PP_O_STATUS_PURCHASE_ORDER, @PP_L_STATUS_PURCHASE_ORDER	 )
GO

EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,00, 'CANCEL',						'', 'CANCL', 130,1		-- ACTUALIZA QUIEN LA GENERA
-- =================================================================================
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,01, 'REGISTERED',					'', 'REGIS', 10,1		-- ESTATUS INICIAL
-- =================================================================================
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,02, 'PENDING BY DEPT. MANAGER',		'', 'PNMNG', 20,1		-- ACTUALIZA GERENTE
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,03, 'DENIED BY DEPT. MANAGER',		'', 'DNMNG', 30,1
-- =================================================================================
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,04, 'PENDING BY FINANCES',			'', 'PNFIN', 40,1		-- ACTUALIZA FINANZAS
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,05, 'DENIED BY FINANCES',			'', 'DNFIN', 50,1
-- =================================================================================
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,06, 'PENDING PRINT',				'', 'PRINT', 60,1		-- ACTUALIZA AL IMPRIMIR
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,07, 'PENDING BY GENERAL MANAGER',	'', 'PNGMN', 70,1		-- ACTUALIZA FINANZAS
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,08, 'DENIED BY GENERAL MANAGER',	'', 'DNGMN', 80,1
-- =================================================================================
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,09, 'APPROVED',						'', 'APROV', 90,1		-- ACTUALIZA FINANZAS
-- =================================================================================
--EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,10, 'PENDING SEND TO VENDOR',		'', 'PNVEN', 100,1		-- ACTUALIZA FINANZAS
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,11, 'PENDING TO RECEIVE',			'', 'PNRCV', 110,1		-- ACTUALIZA FINANZAS
-- =================================================================================
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,12, 'COMPLETE ORDER RECEIVED',		'', 'COMPL', 110,1		-- ACTUALIZA FINANZAS
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,13, 'PARTIAL ORDER RECEIVED',		'', 'PRRCV', 130,1		-- ACTUALIZA FINANZAS
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,14, 'PARTIAL ORDER CLOSED',			'', 'PRCOM', 140,1		-- ACTUALIZA FINANZAS
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,15, 'RETURNED ORDER',				'', 'RETUR', 150,1		-- ACTUALIZA FINANZAS

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_STATUS_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_STATUS_PURCHASE_ORDER]
GO

-- ////////////////////////////////////////////////////////////////
-- //					PURCHASE_ORDER				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[HEADER_PURCHASE_ORDER] (
	[K_HEADER_PURCHASE_ORDER]				[INT] NOT NULL,			
	[C_PURCHASE_ORDER]						[VARCHAR](255) NOT NULL DEFAULT '',
	-- ============================
	[K_APPROVED_BY]							[INT] NOT NULL,
	[K_BLANKET]								[INT] NOT NULL DEFAULT 1,		-- #1 PO-REGULAR(UN SOLO EVENTO)	/	#2	PO-BLANKET(ORDEN ABIERTA)
	[K_CURRENCY]							[INT] NOT NULL,
	[K_DELIVERY_TO]							[INT] NOT NULL,
	[K_PLACED_BY]							[INT] NOT NULL,
	[K_STATUS_PURCHASE_ORDER]				[INT] NOT NULL,
	[K_TERMS]								[INT] NOT NULL,
	[K_VENDOR]								[INT] NOT NULL,	
	-- ============================
	[F_DATE_PURCHASE_ORDER]					[DATE] NOT NULL,
	[F_REQUIRED_PURCHASE_ORDER]				[DATE] NOT NULL,
	-- ============================
	[F_PROMISE_PURCHASE_ORDER]				[DATE] NULL,
	[F_RECEIVED_PURCHASE_ORDER]				[DATE] NULL,
	-- ============================
	[ISSUED_BY_PURCHASE_ORDER]				[VARCHAR] (150) NOT NULL,
	[REQUIRED_PURCHASE_ORDER]				[VARCHAR] (150) NOT NULL,
	[CONFIRMING_ORDER_WITH]					[VARCHAR] (150) NOT NULL,
	-- ============================
	[TAX_RATE]								[DECIMAL] (10,4) NOT NULL,
	-- ============================
	[TOTAL_ITEMS]							[INT] NOT NULL,
	[SUBTOTAL_PURCHASE_ORDER]				[DECIMAL] (10,4) NOT NULL,
	[IVA_PURCHASE_ORDER]					[DECIMAL] (10,4) NOT NULL,
	[TOTAL_PURCHASE_ORDER]					[DECIMAL] (10,4) NOT NULL,
	-- ============================
	[D_DELIVERY_TO]							[VARCHAR] (250) NOT NULL,
	[EXCHANGE_RATE]							[DECIMAL] (10,4) NOT NULL DEFAULT 0,
	[ADDITIONAL_TAXES_PURCHASE_ORDER]		[DECIMAL] (10,4) NOT NULL DEFAULT 0,
	[ADDITIONAL_DISCOUNTS_PURCHASE_ORDER]	[DECIMAL] (10,4) NOT NULL DEFAULT 0,
	[PREPAID_PURCHASE_ORDER]				[DECIMAL] (10,4) NOT NULL DEFAULT 0,
	[K_ACCOUNT_PURCHASE_ORDER]				[VARCHAR] (17) NOT NULL DEFAULT 0	
	-- ============================
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[HEADER_PURCHASE_ORDER]
	ADD CONSTRAINT [PK_HEADER_PURCHASE_ORDER]
		PRIMARY KEY CLUSTERED ([K_HEADER_PURCHASE_ORDER])	
GO

----CREATE UNIQUE NONCLUSTERED 
----	INDEX [UN_PURCHASE_ORDER_01_RFC] 
----	   ON [dbo].[PURCHASE_ORDER] ( [RFC_PURCHASE_ORDER] )
----GO

ALTER TABLE [dbo].[HEADER_PURCHASE_ORDER] ADD 
	CONSTRAINT [FK_STATUS_PURCHASE_ORDER_01] 
		FOREIGN KEY ( K_STATUS_PURCHASE_ORDER ) 
		REFERENCES [dbo].[STATUS_PURCHASE_ORDER] (K_STATUS_PURCHASE_ORDER )
	--CONSTRAINT [FK_PLACED_BY_PURCHASE_ORDER_02] 
	--	FOREIGN KEY ( K_PLACED_BY ) 
	--	REFERENCES [dbo].[PLACED_BY ] (K_PLACED_BY )	--,
	--CONSTRAINT [FK_VENDOR_PURCHASE_ORDER_03] 
	--	FOREIGN KEY ( K_VENDOR ) 
	--	REFERENCES [dbo].[VENDOR] (K_VENDOR )
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[HEADER_PURCHASE_ORDER] 
	ADD		[K_USUARIO_ALTA]			[INT] NOT NULL,
			[F_ALTA]					[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]			[INT] NOT NULL,
			[F_CAMBIO]					[DATETIME] NOT NULL,
			[L_BORRADO]					[INT] NOT NULL,
			[K_USUARIO_BAJA]			[INT] NULL,
			[F_BAJA]					[DATETIME] NULL;
GO

-- ALTER TABLE [dbo].[HEADER_PURCHASE_ORDER]						
-- 	ADD		[L_IS_BLANKET]				[INT] NOT NULL DEFAULT 0				-- AX - 20200810
-- GO																
-- ALTER TABLE [dbo].[HEADER_PURCHASE_ORDER]								
-- 	ADD		[C_INFO_QUOTATION]			[VARCHAR](500) NOT NULL DEFAULT ''		-- AX - 20200814
-- GO		
-- ALTER TABLE [dbo].[HEADER_PURCHASE_ORDER]								
-- 	ADD		[TERMS_HEADER]				[VARCHAR](500) NOT NULL DEFAULT ''		-- AX - 20200818
-- GO		
-- ALTER TABLE [dbo].[HEADER_PURCHASE_ORDER]									
-- 	ADD		[TOTAL_PURCHASE_ORDER_CLOSED]	[DECIMAL] (10,4) NOT NULL DEFAULT 0		-- AX - 20200916
-- GO		

-- ALTER TABLE [dbo].[HEADER_PURCHASE_ORDER]														
-- 	ADD		[L_RETENTION]				[INT] NOT NULL DEFAULT 0		-- AX - 20210903
-- GO		
-- ALTER TABLE [dbo].[HEADER_PURCHASE_ORDER]									
-- 	ADD		[ISR_RETEN]					[DECIMAL] (10,4) NOT NULL DEFAULT 0		-- AX - 20210903
-- GO		
-- ALTER TABLE [dbo].[HEADER_PURCHASE_ORDER]									
-- 	ADD		[IVA_RETEN]					[DECIMAL] (10,4) NOT NULL DEFAULT 0		-- AX - 20210903
-- GO		
-- ////////////////////////////////////////////////////////////////
-- //					DETAILS_PURCHASE_ORDER				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[DETAILS_PURCHASE_ORDER] (
	[K_HEADER_PURCHASE_ORDER]				[INT] NOT NULL,
	[K_DETAILS_PURCHASE_ORDER]				[INT] NOT NULL,
	-- ============================
	[K_ITEM]								[INT] NOT NULL,
	-- ============================
	[QUANTITY_ORDER]						[DECIMAL] (10,4) NOT NULL DEFAULT 1,
	-- ============================
	[K_PO_PRICE_LOG]						[INT] NOT NULL,
	[UNIT_PRICE]							[DECIMAL] (10,4) NOT NULL,
	-- ============================
	[TOTAL_PRICE]							[DECIMAL] (10,4) NOT NULL,
	-- ============================
	[QUANTITY_RECEIVED]						[DECIMAL] (10,4) NOT NULL,
	[QUANTITY_PENDING]						[DECIMAL] (10,4) NOT NULL,
) ON [PRIMARY]
GO

--	ALTER TABLE [dbo].[DETAILS_PURCHASE_ORDER]				-- AX - 20200806
--	ALTER COLUMN	[QUANTITY_ORDER]	[DECIMAL] (10,4)	-- AX - 20200806
--	ALTER TABLE [dbo].[DETAILS_PURCHASE_ORDER]				-- AX - 20200806
--	ALTER COLUMN	[QUANTITY_RECEIVED] [DECIMAL] (10,4)	-- AX - 20200806
--	ALTER TABLE [dbo].[DETAILS_PURCHASE_ORDER]				-- AX - 20200806
--	ALTER COLUMN	[QUANTITY_PENDING] [DECIMAL] (10,4)		-- AX - 20200806
															
--	ALTER TABLE [dbo].[DETAILS_PURCHASE_ORDER]
--	ADD	[K_PO_PRICE_LOG]	[INT]	NOT NULL DEFAULT 1		-- AX - 20200806

--	ALTER TABLE [dbo].[DETAILS_PURCHASE_ORDER]
--	DROP COLUMN	[DISCOUNTS_PRICE]				[DECIMAL] (10,4)	NOT NULL DEFAULT 0		-- AX - 20200821 NO SE UTILIZÓ
-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[DETAILS_PURCHASE_ORDER] ADD 
	CONSTRAINT [FK_HEADER_PURCHASE_ORDER_01] 
		FOREIGN KEY ( K_HEADER_PURCHASE_ORDER ) 
		REFERENCES [dbo].[HEADER_PURCHASE_ORDER] (K_HEADER_PURCHASE_ORDER )	--,	
	--CONSTRAINT [FK_ITEM_02] 
	--	FOREIGN KEY ( K_ITEM ) 
	--	REFERENCES [dbo].[ITEM] (K_ITEM)
GO


-- ////////////////////////////////////////////////////////////////
-- //					DETAILS_BLANKET_PURCHASE_ORDER				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[DETAILS_BLANKET_PURCHASE_ORDER] (
	[K_HEADER_PURCHASE_ORDER]				[INT] NOT NULL,
	-- ============================		-- ============================		-- ============================	
	-- CAMPOS ADICIONALES PARA BLANKET_PO
	[K_CUSTOMER]							[INT] NOT NULL,
	[D_PROGRAM]								[VARCHAR](500)	NOT NULL DEFAULT '',
	[ANNUAL_VOLUME]							[DECIMAL](10,4) NOT NULL DEFAULT 0,
	[GROSS_VEHICLE_AREA]					[DECIMAL](10,4) NOT NULL DEFAULT 0
	-- ============================
--	[K_UNIT_OF_ITEM_PRODUCTIVE]				[INT] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DETAILS_BLANKET_PURCHASE_ORDER] ADD 
	CONSTRAINT [FK_HEADER_PURCHASE_ORDER_10] 
		FOREIGN KEY ( K_HEADER_PURCHASE_ORDER ) 
		REFERENCES [dbo].[HEADER_PURCHASE_ORDER] (K_HEADER_PURCHASE_ORDER )
GO


-- ////////////////////////////////////////////////////////////////
-- //					DETAILS_PURCHASE_ORDER				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[LOG_DETAILS_PURCHASE_ORDER] (
	[K_LOG_DETAILS_PURCHASE_ORDER]			[INT] IDENTITY (1,1)	NOT NULL,
	[K_HEADER_PURCHASE_ORDER]				[INT] NOT NULL,
	[K_PO_TEMPORAL]							[INT] NOT NULL,
	-- ============================
	[K_ITEM]								[INT] NOT NULL,
	[K_STATUS_PO]							[INT] NOT NULL,
	-- ============================
	[QUANTITY_ORDER]						[DECIMAL] (10,4) NOT NULL DEFAULT 1,
	[QUANTITY_RECEIVED]						[DECIMAL] (10,4) NOT NULL,
	[QUANTITY_PENDING]						[DECIMAL] (10,4) NOT NULL,
	[QUANTITY_PENDING_ORIGINAL]				[DECIMAL] (10,4) NOT NULL
	-- ============================
) ON [PRIMARY]
GO
-- //////////////////////////////////////////////////////
ALTER TABLE [dbo].[LOG_DETAILS_PURCHASE_ORDER]		ADD		
	[K_USUARIO_ALTA]			[INT]		NOT NULL,
	[F_ALTA]					[DATETIME]	NOT NULL,
	[F_SISTEMA]					[DATETIME]	NOT NULL DEFAULT	GETDATE();
GO

	--ALTER TABLE [dbo].[LOG_DETAILS_PURCHASE_ORDER]
-- //////////////////////////////////////////////////////
-----===========================================


-- ////////////////////////////////////////////////////////////////
-- //					LOG_HEADER_PURCHASE_ORDER				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[LOG_HEADER_PURCHASE_ORDER] (
	[K_LOG_HEADER_PURCHASE_ORDER]			[INT] IDENTITY (1,1)	NOT NULL,
	[K_HEADER_PURCHASE_ORDER]				[INT] NOT NULL,
	[K_PO_TEMPORAL]							[INT] NOT NULL,
	-- ============================
	[K_STATUS_PO_ORIGINAL]					[INT] NOT NULL,
	[D_STATUS_PURCHASE_ORDER_O]				[VARCHAR](500) NOT NULL DEFAULT '',
	-- ============================
	[K_STATUS_PO_FINAL]						[INT] NOT NULL,
	[D_STATUS_PURCHASE_ORDER_F]				[VARCHAR](500) NOT NULL DEFAULT ''
) ON [PRIMARY]
GO
-- //////////////////////////////////////////////////////
ALTER TABLE [dbo].[LOG_HEADER_PURCHASE_ORDER]		ADD		
	[K_USUARIO_ALTA]			[INT]		NOT NULL,
	[F_ALTA]					[DATETIME]	NOT NULL;

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////

