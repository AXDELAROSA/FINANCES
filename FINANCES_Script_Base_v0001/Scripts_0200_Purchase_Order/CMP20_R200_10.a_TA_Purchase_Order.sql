-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			HEADER_PURCHASE_ORDER
-- // OPERATION:		TABLE
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200224
-- ////////////////////////////////////////////////////////////// 

USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DETAILS_PURCHASE_ORDER]') AND type in (N'U'))
	DROP TABLE [dbo].[DETAILS_PURCHASE_ORDER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEADER_PURCHASE_ORDER]') AND type in (N'U'))
	DROP TABLE [dbo].[HEADER_PURCHASE_ORDER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STATUS_PURCHASE_ORDER]') AND type in (N'U'))
	DROP TABLE [dbo].[STATUS_PURCHASE_ORDER]
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


EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,1, 'PRE-REGISTERED',		'', 'PRERE', 10,1
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,2, 'CANCEL',				'', 'CANCL', 20,1
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,3, 'PRE-AUTHORIZED DPT',	'', 'AUDPT', 30,1
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,4, 'PRE-AUTHORIZED FIN',	'', 'AUFIN', 40,1
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,5, 'PRE-AUTHORIZED MGM',	'', 'AUMGM', 50,1
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,6, 'DENIED',				'', 'DNIED', 60,1
EXECUTE [dbo].[PG_CI_STATUS_PURCHASE_ORDER] 0,0,7, 'APPROVED',				'', 'APROV', 70,1
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
	[K_STATUS_PURCHASE_ORDER]				[INT] NOT NULL,
	-- ============================
	[F_DATE_PURCHASE_ORDER]					[DATE] NOT NULL,
	[F_REQUIRED_PURCHASE_ORDER]				[DATE] NOT NULL,
	-- ============================
	[ISSUED_BY_PURCHASE_ORDER]				[VARCHAR] (150) NOT NULL,
	[REQUIRED_PURCHASE_ORDER]				[VARCHAR] (150) NOT NULL,
	[K_PLACED_BY]							[INT] NOT NULL,
	-- ============================
	[DELIVERY_TO]							[VARCHAR] (500)NOT NULL,
	[CONFIRMING_ORDER_WITH]					[VARCHAR] (150) NOT NULL,
	[K_VENDOR]								[INT] NOT NULL,
	-- ============================
	[K_TERMS]								[INT] NOT NULL,
	[K_CURRENCY]							[INT] NOT NULL,
	[TAX_RATE]								[DECIMAL] (10,4) NOT NULL,
	[ADDITIONAL_TAXES_PURCHASE_ORDER]		[DECIMAL] (10,4) NOT NULL,
	[ADDITIONAL_DISCOUNTS_PURCHASE_ORDER]	[DECIMAL] (10,4) NOT NULL,
	[PREPAID_PURCHASE_ORDER]				[DECIMAL] (10,4) NOT NULL,
	-- ============================
	[SUBTOTAL_PURCHASE_ORDER]				[DECIMAL] (10,4) NOT NULL,
	[TOTAL_PURCHASE_ORDER]					[DECIMAL] (10,4) NOT NULL,
	-- ============================
	[ACCOUNT_PURCHASE_ORDER]				[VARCHAR] (17) NOT NULL DEFAULT ''	
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
		REFERENCES [dbo].[STATUS_PURCHASE_ORDER] (K_STATUS_PURCHASE_ORDER ),
	CONSTRAINT [FK_PLACED_BY_PURCHASE_ORDER_02] 
		FOREIGN KEY ( K_PLACED_BY ) 
		REFERENCES [dbo].[PLACED_BY ] (K_PLACED_BY )	--,
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


-- ////////////////////////////////////////////////////////////////
-- //					DETAILS_PURCHASE_ORDER				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[DETAILS_PURCHASE_ORDER] (
	[K_HEADER_PURCHASE_ORDER]				[INT] NOT NULL,
	[K_DETAILS_PURCHASE_ORDER]				[INT] NOT NULL,
	-- ============================
	[K_ITEM]								[INT] NOT NULL,
	[QUANTITY_ORDER]						[DECIMAL] (10,4) NOT NULL,
	[K_UNIT_OF_ITEM]						[INT] NOT NULL,
	[PART_NUMBER_ITEM_VENDOR]				[VARCHAR](250)	NOT NULL DEFAULT '0',
	[PART_NUMBER_ITEM_PEARL]				[VARCHAR](250)	NOT NULL DEFAULT '0',
	-- ============================
	[UNIT_PRICE]							[DECIMAL] (10,4) NOT NULL,
	[TOTAL_PRICE]							[DECIMAL] (10,4) NOT NULL,
	-- ============================
	[QUANTITY_RECEIVED]						[DECIMAL] (10,4) NOT NULL,
	[QUANTITY_REJECTED]						[DECIMAL] (10,4) NOT NULL	
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[DETAILS_PURCHASE_ORDER]
	ADD CONSTRAINT [PK_DETAILS_PURCHASE_ORDER]
		PRIMARY KEY CLUSTERED ([K_DETAILS_PURCHASE_ORDER])	
GO

----CREATE UNIQUE NONCLUSTERED 
----	INDEX [UN_PURCHASE_ORDER_01_RFC] 
----	   ON [dbo].[PURCHASE_ORDER] ( [RFC_PURCHASE_ORDER] )
----GO

ALTER TABLE [dbo].[DETAILS_PURCHASE_ORDER] ADD 
	CONSTRAINT [FK_HEADER_PURCHASE_ORDER_01] 
		FOREIGN KEY ( K_HEADER_PURCHASE_ORDER ) 
		REFERENCES [dbo].[HEADER_PURCHASE_ORDER] (K_HEADER_PURCHASE_ORDER )	--,	
	--CONSTRAINT [FK_ITEM_02] 
	--	FOREIGN KEY ( K_ITEM ) 
	--	REFERENCES [dbo].[ITEM] (K_ITEM)
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[DETAILS_PURCHASE_ORDER] 
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