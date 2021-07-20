USE COMPRAS
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- // CUANDO SE ACTUALICE ESTE SP SE DEBE ACTUALIZAR EL QUE REGRESA EL K_ITEM
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_INSERTAR_COLORES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_INSERTAR_COLORES]
GO
CREATE PROCEDURE [dbo].[PG_IN_INSERTAR_COLORES]
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
	--@OU_K_ITEM						VARCHAR(200)		OUTPUT
AS			
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_K_ITEM			INT = 0
BEGIN TRANSACTION 
BEGIN TRY
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
	
	-- //////////ADD FEG 16-04-2021: SE ACTUALIZA LA TABLA IMITMIDX_SQL CON LA REFENCIA DEL ITEM///////////////////////////////////////////////////////////
	UPDATE	DATA_02.DBO.IMITMIDX_SQL
		SET		[upc_cd]	= @VP_K_ITEM
	WHERE	LTRIM(RTRIM([item_no]))		= @PP_PART_NUMBER_ITEM_PEARL

	IF @@ROWCOUNT = 0
	BEGIN
		SET @VP_MENSAJE ='No se pudó Actualizar el Color. [ITEM#'+ @PP_PART_NUMBER_ITEM_PEARL +'] en IMITMIDX_SQL'
		RAISERROR (@VP_ERROR_2, 16, 1 )
	END	

	--	SET @OU_K_ITEM = @VP_K_ITEM
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
			SET	@VP_MENSAJE = 'No es posible ingresar el [ITEM_MASTER]: ' + @VP_MENSAJE 
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_PART_NUMBER_ITEM_PEARL AS CLAVE
	-- //////////////////////////////////////////////////////////////
GO

--<<<<<<< Updated upstream
----SELECT DISTINCT	colour	--*
----FROM	DATA_02.DBO.COLORES_ACTIVOS
----WHERE	colour	= 'FWLNPX7'

------SELECT	cus_no,	colour,	modelno,	versionno,	item_desc_1	--* 
----SELECT		--		*
---- [item_no],[item_filler]				,[search_desc]			,[item_desc_1]			,[item_desc_2]			,[prod_cat]				,[loc]					,[uom]					
----,[price_uom]				,[price_ratio]			,[mat_cost_type]			,[activity_cd]			,[activity_dt]			,[pur_or_mfg]			,[upc_cd]				
----,[landed_cost_cd]		,[landed_cost_cd_2]		,[landed_cost_cd_3]		,[landed_cost_cd_4]		,[landed_cost_cd_5]		,[landed_cost_cd_6]		,[landed_cost_cd_7]		
----FROM	DATA_02.DBO.IMITMIDX_SQL
----WHERE	LTRIM(RTRIM(IMITMIDX_SQL.ITEM_NO)) IN (SELECT DISTINCT	colour FROM	DATA_02.DBO.COLORES_ACTIVOS) -- WHERE	colour	= 'FWLNPX7')
----AND		PUR_OR_MFG	<> 'R'

----SELECT * FROM VENDOR

----EXECUTE	[DBO].[PG_IN_INSERTAR_COLORES]	0,	0,
----										-- ===========================
----										0,						-- @PP_K_VENDOR,
----										'NAPPA TX7',			-- @PP_D_ITEM,
----										-- ===========================
----										0,						-- @PP_PART_NUMBER_ITEM_VENDOR,
----										'FWLNPX7',				-- @PP_PART_NUMBER_ITEM_PEARL,
----										-- ===========================
----										'PIEL',					-- @PP_TRADEMARK_ITEM,
----										'',						-- @PP_MODEL_ITEM,
----										-- ============================	
----										1,						-- @PP_K_PO_PRICE,
----										0,						-- @PP_PRICE_ITEM,
----										-- ===========================
----										2,						-- @PP_K_STATUS_ITEM,		--	INACTIVE
----										0,						-- @PP_K_TYPE_ITEM,
----										13,						-- @PP_K_UNIT_OF_ITEM,
----										-- ============================
----										3,						-- @PP_K_CURRENCY,
----										3						-- @PP_K_CLASS_ITEM



----SELECT * FROM COMPRAS_Pruebas.DBO.STATUS_ITEM
----SELECT * FROM COMPRAS_Pruebas.DBO.CLASS_ITEM
----SELECT * FROM COMPRAS_Pruebas.DBO.TYPE_ITEM
----SELECT * FROM BD_GENERAL.DBO.UNIT_OF_MEASURE
----SELECT * FROM BD_GENERAL.DBO.CURRENCY


----SELECT * FROM COMPRAS_Pruebas.DBO.ITEM	WHERE	K_CLASS_ITEM	= 3

------SELECT	cus_no,	colour,	modelno,	versionno,	item_desc_1	--* 
----SELECT	item_desc_2, 
----FROM	DATA_02.DBO.COLORES_ACTIVOS
----INNER JOIN	DATA_02.DBO.IMITMIDX_SQL		ON	item_no=colour

----UDATE	DATA_02Pruebas.DBO.IMITMIDX_SQL
----SET		[upc_cd]	= 1191
----WHERE	item_no		= 'FWLNPX7'

----SELECT * FROM DATA_02Pruebas.DBO.IMITMIDX_SQL
----WHERE	item_no		= 'FWLNPX7'
--=======
--SELECT DISTINCT	colour	--*
--FROM	DATA_02.DBO.COLORES_ACTIVOS
--WHERE	colour	= 'FWLNPX7'

----SELECT	cus_no,	colour,	modelno,	versionno,	item_desc_1	--* 
--SELECT		--		*
-- [item_no],[item_filler]				,[search_desc]			,[item_desc_1]			,[item_desc_2]			,[prod_cat]				,[loc]					,[uom]					
--,[price_uom]				,[price_ratio]			,[mat_cost_type]			,[activity_cd]			,[activity_dt]			,[pur_or_mfg]			,[upc_cd]				
--,[landed_cost_cd]		,[landed_cost_cd_2]		,[landed_cost_cd_3]		,[landed_cost_cd_4]		,[landed_cost_cd_5]		,[landed_cost_cd_6]		,[landed_cost_cd_7]		
--FROM	DATA_02.DBO.IMITMIDX_SQL
--WHERE	LTRIM(RTRIM(IMITMIDX_SQL.ITEM_NO)) IN (SELECT DISTINCT	colour FROM	DATA_02.DBO.COLORES_ACTIVOS WHERE	colour	= 'FWLNPX7')
--AND		PUR_OR_MFG	<> 'R'

--SELECT * FROM VENDOR

--EXECUTE	[DBO].[PG_IN_INSERTAR_COLORES]	0,	0,
--										-- ===========================
--										0,						-- @PP_K_VENDOR,
--										'NAPPA TX7',			-- @PP_D_ITEM,
--										-- ===========================
--										0,						-- @PP_PART_NUMBER_ITEM_VENDOR,
--										'FWLNPX7',				-- @PP_PART_NUMBER_ITEM_PEARL,
--										-- ===========================
--										'PIEL',					-- @PP_TRADEMARK_ITEM,
--										'',						-- @PP_MODEL_ITEM,
--										-- ============================	
--										1,						-- @PP_K_PO_PRICE,
--										0,						-- @PP_PRICE_ITEM,
--										-- ===========================
--										2,						-- @PP_K_STATUS_ITEM,		--	INACTIVE
--										0,						-- @PP_K_TYPE_ITEM,
--										13,						-- @PP_K_UNIT_OF_ITEM,
--										-- ============================
--										3,						-- @PP_K_CURRENCY,
--										3						-- @PP_K_CLASS_ITEM



--SELECT * FROM COMPRAS_Pruebas.DBO.STATUS_ITEM
--SELECT * FROM COMPRAS_Pruebas.DBO.CLASS_ITEM
--SELECT * FROM COMPRAS_Pruebas.DBO.TYPE_ITEM
--SELECT * FROM BD_GENERAL.DBO.UNIT_OF_MEASURE
--SELECT * FROM BD_GENERAL.DBO.CURRENCY


--SELECT * FROM COMPRAS_Pruebas.DBO.ITEM	WHERE	K_CLASS_ITEM	= 3
--SELECT * FROM DATA_02Pruebas.DBO.IMITMIDX_SQL	WHERE UPC_CD<>''
----SELECT	cus_no,	colour,	modelno,	versionno,	item_desc_1	--* 
--SELECT	item_desc_2, 
--FROM	DATA_02.DBO.COLORES_ACTIVOS
--INNER JOIN	DATA_02.DBO.IMITMIDX_SQL		ON	item_no=colour

--UDATE	DATA_02Pruebas.DBO.IMITMIDX_SQL
--SET		[upc_cd]	= 1191
--WHERE	item_no		= 'FWLNPX7'

--SELECT * FROM DATA_02Pruebas.DBO.IMITMIDX_SQL
--WHERE	item_no		= 'FWLNPX7'
-->>>>>>> Stashed changes
