-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			COMPRAS
-- // OPERATION:		CARGA COMBO
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200224
-- ////////////////////////////////////////////////////////////// 

USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////
--	SE UTILIZA EN LA FO PURCHASE_ORDER

-- EXECUTE [dbo].[PG_CB_REQUIRED_BY] 0,0,1
-- EXECUTE [dbo].[PG_CB_REQUIRED_BY] 0,0,0

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_REQUIRED_BY]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_REQUIRED_BY]
GO


CREATE PROCEDURE [dbo].[PG_CB_REQUIRED_BY]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO				INT,
	--============================
	@PP_L_CON_TODOS				INT
AS

	DECLARE @VP_TA_CATALOGO	AS TABLE
				(	TA_K_CATALOGO		INT,
					TA_D_CATALOGO		VARCHAR(50),
					TA_O_CATALOGO		INT,
					TA_L_DELETED		INT,	
					TA_L_ACTIVO			INT			 )	
	INSERT INTO @VP_TA_CATALOGO 
	SELECT		EN_NUM_EMP				AS K_COMBOBOX,
			LTRIM(RTRIM(UPPER(apellido))) 
			+' '+ 
			LTRIM(RTRIM(UPPER(nombre))) AS D_COMBOBOX,
				0						AS TA_O_CATALOGO,
				0						AS L_DELETED, 
				1						AS L_ACTIVO
	FROM		HOWE.DBO.VISTA_GAFETES		   (NOLOCK) 
	INNER JOIN	DATA_02PRUEBAS.DBO.users_pearl (NOLOCK) on correo=EP_CORREO_ELECTRONICO
	WHERE		EN_SUPERVISOR='GERENTES'
	ORDER BY	apellido

	IF @PP_L_CON_TODOS=1
	INSERT INTO @VP_TA_CATALOGO
		( TA_K_CATALOGO,	TA_D_CATALOGO,	TA_O_CATALOGO, TA_L_DELETED, TA_L_ACTIVO	)
	VALUES
		( -1,				'( ALL )',	-999,		   0,			 1				)
	SELECT		TA_K_CATALOGO	AS K_COMBOBOX,
				TA_D_CATALOGO	AS D_COMBOBOX 
	FROM		@VP_TA_CATALOGO
	ORDER BY	TA_O_CATALOGO, TA_D_CATALOGO 

	-- ==========================================

	-- ////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
--	SE UTILIZA EN LA FO PURCHASE_ORDER

-- EXECUTE [dbo].[PG_CB_CURRENCY] 0,0,1
-- EXECUTE [dbo].[PG_CB_CURRENCY] 0,0,0

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_CURRENCY]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_CURRENCY]
GO


CREATE PROCEDURE [dbo].[PG_CB_CURRENCY]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO				INT,
	--============================
	@PP_L_CON_TODOS				INT
AS

	DECLARE @VP_TA_CATALOGO	AS TABLE
				(	TA_K_CATALOGO		INT,
					TA_D_CATALOGO		VARCHAR(50),
					TA_O_CATALOGO		INT,
					TA_L_DELETED		INT,	
					TA_L_ACTIVO			INT			 )	
	INSERT INTO @VP_TA_CATALOGO 
	SELECT		K_CURRENCY				AS K_COMBOBOX,
				S_CURRENCY				 AS D_COMBOBOX,
				0						AS TA_O_CATALOGO,
				0						AS L_DELETED, 
				1						AS L_ACTIVO
	FROM		BD_GENERAL.DBO.CURRENCY	(NOLOCK)
	WHERE		L_CURRENCY<>0
	ORDER BY	O_CURRENCY

	IF @PP_L_CON_TODOS=1
	INSERT INTO @VP_TA_CATALOGO
		( TA_K_CATALOGO,	TA_D_CATALOGO,	TA_O_CATALOGO, TA_L_DELETED, TA_L_ACTIVO	)
	VALUES
		( -1,				'( ALL )',	-999,		   0,			 1				)
	SELECT		TA_K_CATALOGO	AS K_COMBOBOX,
				TA_D_CATALOGO	AS D_COMBOBOX 
	FROM		@VP_TA_CATALOGO
	ORDER BY	TA_O_CATALOGO, TA_D_CATALOGO 

	-- ==========================================

	-- ////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////
--	SE UTILIZA EN LA FO PURCHASE_ORDER		PARA REALIZAR LOS PAGOS			20201208
--	MUESTRA TODAS LAS MONEDAS DISPONIBLES MENOS CON LA QUE SE REALIZ�
--	LA SOLICITUD DE LA ORDEN DE COMPRA
-- EXECUTE [dbo].[PG_CB_CURRENCY_NO_EN_ORDEN] 0,0,1
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_CURRENCY_NO_EN_ORDEN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_CURRENCY_NO_EN_ORDEN]
GO

CREATE PROCEDURE [dbo].[PG_CB_CURRENCY_NO_EN_ORDEN]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO				INT,
	--============================
	@PP_CURRENCY				INT
AS
--IF @PP_K_SISTEMA_EXE = 0
--BEGIN
	DECLARE @VP_TA_CATALOGO	AS TABLE
				(	TA_K_CATALOGO		INT,
					TA_D_CATALOGO		VARCHAR(50),
					TA_O_CATALOGO		INT,
					TA_L_DELETED		INT,	
					TA_L_ACTIVO			INT			 )	
	INSERT INTO @VP_TA_CATALOGO 
	SELECT		K_CURRENCY				AS K_COMBOBOX,
				S_CURRENCY				 AS D_COMBOBOX,
				0						AS TA_O_CATALOGO,
				0						AS L_DELETED, 
				1						AS L_ACTIVO
	FROM		BD_GENERAL.DBO.CURRENCY	(NOLOCK)
	WHERE		L_CURRENCY<>0
	AND			K_CURRENCY NOT IN (@PP_CURRENCY)
	ORDER BY	O_CURRENCY

	INSERT INTO @VP_TA_CATALOGO
		( TA_K_CATALOGO,	TA_D_CATALOGO,	TA_O_CATALOGO, TA_L_DELETED, TA_L_ACTIVO	)
	VALUES
		( -1,				'( ALL )',	-999,		   0,			 1				)
	SELECT		TA_K_CATALOGO	AS K_COMBOBOX,
				TA_D_CATALOGO	AS D_COMBOBOX 
	FROM		@VP_TA_CATALOGO
	ORDER BY	TA_O_CATALOGO, TA_D_CATALOGO 

	-- ==========================================

	-- ////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
--	SE UTILIZAN EN LA FO ITEM
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> PARA CREAR COMBO EN CASCADA DE LA CLASE EN BASE AL TIPO DE ITEM
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_TYPE_CLASS_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_TYPE_CLASS_ITEM]
GO
--		 EXECUTE [dbo].[PG_CB_TYPE_CLASS_ITEM] 0,139,0,0
--		 EXECUTE [dbo].[PG_CB_TYPE_CLASS_ITEM] 0,139,1,0
--		 EXECUTE [dbo].[PG_CB_TYPE_CLASS_ITEM] 0,139,2,0
CREATE PROCEDURE [dbo].[PG_CB_TYPE_CLASS_ITEM]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO				INT,
	--============================
	@PP_K_TYPE_ITEM				INT,
	@PP_L_CON_TODOS				INT
AS
		DECLARE @VP_TA_CATALOGO	AS TABLE
					(	TA_K_CATALOGO		INT,
						TA_D_CATALOGO		VARCHAR(50),
						TA_O_CATALOGO		INT,
						TA_L_DELETED		INT,	
						TA_L_ACTIVO			INT			 )	

	IF @PP_K_TYPE_ITEM IN (0,2)	-- TO DEFINE, SERVICE
	BEGIN
		INSERT INTO @VP_TA_CATALOGO 
		SELECT		K_CLASS_ITEM			AS K_COMBOBOX,
					D_CLASS_ITEM			AS D_COMBOBOX,
					0						AS TA_O_CATALOGO,
					0						AS L_DELETED, 
					1						AS L_ACTIVO
		FROM		CLASS_ITEM			(NOLOCK)
		WHERE		K_CLASS_ITEM IN (0)
		AND			L_CLASS_ITEM<>0
		ORDER BY	D_CLASS_ITEM
	END
	ELSE IF @PP_K_TYPE_ITEM IN (1)	-- TO DEFINE, SERVICE
	BEGIN
		INSERT INTO @VP_TA_CATALOGO 
		SELECT		K_CLASS_ITEM			AS K_COMBOBOX,
					D_CLASS_ITEM			AS D_COMBOBOX,
					0						AS TA_O_CATALOGO,
					0						AS L_DELETED, 
					1						AS L_ACTIVO
		FROM		CLASS_ITEM		(NOLOCK)
		WHERE		K_CLASS_ITEM IN (1,2)
		AND			L_CLASS_ITEM<>0
		ORDER BY	D_CLASS_ITEM
	END

	-- ==========================================
	IF @PP_L_CON_TODOS=1
	INSERT INTO @VP_TA_CATALOGO
		( TA_K_CATALOGO,	TA_D_CATALOGO,	TA_O_CATALOGO, TA_L_DELETED, TA_L_ACTIVO	)
	VALUES
		( -1,				'( ALL )',	-999,		   0,			 1				)
	SELECT		TA_K_CATALOGO	AS K_COMBOBOX,
				TA_D_CATALOGO	AS D_COMBOBOX 
	FROM		@VP_TA_CATALOGO
	ORDER BY	TA_O_CATALOGO, TA_D_CATALOGO 
	-- ////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
--	SE UTILIZAN EN LA FO PEDIDOS_BPO
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> PARA SELECCIONAR LOS PROVEEDORES QUE TIENEN ALTA DE BLANKETS
-- // A LOS USUARIOS DE PRODUCCI�N S�LO SE LES MUESTRA EL VENDOR 383: PARA LA SOLICITUD DE HILOS.
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_VENDOR_BPO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_VENDOR_BPO]
GO
--		 EXECUTE [dbo].[PG_CB_VENDOR_BPO] 0,139,0
CREATE PROCEDURE [dbo].[PG_CB_VENDOR_BPO]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO				INT,
	--============================
	@PP_L_CON_TODOS				INT
AS

	DECLARE @VP_TA_CATALOGO	AS TABLE
				(	TA_K_CATALOGO		INT,
					TA_D_CATALOGO		VARCHAR(50),
					TA_O_CATALOGO		INT,
					TA_L_DELETED		INT,	
					TA_L_ACTIVO			INT			 )	

	IF	@PP_K_USUARIO IN (64)
	BEGIN
		INSERT INTO @VP_TA_CATALOGO 
		SELECT DISTINCT 
				HEADER_PURCHASE_ORDER.K_VENDOR	AS K_COMBOBOX,
				D_VENDOR						AS D_COMBOBOX,
				0								AS TA_O_CATALOGO,
				0								AS L_DELETED, 
				1								AS L_ACTIVO
		FROM	HEADER_PURCHASE_ORDER	(NOLOCK), VENDOR	(NOLOCK)
		WHERE	HEADER_PURCHASE_ORDER.K_VENDOR=VENDOR.K_VENDOR
		AND		HEADER_PURCHASE_ORDER.L_IS_BLANKET=1
		AND		HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER>=9		
		AND		HEADER_PURCHASE_ORDER.K_VENDOR	IN (383)
	END
	ELSE
	BEGIN		
		INSERT INTO @VP_TA_CATALOGO 
		SELECT DISTINCT 
				HEADER_PURCHASE_ORDER.K_VENDOR	AS K_COMBOBOX,
				D_VENDOR						AS D_COMBOBOX,
				0								AS TA_O_CATALOGO,
				0								AS L_DELETED, 
				1								AS L_ACTIVO
		FROM	HEADER_PURCHASE_ORDER	(NOLOCK), VENDOR	(NOLOCK)
		WHERE	HEADER_PURCHASE_ORDER.K_VENDOR=VENDOR.K_VENDOR
		AND		HEADER_PURCHASE_ORDER.L_IS_BLANKET=1
		AND		HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER>=9
	
		IF @PP_L_CON_TODOS=1
		INSERT INTO @VP_TA_CATALOGO
			( TA_K_CATALOGO,	TA_D_CATALOGO,	TA_O_CATALOGO, TA_L_DELETED, TA_L_ACTIVO	)
		VALUES
			( -1,				'( ALL )',	-999,		   0,			 1				)	
	END

	SELECT		TA_K_CATALOGO	AS K_COMBOBOX,
				TA_D_CATALOGO	AS D_COMBOBOX 
	FROM		@VP_TA_CATALOGO
	ORDER BY	TA_O_CATALOGO, TA_D_CATALOGO 
	-- ==========================================
	-- ////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
--	SE UTILIZA EN LA FO SET_PAYMENTS

-- EXECUTE [dbo].[PG_CB_PAYMENT_METHOD] 0,0,1
-- EXECUTE [dbo].[PG_CB_PAYMENT_METHOD] 0,0,0

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_PAYMENT_METHOD]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_PAYMENT_METHOD]
GO
CREATE PROCEDURE [dbo].[PG_CB_PAYMENT_METHOD]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO				INT,
	--============================
	@PP_L_CON_TODOS				INT
AS

	DECLARE @VP_TA_CATALOGO	AS TABLE
				(	TA_K_CATALOGO		INT,
					TA_D_CATALOGO		VARCHAR(50),
					TA_O_CATALOGO		INT,
					TA_L_DELETED		INT,	
					TA_L_ACTIVO			INT			 )	
	INSERT INTO @VP_TA_CATALOGO 
	SELECT		K_PAYMENT_METHOD		AS K_COMBOBOX,								
				D_PAYMENT_METHOD		AS D_COMBOBOX,
				0						AS TA_O_CATALOGO,
				0						AS L_DELETED, 
				1						AS L_ACTIVO
	FROM		BD_GENERAL.DBO.PAYMENT_METHOD	(NOLOCK)
	WHERE		L_PAYMENT_METHOD=1
	ORDER BY	D_PAYMENT_METHOD

	IF @PP_L_CON_TODOS=1
	INSERT INTO @VP_TA_CATALOGO
		( TA_K_CATALOGO,	TA_D_CATALOGO,	TA_O_CATALOGO, TA_L_DELETED, TA_L_ACTIVO	)
	VALUES
		( -1,				'( SELECCIONAR UNO )',	-999,		   0,			 1				)
	SELECT		TA_K_CATALOGO	AS K_COMBOBOX,
				TA_D_CATALOGO	AS D_COMBOBOX 
	FROM		@VP_TA_CATALOGO
	ORDER BY	TA_O_CATALOGO, TA_D_CATALOGO 

	-- ==========================================

	-- ////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
--	SE UTILIZA EN LA FO PURCHASE_ORDER

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_VENDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_VENDOR]
GO
--		 EXECUTE [dbo].[PG_CB_VENDOR] 0,0,0
--		 EXECUTE [dbo].[PG_CB_VENDOR] 0,0,1
--		 EXECUTE [dbo].[PG_CB_VENDOR] 0,0,2
--		 EXECUTE [dbo].[PG_CB_VENDOR] 0,0,3
--		 EXECUTE [dbo].[PG_CB_VENDOR] 0,0,4
--		 EXECUTE [dbo].[PG_CB_VENDOR] 0,0,5
--		 EXECUTE [dbo].[PG_CB_VENDOR] 0,0,6
CREATE PROCEDURE [dbo].[PG_CB_VENDOR]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO				INT,
	--============================
	@PP_L_CON_TODOS				INT
AS

	DECLARE @VP_TA_CATALOGO	AS TABLE
			(	TA_K_CATALOGO		INT,
				TA_D_CATALOGO		VARCHAR(350),
				TA_O_CATALOGO		INT,
				TA_L_DELETED		INT,	
				TA_L_ACTIVO			INT			 )	
	
	IF @PP_L_CON_TODOS	IN (0,1)
	BEGIN
		INSERT INTO @VP_TA_CATALOGO 
		SELECT		K_VENDOR				AS K_COMBOBOX,
					D_VENDOR				AS D_COMBOBOX,
					0						AS TA_O_CATALOGO,
					L_BORRADO				AS L_DELETED, 
					1						AS L_ACTIVO
		FROM		VENDOR	(NOLOCK)
		WHERE		L_BORRADO=0
		ORDER BY	D_VENDOR
	END

	-- PARA SELECCIONAR LOS PROVEEDORES QUE TIENEN ART�CULOS
	IF @PP_L_CON_TODOS	IN (2,3)
	BEGIN
		INSERT INTO @VP_TA_CATALOGO 
		SELECT		DISTINCT
					VENDOR.K_VENDOR			AS K_COMBOBOX,
					D_VENDOR				AS D_COMBOBOX,
					0						AS TA_O_CATALOGO,
					VENDOR.L_BORRADO		AS L_DELETED, 
					1						AS L_ACTIVO
		FROM		ITEM	(NOLOCK)
		INNER JOIN	VENDOR	ON ITEM.K_VENDOR=VENDOR.K_VENDOR
		WHERE		VENDOR.L_BORRADO=0
		AND			ITEM.L_BORRADO=0
		ORDER BY	D_VENDOR
	END

	-- PARA SELECCIONAR LOS PROVEEDORES QUE EXISTEN EN PO
	IF @PP_L_CON_TODOS	IN (4,5)
	BEGIN
		INSERT INTO @VP_TA_CATALOGO 
		SELECT		DISTINCT
					VENDOR.K_VENDOR			AS K_COMBOBOX,
					D_VENDOR				AS D_COMBOBOX,
					0						AS TA_O_CATALOGO,
					VENDOR.L_BORRADO		AS L_DELETED, 
					1						AS L_ACTIVO
		FROM		HEADER_PURCHASE_ORDER	(NOLOCK)
		INNER JOIN	VENDOR		(NOLOCK) ON HEADER_PURCHASE_ORDER.K_VENDOR=VENDOR.K_VENDOR
		WHERE		VENDOR.L_BORRADO=0
		AND			HEADER_PURCHASE_ORDER.L_BORRADO=0
		ORDER BY	D_VENDOR
	END

	-- PARA SELECCIONAR LOS PROVEEDORES QUE EXISTEN EN BACKING_YARDAGE
	IF @PP_L_CON_TODOS	IN (6,7)
	BEGIN
		INSERT INTO @VP_TA_CATALOGO 
		SELECT		DISTINCT
					VENDOR.K_VENDOR			AS K_COMBOBOX,
					D_VENDOR				AS D_COMBOBOX,
					0						AS TA_O_CATALOGO,
					VENDOR.L_BORRADO		AS L_DELETED, 
					1						AS L_ACTIVO
		FROM		BACKING_YARDAGE	(NOLOCK)
		INNER JOIN	VENDOR	(NOLOCK)	ON BACKING_YARDAGE.K_VENDOR=VENDOR.K_VENDOR
		WHERE		VENDOR.L_BORRADO=0
		AND			BACKING_YARDAGE.L_BORRADO=0
		ORDER BY	D_VENDOR
	END

	IF @PP_L_CON_TODOS IN (1,3,5,7)
	BEGIN
		INSERT INTO @VP_TA_CATALOGO
			( TA_K_CATALOGO,	TA_D_CATALOGO,	TA_O_CATALOGO, TA_L_DELETED, TA_L_ACTIVO	)
		VALUES
			( -1,				'( ALL )',	-999,		   0,			 1				)
	END

	SELECT		TA_K_CATALOGO	AS K_COMBOBOX,
				TA_D_CATALOGO	AS D_COMBOBOX 
	FROM		@VP_TA_CATALOGO
	ORDER BY	TA_O_CATALOGO, TA_D_CATALOGO 
	-- ==========================================
	-- ////////////////////////////////////////////////////
GO

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////