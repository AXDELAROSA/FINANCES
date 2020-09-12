-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			COMPRAS
-- // OPERATION:		CARGA COMBO
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200224
-- ////////////////////////////////////////////////////////////// 

--	USE [COMPRAS]
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
	FROM		HOWE.DBO.VISTA_GAFETES
	INNER JOIN	DATA_02PRUEBAS.DBO.users_pearl on correo=EP_CORREO_ELECTRONICO
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
	FROM		BD_GENERAL.DBO.CURRENCY
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
--	SE UTILIZAN EN LA FO BACKING_YARDAGE
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> PARA CARGAR COMBO DE VENDORS EN BASE A LOS QUE TIENEN
-- // ITEM CATALOGADOS CON LA CLASS_ITEM [ROW_MATERIAL]
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_VENDOR_ITEM_CLASS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_VENDOR_ITEM_CLASS]
GO
--		 EXECUTE [dbo].[PG_CB_VENDOR_ITEM_CLASS] 0,139,0
--		 EXECUTE [dbo].[PG_CB_VENDOR_ITEM_CLASS] 0,139,1
CREATE PROCEDURE [dbo].[PG_CB_VENDOR_ITEM_CLASS]
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
	SELECT	DISTINCT	
				ITEM.K_VENDOR				AS K_COMBOBOX,
				D_VENDOR					AS D_COMBOBOX,
					0						AS TA_O_CATALOGO,
					0						AS L_DELETED, 
					1						AS L_ACTIVO
	FROM		ITEM, VENDOR
	WHERE		ITEM.K_CLASS_ITEM=2
	AND			ITEM.K_VENDOR=VENDOR.K_VENDOR
	AND			ITEM.L_BORRADO=0
	ORDER BY	D_VENDOR
	

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
--	SE UTILIZAN EN LA FO BACKING_YARDAGE
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> PARA CREAR COMBO EN CASCADA DEPENDE EL VENDOR SELECCIONADO.
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_ITEM_HIJO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_ITEM_HIJO]
GO
--		 EXECUTE [dbo].[PG_CB_ITEM_HIJO] 0,139,282,0
--		 EXECUTE [dbo].[PG_CB_ITEM_HIJO] 0,139,135,1
--		 EXECUTE [dbo].[PG_CB_ITEM_HIJO] 0,139,282,0
--		 EXECUTE [dbo].[PG_CB_ITEM_HIJO] 0,139,282,1
CREATE PROCEDURE [dbo].[PG_CB_ITEM_HIJO]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO				INT,
	--============================
	@PP_K_VENDOR				INT,
	@PP_L_CON_TODOS				INT
AS

	DECLARE @VP_TA_CATALOGO	AS TABLE
				(	TA_K_CATALOGO		INT,
					TA_D_CATALOGO		VARCHAR(50),
					TA_O_CATALOGO		INT,
					TA_L_DELETED		INT,	
					TA_L_ACTIVO			INT			 )	
	INSERT INTO @VP_TA_CATALOGO 
	SELECT		K_ITEM					AS K_COMBOBOX,
				D_ITEM					AS D_COMBOBOX,
				0						AS TA_O_CATALOGO,
				0						AS L_DELETED, 
				1						AS L_ACTIVO
	FROM		ITEM
	WHERE		K_VENDOR=@PP_K_VENDOR
	AND			ITEM.K_CLASS_ITEM=2
	AND			L_BORRADO=0
	ORDER BY	D_ITEM

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
--	SE UTILIZAN EN LA FO ITEM
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> PARA CREAR COMBO EN CASCADA DE LA CLASE EN BASE AL TIPO DE ITEM
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_TYPE_CLASS_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_TYPE_CLASS_ITEM]
GO
--		 EXECUTE [dbo].[PG_CB_TYPE_CLASS_ITEM] 0,139,0,0
--		 EXECUTE [dbo].[PG_CB_TYPE_CLASS_ITEM] 0,139,2,0
--		 EXECUTE [dbo].[PG_CB_TYPE_CLASS_ITEM] 0,139,1,0
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
		FROM		CLASS_ITEM
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
		FROM		CLASS_ITEM
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
--	SE UTILIZAN EN LA FO BACKING_YARDAGE
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> PARA SELECCIONAR LAS SIGLAS DE LAS UNIDADES DE MEDIDA
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_S_UOM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_S_UOM]
GO
--		 EXECUTE [dbo].[PG_CB_S_UOM] 0,139,0
CREATE PROCEDURE [dbo].[PG_CB_S_UOM]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO				INT,
	--============================
--	@PP_K_UOM					INT,
	@PP_L_CON_TODOS				INT
AS

	DECLARE @VP_TA_CATALOGO	AS TABLE
				(	TA_K_CATALOGO		INT,
					TA_D_CATALOGO		VARCHAR(50),
					TA_O_CATALOGO		INT,
					TA_L_DELETED		INT,	
					TA_L_ACTIVO			INT			 )	
	INSERT INTO @VP_TA_CATALOGO 
	SELECT		K_UNIT_OF_MEASURE		AS K_COMBOBOX,
				S_UNIT_OF_MEASURE		AS D_COMBOBOX,
				0						AS TA_O_CATALOGO,
				0						AS L_DELETED, 
				1						AS L_ACTIVO
	FROM		BD_GENERAL.DBO.UNIT_OF_MEASURE
--	WHERE		K_UNIT_OF_MEASURE=@PP_K_UOM
	WHERE		K_UNIT_OF_MEASURE NOT IN(0)
	AND			K_UNIT_CLASS IN (2,3)
		
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


-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////