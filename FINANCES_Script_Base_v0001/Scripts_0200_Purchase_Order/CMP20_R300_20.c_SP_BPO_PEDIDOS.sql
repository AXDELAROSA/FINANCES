-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			HEADER_PURCHASE_ORDER
-- // OPERATION:		SP'S
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200914
-- ////////////////////////////////////////////////////////////// 

-- USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO DE LOS PEDIDOS 
-- // REALIZADOS DE UNA BLANKET
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_HEADER_BPO_PEDIDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_HEADER_BPO_PEDIDO]
GO
--		 EXECUTE [dbo].[PG_LI_HEADER_BPO_PEDIDO] 0,139,'',-1,null,null
CREATE PROCEDURE [dbo].[PG_LI_HEADER_BPO_PEDIDO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_BUSCAR						VARCHAR(25),
	@PP_K_VENDOR					INT,
	@PP_F_INIT						DATE,
	@PP_F_FINISH					DATE
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1		
	DECLARE @VP_LI_N_REGISTROS		INT =5000
	-- ///////////////////////////////////////////
	-- =========================================		
	DECLARE @VP_K_FOLIO				INT
	EXECUTE [BD_GENERAL].DBO.[PG_RN_OBTENER_ID_X_REFERENCIA]			
								@PP_BUSCAR,	@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================		
	IF @VP_MENSAJE=''
	BEGIN
		--SET @VP_LI_N_REGISTROS = 0		
	SELECT		TOP (@VP_LI_N_REGISTROS)
				HEADER_BPO_PEDIDO.[K_HEADER_PURCHASE_ORDER]				
				,[K_ORDEN_COMPRA_PEDIDO]
				,[K_STATUS_BPO_PEDIDO]					
				,HEADER_BPO_PEDIDO.[F_DATE_BPO_PEDIDO]
				,[C_BPO_PEDIDO]
				,HEADER_BPO_PEDIDO.K_VENDOR
				,HEADER_BPO_PEDIDO.K_CUSTOMER
				-- ============================
				,D_VENDOR
				,LTRIM(RTRIM(CUS_NO))	AS	D_CUSTOMER
				-- =============================	
				,D_PROGRAM
				-- =============================	
	FROM		HEADER_PURCHASE_ORDER
	INNER JOIN 	VENDOR					ON VENDOR.K_VENDOR=HEADER_PURCHASE_ORDER.K_VENDOR
	INNER JOIN	DETAILS_BLANKET_PURCHASE_ORDER	ON HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=DETAILS_BLANKET_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER
	INNER JOIN	HEADER_BPO_PEDIDO				ON	HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=HEADER_BPO_PEDIDO.K_HEADER_PURCHASE_ORDER
	INNER JOIN	[DATA_02].[dbo].ARCUSFIL_SQL	ON	HEADER_BPO_PEDIDO.K_CUSTOMER=[DATA_02].[dbo].ARCUSFIL_SQL.A4GLIdentity	--CUSTOMER,
				-- =============================
	WHERE		(	HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=@VP_K_FOLIO
				OR	HEADER_PURCHASE_ORDER.CONFIRMING_ORDER_WITH				LIKE '%'+@PP_BUSCAR+'%' 
				OR	HEADER_PURCHASE_ORDER.C_PURCHASE_ORDER					LIKE '%'+@PP_BUSCAR+'%' )
				-- =============================
	AND			( @PP_F_INIT IS NULL		OR	@PP_F_INIT<=HEADER_BPO_PEDIDO.F_DATE_BPO_PEDIDO)
	AND			( @PP_F_FINISH IS NULL		OR	@PP_F_FINISH>=HEADER_BPO_PEDIDO.F_DATE_BPO_PEDIDO)
				-- =============================
	AND			( @PP_K_VENDOR =-1			OR	HEADER_PURCHASE_ORDER.K_VENDOR=@PP_K_VENDOR )
				-- =============================
	AND			HEADER_PURCHASE_ORDER.L_BORRADO<>1 
	AND			HEADER_BPO_PEDIDO.L_BORRADO<>1
	ORDER BY	K_ORDEN_COMPRA_PEDIDO ,K_STATUS_BPO_PEDIDO, F_DATE_BPO_PEDIDO	DESC
	END
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO DE LAS BLANKET PO
-- // QUE ESTAN ASIGNADAS A LOS PROVEEDORES
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_BPO_VENDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_BPO_VENDOR]
GO
--		 EXECUTE [dbo].[PG_LI_BPO_VENDOR] 0,139,128
--		 EXECUTE [dbo].[PG_LI_BPO_VENDOR] 0,139,190
--		 EXECUTE [dbo].[PG_LI_BPO_VENDOR] 0,139,226
CREATE PROCEDURE [dbo].[PG_LI_BPO_VENDOR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VENDOR					INT
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1		
	DECLARE @VP_LI_N_REGISTROS		INT =5000
	-- ///////////////////////////////////////////
	-- =========================================		
	IF @VP_MENSAJE=''
	BEGIN
		--SET @VP_LI_N_REGISTROS = 0		
	SELECT		TOP (@VP_LI_N_REGISTROS)
				-- =============================	
				K_CUSTOMER
				,LTRIM(RTRIM(CUS_NO))	AS	D_CUSTOMER
				,D_VENDOR
				,D_PROGRAM
				-- =============================	
				,HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER
				-- =============================	
	FROM		HEADER_PURCHASE_ORDER
	INNER JOIN 	VENDOR					ON VENDOR.K_VENDOR=HEADER_PURCHASE_ORDER.K_VENDOR
	INNER JOIN	DETAILS_BLANKET_PURCHASE_ORDER	ON HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=DETAILS_BLANKET_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER
	INNER JOIN	[DATA_02].[dbo].ARCUSFIL_SQL	ON	DETAILS_BLANKET_PURCHASE_ORDER.K_CUSTOMER=[DATA_02].[dbo].ARCUSFIL_SQL.A4GLIdentity	--CUSTOMER,
				-- =============================
	WHERE		HEADER_PURCHASE_ORDER.K_VENDOR=@PP_K_VENDOR
				-- =============================
	AND			HEADER_PURCHASE_ORDER.L_IS_BLANKET=1
	AND			HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER>=9
	AND			HEADER_PURCHASE_ORDER.L_BORRADO<>1
	ORDER BY	K_STATUS_PURCHASE_ORDER, F_DATE_PURCHASE_ORDER	DESC
	END
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_HEADER_BPO_PEDIDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_HEADER_BPO_PEDIDO]
GO
--		 EXECUTE [dbo].[PG_SK_HEADER_BPO_PEDIDO] 0,139,78,'00016-00001'
CREATE PROCEDURE [dbo].[PG_SK_HEADER_BPO_PEDIDO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		INT,
	@PP_K_ORDEN_COMPRA_PEDIDO		VARCHAR(50)
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''	
	-- ///////////////////////////////////////////			
	SELECT		TOP (1)
				HEADER_BPO_PEDIDO.K_HEADER_PURCHASE_ORDER,	HEADER_BPO_PEDIDO.K_ORDEN_COMPRA_PEDIDO,
				-- ===========================	-- ===========================
				HEADER_PURCHASE_ORDER.K_VENDOR
				,HEADER_BPO_PEDIDO.K_VENDOR
				,D_VENDOR
				,K_CUSTOMER
				,LTRIM(RTRIM(CUS_NO))	AS	D_CUSTOMER
				-- ===========================	-- ===========================
				,F_DATE_BPO_PEDIDO
				,C_BPO_PEDIDO
				-- =============================	
	FROM		HEADER_BPO_PEDIDO
	INNER JOIN HEADER_PURCHASE_ORDER	ON HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=HEADER_BPO_PEDIDO.K_HEADER_PURCHASE_ORDER
--				HEADER_PURCHASE_ORDER,
	INNER JOIN 	VENDOR					ON VENDOR.K_VENDOR=HEADER_PURCHASE_ORDER.K_VENDOR
--				VENDOR
	INNER JOIN	[DATA_02].[dbo].ARCUSFIL_SQL	ON	HEADER_BPO_PEDIDO.K_CUSTOMER=[DATA_02].[dbo].ARCUSFIL_SQL.A4GLIdentity	--CUSTOMER,
				-- =============================
	WHERE		HEADER_BPO_PEDIDO.K_HEADER_PURCHASE_ORDER=HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER
	AND			HEADER_BPO_PEDIDO.K_ORDEN_COMPRA_PEDIDO=@PP_K_ORDEN_COMPRA_PEDIDO
	AND			HEADER_BPO_PEDIDO.L_BORRADO<>1		
	-- ////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_DETAILS_BPO_PEDIDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_DETAILS_BPO_PEDIDO]
GO
--		 EXECUTE [dbo].[PG_SK_DETAILS_BPO_PEDIDO] 0,139,16,'00016-00001'
CREATE PROCEDURE [dbo].[PG_SK_DETAILS_BPO_PEDIDO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		INT,
	@PP_K_ORDEN_COMPRA_PEDIDO		VARCHAR(50)
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''	
	-- ///////////////////////////////////////////			
	SELECT		
				DETAILS_BPO_PEDIDO.K_HEADER_PURCHASE_ORDER
				,DETAILS_BPO_PEDIDO.K_DETAILS_BPO_PEDIDO	--HEADER_BPO_PEDIDO.K_ORDEN_COMPRA_PEDIDO
				,DETAILS_BPO_PEDIDO.K_ITEM
				-- ===========================	-- ===========================
				,S_UNIT_OF_MEASURE
				,PART_NUMBER_ITEM_VENDOR
				,PART_NUMBER_ITEM_PEARL
				,D_ITEM
				-- ===========================	-- ===========================
				,QUANTITY_ORDER
				-- =============================	
	FROM		DETAILS_BPO_PEDIDO
	INNER JOIN	ITEM		ON	DETAILS_BPO_PEDIDO.K_ITEM=ITEM.K_ITEM
	INNER JOIN	BD_GENERAL.DBO.UNIT_OF_MEASURE ON ITEM.K_UNIT_OF_ITEM=UNIT_OF_MEASURE.K_UNIT_OF_MEASURE
	--,HEADER_BPO_PEDIDO
				-- =============================
	--WHERE		HEADER_BPO_PEDIDO.K_HEADER_PURCHASE_ORDER=DETAILS_BPO_PEDIDO.K_HEADER_PURCHASE_ORDER
	--AND			HEADER_BPO_PEDIDO.K_ORDEN_COMPRA_PEDIDO=DETAILS_BPO_PEDIDO.K_ORDEN_COMPRA_PEDIDO
	WHERE		DETAILS_BPO_PEDIDO.K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
	AND			DETAILS_BPO_PEDIDO.K_ORDEN_COMPRA_PEDIDO=@PP_K_ORDEN_COMPRA_PEDIDO
	--AND			HEADER_BPO_PEDIDO.L_BORRADO<>1		
	-- ////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / CARGA LOS ARTÍCULOS DE 
-- // LA ORDEN DE COMPRA SELECCIONADA AL LISTADO.
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_DETAILS_BPO_ITEMS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_DETAILS_BPO_ITEMS]
GO
--			   EXECUTE [PG_SK_DETAILS_BPO_ITEMS] 0,139,  107
--			   EXECUTE [PG_SK_DETAILS_BPO_ITEMS] 0,139,  16
CREATE PROCEDURE [dbo].[PG_SK_DETAILS_BPO_ITEMS]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		INT
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_K_STATUS			INT
	-- ///////////////////////////////////////////
	SELECT		@VP_K_STATUS = K_STATUS_PURCHASE_ORDER
	FROM		HEADER_PURCHASE_ORDER
	WHERE		K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
	
	IF	@VP_K_STATUS >= 9
	BEGIN
		SELECT		TOP (5000)
					S_UNIT_OF_MEASURE
					,PART_NUMBER_ITEM_VENDOR
					,PART_NUMBER_ITEM_PEARL
					,D_ITEM
					-- ======================================================
					,0			AS QUANTITY_ORDER
					,K_DETAILS_PURCHASE_ORDER AS K_DETAILS_BPO_PEDIDO
					,K_HEADER_PURCHASE_ORDER
					,DETAILS_PURCHASE_ORDER.K_ITEM
					-- ======================================================
					--,DETAILS_PURCHASE_ORDER.*
		FROM		DETAILS_PURCHASE_ORDER
		INNER JOIN	ITEM		ON	DETAILS_PURCHASE_ORDER.K_ITEM=ITEM.K_ITEM
		INNER JOIN	BD_GENERAL.DBO.UNIT_OF_MEASURE ON ITEM.K_UNIT_OF_ITEM=UNIT_OF_MEASURE.K_UNIT_OF_MEASURE
		INNER JOIN	BD_GENERAL.DBO.CURRENCY	ON	ITEM.K_CURRENCY=CURRENCY.K_CURRENCY
		WHERE		DETAILS_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
		ORDER BY	K_DETAILS_PURCHASE_ORDER
	END
	
	-- ////////////////////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////
-- // PARA INSERTAR LOS DETALLES DEL PEDIDO
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_INUP_DETAILS_BPO_PEDIDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_INUP_DETAILS_BPO_PEDIDO]
GO
CREATE PROCEDURE [dbo].[PG_INUP_DETAILS_BPO_PEDIDO]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-----=====================================================
	@PP_K_HEADER_PURCHASE_ORDER				INT,
	@PP_K_ORDEN_COMPRA_PEDIDO				VARCHAR(50),
	@PP_K_DETAIL_ARRAY						NVARCHAR(MAX),
	@PP_ITEM_ARRAY							NVARCHAR(MAX),
	@PP_QUANTITY_ARRAY						NVARCHAR(MAX)
	-----=====================================================
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	-----=====================================================				
	DECLARE @VP_K_DETAIL_PO	INT = 1
	
	DECLARE @VP_POSICION_DETA	INT
	DECLARE @VP_POSICION_ITEM	INT
	DECLARE @VP_POSICION_QTY	INT
	DECLARE @VP_VALOR_DETA		VARCHAR(500)
	DECLARE @VP_VALOR_ITEM		VARCHAR(500)
	DECLARE @VP_VALOR_QTY		VARCHAR(500)
	--Colocamos un separador al final de los parametros para que funcione bien nuestro codigo
	SET	@PP_K_DETAIL_ARRAY	= @PP_K_DETAIL_ARRAY	+ '/'
	SET	@PP_ITEM_ARRAY		= @PP_ITEM_ARRAY		+ '/'
	SET	@PP_QUANTITY_ARRAY	= @PP_QUANTITY_ARRAY	+ '/'
		
	--Hacemos un bucle que se repite mientras haya separadores, patindex busca un patron en una cadena y nos devuelve su posicion
	WHILE patindex('%/%' , @PP_ITEM_ARRAY) <> 0
		BEGIN
			SELECT @VP_POSICION_DETA	=	patindex('%/%' , @PP_K_DETAIL_ARRAY	)
			SELECT @VP_POSICION_ITEM	=	patindex('%/%' , @PP_ITEM_ARRAY		)
			SELECT @VP_POSICION_QTY		=	patindex('%/%' , @PP_QUANTITY_ARRAY	)

			--Buscamos la posicion de la primera y obtenemos los caracteres hasta esa posicion
			SELECT @VP_VALOR_DETA		= LEFT(@PP_K_DETAIL_ARRAY	, @VP_POSICION_DETA	- 1)
			SELECT @VP_VALOR_ITEM		= LEFT(@PP_ITEM_ARRAY		, @VP_POSICION_ITEM		- 1)
			SELECT @VP_VALOR_QTY		= LEFT(@PP_QUANTITY_ARRAY	, @VP_POSICION_QTY		- 1)

					INSERT INTO DETAILS_BPO_PEDIDO
						(
						[K_HEADER_PURCHASE_ORDER]		,
						[K_ORDEN_COMPRA_PEDIDO]			,
						[K_DETAILS_BPO_PEDIDO]			,
						-- ============================	,
						[K_ITEM]						,						
						-- ============================
						[QUANTITY_ORDER]
						)
					VALUES
						(
						@PP_K_HEADER_PURCHASE_ORDER,
						@PP_K_ORDEN_COMPRA_PEDIDO,
						@VP_VALOR_DETA,	
						-- ============================
						@VP_VALOR_ITEM,
						@VP_VALOR_QTY
						)																		
													
			IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='The DETAIL_PURCHASE_ORDER was not inserted. [DETAIL#'+CONVERT(VARCHAR(10),@VP_VALOR_ITEM)+']'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END	

			--Reemplazamos lo procesado con nada con la funcion stuff
			SELECT @PP_K_DETAIL_ARRAY	= STUFF(@PP_K_DETAIL_ARRAY	, 1, @VP_POSICION_DETA, '')
			SELECT @PP_ITEM_ARRAY		= STUFF(@PP_ITEM_ARRAY		, 1, @VP_POSICION_ITEM , '')
			SELECT @PP_QUANTITY_ARRAY	= STUFF(@PP_QUANTITY_ARRAY	, 1, @VP_POSICION_QTY  , '')
		END
	-- ////////////////////////////////////////////////////////////////
	-- ///////////////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERTA EL ENCABEZADO DEL PEDIDO
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_HEADER_BPO_PEDIDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_HEADER_BPO_PEDIDO]
GO
--		 EXECUTE [dbo].[PG_IN_HEADER_BPO]	1,139,  
--		'78' , '' , '2020/09/15' , 
CREATE PROCEDURE [dbo].[PG_IN_HEADER_BPO_PEDIDO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER				[INT],
	@PP_C_PURCHASE_ORDER					[VARCHAR](255),
	-- ============================
	@PP_K_VENDOR							[INT],
	@PP_K_CUSTOMER							[INT],
	-- ============================
	@PP_F_DATE_BPO_PEDIDO					[DATE],
	-----=====================================================
	--	PARA DETAILS_PURCHASE_ORDER
	@PP_K_DETAIL_ARRAY						NVARCHAR(MAX),
	@PP_ITEM_ARRAY							NVARCHAR(MAX),
	@PP_QUANTITY_ARRAY						NVARCHAR(MAX)
	-----=====================================================
AS			
DECLARE @VP_MENSAJE						VARCHAR(500) = ''
DECLARE @VP_K_SIGUIENTE					INT
DECLARE @VP_K_ORDEN_COMPRA_PEDIDO		VARCHAR(50) =  '' ;
BEGIN TRANSACTION 
BEGIN TRY
		-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
	BEGIN
		SELECT	@VP_K_SIGUIENTE=COUNT(K_ORDEN_COMPRA_PEDIDO)	
		FROM	HEADER_BPO_PEDIDO
		WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER

	END

	IF @VP_MENSAJE=''
	BEGIN
		SELECT @VP_K_ORDEN_COMPRA_PEDIDO= FORMAT(@PP_K_HEADER_PURCHASE_ORDER,'00000') + '-' + FORMAT(@VP_K_SIGUIENTE+1,'00000')
				
	--============================================================================
	--======================================INSERTAR EL HEADER_BPO_PEDIDO
	--============================================================================
		INSERT INTO HEADER_BPO_PEDIDO
			(	[K_HEADER_PURCHASE_ORDER]
				,[K_ORDEN_COMPRA_PEDIDO]
				,[C_BPO_PEDIDO]
				-- ============================
				,[K_VENDOR]
				,[K_CUSTOMER]
				-- ============================
				,[K_STATUS_BPO_PEDIDO]
				-- ============================
				,[F_DATE_BPO_PEDIDO]
				-- ===========================
				,[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@PP_K_HEADER_PURCHASE_ORDER
				,@VP_K_ORDEN_COMPRA_PEDIDO
				,@PP_C_PURCHASE_ORDER
				-- ============================				
				,@PP_K_VENDOR	
				,@PP_K_CUSTOMER
				-- ============================
				,1
				-- ============================
				,@PP_F_DATE_BPO_PEDIDO
				-- ============================
				,@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )

			IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='The BPO_PEDIDO was not inserted. [ORDEN_COMPRA_PEDIDO#'+CONVERT(VARCHAR(10),@VP_K_ORDEN_COMPRA_PEDIDO)+']'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END				
	END


	IF @VP_MENSAJE=''
	BEGIN
		EXECUTE		[dbo].[PG_INUP_DETAILS_BPO_PEDIDO]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															-----=====================================================
															@PP_K_HEADER_PURCHASE_ORDER,	@VP_K_ORDEN_COMPRA_PEDIDO,
															@PP_K_DETAIL_ARRAY, @PP_ITEM_ARRAY,		@PP_QUANTITY_ARRAY
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
	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		SET		@VP_MENSAJE = 'Not is possible [Insert] at [BPO]: ' + @VP_MENSAJE 
	END
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_ORDEN_COMPRA_PEDIDO AS CLAVE
	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> ACTUALIZA EL ENCABEZADO DEL PEDIDO
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_HEADER_BPO_PEDIDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_HEADER_BPO_PEDIDO]
GO
--		 EXECUTE [dbo].[PG_UP_HEADER_BPO]	1,139,  
--		'78' , '' , '2020/09/15' , 
CREATE PROCEDURE [dbo].[PG_UP_HEADER_BPO_PEDIDO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER				[INT],
	@PP_K_ORDEN_COMPRA_PEDIDO				[VARCHAR](50),
	@PP_C_PURCHASE_ORDER					[VARCHAR](255),
	-- ============================
	@PP_K_VENDOR							[INT],
	@PP_K_CUSTOMER							[INT],
	-- ============================
	@PP_F_DATE_BPO_PEDIDO					[DATE],
	-----=====================================================
	--	PARA DETAILS_PURCHASE_ORDER
	@PP_K_DETAIL_ARRAY						NVARCHAR(MAX),
	@PP_ITEM_ARRAY							NVARCHAR(MAX),
	@PP_QUANTITY_ARRAY						NVARCHAR(MAX)
	-----=====================================================
AS			
DECLARE @VP_MENSAJE						VARCHAR(500) = ''
BEGIN TRANSACTION 
BEGIN TRY
		-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
	BEGIN		
	--============================================================================
	--======================================INSERTAR EL HEADER_BPO_PEDIDO
	--============================================================================
		UPDATE	HEADER_BPO_PEDIDO
		SET					
				[C_BPO_PEDIDO]						= @PP_C_PURCHASE_ORDER
				-- ============================		= -- ============================
				,[K_VENDOR]							= @PP_K_VENDOR
				,[K_CUSTOMER]						= @PP_K_CUSTOMER
				-- ============================		= -- ============================
				,[K_STATUS_BPO_PEDIDO]				= 1
				-- ============================		= -- ============================
				,[F_DATE_BPO_PEDIDO]				= @PP_F_DATE_BPO_PEDIDO
				-- ============================		= -- ============================
				,[F_CAMBIO]							= GETDATE()
				,[K_USUARIO_CAMBIO]					= @PP_K_USUARIO_ACCION
		WHERE	[K_HEADER_PURCHASE_ORDER]= @PP_K_HEADER_PURCHASE_ORDER
		AND		[K_ORDEN_COMPRA_PEDIDO]= @PP_K_ORDEN_COMPRA_PEDIDO	

			IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='The BPO_PEDIDO was not updated. [ORDEN_COMPRA_PEDIDO#'+CONVERT(VARCHAR(10),@PP_K_ORDEN_COMPRA_PEDIDO)+']'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END				
	END

		DELETE 
		FROM	DETAILS_BPO_PEDIDO
		WHERE	[K_HEADER_PURCHASE_ORDER]= @PP_K_HEADER_PURCHASE_ORDER
		AND		[K_ORDEN_COMPRA_PEDIDO]= @PP_K_ORDEN_COMPRA_PEDIDO

	IF @VP_MENSAJE=''
	BEGIN
		EXECUTE		[dbo].[PG_INUP_DETAILS_BPO_PEDIDO]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															-----=====================================================
															@PP_K_HEADER_PURCHASE_ORDER,	@PP_K_ORDEN_COMPRA_PEDIDO,
															@PP_K_DETAIL_ARRAY, @PP_ITEM_ARRAY,		@PP_QUANTITY_ARRAY
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
	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		SET		@VP_MENSAJE = 'Not is possible [Update] at [BPO]: ' + @VP_MENSAJE 
	END
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ORDEN_COMPRA_PEDIDO AS CLAVE
	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////
--	EXECUTE [dbo].[PG_DL_HEADER_PURCHASE_ORDER] 0,139,380,2,2
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_HEADER_BPO_PEDIDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_HEADER_BPO_PEDIDO]
GO
CREATE PROCEDURE [dbo].[PG_DL_HEADER_BPO_PEDIDO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		[INT],
	@PP_K_ORDEN_COMPRA_PEDIDO		[VARCHAR](50)
AS
DECLARE @VP_MENSAJE				VARCHAR(300) = ''
BEGIN TRANSACTION 
BEGIN TRY
	--////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
	BEGIN		
		UPDATE	HEADER_BPO_PEDIDO
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	[K_HEADER_PURCHASE_ORDER]= @PP_K_HEADER_PURCHASE_ORDER
		AND		[K_ORDEN_COMPRA_PEDIDO]= @PP_K_ORDEN_COMPRA_PEDIDO	
		IF @@ROWCOUNT = 0
			BEGIN
				SET @VP_MENSAJE='The BPO_PEDIDO was not updated. [ORDEN_COMPRA_PEDIDO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
			END
	END
-- /////////////////////////////////////////////////////////////////////
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH	

	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		SET		@VP_MENSAJE = 'Not is possible [Update] at [ORDEN_COMPRA_PEDIDO]: ' + @VP_MENSAJE 
	END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_HEADER_PURCHASE_ORDER AS CLAVE
	-- //////////////////////////////////////////////////////////////
	
	-- //////////////////////////////////////////////////////////////	
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////