-- ///////////////////////////////////////////////////////////////////
-- //	PARA AGREGAR LA TABLA DE METODO DE PAGO DE LAS ORDENES DE COMPRA.
-- //	SE REALIZA:
-- //	* 
-- //	* 
-- //	* 
-- //////////////////////////////////////////////////////////////

--	PRIMERO SE ELIMINA LA COLUMNA	QUE YA NO SE UTILIZARÁ, LA CUENTA VA EN EL PAGO
--		ALTER TABLE	[dbo].[HEADER_PURCHASE_ORDER]
--		DROP COLUMN	[K_ACCOUNT_PURCHASE_ORDER]

--	SE AGREGA LA COLUMNA DEL ESTATUS DEL PAGO
-- ALTER TABLE [dbo].[HEADER_PURCHASE_ORDER]						
-- ADD		[K_STATUS_PAID_ORDER]		[INT] NOT NULL DEFAULT	10		-- AX - 20200919

--	SE ACTUALIZA EL ESTATUS DEL PAGO DE LA ORDEN PARA MOSTRAR EN EL LISTADO
--	UPDATE	[dbo].[HEADER_PURCHASE_ORDER]
--	SET	
--	    [K_STATUS_PAID_ORDER]=0
--	WHERE	[K_STATUS_PURCHASE_ORDER] IN (0,3,5,8,15)


-- PARA PRUEBAS
--	UPDATE	[dbo].[HEADER_PURCHASE_ORDER]
--	SET	
--	    [K_STATUS_PAID_ORDER]=0
--	WHERE	[L_IS_BLANKET]=1

--	SELECT TOP (1000) [K_HEADER_PURCHASE_ORDER]
--	    ,[K_STATUS_PURCHASE_ORDER]
--	    ,[K_STATUS_PAID_ORDER]
--	FROM [COMPRAS].[dbo].[HEADER_PURCHASE_ORDER]
--	
--	SELECT DISTINCT 
--	    [K_STATUS_PURCHASE_ORDER]
--	FROM [COMPRAS].[dbo].[HEADER_PURCHASE_ORDER]
--	
--	
--	SELECT * FROM STATUS_PURCHASE_ORDER
--	PARA PRUEBAS

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOG_PAYMENT]') AND type in (N'U'))
	DROP TABLE [dbo].[LOG_PAYMENT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DETAILS_PAYMENT]') AND type in (N'U'))
	DROP TABLE [dbo].[DETAILS_PAYMENT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PAYMENT]') AND type in (N'U'))
	DROP TABLE [dbo].[PAYMENT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STATUS_PAYMENT]') AND type in (N'U'))
	DROP TABLE [dbo].[STATUS_PAYMENT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STATUS_PAID_ORDER]') AND type in (N'U'))
	DROP TABLE [dbo].[STATUS_PAID_ORDER]
GO

-- //////////////////////////////////////////////////////////////
-- // STATUS_PAID_ORDER
-- //////////////////////////////////////////////////////////////
CREATE TABLE [dbo].[STATUS_PAID_ORDER] (
	[K_STATUS_PAID_ORDER]	[INT] NOT NULL,
	[D_STATUS_PAID_ORDER]	[VARCHAR] (100) NOT NULL,
	[S_STATUS_PAID_ORDER]	[VARCHAR] (10) NOT NULL,
	[O_STATUS_PAID_ORDER]	[INT] NOT NULL,
	[C_STATUS_PAID_ORDER]	[VARCHAR] (255) NOT NULL,
	[L_STATUS_PAID_ORDER]	[INT] NOT NULL
) ON [PRIMARY]
GO
-- //////////////////////////////////////////////////////////////
ALTER TABLE [dbo].[STATUS_PAID_ORDER]
	ADD CONSTRAINT [PK_STATUS_PAID_ORDER]
		PRIMARY KEY CLUSTERED ([K_STATUS_PAID_ORDER])
GO
CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_STATUS_PAID_ORDER_01_DESCRIPCION] 
	   ON [dbo].[STATUS_PAID_ORDER] ( [D_STATUS_PAID_ORDER] )
GO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_STATUS_PAID_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_STATUS_PAID_ORDER]
GO
CREATE PROCEDURE [dbo].[PG_CI_STATUS_PAID_ORDER]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	-- ========================================
	@PP_K_STATUS_PAID_ORDER		INT,
	@PP_D_STATUS_PAID_ORDER		VARCHAR(100),
	@PP_S_STATUS_PAID_ORDER		VARCHAR(10),
	@PP_O_STATUS_PAID_ORDER		INT,
	@PP_C_STATUS_PAID_ORDER		VARCHAR(255),
	@PP_L_STATUS_PAID_ORDER		INT
AS	
	-- ===============================
	DECLARE @VP_K_EXISTE	INT
	SELECT	@VP_K_EXISTE =	K_STATUS_PAID_ORDER
							FROM	STATUS_PAID_ORDER
							WHERE	K_STATUS_PAID_ORDER=@PP_K_STATUS_PAID_ORDER
	-- ===============================
	IF @VP_K_EXISTE IS NULL
		INSERT INTO STATUS_PAID_ORDER	
			(	K_STATUS_PAID_ORDER,				D_STATUS_PAID_ORDER, 
				S_STATUS_PAID_ORDER,				O_STATUS_PAID_ORDER,
				C_STATUS_PAID_ORDER,
				L_STATUS_PAID_ORDER				)		
		VALUES	
			(	@PP_K_STATUS_PAID_ORDER,			@PP_D_STATUS_PAID_ORDER,	
				@PP_S_STATUS_PAID_ORDER,			@PP_O_STATUS_PAID_ORDER,
				@PP_C_STATUS_PAID_ORDER,
				@PP_L_STATUS_PAID_ORDER			)
	ELSE
		UPDATE	STATUS_PAID_ORDER
		SET		D_STATUS_PAID_ORDER	= @PP_D_STATUS_PAID_ORDER,	
				S_STATUS_PAID_ORDER	= @PP_S_STATUS_PAID_ORDER,			
				O_STATUS_PAID_ORDER	= @PP_O_STATUS_PAID_ORDER,
				C_STATUS_PAID_ORDER	= @PP_C_STATUS_PAID_ORDER,
				L_STATUS_PAID_ORDER	= @PP_L_STATUS_PAID_ORDER	
		WHERE	K_STATUS_PAID_ORDER=@PP_K_STATUS_PAID_ORDER
	-- =========================================================
GO

-- //////////////////////////////////////////////////////////////
-- ===============================================
SET NOCOUNT ON
-- ===============================================
EXECUTE [dbo].[PG_CI_STATUS_PAID_ORDER] 0, 0, 00, 'NO PAYMENT APPLIES'	,			'NOPAY', 00, '', 1
EXECUTE [dbo].[PG_CI_STATUS_PAID_ORDER] 0, 0, 10, 'TO PAY'	,						'TOPAY', 10, '', 1
EXECUTE [dbo].[PG_CI_STATUS_PAID_ORDER] 0, 0, 20, 'PURCHASE PAID PARTIAL'	,		'PRPAI', 20, '', 1
EXECUTE [dbo].[PG_CI_STATUS_PAID_ORDER] 0, 0, 30, 'PURCHASE PAID COMPLETE'	,		'CMPAI', 30, '', 1
GO
-- ===============================================
SET NOCOUNT OFF
-- ===============================================


-- //////////////////////////////////////////////////////////////
-- // STATUS_PAYMENT
-- //////////////////////////////////////////////////////////////
CREATE TABLE [dbo].[STATUS_PAYMENT] (
	[K_STATUS_PAYMENT]	[INT] NOT NULL,
	[D_STATUS_PAYMENT]	[VARCHAR] (100) NOT NULL,
	[S_STATUS_PAYMENT]	[VARCHAR] (10) NOT NULL,
	[O_STATUS_PAYMENT]	[INT] NOT NULL,
	[C_STATUS_PAYMENT]	[VARCHAR] (255) NOT NULL,
	[L_STATUS_PAYMENT]	[INT] NOT NULL
) ON [PRIMARY]
GO
-- //////////////////////////////////////////////////////////////
ALTER TABLE [dbo].[STATUS_PAYMENT]
	ADD CONSTRAINT [PK_STATUS_PAYMENT]
		PRIMARY KEY CLUSTERED ([K_STATUS_PAYMENT])
GO
CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_STATUS_PAYMENT_01_DESCRIPCION] 
	   ON [dbo].[STATUS_PAYMENT] ( [D_STATUS_PAYMENT] )
GO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_STATUS_PAYMENT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_STATUS_PAYMENT]
GO
CREATE PROCEDURE [dbo].[PG_CI_STATUS_PAYMENT]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	-- ========================================
	@PP_K_STATUS_PAYMENT		INT,
	@PP_D_STATUS_PAYMENT		VARCHAR(100),
	@PP_S_STATUS_PAYMENT		VARCHAR(10),
	@PP_O_STATUS_PAYMENT		INT,
	@PP_C_STATUS_PAYMENT		VARCHAR(255),
	@PP_L_STATUS_PAYMENT		INT
AS	
	-- ===============================
	DECLARE @VP_K_EXISTE	INT
	SELECT	@VP_K_EXISTE =	K_STATUS_PAYMENT
							FROM	STATUS_PAYMENT
							WHERE	K_STATUS_PAYMENT=@PP_K_STATUS_PAYMENT
	-- ===============================
	IF @VP_K_EXISTE IS NULL
		INSERT INTO STATUS_PAYMENT	
			(	K_STATUS_PAYMENT,				D_STATUS_PAYMENT, 
				S_STATUS_PAYMENT,				O_STATUS_PAYMENT,
				C_STATUS_PAYMENT,
				L_STATUS_PAYMENT				)		
		VALUES	
			(	@PP_K_STATUS_PAYMENT,			@PP_D_STATUS_PAYMENT,	
				@PP_S_STATUS_PAYMENT,			@PP_O_STATUS_PAYMENT,
				@PP_C_STATUS_PAYMENT,
				@PP_L_STATUS_PAYMENT			)
	ELSE
		UPDATE	STATUS_PAYMENT
		SET		D_STATUS_PAYMENT	= @PP_D_STATUS_PAYMENT,	
				S_STATUS_PAYMENT	= @PP_S_STATUS_PAYMENT,			
				O_STATUS_PAYMENT	= @PP_O_STATUS_PAYMENT,
				C_STATUS_PAYMENT	= @PP_C_STATUS_PAYMENT,
				L_STATUS_PAYMENT	= @PP_L_STATUS_PAYMENT	
		WHERE	K_STATUS_PAYMENT=@PP_K_STATUS_PAYMENT
	-- =========================================================
GO

-- //////////////////////////////////////////////////////////////
-- ===============================================
SET NOCOUNT ON
-- ===============================================
EXECUTE [dbo].[PG_CI_STATUS_PAYMENT] 0, 0, 0, 'INACTIVE',	'INACT', 1, '', 1
EXECUTE [dbo].[PG_CI_STATUS_PAYMENT] 0, 0, 1, 'ACTIVE',		'ACTVO', 1, '', 1
--EXECUTE [dbo].[PG_CI_STATUS_PAYMENT] 0, 0, 2, 'IN PROCESS',	'ENPRO', 1, '', 1
GO
-- ===============================================
SET NOCOUNT OFF
-- ===============================================


-- //////////////////////////////////////////////////////////////
-- //	PAGOS
-- //////////////////////////////////////////////////////////////
CREATE TABLE [dbo].[PAYMENT] (
	[K_PAYMENT]				[INT]			NOT NULL,
	-- ============================	
	[K_STATUS_PAYMENT]		[INT]			NOT NULL DEFAULT 1,
	[K_VENDOR]				[INT]			NOT NULL,
	-- ============================	
	[F_PAYMENT]				[DATETIME]		NOT NULL,
	[NO_CUENTA_ORIGEN]		[VARCHAR](100)	NULL DEFAULT '',
	[PAGO_IMPORTE]			[DECIMAL](19,4) NOT NULL,	--	---> PAGO REALIZADO
	[PAGO_APLICADO]			[DECIMAL](19,4) NOT NULL,	--	---> SUM(PAGOS_APLICADOS)
	[PAGO_X_APLICAR]		[DECIMAL](19,4) NOT NULL	--	---> [PAGO_IMPORTE] - [PAGO_APLICADO]
	-- ============================	
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PAYMENT] 
	ADD		[K_USUARIO_ALTA]			[INT] NOT NULL,
			[F_ALTA]					[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]			[INT] NOT NULL,
			[F_CAMBIO]					[DATETIME] NOT NULL,
			[L_BORRADO]					[INT] NOT NULL,
			[K_USUARIO_BAJA]			[INT] NULL,
			[F_BAJA]					[DATETIME] NULL;
GO

-- ////////////////////////////////////////////////////////////////
-- //						DETAILS_PAYMENT				 
-- ////////////////////////////////////////////////////////////////
CREATE TABLE [dbo].[DETAILS_PAYMENT] (
	[K_DETAILS_PAYMENT]						[INT] IDENTITY (1,1)	NOT NULL,
	[K_PAYMENT]								[INT]			NOT NULL,
	-- ============================		-- ============================		-- ============================	
	[K_HEADER_PURCHASE_ORDER]				[INT] NOT NULL,
	-- ============================		-- ============================		-- ============================	
	-- CAMPOS ADICIONALES PARA PAYMENTS
	[K_PAYMENT_METHOD]						[INT] NOT NULL,
	[F_DETAILS_PAYMENT]						[DATETIME]	NOT NULL,
	[NO_IDENTICACION_PAGO]					[VARCHAR](100)	NULL DEFAULT '',
	[NO_FACTURA_PAGADA]						[VARCHAR](100)	NULL DEFAULT '',	
	[NO_CUENTA_DESTINO]						[VARCHAR](100)	NULL DEFAULT '',
	--[PAGO_IMPORTE]							[DECIMAL](19,4) NOT NULL DEFAULT 0, -- --> PAGO TOTAL A REALIZAR DE ACUERDO A PO O A CANTIDAD INGRESADA
	[PAGO_REALIZADO]						[DECIMAL](19,4) NOT NULL DEFAULT 0, -- --> ES EL PAGO QUE SE HIZO/ EL QUE SE VA A APLICAR
	--[PAGO_RESTANTE]							[DECIMAL](19,4) NOT NULL DEFAULT 0, -- --> ES EL RESTANTE POR PAGAR
	--[TOTAL_ORDEN_COMPRA]					[DECIMAL](19,4) NOT NULL DEFAULT 0, -- --> ES EL TOTAL ORIGINAL DE LA ORDEN DE COMPRA
	-- ============================
	[C_DETAILS_PAYMENT]						[VARCHAR](500)	NULL DEFAULT ''
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DETAILS_PAYMENT] 
	ADD		[K_USUARIO_ALTA]			[INT] NOT NULL,
			[F_ALTA]					[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]			[INT] NOT NULL,
			[F_CAMBIO]					[DATETIME] NOT NULL,
			[L_BORRADO]					[INT] NOT NULL,
			[K_USUARIO_BAJA]			[INT] NULL,
			[F_BAJA]					[DATETIME] NULL;
GO


-- ////////////////////////////////////////////////////////////////
-- //						LOG_PAYMENT
-- ////////////////////////////////////////////////////////////////
CREATE TABLE [dbo].[LOG_PAYMENT] (			
	[K_LOG_PAYMENT]							[INT] IDENTITY (1,1)	NOT NULL,
	[K_PAYMENT]								[INT]					NOT NULL,
	-- ============================		-- ============================		-- ============================	
	[K_HEADER_PURCHASE_ORDER]				[INT]					NOT NULL,
	-- ============================		-- ============================		-- ============================	
	-- CAMPOS ADICIONALES PARA PAYMENTS
	[K_PAYMENT_METHOD]						[INT] NOT NULL,
	[F_DETAILS_PAYMENT]						[DATETIME]	NOT NULL,
	[NO_IDENTICACION_PAGO]					[VARCHAR](100)	NULL DEFAULT '',
	[NO_FACTURA_PAGADA]						[VARCHAR](100)	NULL DEFAULT '',	
	[NO_CUENTA_DESTINO]						[VARCHAR](100)	NULL DEFAULT '',
	[PAGO_IMPORTE]							[DECIMAL](19,4) NOT NULL,
	-- ============================
	[C_DETAILS_PAYMENT]						[VARCHAR](500)	NULL DEFAULT '',
	-- ============================
	[TIPO_MOVIMIENTO]						[VARCHAR](500)	NULL DEFAULT ''
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[LOG_PAYMENT] 
	ADD		[K_USUARIO_ALTA]			[INT] NOT NULL,
			[F_ALTA]					[DATETIME] NOT NULL
GO
-- //////////////////////////////////////////////////////