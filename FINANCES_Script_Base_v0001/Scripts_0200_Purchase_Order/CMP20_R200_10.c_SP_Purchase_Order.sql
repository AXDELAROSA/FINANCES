-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			HEADER_PURCHASE_ORDER
-- // OPERATION:		SP'S
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200206
-- ////////////////////////////////////////////////////////////// 

USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_HEADER_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_HEADER_PURCHASE_ORDER]
GO

-- EXECUTE [dbo].[PG_LI_HEADER_PURCHASE_ORDER] 0,139,'',-1,-1,-1,-1,-1,null,null
CREATE PROCEDURE [dbo].[PG_LI_HEADER_PURCHASE_ORDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_BUSCAR						VARCHAR(200),
	@PP_K_STATUS_PURCHASE_ORDER		INT,
	@PP_K_VENDOR					INT,
	@PP_K_PLACED_BY					INT,
	@PP_K_TERMS						INT,
	@PP_K_CURRENCY					INT,
	@PP_F_INIT						DATE,
	@PP_F_FINISH					DATE
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
				HEADER_PURCHASE_ORDER.*,
				S_STATUS_PURCHASE_ORDER	, D_STATUS_PURCHASE_ORDER,
--				D_VENDOR,
				S_PLACED_BY	, D_PLACED_BY,
				S_TERMS		, D_TERMS	 ,				
				S_CURRENCY	, D_CURRENCY 
				-- =============================	
	FROM		HEADER_PURCHASE_ORDER,
				STATUS_PURCHASE_ORDER, 
				VENDOR,
				PLACED_BY,
				BD_GENERAL.DBO.TERMS,				
				BD_GENERAL.DBO.CURRENCY	
				-- =============================
	WHERE		HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER=STATUS_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER
	AND			HEADER_PURCHASE_ORDER.K_VENDOR=VENDOR.K_VENDOR
	AND			HEADER_PURCHASE_ORDER.K_PLACED_BY=PLACED_BY.K_PLACED_BY
	AND			HEADER_PURCHASE_ORDER.K_TERMS=TERMS.K_TERMS
	AND			HEADER_PURCHASE_ORDER.K_CURRENCY=CURRENCY.K_CURRENCY
				-- =============================
	AND			(	HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=@VP_K_FOLIO
				OR	HEADER_PURCHASE_ORDER.ISSUED_BY_PURCHASE_ORDER			LIKE '%'+@PP_BUSCAR+'%'
				OR	HEADER_PURCHASE_ORDER.CONFIRMING_ORDER_WITH				LIKE '%'+@PP_BUSCAR+'%' 
				OR	HEADER_PURCHASE_ORDER.DELIVERY_TO						LIKE '%'+@PP_BUSCAR+'%'
				OR	HEADER_PURCHASE_ORDER.C_PURCHASE_ORDER					LIKE '%'+@PP_BUSCAR+'%' )
				-- =============================
	AND			( @PP_F_INIT IS NULL		OR	@PP_F_INIT<=F_DATE_PURCHASE_ORDER)
	AND			( @PP_F_FINISH IS NULL		OR	@PP_F_INIT>=F_DATE_PURCHASE_ORDER)
				-- =============================
	AND			( @PP_F_INIT IS NULL		OR	@PP_F_INIT<=F_REQUIRED_PURCHASE_ORDER)
	AND			( @PP_F_FINISH IS NULL		OR	@PP_F_INIT>=F_REQUIRED_PURCHASE_ORDER)
				-- =============================
	AND			( @PP_K_STATUS_PURCHASE_ORDER	=-1		OR	HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER=@PP_K_STATUS_PURCHASE_ORDER )
	AND			( @PP_K_VENDOR =-1			OR	HEADER_PURCHASE_ORDER.K_VENDOR=@PP_K_VENDOR )
	AND			( @PP_K_PLACED_BY =-1		OR	HEADER_PURCHASE_ORDER.K_PLACED_BY=@PP_K_PLACED_BY )
	AND			( @PP_K_TERMS =-1			OR	HEADER_PURCHASE_ORDER.K_TERMS=@PP_K_TERMS )
	AND			( @PP_K_CURRENCY =-1		OR	HEADER_PURCHASE_ORDER.K_CURRENCY=@PP_K_CURRENCY )
				-- =============================
	AND			HEADER_PURCHASE_ORDER.L_BORRADO<>1
	ORDER BY	F_DATE_PURCHASE_ORDER	DESC
	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_HEADER_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_HEADER_PURCHASE_ORDER]
GO

-- EXECUTE [dbo].[PG_SK_HEADER_PURCHASE_ORDER] 0,139,2
CREATE PROCEDURE [dbo].[PG_SK_HEADER_PURCHASE_ORDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		INT
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''	
	-- ///////////////////////////////////////////
			
	SELECT		TOP (1)
				HEADER_PURCHASE_ORDER.*,
				S_STATUS_PURCHASE_ORDER	, D_STATUS_PURCHASE_ORDER,
--				D_VENDOR,
				S_PLACED_BY	, D_PLACED_BY,
				S_TERMS		, D_TERMS	 ,				
				S_CURRENCY	, D_CURRENCY 
				-- =============================	
	FROM		HEADER_PURCHASE_ORDER,
				STATUS_PURCHASE_ORDER, 
				VENDOR,
				PLACED_BY,
				BD_GENERAL.DBO.TERMS,				
				BD_GENERAL.DBO.CURRENCY	
				-- =============================
	WHERE		HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER=STATUS_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER
	AND			HEADER_PURCHASE_ORDER.K_VENDOR=VENDOR.K_VENDOR
	AND			HEADER_PURCHASE_ORDER.K_PLACED_BY=PLACED_BY.K_PLACED_BY
	AND			HEADER_PURCHASE_ORDER.K_TERMS=TERMS.K_TERMS
	AND			HEADER_PURCHASE_ORDER.K_CURRENCY=CURRENCY.K_CURRENCY
				-- =============================
	AND			HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
	AND			HEADER_PURCHASE_ORDER.L_BORRADO<>1
		
	-- ////////////////////////////////////////////////////////////////////
GO


	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_HEADER_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_HEADER_PURCHASE_ORDER]
GO

-- EXECUTE [dbo].[PG_IN_HEADER_PURCHASE_ORDER] 0, 139,												
--				'TEST INSERT HEADER PURCHASE',
--				1,
--				'2020-02-24' , '2020-02-24',
--				'ALEJANDROD','ALEJANDROD',1,
--				'PEARL','ALEJANDROD',1,
--				1,1,16,0,0,0,
--				0,0,'CUENTA'

CREATE PROCEDURE [dbo].[PG_IN_HEADER_PURCHASE_ORDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
--	@PP_K_HEADER_PURCHASE_ORDER				[INT],			
	@PP_C_PURCHASE_ORDER					[VARCHAR](255),
	-- ============================
	@PP_K_STATUS_PURCHASE_ORDER				[INT],
	-- ============================
	@PP_F_DATE_PURCHASE_ORDER				[DATE],
	@PP_F_REQUIRED_PURCHASE_ORDER			[DATE],
	-- ============================
	@PP_ISSUED_BY_PURCHASE_ORDER			[VARCHAR] (150),
	@PP_REQUIRED_PURCHASE_ORDER				[VARCHAR] (150),
	@PP_K_PLACED_BY							[INT],
	-- ============================
	@PP_DELIVERY_TO							[VARCHAR] (500),
	@PP_CONFIRMING_ORDER_WITH				[VARCHAR] (150),
	@PP_K_VENDOR							[INT],
	-- ============================
	@PP_K_TERMS								[INT],
	@PP_K_CURRENCY							[INT],
	@PP_TAX_RATE							[DECIMAL] (10,4),
	@PP_ADDITIONAL_TAXES_PURCHASE_ORDER		[DECIMAL] (10,4),
	@PP_ADDITIONAL_DISCOUNTS_PURCHASE_ORDER	[DECIMAL] (10,4),
	@PP_PREPAID_PURCHASE_ORDER				[DECIMAL] (10,4),
	-- ============================
	@PP_SUBTOTAL_PURCHASE_ORDER				[DECIMAL] (10,4),
	@PP_TOTAL_PURCHASE_ORDER				[DECIMAL] (10,4),
	-- ============================
	@PP_ACCOUNT_PURCHASE_ORDER				[VARCHAR] (17)
AS			
DECLARE @VP_MENSAJE				VARCHAR(500) = ''
DECLARE @VP_K_HEADER_PURCHASE_ORDER			INT = 0;	
	
BEGIN TRANSACTION 
BEGIN TRY
-- /////////////////////////////////////////////////////////////////////

		EXECUTE [BD_GENERAL].dbo.[PG_SK_CATALOGO_K_MAX_GET]		@PP_K_SISTEMA_EXE, 'COMPRAS',
																'HEADER_PURCHASE_ORDER', 'K_HEADER_PURCHASE_ORDER',
																@OU_K_TABLA_DISPONIBLE = @VP_K_HEADER_PURCHASE_ORDER	OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	--IF @VP_MENSAJE=''
	--	EXECUTE [dbo].[PG_RN_HEADER_PURCHASE_ORDER_UNIQUE]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
	--											@VP_K_HEADER_PURCHASE_ORDER, 
	--											@PP_D_HEADER_PURCHASE_ORDER, @PP_RFC_HEADER_PURCHASE_ORDER,
	--											@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT	
	-- //////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
	BEGIN		
	--============================================================================
	--======================================INSERTAR EL HEADER_PURCHASE_ORDER
	--============================================================================
		INSERT INTO HEADER_PURCHASE_ORDER
			(	[K_HEADER_PURCHASE_ORDER],	[C_PURCHASE_ORDER],
				-- ============================
				[K_STATUS_PURCHASE_ORDER],				
				-- ============================
				[F_DATE_PURCHASE_ORDER],		[F_REQUIRED_PURCHASE_ORDER],			
				-- ============================
				[ISSUED_BY_PURCHASE_ORDER],	[REQUIRED_PURCHASE_ORDER],				
				[K_PLACED_BY],
				-- ============================
				[DELIVERY_TO],				[CONFIRMING_ORDER_WITH],				
				[K_VENDOR],
				-- ============================
				[K_TERMS],					[K_CURRENCY],							
				[TAX_RATE],					[ADDITIONAL_TAXES_PURCHASE_ORDER],		
				[ADDITIONAL_DISCOUNTS_PURCHASE_ORDER],	
				[PREPAID_PURCHASE_ORDER],				
				-- ============================
				[SUBTOTAL_PURCHASE_ORDER],	[TOTAL_PURCHASE_ORDER],				
				-- ============================
				[ACCOUNT_PURCHASE_ORDER],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_HEADER_PURCHASE_ORDER, @PP_C_PURCHASE_ORDER, 
				-- ============================
				@PP_K_STATUS_PURCHASE_ORDER,				
				-- ============================
				@PP_F_DATE_PURCHASE_ORDER,		@PP_F_REQUIRED_PURCHASE_ORDER,			
				-- ============================
				@PP_ISSUED_BY_PURCHASE_ORDER,	@PP_REQUIRED_PURCHASE_ORDER,				
				@PP_K_PLACED_BY,
				-- ============================
				@PP_DELIVERY_TO,				@PP_CONFIRMING_ORDER_WITH,				
				@PP_K_VENDOR,
				-- ============================
				@PP_K_TERMS,					@PP_K_CURRENCY,							
				@PP_TAX_RATE,					@PP_ADDITIONAL_TAXES_PURCHASE_ORDER,		
				@PP_ADDITIONAL_DISCOUNTS_PURCHASE_ORDER,	
				@PP_PREPAID_PURCHASE_ORDER,				
				-- ============================
				@PP_SUBTOTAL_PURCHASE_ORDER,	@PP_TOTAL_PURCHASE_ORDER,				
				-- ============================
				@PP_ACCOUNT_PURCHASE_ORDER,
				-- ============================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )

			IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='The HEADER_PURCHASE_ORDER was not inserted. [HEADER_PURCHASE_ORDER#'+CONVERT(VARCHAR(10),@VP_K_HEADER_PURCHASE_ORDER)+']'
				END
				
--	RAISERROR ('ERROR DE PRUEBAS 3', 16, 1 ) --MENSAJE - Severity -State.
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
		SET		@VP_MENSAJE = 'Not is possible [Insert] at [HEADER_PURCHASE_ORDER]: ' + @VP_MENSAJE 
	END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_HEADER_PURCHASE_ORDER AS CLAVE
	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE 
-- // INSERTA UN DATATABLE QUE SE RECIBE DEL FRONT Y LO ASIGNA 
-- // A LA TABLA QUE SE UTILIZARÁ COMO TEMPORAL.
-- // ESTA TABLA UNA VEZ QUE SE REALICE EL INSERT DE LOS DATOS
-- // SERÁ ELIMINADA.
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_TEMP_DETAILS_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_TEMP_DETAILS_PURCHASE_ORDER]
GO

-- EXECUTE [dbo].[PG_IN_TEMP_DETAILS_PURCHASE_ORDER] 0,139,2
CREATE PROCEDURE [dbo].[PG_IN_TEMP_DETAILS_PURCHASE_ORDER]
	@TBL_DATA_TABLE			NVARCHAR
AS
DECLARE @VP_MENSAJE VARCHAR(250)
BEGIN TRANSACTION 
BEGIN TRY
	  --SET NOCOUNT ON;
     
      INSERT INTO TEMP_DETAILS_PURCHASE_ORDER
		(
		[K_HEADER_PURCHASE_ORDER]		,
		-- ============================	,
		[K_ITEM]						--,		
		--[QUANTITY_ORDER]				,		
		--[K_UNIT_OF_ITEM]				,		
		--[PART_NUMBER_ITEM_VENDOR]		,		
		--[PART_NUMBER_ITEM_PEARL]		,		
		---- ============================	,
		--[UNIT_PRICE]					,		
		--[TOTAL_PRICE]							
		)
      --SELECT K_PURCHASE_ORDER, K_ITEM FROM @TBL_DATA_TABLE
	  SELECT K_VENDOR,K_VENDOR FROM VENDOR

	  IF @@ROWCOUNT = 0
		BEGIN
		DECLARE @VP_ERROR_1 VARCHAR(250)='The TABLE was not updated.[TEMP_DETAILS_PURCHASE_ORDER]'
			RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
		END			
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH

SELECT @VP_MENSAJE AS MENSAJE
	-- ////////////////////////////////////////////////////////////////////
GO

/*
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_UP_HEADER_PURCHASE_ORDER] 0, 139,												
--				379,												
--				'TEST HEADER_PURCHASE_ORDER 3' , '' , 
--				'TEST200220IT' , 'TEST200201IT@TEST.HEADER_PURCHASE_ORDER' , '6660000000' , 30 , 
--				1,0,
--				1,
--				'CALLE HEADER_PURCHASE_ORDER' , 'COLONIA HEADER_PURCHASE_ORDER' , 'COMMENTS' , 
--				'CIUDAD HEADER_PURCHASE_ORDER', 'ESTADO HEADER_PURCHASE_ORDER' , '32000' , '123' , '-A',
--				1, 
--				'NOMBRE 1' , 'APELLIDO 1' , '' , '' , '' , 
--				'' , '' ,'' ,''														
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_HEADER_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_HEADER_PURCHASE_ORDER]
GO

CREATE PROCEDURE [dbo].[PG_UP_HEADER_PURCHASE_ORDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER					INT,
	@PP_D_HEADER_PURCHASE_ORDER					VARCHAR(250),
	@PP_C_HEADER_PURCHASE_ORDER					VARCHAR(255),
	-- ===========================
	@PP_RFC_HEADER_PURCHASE_ORDER					VARCHAR(13),
	@PP_EMAIL						VARCHAR(100),
	@PP_PHONE						VARCHAR(100),
	@PP_N_CREDIT_DAYS				INT,
	-- ===========================
	@PP_K_STATUS_HEADER_PURCHASE_ORDER				INT,
	@PP_K_CATEGORY_HEADER_PURCHASE_ORDER			INT,
	-- ============================-- ============================
	@PP_K_ADDRESS_HEADER_PURCHASE_ORDER			INT,
	@PP_D_ADDRESS_HEADER_PURCHASE_ORDER_1			VARCHAR (255) ,	-- STREET
	@PP_D_ADDRESS_HEADER_PURCHASE_ORDER_2			VARCHAR (255) ,	-- COLONY, FRACC, 
	-- ============================
	@PP_CITY						VARCHAR (100) ,
	@PP_STATE_GEO					VARCHAR (100),
	@PP_POSTAL_CODE					VARCHAR (10),
	@PP_NUMBER_EXTERIOR				VARCHAR (10),
	@PP_NUMBER_INSIDE				VARCHAR (10),
	-- ============================-- ============================
	@PP_K_CONTACT_HEADER_PURCHASE_ORDER			INT,
	@PP_1_FIRST_NAME				VARCHAR(255),
	@PP_1_MIDDLE_NAME				VARCHAR(255),
	@PP_2_FIRST_NAME				VARCHAR(255),
	@PP_2_MIDDLE_NAME				VARCHAR(255)
	-- ============================				
--	,@PP_1_EMAIL						VARCHAR(100),
--	@PP_1_PHONE						VARCHAR(25)	,
--	@PP_2_EMAIL						VARCHAR(100),
--	@PP_2_PHONE						VARCHAR(25)	
AS			
DECLARE @VP_MENSAJE				VARCHAR(300) = ''
BEGIN TRANSACTION 
BEGIN TRY
	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_HEADER_PURCHASE_ORDER_UPDATE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_HEADER_PURCHASE_ORDER, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_HEADER_PURCHASE_ORDER_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_HEADER_PURCHASE_ORDER,@PP_D_HEADER_PURCHASE_ORDER, @PP_RFC_HEADER_PURCHASE_ORDER,
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
	BEGIN
		UPDATE	HEADER_PURCHASE_ORDER
		SET		
				[D_HEADER_PURCHASE_ORDER]						= @PP_D_HEADER_PURCHASE_ORDER,
				[C_HEADER_PURCHASE_ORDER]						= @PP_C_HEADER_PURCHASE_ORDER,
				-- ========================== -- ===========================
				[BUSINESS_NAME]					= @PP_D_HEADER_PURCHASE_ORDER,				--@PP_BUSINESS_NAME,
				[RFC_HEADER_PURCHASE_ORDER]					= @PP_RFC_HEADER_PURCHASE_ORDER,
				[EMAIL]							= @PP_EMAIL,
				[PHONE]							= @PP_PHONE,
				[N_CREDIT_DAYS]					= @PP_N_CREDIT_DAYS,
				-- ========================== -- ===========================
				[K_STATUS_HEADER_PURCHASE_ORDER]				= @PP_K_STATUS_HEADER_PURCHASE_ORDER,
				[K_CATEGORY_HEADER_PURCHASE_ORDER]				= @PP_K_CATEGORY_HEADER_PURCHASE_ORDER,		
				-- ========================== -- ============================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION
		WHERE	[K_HEADER_PURCHASE_ORDER]=@PP_K_HEADER_PURCHASE_ORDER
		IF @@ROWCOUNT = 0
			BEGIN
				SET @VP_MENSAJE='The HEADER_PURCHASE_ORDER was not updated. [HEADER_PURCHASE_ORDER#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
			END
		
		IF @VP_MENSAJE=''
		BEGIN
			UPDATE	ADDRESS_HEADER_PURCHASE_ORDER
			SET
					[D_ADDRESS_HEADER_PURCHASE_ORDER_1]		= @PP_D_ADDRESS_HEADER_PURCHASE_ORDER_1	,	
					[D_ADDRESS_HEADER_PURCHASE_ORDER_2]		= @PP_D_ADDRESS_HEADER_PURCHASE_ORDER_2	,		
					[C_ADDRESS_HEADER_PURCHASE_ORDER]			= @PP_D_HEADER_PURCHASE_ORDER				,	
					-- =======================	= -- =========================
					[CITY]						= @PP_CITY			,		
					[STATE_GEO]					= @PP_STATE_GEO		,
					[POSTAL_CODE]				= @PP_POSTAL_CODE		,		
					[NUMBER_EXTERIOR]			= @PP_NUMBER_EXTERIOR	,		
					[NUMBER_INSIDE]				= @PP_NUMBER_INSIDE	,		
					-- ========================== -- ============================
					[F_CAMBIO]					= GETDATE(), 
					[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION
			WHERE	[K_ADDRESS_HEADER_PURCHASE_ORDER]=@PP_K_ADDRESS_HEADER_PURCHASE_ORDER			
			AND		[K_HEADER_PURCHASE_ORDER]=@PP_K_HEADER_PURCHASE_ORDER
			IF @@ROWCOUNT = 0
				BEGIN
				DECLARE @VP_ERROR_1 VARCHAR(250)='The address was not updated.[HEADER_PURCHASE_ORDER#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+' //ADDRESS#'+CONVERT(VARCHAR(10),@PP_K_ADDRESS_HEADER_PURCHASE_ORDER)+']'
					RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
				END
		END

		IF @VP_MENSAJE=''
		BEGIN
			UPDATE	CONTACT_HEADER_PURCHASE_ORDER
			SET													
					[1_FIRST_NAME]					= @PP_1_FIRST_NAME		,
					[1_MIDDLE_NAME]					= @PP_1_MIDDLE_NAME		,		
					[2_FIRST_NAME]					= @PP_2_FIRST_NAME		,		
					[2_MIDDLE_NAME]					= @PP_2_MIDDLE_NAME		,		
					[C_CONTACT_HEADER_PURCHASE_ORDER]				= @PP_D_HEADER_PURCHASE_ORDER			,		
					-- ========================== -- ============================
--					[1_EMAIL]						= @PP_1_EMAIL			,			
--					[1_PHONE]						= @PP_1_PHONE			,			
--					[2_EMAIL]						= @PP_2_EMAIL			,			
--					[2_PHONE]						= @PP_2_PHONE			,		
					-- ========================== -- ============================
					[F_CAMBIO]						= GETDATE()				, 
					[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION
			WHERE	[K_CONTACT_HEADER_PURCHASE_ORDER]=@PP_K_CONTACT_HEADER_PURCHASE_ORDER			
			AND		[K_HEADER_PURCHASE_ORDER]=@PP_K_HEADER_PURCHASE_ORDER
			IF @@ROWCOUNT = 0
				BEGIN
				DECLARE @VP_ERROR_2 VARCHAR(250)='The contact was not updated.[HEADER_PURCHASE_ORDER#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+' //CONTACT# '+CONVERT(VARCHAR(10),@PP_K_CONTACT_HEADER_PURCHASE_ORDER)+']'
					RAISERROR (@VP_ERROR_2, 16, 1 ) --MENSAJE - Severity -State.
				END
		END	
	END
--	RAISERROR ('ERROR DE PRUEBAS 3', 16, 1 ) --MENSAJE - Severity -State.
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
		SET		@VP_MENSAJE = 'Not is possible [Update] at [HEADER_PURCHASE_ORDER]: ' + @VP_MENSAJE 
	END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_HEADER_PURCHASE_ORDER AS CLAVE
	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

--	EXECUTE [dbo].[PG_DL_HEADER_PURCHASE_ORDER] 0,139,380,2,2
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_HEADER_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_HEADER_PURCHASE_ORDER]
GO

CREATE PROCEDURE [dbo].[PG_DL_HEADER_PURCHASE_ORDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER					INT
AS
DECLARE @VP_MENSAJE				VARCHAR(300) = ''
DECLARE @PP_K_ADDRESS_HEADER_PURCHASE_ORDER			INT
DECLARE @PP_K_CONTACT_HEADER_PURCHASE_ORDER			INT
BEGIN TRANSACTION 
BEGIN TRY
--/////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_HEADER_PURCHASE_ORDER_DELETE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_HEADER_PURCHASE_ORDER, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	--////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
	
	SELECT	@PP_K_ADDRESS_HEADER_PURCHASE_ORDER=K_ADDRESS_HEADER_PURCHASE_ORDER,
			@PP_K_CONTACT_HEADER_PURCHASE_ORDER=K_CONTACT_HEADER_PURCHASE_ORDER
	FROM	HEADER_PURCHASE_ORDER
	LEFT JOIN ADDRESS_HEADER_PURCHASE_ORDER ON HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER= ADDRESS_HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER
	LEFT JOIN CONTACT_HEADER_PURCHASE_ORDER ON HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER= CONTACT_HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER
	WHERE HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
	
	BEGIN		
		UPDATE	HEADER_PURCHASE_ORDER
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
		IF @@ROWCOUNT = 0
			BEGIN
				SET @VP_MENSAJE='The HEADER_PURCHASE_ORDER was not updated. [HEADER_PURCHASE_ORDER#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
			END
		IF @VP_MENSAJE=''
		BEGIN		
			UPDATE	ADDRESS_HEADER_PURCHASE_ORDER
			SET		
					[L_BORRADO]				= 1,
					-- ====================
					[F_BAJA]				= GETDATE(), 
					[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
			WHERE	K_ADDRESS_HEADER_PURCHASE_ORDER=@PP_K_ADDRESS_HEADER_PURCHASE_ORDER
			IF @@ROWCOUNT = 0
				BEGIN
				DECLARE @VP_ERROR_1 VARCHAR(250)='The address was not deleted.[HEADER_PURCHASE_ORDER#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+' //ADDRESS#'+CONVERT(VARCHAR(10),@PP_K_ADDRESS_HEADER_PURCHASE_ORDER)+']'
					RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
				END
		END

		IF @VP_MENSAJE=''
		BEGIN		
			UPDATE	CONTACT_HEADER_PURCHASE_ORDER
			SET		
					[L_BORRADO]				= 1,
					-- ====================
					[F_BAJA]				= GETDATE(), 
					[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
			WHERE	K_CONTACT_HEADER_PURCHASE_ORDER=@PP_K_CONTACT_HEADER_PURCHASE_ORDER		
			IF @@ROWCOUNT = 0
				BEGIN
				DECLARE @VP_ERROR_2 VARCHAR(250)='The contact was not updated.[HEADER_PURCHASE_ORDER#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+' //CONTACT#'+CONVERT(VARCHAR(10),@PP_K_CONTACT_HEADER_PURCHASE_ORDER)+']'
					RAISERROR (@VP_ERROR_2, 16, 1 ) --MENSAJE - Severity -State.
				END
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
		SET		@VP_MENSAJE = 'Not is possible [Update] at [HEADER_PURCHASE_ORDER]: ' + @VP_MENSAJE 
	END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_HEADER_PURCHASE_ORDER AS CLAVE
	-- //////////////////////////////////////////////////////////////
	
	-- //////////////////////////////////////////////////////////////	
GO
*/
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
