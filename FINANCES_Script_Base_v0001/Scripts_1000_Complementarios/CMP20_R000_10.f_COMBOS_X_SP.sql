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

--IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_COLOR_IMITMIDX_SQL]') AND type in (N'P', N'PC'))
--	DROP PROCEDURE [dbo].[PG_CB_COLOR_IMITMIDX_SQL]
--GO


--CREATE PROCEDURE [dbo].[PG_CB_COLOR_IMITMIDX_SQL]
--	@PP_K_SISTEMA_EXE			INT,
--	@PP_K_USUARIO				INT,
--	--============================
--	@PP_L_CON_TODOS				INT
--AS
--	DECLARE @VP_TA_CATALOGO	AS TABLE
--				(	TA_K_CATALOGO		INT,
--					TA_D_CATALOGO		VARCHAR(50),
--					TA_O_CATALOGO		INT,
--					TA_L_DELETED		INT,	
--					TA_L_ACTIVO			INT			 )
	
--	INSERT INTO @VP_TA_CATALOGO 
--	SELECT	A4GLIDENTITY			AS TA_K_CATALOGO,
--			LTRIM(RTRIM(ITEM_NO))	AS TA_D_CATALOGO,
--			0						AS TA_O_CATALOGO,
--			0						AS L_DELETED, 
--			1						AS L_ACTIVO
--	FROM IMITMIDX_SQL 
--	WHERE ITEM_NO LIKE 'F%'
--	AND LEN(RTRIM(LTRIM(ITEM_NO)))=7
--	ORDER BY TA_D_CATALOGO 


--	IF @PP_L_CON_TODOS=1
--		INSERT INTO @VP_TA_CATALOGO
--				( TA_K_CATALOGO,	TA_D_CATALOGO,	TA_O_CATALOGO, TA_L_DELETED, TA_L_ACTIVO	)
--			VALUES
--				( -1,				'( TODOS )',	-999,		   0,			 1				)

--	SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
--				TA_D_CATALOGO	AS D_COMBOBOX 
--		FROM	@VP_TA_CATALOGO
--		ORDER BY TA_O_CATALOGO, TA_D_CATALOGO 

--	-- ==========================================
		
--	-- ////////////////////////////////////////////////////
--GO



-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////