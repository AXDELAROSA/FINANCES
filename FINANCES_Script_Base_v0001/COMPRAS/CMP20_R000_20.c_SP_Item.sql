-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			ITEM
-- // OPERATION:		TABLA
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200217
-- ////////////////////////////////////////////////////////////// 

USE [COMPRAS]
GO


-- //////////////////////////////////////////////////////////////

-- SELECT * FROM PRODUCTO
-- SELECT * FROM CURRENCY
-- SELECT * FROM ITEM

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_ITEM]
GO

-- EXECUTE [dbo].[PG_LI_ITEM] 0,139,'',-1,-1,-1
CREATE PROCEDURE [dbo].[PG_LI_ITEM]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_BUSCAR						VARCHAR(200),
	@PP_K_STATUS_ITEM				INT,
	@PP_K_TYPE_ITEM					INT,
	@PP_K_CURRENCY					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1
		
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS	INT =5000	
	-- =========================================	
	
	DECLARE @VP_K_FOLIO				INT

	EXECUTE [BD_GENERAL].DBO.[PG_RN_OBTENER_ID_X_REFERENCIA]			
												@PP_BUSCAR,	@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
		
	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	SELECT		TOP (@VP_LI_N_REGISTROS)
				ITEM.*,
				STATUS_ITEM.D_STATUS_ITEM, TYPE_ITEM.D_TYPE_ITEM, UNIT_OF_ITEM.D_UNIT_OF_ITEM,
				STATUS_ITEM.S_STATUS_ITEM, TYPE_ITEM.S_TYPE_ITEM, UNIT_OF_ITEM.S_UNIT_OF_ITEM
				-- =============================	
	FROM		ITEM, 
				STATUS_ITEM, TYPE_ITEM,
				UNIT_OF_ITEM,
				BD_GENERAL.DBO.CURRENCY
				-- =============================
	WHERE		ITEM.K_STATUS_ITEM=STATUS_ITEM.K_STATUS_ITEM
	AND			ITEM.K_TYPE_ITEM=TYPE_ITEM.K_TYPE_ITEM
	AND			ITEM.K_UNIT_OF_ITEM=UNIT_OF_ITEM.K_UNIT_OF_ITEM
	AND			ITEM.K_CURRENCY=CURRENCY.K_CURRENCY
				-- =============================
	AND			(	ITEM.K_ITEM=@VP_K_FOLIO
				OR	ITEM.MODEL_ITEM				LIKE '%'+@PP_BUSCAR+'%'
				OR	ITEM.PRICE_ITEM				LIKE '%'+@PP_BUSCAR+'%' )
				-- =============================
	AND			( @PP_K_STATUS_ITEM	=-1		OR	ITEM.K_STATUS_ITEM=@PP_K_STATUS_ITEM )
	AND			( @PP_K_TYPE_ITEM =-1		OR	ITEM.K_TYPE_ITEM=@PP_K_TYPE_ITEM )
	AND			( @PP_K_CURRENCY =-1		OR	ITEM.K_CURRENCY=@PP_K_CURRENCY )
				-- =============================
	AND			ITEM.L_BORRADO<>1
	ORDER BY	D_ITEM,K_TYPE_ITEM,K_CURRENCY	DESC
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_ITEM]
GO

-- EXECUTE [dbo].[PG_SK_ITEM] 0,139,3
CREATE PROCEDURE [dbo].[PG_SK_ITEM]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_ITEM						INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT = 1
	
		IF @VP_MENSAJE<>''
			SET @VP_LI_N_REGISTROS = 0
			
		SELECT	TOP (@VP_LI_N_REGISTROS)
				ITEM.*,
				STATUS_ITEM.D_STATUS_ITEM, TYPE_ITEM.D_TYPE_ITEM, UNIT_OF_ITEM.D_UNIT_OF_ITEM,
				STATUS_ITEM.S_STATUS_ITEM, TYPE_ITEM.S_TYPE_ITEM, UNIT_OF_ITEM.S_UNIT_OF_ITEM
				-- =============================	
		FROM	ITEM, 
				STATUS_ITEM, TYPE_ITEM,
				UNIT_OF_ITEM,
				BD_GENERAL.DBO.CURRENCY
				-- =============================
		WHERE	ITEM.K_STATUS_ITEM=STATUS_ITEM.K_STATUS_ITEM
		AND		ITEM.K_TYPE_ITEM=TYPE_ITEM.K_TYPE_ITEM
		AND		ITEM.K_UNIT_OF_ITEM=UNIT_OF_ITEM.K_UNIT_OF_ITEM
		AND		ITEM.K_CURRENCY=CURRENCY.K_CURRENCY
		AND		ITEM.K_ITEM=@PP_K_ITEM
		
	-- ////////////////////////////////////////////////////////////////////
GO



	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_ITEM]
GO

-- EXECUTE [dbo].[PG_IN_ITEM] 0, 139,'TEST','750000000','0','LENOVO','THINK PAD',12500.50,1,1,8,1
CREATE PROCEDURE [dbo].[PG_IN_ITEM]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_D_ITEM						VARCHAR(100),
	-- ===========================
	@PP_PART_NUMBER_ITEM_VENDOR		VARCHAR(250),
	@PP_PART_NUMBER_ITEM_PEARL		VARCHAR(250),
	-- ===========================
	@PP_TRADEMARK_ITEM				VARCHAR(100),
	@PP_MODEL_ITEM					VARCHAR(100),
	@PP_PRICE_ITEM					DECIMAL(10,4),
	-- ===========================
	@PP_K_STATUS_ITEM				INT,
	@PP_K_TYPE_ITEM					INT,
	@PP_K_UNIT_OF_ITEM				INT,
	-- ============================
	@PP_K_CURRENCY					INT
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	DECLARE @VP_K_ITEM			INT = 0

		EXECUTE [BD_GENERAL].dbo.[PG_SK_CATALOGO_K_MAX_GET]		@PP_K_SISTEMA_EXE, 'COMPRAS',
																'ITEM', 'K_ITEM',
													@OU_K_TABLA_DISPONIBLE = @VP_K_ITEM	OUTPUT
														
	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ITEM_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@VP_K_ITEM, @PP_D_ITEM, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
		-- //////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		INSERT INTO ITEM
			(	[K_ITEM]	,		[D_ITEM]	, 
				[O_ITEM]	,
				 -- ============================
				[PART_NUMBER_ITEM_VENDOR]		,
				[PART_NUMBER_ITEM_PEARL]		,
				 -- ============================
				[TRADEMARK_ITEM]		,
				[MODEL_ITEM]		,	[PRICE_ITEM]		,			
				-- ============================	
				[K_STATUS_ITEM]		,	[K_TYPE_ITEM]		,
				[K_UNIT_OF_ITEM]	,
				-- ============================	
				[K_CURRENCY]		,
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_ITEM	, 		@PP_D_ITEM	,
				10			,
				-- ===========================
				@PP_PART_NUMBER_ITEM_VENDOR		,
				@PP_PART_NUMBER_ITEM_PEARL		,
				-- ===========================
				@PP_TRADEMARK_ITEM		,	
				@PP_MODEL_ITEM		,	@PP_PRICE_ITEM		,			
				-- ===========================
				@PP_K_STATUS_ITEM	,	@PP_K_TYPE_ITEM		,			
				@PP_K_UNIT_OF_ITEM	,			
				-- ============================
				@PP_K_CURRENCY		,		
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Insert] at [ITEM]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#ITEM.'+CONVERT(VARCHAR(10),@VP_K_ITEM)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_ITEM AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_SK_ITEM] 0,139,9
-- EXECUTE [dbo].[PG_UP_ITEM] 0, 139,9,'TEST','750000000','0','LENOVO','THINK PAD',12500.50,1,1,8,1
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_ITEM]
GO

CREATE PROCEDURE [dbo].[PG_UP_ITEM]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_ITEM						INT,
	@PP_D_ITEM						VARCHAR(100),
	-- ===========================
	@PP_PART_NUMBER_ITEM_VENDOR		VARCHAR(250),
	@PP_PART_NUMBER_ITEM_PEARL		VARCHAR(250),
	-- ===========================
	@PP_TRADEMARK_ITEM				VARCHAR(100),
	@PP_MODEL_ITEM					VARCHAR(100),
	@PP_PRICE_ITEM					DECIMAL(10,4),
	-- ===========================
	@PP_K_STATUS_ITEM				INT,
	@PP_K_TYPE_ITEM					INT,
	@PP_K_UNIT_OF_ITEM				INT,
	-- ============================
	@PP_K_CURRENCY					INT
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ITEM_UPDATE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_ITEM, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ITEM_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_ITEM, 
												@PP_D_ITEM,
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	ITEM
		SET		
				[D_ITEM]						= @PP_D_ITEM	,
				-- ==========================	-- ===========================
				[PART_NUMBER_ITEM_VENDOR]		= @PP_PART_NUMBER_ITEM_VENDOR	,	
				[PART_NUMBER_ITEM_PEARL]		= @PP_PART_NUMBER_ITEM_PEARL	,	
				-- ==========================	-- ===========================
				[TRADEMARK_ITEM]				= @PP_TRADEMARK_ITEM			,	
				[MODEL_ITEM]					= @PP_MODEL_ITEM				,	
				[PRICE_ITEM]					= @PP_PRICE_ITEM				,	
				-- ==========================	-- ===========================
				[K_STATUS_ITEM]					= @PP_K_STATUS_ITEM				,
				[K_TYPE_ITEM]					= @PP_K_TYPE_ITEM				,	
				[K_UNIT_OF_ITEM]				= @PP_K_UNIT_OF_ITEM			,	
				-- ==========================	-- ============================
				[K_CURRENCY]					= @PP_K_CURRENCY				,	
				-- ====================		
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION
		WHERE	K_ITEM=@PP_K_ITEM
	
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Update] at [ITEM]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#ITEM.'+CONVERT(VARCHAR(10),@PP_K_ITEM)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ITEM AS CLAVE
	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////
--  EXECUTE [dbo].[PG_SK_ITEM] 0,139,9
--	EXECUTE [dbo].[PG_DL_ITEM] 0,139,9
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_ITEM]
GO

CREATE PROCEDURE [dbo].[PG_DL_ITEM]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_ITEM						INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ITEM_DELETE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_ITEM, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	ITEM
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_ITEM=@PP_K_ITEM
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Delete] at [ITEM]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#ITEM.'+CONVERT(VARCHAR(10),@PP_K_ITEM)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ITEM AS CLAVE

	-- //////////////////////////////////////////////////////////////	
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
