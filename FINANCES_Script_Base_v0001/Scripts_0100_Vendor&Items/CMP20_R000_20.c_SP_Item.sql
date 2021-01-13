-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			ITEM
-- // OPERATION:		TABLA
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200217
-- ////////////////////////////////////////////////////////////// 

--USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////
-- SELECT * FROM ITEM
-- SELECT * FROM CURRENCY
-- SELECT * FROM ITEM
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_ITEM]
GO
-- SELECT * FROM ITEM
-- EXECUTE [dbo].[PG_LI_ITEM] 0,139,'',-1,-1,-1,-1
CREATE PROCEDURE [dbo].[PG_LI_ITEM]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_BUSCAR						VARCHAR(200),
	@PP_K_VENDOR					INT,
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
				S_CURRENCY	,
				CONVERT(VARCHAR, CAST(PRICE_ITEM AS MONEY), 2) AS PRICE	,
				ITEM.*,	D_VENDOR,
				STATUS_ITEM.D_STATUS_ITEM, TYPE_ITEM.D_TYPE_ITEM, UNIT_OF_MEASURE.D_UNIT_OF_MEASURE, -- UNIT_OF_ITEM.D_UNIT_OF_ITEM,
				STATUS_ITEM.S_STATUS_ITEM, TYPE_ITEM.S_TYPE_ITEM, UNIT_OF_MEASURE.S_UNIT_OF_MEASURE, -- UNIT_OF_ITEM.S_UNIT_OF_ITEM,
				CLASS_ITEM.D_CLASS_ITEM,
				CLASS_ITEM.S_CLASS_ITEM
				-- =============================	
	FROM		ITEM,	VENDOR, 
				STATUS_ITEM, TYPE_ITEM,
				-- UNIT_OF_ITEM,
				BD_GENERAL.DBO.UNIT_OF_MEASURE,
				CLASS_ITEM,
				BD_GENERAL.DBO.CURRENCY
				-- =============================
	WHERE		ITEM.K_VENDOR=VENDOR.K_VENDOR
	AND			ITEM.K_STATUS_ITEM=STATUS_ITEM.K_STATUS_ITEM
	AND			ITEM.K_TYPE_ITEM=TYPE_ITEM.K_TYPE_ITEM
--	AND			ITEM.K_UNIT_OF_ITEM=UNIT_OF_ITEM.K_UNIT_OF_ITEM
	AND			ITEM.K_UNIT_OF_ITEM=UNIT_OF_MEASURE.K_UNIT_OF_MEASURE
	AND			ITEM.K_CURRENCY=CURRENCY.K_CURRENCY
	AND			ITEM.K_CLASS_ITEM=CLASS_ITEM.K_CLASS_ITEM
				-- =============================
	AND			(	ITEM.K_ITEM=@VP_K_FOLIO
				OR	ITEM.D_ITEM						LIKE '%'+@PP_BUSCAR+'%'
				OR	ITEM.PART_NUMBER_ITEM_VENDOR	LIKE '%'+@PP_BUSCAR+'%'
				OR	ITEM.PART_NUMBER_ITEM_PEARL		LIKE '%'+@PP_BUSCAR+'%'
				OR	ITEM.MODEL_ITEM					LIKE '%'+@PP_BUSCAR+'%'
				OR	ITEM.TRADEMARK_ITEM				LIKE '%'+@PP_BUSCAR+'%'
				OR	ITEM.PRICE_ITEM					LIKE '%'+@PP_BUSCAR+'%' )
				-- =============================
	AND			( @PP_K_VENDOR	=-1			OR	VENDOR.K_VENDOR=@PP_K_VENDOR )
	AND			( @PP_K_STATUS_ITEM	=-1		OR	ITEM.K_STATUS_ITEM=@PP_K_STATUS_ITEM )
	AND			( @PP_K_TYPE_ITEM =-1		OR	ITEM.K_TYPE_ITEM=@PP_K_TYPE_ITEM )
	AND			( @PP_K_CURRENCY =-1		OR	ITEM.K_CURRENCY=@PP_K_CURRENCY )
				-- =============================
	AND			ITEM.L_BORRADO<>1
	ORDER BY	K_VENDOR, D_ITEM,K_CURRENCY DESC
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> PARA MOSTRAR LOS ITEM EN LA CAPTURA 
-- // DE LA PO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_ITEM_PO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_ITEM_PO]
GO
-- SELECT * FROM ITEM
-- EXECUTE [dbo].[PG_LI_ITEM_PO] 0,139,282,1
CREATE PROCEDURE [dbo].[PG_LI_ITEM_PO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
--	@PP_BUSCAR						VARCHAR(200),
	@PP_K_VENDOR					INT,
	@PP_K_CURRENCY					INT
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1		
	-- ///////////////////////////////////////////
	DECLARE @VP_LI_N_REGISTROS	INT =5000	
	-- =========================================		
	----DECLARE @VP_K_FOLIO				INT
	----EXECUTE [BD_GENERAL].DBO.[PG_RN_OBTENER_ID_X_REFERENCIA]			
	----						@PP_BUSCAR,	@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================		
	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	SELECT		TOP (@VP_LI_N_REGISTROS)
				S_CURRENCY	,
				CONVERT(VARCHAR, CAST(PRICE_ITEM AS MONEY), 2) AS PRICE	,
				ITEM.*,	D_VENDOR,
				STATUS_ITEM.D_STATUS_ITEM, TYPE_ITEM.D_TYPE_ITEM, UNIT_OF_MEASURE.D_UNIT_OF_MEASURE, -- UNIT_OF_ITEM.D_UNIT_OF_ITEM,
				STATUS_ITEM.S_STATUS_ITEM, TYPE_ITEM.S_TYPE_ITEM, UNIT_OF_MEASURE.S_UNIT_OF_MEASURE, -- UNIT_OF_ITEM.S_UNIT_OF_ITEM,
				CLASS_ITEM.D_CLASS_ITEM,
				CLASS_ITEM.S_CLASS_ITEM
				-- =============================	
	FROM		ITEM,	VENDOR, 
				STATUS_ITEM, TYPE_ITEM,
				-- UNIT_OF_ITEM,
				BD_GENERAL.DBO.UNIT_OF_MEASURE,
				CLASS_ITEM,
				BD_GENERAL.DBO.CURRENCY
				-- =============================
	WHERE		ITEM.K_VENDOR=VENDOR.K_VENDOR
	AND			ITEM.K_STATUS_ITEM=STATUS_ITEM.K_STATUS_ITEM
	AND			ITEM.K_TYPE_ITEM=TYPE_ITEM.K_TYPE_ITEM
--	AND			ITEM.K_UNIT_OF_ITEM=UNIT_OF_ITEM.K_UNIT_OF_ITEM
	AND			ITEM.K_UNIT_OF_ITEM=UNIT_OF_MEASURE.K_UNIT_OF_MEASURE
	AND			ITEM.K_CURRENCY=CURRENCY.K_CURRENCY
	AND			ITEM.K_CLASS_ITEM=CLASS_ITEM.K_CLASS_ITEM
				-- =============================
	--AND			(	ITEM.K_ITEM=@VP_K_FOLIO
	--			OR	ITEM.PART_NUMBER_ITEM_VENDOR	LIKE '%'+@PP_BUSCAR+'%'
	--			OR	ITEM.PART_NUMBER_ITEM_PEARL		LIKE '%'+@PP_BUSCAR+'%'
	--			OR	ITEM.MODEL_ITEM					LIKE '%'+@PP_BUSCAR+'%'
	--			OR	ITEM.TRADEMARK_ITEM				LIKE '%'+@PP_BUSCAR+'%'
	--			OR	ITEM.PRICE_ITEM					LIKE '%'+@PP_BUSCAR+'%' )
				-- =============================
	AND			( @PP_K_VENDOR	 =-1			OR	VENDOR.K_VENDOR=@PP_K_VENDOR )
	AND			( @PP_K_CURRENCY =-1			OR	ITEM.K_CURRENCY=@PP_K_CURRENCY )
	----AND			( @PP_K_STATUS_ITEM	=-1		OR	ITEM.K_STATUS_ITEM=@PP_K_STATUS_ITEM )
	----AND			( @PP_K_TYPE_ITEM =-1		OR	ITEM.K_TYPE_ITEM=@PP_K_TYPE_ITEM )
				-- =============================
	AND			ITEM.L_BORRADO<>1
	ORDER BY	K_VENDOR, D_ITEM,K_CURRENCY DESC
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> PARA MOSTRAR EL HISTORIAL DE LOS PRECIOS
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_ITEM_PO_PRICE_LOG]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_ITEM_PO_PRICE_LOG]
GO	
--		 EXECUTE [dbo].[PG_LI_ITEM_PO_PRICE_LOG] 0,139
CREATE PROCEDURE [dbo].[PG_LI_ITEM_PO_PRICE_LOG]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT
	-- ===========================
AS
	--	DECLARE @VP_MENSAJE				VARCHAR(300) = ''	
	-- ////////////////////////////////////////////////////////////////////
	SELECT		PO_PRICE_LOG.K_ITEM,
				F_CHANGE_PRICE					AS F_CHANGE_PRICE,
				PO_PRICE_LOG.UNIT_PRICE_HISTORY AS PRICE_RECORD,
				PO_PRICE_LOG.UNIT_PRICE			AS PRICE_CURRENT,
				D_ITEM,
				D_USUARIO_PEARL					AS D_USUARIO
	FROM		PO_PRICE_LOG
	LEFT JOIN	BD_GENERAL.DBO.USUARIO_PEARL	ON	PO_PRICE_LOG.K_USUARIO=K_USUARIO_PEARL
	LEFT JOIN	ITEM							ON	PO_PRICE_LOG.K_ITEM=ITEM.K_ITEM
	WHERE		ITEM.L_BORRADO=0
	AND			PO_PRICE_LOG.UNIT_PRICE_HISTORY<>0
				
	-- ////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_ITEM]
GO
-- EXECUTE [dbo].[PG_SK_ITEM] 0,139,32
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
			SET @VP_LI_N_REGISTROS = 1			
		SELECT	TOP (@VP_LI_N_REGISTROS)
				-- =============================
				-- PARA INDICAR EL TOTAL DEL ITEM
				CONVERT(VARCHAR, CAST(PRICE_ITEM AS MONEY), 2) AS TOTAL_ITEM,
				-- =============================
				( CASE
					WHEN	[PART_NUMBER_ITEM_PEARL]='0'	THEN	''
					ELSE	[PART_NUMBER_ITEM_PEARL]	END
				)	AS PART_NUMBER_ITEM_PEARL,
				-- =============================
				1 as QUANTITY,
				S_CURRENCY	,
				CONVERT(VARCHAR, CAST(PRICE_ITEM AS MONEY), 2) AS PRICE	,
				ITEM.*,	D_VENDOR,
				STATUS_ITEM.D_STATUS_ITEM, TYPE_ITEM.D_TYPE_ITEM,UNIT_OF_MEASURE.D_UNIT_OF_MEASURE, -- UNIT_OF_ITEM.D_UNIT_OF_ITEM,
				STATUS_ITEM.S_STATUS_ITEM, TYPE_ITEM.S_TYPE_ITEM,UNIT_OF_MEASURE.S_UNIT_OF_MEASURE, -- UNIT_OF_ITEM.S_UNIT_OF_ITEM,
				CLASS_ITEM.D_CLASS_ITEM,
				CLASS_ITEM.S_CLASS_ITEM
				-- =============================
		FROM 	ITEM,	VENDOR, 
				STATUS_ITEM, TYPE_ITEM,
				--UNIT_OF_ITEM,
				BD_GENERAL.DBO.UNIT_OF_MEASURE,
				CLASS_ITEM,
				BD_GENERAL.DBO.CURRENCY
				-- =============================
		WHERE	ITEM.K_VENDOR=VENDOR.K_VENDOR
		AND		ITEM.K_STATUS_ITEM=STATUS_ITEM.K_STATUS_ITEM
		AND		ITEM.K_TYPE_ITEM=TYPE_ITEM.K_TYPE_ITEM
--		AND		ITEM.K_UNIT_OF_ITEM=UNIT_OF_ITEM.K_UNIT_OF_ITEM
		AND		ITEM.K_UNIT_OF_ITEM=UNIT_OF_MEASURE.K_UNIT_OF_MEASURE
		AND		ITEM.K_CURRENCY=CURRENCY.K_CURRENCY
		AND		ITEM.K_CLASS_ITEM=CLASS_ITEM.K_CLASS_ITEM
		AND		ITEM.K_ITEM=@PP_K_ITEM
		
	-- ////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> PARA ACTUALIZAR EL LOG DE PRECIOS
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_LOG_PRECIOS_ITEM_NUEVOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_LOG_PRECIOS_ITEM_NUEVOS]
GO

CREATE PROCEDURE [dbo].[PG_IN_LOG_PRECIOS_ITEM_NUEVOS]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_ITEM						INT,
	-- ============================
	@PP_K_PO_PRICE					INT,		
	@PP_PRICE_ITEM					DECIMAL(10,4)
AS
DECLARE  @VP_MENSAJE				VARCHAR(300) = ''

	INSERT INTO [PO_PRICE_LOG]
	(	[K_PO_PRICE]			,
		[K_ITEM]				,	[UNIT_PRICE]		,
		[K_USUARIO]				,	[F_CHANGE_PRICE]
	)
	VALUES
	(	@PP_K_PO_PRICE			,
		@PP_K_ITEM				,	@PP_PRICE_ITEM		,
		@PP_K_USUARIO_ACCION	,	GETDATE()
	)

	IF @@ROWCOUNT = 0
	BEGIN
		SET @VP_MENSAJE ='Error del LOG de Precios. [ITEM#'+CONVERT(VARCHAR(10),@PP_K_ITEM)+']'
		RAISERROR (@VP_MENSAJE, 16, 1 ) 
	END			
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> PARA ACTUALIZAR EL LOG DE PRECIOS
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_LOG_PRECIOS_ITEM_MODIFICADOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_LOG_PRECIOS_ITEM_MODIFICADOS]
GO

CREATE PROCEDURE [dbo].[PG_IN_LOG_PRECIOS_ITEM_MODIFICADOS]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_ITEM						INT,
	-- ============================
	@PP_K_PO_PRICE					INT,		
	@PP_PRICE_ITEM					DECIMAL(10,4),
	@PP_PRICE_ITEM_ORIGINAL			DECIMAL(10,4)
AS	
DECLARE  @VP_MENSAJE				VARCHAR(300) = ''
		,@VP_K_PRICE_LOG			INT

IF @PP_PRICE_ITEM<>@PP_PRICE_ITEM_ORIGINAL
BEGIN	
	SELECT	TOP(1) @VP_K_PRICE_LOG = K_PO_PRICE
	FROM		[PO_PRICE_LOG]
	WHERE		K_ITEM=@PP_K_ITEM
	ORDER BY	K_PO_PRICE	DESC
	
		IF @VP_K_PRICE_LOG IS NULL
		BEGIN
			RAISERROR ('LOG_PRICE no puede ser NULL', 16, 1 ) 
		END
		
	SET @PP_K_PO_PRICE = @VP_K_PRICE_LOG + 1
	
	INSERT INTO [PO_PRICE_LOG]
	(	[K_PO_PRICE]			,
		[K_ITEM]				,	[UNIT_PRICE]		,
		[K_USUARIO]				,	[F_CHANGE_PRICE]	,
		[UNIT_PRICE_HISTORY]
	)
	VALUES
	(	@PP_K_PO_PRICE			,
		@PP_K_ITEM				,	@PP_PRICE_ITEM		,
		@PP_K_USUARIO_ACCION	,	GETDATE()			,
		@PP_PRICE_ITEM_ORIGINAL
	)
	
		IF @@ROWCOUNT = 0
		BEGIN
			SET @VP_MENSAJE ='El PRICE_LOG no fue actualizado. [ITEM#'+CONVERT(VARCHAR(10),@PP_K_ITEM)+']'
			RAISERROR (@VP_MENSAJE, 16, 1 ) 
		END
	---- ============================================================================================================================================
	----	LA ACTUALIZACIÓN LA HACE EN CUALQUIER CASO, LA ÚNICA CONDICIÓN ES QUE EL PRECIO ORIGINAL SEA DIFERENTE AL PRECIO INGRESADO.
	---- ============================================================================================================================================	
		UPDATE	ITEM
		SET		
				-- ==========================	-- ===========================
				[K_PO_PRICE]					= @PP_K_PO_PRICE				,
				[PRICE_ITEM]					= @PP_PRICE_ITEM				,	
				-- ==========================	-- ===========================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION
		WHERE	K_ITEM=@PP_K_ITEM
	
			IF @@ROWCOUNT = 0
			BEGIN
				SET @VP_MENSAJE ='El [Precio] no fue actualizado. [ITEM#'+CONVERT(VARCHAR(10),@PP_K_ITEM)+']'
				RAISERROR (@VP_MENSAJE, 16, 1 ) 
			END
	-- ============================================================================================================================================
	--	DESDE AQUÍ SE MANDARÁ ACTUALIZAR LOS PRECIOS PARA LOS SPECIAL_PROCESS
	-- ============================================================================================================================================
		EXECUTE [dbo].[PG_UP_PRECIOS_BACKING_YARDAGE_X_ITEM]	@PP_K_SISTEMA_EXE			,@PP_K_USUARIO_ACCION
																-- ========================================
																,@PP_K_ITEM
	-- ============================================================================================================================================
	-- ============================================================================================================================================
END
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //	CUANDO SE ACTUALICE ESTE SP SE DEBE ACTUALIZAR EL QUE REGRESA EL K_ITEM
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_ITEM]
GO
--	SELECT * FROM COMPRAS.DBO.ITEM
--	SELECT * FROM ITEM
--		 EXECUTE [dbo].[PG_IN_ITEM] 0,139,   1 , 'TRAPEADOR' , '' , '' , '' , '' , '1' , '45' , 1 , 1 , 11 , 1
CREATE PROCEDURE [dbo].[PG_IN_ITEM]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VENDOR					INT,
	@PP_D_ITEM						NVARCHAR(MAX),
	-- ===========================
	@PP_PART_NUMBER_ITEM_VENDOR		VARCHAR(250),
	@PP_PART_NUMBER_ITEM_PEARL		VARCHAR(250),
	-- ===========================
	@PP_TRADEMARK_ITEM				VARCHAR(100),
	@PP_MODEL_ITEM					VARCHAR(100),
	-- ============================	
	@PP_K_PO_PRICE					INT,
	@PP_PRICE_ITEM					DECIMAL(10,4),
	-- ===========================
	@PP_K_STATUS_ITEM				INT,
	@PP_K_TYPE_ITEM					INT,
	@PP_K_UNIT_OF_ITEM				INT,
	-- ============================
	@PP_K_CURRENCY					INT,
	@PP_K_CLASS_ITEM				INT
AS			
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_K_ITEM			INT = 0
BEGIN TRANSACTION 
BEGIN TRY
	-- /////////////////////////////////////////////////////////////////////
	IF @PP_K_CLASS_ITEM=2	AND		@PP_K_USUARIO_ACCION <> 139
	BEGIN
		--RAISERROR ('It is not possible to insert ITEMS with class ROW_MATERIAL in this module', 16, 1 )
		RAISERROR ('No es posible insertar ITEMS de clase ROW_MATERIAL en este módulo. Diríjase a ITEM_MASTER', 16, 1 )
	END
	
	DECLARE @VP_BD_NAME				VARCHAR(300) = ''
	IF	@PP_K_SISTEMA_EXE=0
	BEGIN
		SET @VP_BD_NAME='COMPRAS_Pruebas'
	END
	ELSE
	BEGIN
		SET @VP_BD_NAME='COMPRAS'
	END

	EXECUTE [BD_GENERAL].dbo.[PG_SK_CATALOGO_K_MAX_GET]		@PP_K_SISTEMA_EXE, @VP_BD_NAME,
															'ITEM', 'K_ITEM',
															@OU_K_TABLA_DISPONIBLE = @VP_K_ITEM	OUTPUT
	-- /////////////////////////////////////////////////////////////////////
	EXECUTE [dbo].[PG_RN_VENDOR_INSERT]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@PP_K_VENDOR, 
											@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	IF @VP_MENSAJE<>''
	BEGIN
		RAISERROR (@VP_MENSAJE, 16, 1 )
	END

	EXECUTE [dbo].[PG_RN_ITEM_INSERT]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@VP_K_ITEM, 
											@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		RAISERROR (@VP_MENSAJE, 16, 1 )
	END
	
	EXECUTE [dbo].[PG_RN_ITEM_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@PP_K_VENDOR, @VP_K_ITEM, @PP_D_ITEM,
											@PP_PART_NUMBER_ITEM_VENDOR,
											@PP_PART_NUMBER_ITEM_PEARL,
											@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT	
		-- //////////////////////////////////////////////////////////////
	IF @VP_MENSAJE<>''
	BEGIN
		RAISERROR (@VP_MENSAJE, 16, 1 )
	END

	IF @PP_PART_NUMBER_ITEM_PEARL=''
	BEGIN 
		SET @PP_PART_NUMBER_ITEM_PEARL=0
	END

	INSERT INTO ITEM
		(	[K_ITEM]	,		[D_ITEM]	, 
			[O_ITEM]	,
			 -- ============================
			[PART_NUMBER_ITEM_VENDOR]		,
			[PART_NUMBER_ITEM_PEARL]		,
			 -- ============================
			[TRADEMARK_ITEM]	,	[MODEL_ITEM]		,	
			 -- ============================
			[K_PO_PRICE]		,	[PRICE_ITEM]		,			
			-- ============================	
			[K_STATUS_ITEM]		,	[K_TYPE_ITEM]		,
			[K_UNIT_OF_ITEM]	,
			-- ============================	
			[K_CURRENCY]		,	[K_VENDOR]			,
			[K_CLASS_ITEM]		,
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
			@PP_TRADEMARK_ITEM	,	
			@PP_MODEL_ITEM		,	
			-- ===========================				
			@PP_K_PO_PRICE		,	@PP_PRICE_ITEM		,			
			-- ===========================
			@PP_K_STATUS_ITEM	,	@PP_K_TYPE_ITEM		,			
			@PP_K_UNIT_OF_ITEM	,			
			-- ============================
			@PP_K_CURRENCY		,	@PP_K_VENDOR		,
			@PP_K_CLASS_ITEM	,		
			-- ===========================
			@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL  )

		IF @@ROWCOUNT = 0
			BEGIN
				--DECLARE @VP_ERROR_2 VARCHAR(250)='The item was not inserted. [ITEM#'+CONVERT(VARCHAR(10),@VP_K_ITEM)+']'
				SET @VP_MENSAJE='El ITEM no fue insertado. [ITEM#'+CONVERT(VARCHAR(10),@VP_K_ITEM)+']'
				RAISERROR (@VP_MENSAJE, 16, 1 )
			END		

	EXECUTE [dbo].[PG_IN_LOG_PRECIOS_ITEM_NUEVOS]	@PP_K_SISTEMA_EXE	,@PP_K_USUARIO_ACCION			
													,@VP_K_ITEM
													-- ============================
													,@PP_K_PO_PRICE					,@PP_PRICE_ITEM
	-- /////////////////////////////////////////////////////////////////////
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	/* Ocurrió un error, deshacemos los cambios*/ 
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH
	
	IF @VP_MENSAJE<>''
		BEGIN
			SET	@VP_MENSAJE = 'No es posible [Agregar] el [ITEM]: ' + @VP_MENSAJE 
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_ITEM AS CLAVE
	-- //////////////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- // CUANDO SE ACTUALICE ESTE SP SE DEBE ACTUALIZAR EL QUE REGRESA EL K_ITEM
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_ITEM_PARA_MASTER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_ITEM_PARA_MASTER]
GO
CREATE PROCEDURE [dbo].[PG_IN_ITEM_PARA_MASTER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VENDOR					INT,
	@PP_D_ITEM						NVARCHAR(MAX),
	-- ===========================
	@PP_PART_NUMBER_ITEM_VENDOR		VARCHAR(250),
	@PP_PART_NUMBER_ITEM_PEARL		VARCHAR(250),
	-- ===========================
	@PP_TRADEMARK_ITEM				VARCHAR(100),
	@PP_MODEL_ITEM					VARCHAR(100),
	-- ============================	
	@PP_K_PO_PRICE					INT,
	@PP_PRICE_ITEM					DECIMAL(10,4),
	-- ===========================
	@PP_K_STATUS_ITEM				INT,
	@PP_K_TYPE_ITEM					INT,
	@PP_K_UNIT_OF_ITEM				INT,
	-- ============================
	@PP_K_CURRENCY					INT,
	@PP_K_CLASS_ITEM				INT,
	@OU_K_ITEM						VARCHAR(200)		OUTPUT
AS			
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_K_ITEM			INT = 0
	-- /////////////////////////////////////////////////////////////////////
	DECLARE @VP_BD_NAME				VARCHAR(300) = ''
	IF	@PP_K_SISTEMA_EXE=0
	BEGIN
		SET @VP_BD_NAME='COMPRAS_Pruebas'
	END
	ELSE
	BEGIN
		SET @VP_BD_NAME='COMPRAS'
	END

	EXECUTE [BD_GENERAL].dbo.[PG_SK_CATALOGO_K_MAX_GET]		@PP_K_SISTEMA_EXE, @VP_BD_NAME,
															'ITEM', 'K_ITEM',
															@OU_K_TABLA_DISPONIBLE = @VP_K_ITEM	OUTPUT
	-- /////////////////////////////////////////////////////////////////////
	EXECUTE [dbo].[PG_RN_VENDOR_INSERT]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@PP_K_VENDOR, 
											@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	IF @VP_MENSAJE<>''
	BEGIN
		RAISERROR (@VP_MENSAJE, 16, 1 )
	END
	
	EXECUTE [dbo].[PG_RN_ITEM_INSERT]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@VP_K_ITEM, 
											@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		RAISERROR (@VP_MENSAJE, 16, 1 )
	END
	
	EXECUTE [dbo].[PG_RN_ITEM_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@PP_K_VENDOR, @VP_K_ITEM, @PP_D_ITEM,
											@PP_PART_NUMBER_ITEM_VENDOR,
											@PP_PART_NUMBER_ITEM_PEARL,
											@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT													
		-- //////////////////////////////////////////////////////////////
	IF @VP_MENSAJE<>''
	BEGIN
		RAISERROR (@VP_MENSAJE, 16, 1 )
	END

	IF @PP_PART_NUMBER_ITEM_PEARL=''
	BEGIN 
		SET @VP_MENSAJE='PART_NUMBER_ITEM_PEARL. No debe estar vacío. Verifique...'
		RAISERROR (@VP_MENSAJE, 16, 1 )
	END

	INSERT INTO ITEM
		(	[K_ITEM]	,		[D_ITEM]	, 
			[O_ITEM]	,
			 -- ============================
			[PART_NUMBER_ITEM_VENDOR]		,
			[PART_NUMBER_ITEM_PEARL]		,
			 -- ============================
			[TRADEMARK_ITEM]	,	[MODEL_ITEM]		,	
			 -- ============================
			[K_PO_PRICE]		,	[PRICE_ITEM]		,			
			-- ============================	
			[K_STATUS_ITEM]		,	[K_TYPE_ITEM]		,
			[K_UNIT_OF_ITEM]	,
			-- ============================	
			[K_CURRENCY]		,	[K_VENDOR]			,
			[K_CLASS_ITEM]		,
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
			@PP_TRADEMARK_ITEM	,	
			@PP_MODEL_ITEM		,	
			-- ===========================				
			@PP_K_PO_PRICE		,	@PP_PRICE_ITEM		,			
			-- ===========================
			@PP_K_STATUS_ITEM	,	@PP_K_TYPE_ITEM		,			
			@PP_K_UNIT_OF_ITEM	,			
			-- ============================
			@PP_K_CURRENCY		,	@PP_K_VENDOR		,
			@PP_K_CLASS_ITEM	,		
			-- ===========================
			@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL  )

		IF @@ROWCOUNT = 0
		BEGIN
			--RAISERROR (@VP_ERROR_1, 16, 1 ) 
			DECLARE @VP_ERROR_2 VARCHAR(250)='El ITEM no fue agregado. [ITEM#'+CONVERT(VARCHAR(10),@VP_K_ITEM)+']'
			RAISERROR (@VP_ERROR_2, 16, 1 )
		END

	EXECUTE [dbo].[PG_IN_LOG_PRECIOS_ITEM_NUEVOS]	@PP_K_SISTEMA_EXE	,@PP_K_USUARIO_ACCION			
													,@VP_K_ITEM
													-- ============================
													,@PP_K_PO_PRICE					,@PP_PRICE_ITEM			
		
	-- ASIGNAR K_LOTE A LOS ITEM. SE AGREGA CONSECUTIVO SEGÚN SE VAN INSERTANDO.
	DECLARE @VP_K_LOTE	INT
	
	SET @VP_K_LOTE=	(	SELECT	TOP(1)
							K_LOTE
							FROM	DBO.ITEM
							ORDER BY K_LOTE DESC
					) + 1
	
	UPDATE	DBO.ITEM
	SET		K_LOTE	= @VP_K_LOTE
	WHERE	K_ITEM	= @VP_K_ITEM
	
	IF @@ROWCOUNT = 0
	BEGIN
		SET @VP_MENSAJE ='No se pudó insertar el Lote del ITEM. [ITEM#'+CONVERT(VARCHAR(10),@VP_K_ITEM)+']'
		RAISERROR (@VP_ERROR_2, 16, 1 )
	END	
	
	SET @OU_K_ITEM = @VP_K_ITEM
	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> PARA ACTUALIZAR ITEM DESDE COMPRAS O ITEM MASTER
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ITEM_SIN_REGISTROS_PO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_ITEM_SIN_REGISTROS_PO]
GO

CREATE PROCEDURE [dbo].[PG_UP_ITEM_SIN_REGISTROS_PO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VENDOR					INT,
	@PP_K_ITEM						INT,
	@PP_D_ITEM						NVARCHAR(MAX),
	-- ===========================
	@PP_PART_NUMBER_ITEM_VENDOR		VARCHAR(250),
	@PP_PART_NUMBER_ITEM_PEARL		VARCHAR(250),
	-- ===========================
	@PP_TRADEMARK_ITEM				VARCHAR(100),
	@PP_MODEL_ITEM					VARCHAR(100),
	-- ============================	
	@PP_K_PO_PRICE					INT,
	@PP_PRICE_ITEM					DECIMAL(10,4),
	-- ===========================
	@PP_K_STATUS_ITEM				INT,
	@PP_K_TYPE_ITEM					INT,
	@PP_K_UNIT_OF_ITEM				INT,
	-- ============================
	@PP_K_CURRENCY					INT,
	@PP_K_CLASS_ITEM				INT
AS	

	UPDATE	ITEM
	SET		
			[K_VENDOR]						= @PP_K_VENDOR	,
			[D_ITEM]						= @PP_D_ITEM	,
			-- ==========================	-- ===========================
			[PART_NUMBER_ITEM_VENDOR]		= @PP_PART_NUMBER_ITEM_VENDOR	,	
			[PART_NUMBER_ITEM_PEARL]		= @PP_PART_NUMBER_ITEM_PEARL	,	
			-- ==========================	-- ===========================
			[TRADEMARK_ITEM]				= @PP_TRADEMARK_ITEM			,	
			[MODEL_ITEM]					= @PP_MODEL_ITEM				,	
			-- ==========================	-- ===========================
			[K_PO_PRICE]					= @PP_K_PO_PRICE				,
			[PRICE_ITEM]					= @PP_PRICE_ITEM				,	
			-- ==========================	-- ===========================
			[K_STATUS_ITEM]					= @PP_K_STATUS_ITEM				,
			[K_TYPE_ITEM]					= @PP_K_TYPE_ITEM				,	
			[K_UNIT_OF_ITEM]				= @PP_K_UNIT_OF_ITEM			,	
			-- ==========================	-- ============================
			[K_CURRENCY]					= @PP_K_CURRENCY				,
			[K_CLASS_ITEM]					= @PP_K_CLASS_ITEM				,	
			-- ====================		
			[F_CAMBIO]						= GETDATE(), 
			[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION
	WHERE	K_ITEM=@PP_K_ITEM
	
	IF @@ROWCOUNT = 0
	BEGIN
		DECLARE @VP_ERROR_2 VARCHAR(250)='El ITEM no fue actualizado. [ITEM#'+CONVERT(VARCHAR(10),@PP_K_ITEM)+']'
		RAISERROR (@VP_ERROR_2, 16, 1 ) 
	END
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_SK_ITEM] 0,139,9
-- EXECUTE [dbo].[PG_UP_ITEM] 0,139,   1 , 28 , 'RECOGEDOR' , '' , '' , '' , '' , '1' , '28.0000' , 1 , 1 , 11 , 1 
-- EXECUTE [dbo].[PG_UP_ITEM] 0,139,  1 , 21 , 'TELFONO IP' , '76855545649' , '' , 'PANASONIC' , 'KX-T7630' , '2,890.50' , 1 , 1 , 11 , 1
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_ITEM]
GO

CREATE PROCEDURE [dbo].[PG_UP_ITEM]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VENDOR					INT,
	@PP_K_ITEM						INT,
	@PP_D_ITEM						NVARCHAR(MAX),
	-- ===========================
	@PP_PART_NUMBER_ITEM_VENDOR		VARCHAR(250),
	@PP_PART_NUMBER_ITEM_PEARL		VARCHAR(250),
	-- ===========================
	@PP_TRADEMARK_ITEM				VARCHAR(100),
	@PP_MODEL_ITEM					VARCHAR(100),
	-- ============================	
	@PP_K_PO_PRICE					INT,
	@PP_PRICE_ITEM					DECIMAL(10,4),
	-- ===========================
	@PP_K_STATUS_ITEM				INT,
	@PP_K_TYPE_ITEM					INT,
	@PP_K_UNIT_OF_ITEM				INT,
	-- ============================
	@PP_K_CURRENCY					INT,
	@PP_K_CLASS_ITEM				INT
AS			
DECLARE @VP_MENSAJE					VARCHAR(300) = ''
		,@VP_K_PRICE_LOG			INT
BEGIN TRANSACTION 
BEGIN TRY
	IF @PP_K_CLASS_ITEM=2	AND	@PP_K_USUARIO_ACCION<>139
	BEGIN
		RAISERROR ('No es posible actualizar ITEMS de clase ROW_MATERIAL en este módulo.', 16, 1 )
	END

	-- /////////////////////////////////////////////////////////////////////
	EXECUTE [dbo].[PG_RN_VENDOR_INSERT]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@PP_K_VENDOR, 
											@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	IF @VP_MENSAJE<>''
	BEGIN
		RAISERROR (@VP_MENSAJE, 16, 1 )
	END
	EXECUTE [dbo].[PG_RN_ITEM_UPDATE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@PP_K_ITEM, 
											@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE<>''
	BEGIN
		RAISERROR (@VP_MENSAJE, 16, 1 )
	END
	EXECUTE [dbo].[PG_RN_ITEM_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@PP_K_VENDOR, @PP_K_ITEM, @PP_D_ITEM,
											@PP_PART_NUMBER_ITEM_VENDOR,
											@PP_PART_NUMBER_ITEM_PEARL,
											@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT	
	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		RAISERROR (@VP_MENSAJE, 16, 1 )
	END
	
	--	PARA REALIZAR LA ACTUALIZACIÓN DEL LOG DE PRECIOS DE LOS ITEM
	DECLARE @PP_PRICE_ITEM_ORIGINAL		[DECIMAL](10,4)=0.0000
	
	SELECT	@PP_PRICE_ITEM_ORIGINAL=[PRICE_ITEM]
	FROM	ITEM
	WHERE	[K_ITEM]=@PP_K_ITEM
		IF @@ROWCOUNT = 0
		BEGIN
			SET @VP_MENSAJE ='No fue posible encontrar el precio del ITEM. [ITEM#'+CONVERT(VARCHAR(10),@PP_K_ITEM)+']'
			RAISERROR (@VP_MENSAJE, 16, 1 )
		END
	-- /////////////////////////////////////////////////////////////////////	
	--	CUANDO SE DESEA CAMBIAR EL PROVEEDOR DE UN ARTÍCULO Y ESTE YA SE ENCUENTRA AGREGADO EN ALGUNA PO,
	--	YA NO SE PUEDE ALTERAR SE DEBE CREAR UNO NUEVO PARA EL PROVEEDOR.
		DECLARE @PP_EXISTE_ITEM		INT			

		SELECT	@PP_EXISTE_ITEM=COUNT([K_ITEM])
		FROM	DETAILS_PURCHASE_ORDER
		INNER JOIN HEADER_PURCHASE_ORDER ON HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=DETAILS_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER
		WHERE	[K_ITEM]	=	@PP_K_ITEM
		AND		[L_BORRADO]	<>	1
		
		-- SE VERIFICA LA EXISTENCIA DEL ITEM EN ALGUNA PO, SI NO EXISTE SE PUEDE MODIFICAR COMPLETAMENTE.
		IF @PP_EXISTE_ITEM<=0 OR @PP_EXISTE_ITEM IS NULL
		BEGIN
			EXECUTE [dbo].[PG_UP_ITEM_SIN_REGISTROS_PO]	@PP_K_SISTEMA_EXE	,@PP_K_USUARIO_ACCION			
														-- ===========================
														,@PP_K_VENDOR					,@PP_K_ITEM						
														,@PP_D_ITEM						
														-- ===========================
														,@PP_PART_NUMBER_ITEM_VENDOR	,@PP_PART_NUMBER_ITEM_PEARL		
														-- ===========================
														,@PP_TRADEMARK_ITEM				,@PP_MODEL_ITEM					
														-- ============================	
														,@PP_K_PO_PRICE					,@PP_PRICE_ITEM					
														-- ===========================
														,@PP_K_STATUS_ITEM				,@PP_K_TYPE_ITEM					
														,@PP_K_UNIT_OF_ITEM				
														-- ============================
														,@PP_K_CURRENCY					,@PP_K_CLASS_ITEM
		END
				
		EXECUTE [dbo].[PG_IN_LOG_PRECIOS_ITEM_MODIFICADOS]	@PP_K_SISTEMA_EXE	,@PP_K_USUARIO_ACCION			
												,@PP_K_ITEM
												-- ============================
												,@PP_K_PO_PRICE					,@PP_PRICE_ITEM
												,@PP_PRICE_ITEM_ORIGINAL

-- /////////////////////////////////////////////////////////////////////
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	/* Ocurrió un error, deshacemos los cambios*/ 
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH
	
	IF @VP_MENSAJE<>''
	BEGIN
		SET	@VP_MENSAJE = 'No es posible [Actualizar] el [ITEM]: ' + @VP_MENSAJE 
	END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ITEM AS CLAVE
	-- //////////////////////////////////////////////////////////////
	
GO

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE SE MANDA LLAMAR DESDE ITEM_MASTER
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ITEM_PARA_MASTER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_ITEM_PARA_MASTER]
GO

CREATE PROCEDURE [dbo].[PG_UP_ITEM_PARA_MASTER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VENDOR					INT,
	@PP_K_ITEM						INT,
	@PP_D_ITEM						NVARCHAR(MAX),
	-- ===========================
	@PP_PART_NUMBER_ITEM_VENDOR		VARCHAR(250),
	@PP_PART_NUMBER_ITEM_PEARL		VARCHAR(250),
	-- ===========================
	@PP_TRADEMARK_ITEM				VARCHAR(100),
	@PP_MODEL_ITEM					VARCHAR(100),
	-- ============================	
	@PP_K_PO_PRICE					INT,
	@PP_PRICE_ITEM					DECIMAL(10,4),
	-- ===========================
	@PP_K_STATUS_ITEM				INT,
	@PP_K_TYPE_ITEM					INT,
	@PP_K_UNIT_OF_ITEM				INT,
	-- ============================
	@PP_K_CURRENCY					INT,
	@PP_K_CLASS_ITEM				INT,
	@OU_ES_ACTUALIZABLE				INT		OUTPUT		--0 NO SE PUEDE ACTUALIZAR / 1 SE PUEDE ACTUALIZAR
AS			
DECLARE @VP_MENSAJE				VARCHAR(300) = ''
		,@VP_K_PRICE_LOG			INT
	-- /////////////////////////////////////////////////////////////////////
	EXECUTE [dbo].[PG_RN_VENDOR_INSERT]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@PP_K_VENDOR, 
											@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	IF @VP_MENSAJE<>''
	BEGIN
		RAISERROR (@VP_MENSAJE, 16, 1 )
	END

	EXECUTE [dbo].[PG_RN_ITEM_UPDATE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@PP_K_ITEM, 
											@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE<>''
	BEGIN
		RAISERROR (@VP_MENSAJE, 16, 1 )
	END
	
	EXECUTE [dbo].[PG_RN_ITEM_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@PP_K_VENDOR, @PP_K_ITEM, @PP_D_ITEM,
											@PP_PART_NUMBER_ITEM_VENDOR,
											@PP_PART_NUMBER_ITEM_PEARL,
											@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		RAISERROR (@VP_MENSAJE, 16, 1 )
	END

	--	PARA REALIZAR LA ACTUALIZACIÓN DEL LOG DE PRECIOS DE LOS ITEM
	DECLARE @PP_PRICE_ITEM_ORIGINAL		[DECIMAL](10,4)=0.0000
	
	SELECT	@PP_PRICE_ITEM_ORIGINAL=[PRICE_ITEM]
	FROM	ITEM
	WHERE	[K_ITEM]=@PP_K_ITEM
	IF @@ROWCOUNT = 0
	BEGIN
		SET @VP_MENSAJE ='No fue posible encontrar el precio del ITEM. [ITEM#'+CONVERT(VARCHAR(10),@PP_K_ITEM)+']'
		RAISERROR (@VP_MENSAJE, 16, 1 )
	END
	-- ==================================================================================================================================================================
	-- ==================================================================================================================================================================
	-- ==================================================================================================================================================================
	--	CUANDO SE DESEA CAMBIAR EL PROVEEDOR DE UN ARTÍCULO Y ESTE YA SE ENCUENTRA AGREGADO EN ALGUNA PO,
	--	YA NO SE PUEDE ALTERAR SE DEBE CREAR UNO NUEVO PARA EL PROVEEDOR.
	DECLARE @PP_EXISTE_ITEM		INT			

	-- SE VERIFICA SI EL ARTÍCULO EXISTE AGREGADO A UNA ORDEN DE COMPRA, CUANDO ESTO SUCEDE LO ÚNICO QUE SE PUEDE ACTUALIZAR SERÁ EL PRECIO
	SELECT	@PP_EXISTE_ITEM=COUNT([K_ITEM])
	FROM	DETAILS_PURCHASE_ORDER
	INNER JOIN HEADER_PURCHASE_ORDER ON HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=DETAILS_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER
	WHERE	[K_ITEM]	=	@PP_K_ITEM
	AND		[L_BORRADO]	<>	1
	-- /////////////////////////////////////////////////////////////////////
	-- SI NO EXISTE AGRGADO A UNA PO, SE PODRÁ ACTUALIZAR TODOS LOS DATOS E INCLUSO REALIZARÁ LA ACTUALIZACIÓN DEL PRECIO JUNTO CON EL LOG_PRECIO EN CASO DE SER NECESARIO.
	IF @PP_EXISTE_ITEM<=0 OR @PP_EXISTE_ITEM IS NULL
	BEGIN
		EXECUTE [dbo].[PG_UP_ITEM_SIN_REGISTROS_PO]	@PP_K_SISTEMA_EXE	,@PP_K_USUARIO_ACCION			
													-- ===========================
													,@PP_K_VENDOR					,@PP_K_ITEM						
													,@PP_D_ITEM						
													-- ===========================
													,@PP_PART_NUMBER_ITEM_VENDOR	,@PP_PART_NUMBER_ITEM_PEARL		
													-- ===========================
													,@PP_TRADEMARK_ITEM				,@PP_MODEL_ITEM					
													-- ============================	
													,@PP_K_PO_PRICE					,@PP_PRICE_ITEM					
													-- ===========================
													,@PP_K_STATUS_ITEM				,@PP_K_TYPE_ITEM					
													,@PP_K_UNIT_OF_ITEM				
													-- ============================
													,@PP_K_CURRENCY					,@PP_K_CLASS_ITEM				

		-- SE ENVÍA PARA SABER SI SE ACTUALIZARÁ TODA LA INFORMACIÓN O SÓLO EL PRECIO.	#1 ACTUALIZAR TODA LA INFORMACIÓN
		SET @OU_ES_ACTUALIZABLE = 1														
	END
	ELSE
	BEGIN
		-- SE ENVÍA PARA SABER SI SE ACTUALIZARÁ TODA LA INFORMACIÓN O SÓLO EL PRECIO.	#1 ACTUALIZAR TODA LA INFORMACIÓN
		SET @OU_ES_ACTUALIZABLE = 0
	END

	EXECUTE [dbo].[PG_IN_LOG_PRECIOS_ITEM_MODIFICADOS]	@PP_K_SISTEMA_EXE	,@PP_K_USUARIO_ACCION			
										,@PP_K_ITEM
										-- ============================
										,@PP_K_PO_PRICE					,@PP_PRICE_ITEM
										,@PP_PRICE_ITEM_ORIGINAL

	-- /////////////////////////////////////////////////////////////////////
	-- ==================================================================================================================================================================
	-- ==================================================================================================================================================================
	-- ==================================================================================================================================================================
	-- /////////////////////////////////////////////////////////////////////	
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
BEGIN TRANSACTION 
BEGIN TRY
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
	
		IF @@ROWCOUNT = 0
			BEGIN
				DECLARE @VP_ERROR_2 VARCHAR(250)='El item no fue eliminado. [ITEM#'+CONVERT(VARCHAR(10),@PP_K_ITEM)+']'
				RAISERROR (@VP_ERROR_2, 16, 1 ) 
			END
		
		END

	-- /////////////////////////////////////////////////////////////////////
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	/* Ocurrió un error, deshacemos los cambios*/ 
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH
	
	IF @VP_MENSAJE<>''
		BEGIN
			SET	@VP_MENSAJE = 'No es posible [Eliminar] el [ITEM]: ' + @VP_MENSAJE 
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ITEM AS CLAVE
	-- //////////////////////////////////////////////////////////////	
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////