-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			VENDOR
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_VENDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_VENDOR]
GO

-- EXECUTE [dbo].[PG_LI_VENDOR] 0,139,'',-1,-1	
CREATE PROCEDURE [dbo].[PG_LI_VENDOR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_BUSCAR						VARCHAR(200),
	@PP_K_STATUS_VENDOR				INT,
	@PP_K_CATEGORY_VENDOR			INT
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
				VENDOR.*,
				STATUS_VENDOR.D_STATUS_VENDOR, CATEGORY_VENDOR.D_CATEGORY_VENDOR, --STATE_GEO.D_STATE_GEO,
				STATUS_VENDOR.S_STATUS_VENDOR, CATEGORY_VENDOR.S_CATEGORY_VENDOR --STATE_GEO.S_STATE_GEO
				--,D_USUARIO AS D_USUARIO_CAMBIO
				-- =============================	
	FROM		VENDOR, 
				STATUS_VENDOR, CATEGORY_VENDOR
--				COT19_Cotizaciones_V9999_R0.DBO.STATE_GEO
				--,USUARIO
				-- =============================
	WHERE		VENDOR.K_STATUS_VENDOR=STATUS_VENDOR.K_STATUS_VENDOR
	AND			VENDOR.K_CATEGORY_VENDOR=CATEGORY_VENDOR.K_CATEGORY_VENDOR
				-- =============================
--				ESTA LOGICA SE CAMBIA PARA BUSCAR EN BASE A LA DIRECCIÓN QUE TIENE DAD DE ALTA
--				EL VENDOR
--	AND			(	VENDOR.TAX_K_STATE = STATE_GEO.K_STATE_GEO
--				OR	VENDOR.OFFICE_K_STATE = STATE_GEO.K_STATE_GEO )
--	AND			VENDOR.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
				-- =============================
	AND			(	VENDOR.K_VENDOR=@VP_K_FOLIO
				OR	VENDOR.BUSINESS_NAME			LIKE '%'+@PP_BUSCAR+'%'
				OR	VENDOR.D_VENDOR					LIKE '%'+@PP_BUSCAR+'%' 
				OR	VENDOR.RFC_VENDOR				LIKE '%'+@PP_BUSCAR+'%'
				OR	VENDOR.C_VENDOR					LIKE '%'+@PP_BUSCAR+'%' )
				-- =============================
--	AND			( @PP_K_STATE =-1				OR	VENDOR.TAX_K_STATE=@PP_K_STATE )
	AND			( @PP_K_STATUS_VENDOR	=-1		OR	VENDOR.K_STATUS_VENDOR=@PP_K_STATUS_VENDOR )
	AND			( @PP_K_CATEGORY_VENDOR =-1		OR	VENDOR.K_CATEGORY_VENDOR=@PP_K_CATEGORY_VENDOR )
				-- =============================
	AND			VENDOR.L_BORRADO<>1
	ORDER BY	D_VENDOR,K_CATEGORY_VENDOR	DESC
	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_VENDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_VENDOR]
GO

-- EXECUTE [dbo].[PG_SK_VENDOR] 0,139,300
CREATE PROCEDURE [dbo].[PG_SK_VENDOR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VENDOR					INT
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''	
	-- ///////////////////////////////////////////
	DECLARE @VP_LI_N_REGISTROS		INT = 100
	
		IF @VP_MENSAJE<>''
			SET @VP_LI_N_REGISTROS = 0
			
		SELECT	TOP (1)
				 ISNULL([K_ADDRESS_VENDOR]	,-1) AS [K_ADDRESS_VENDOR]
				,ISNULL([K_CONTACT_VENDOR]	,-1) AS [K_CONTACT_VENDOR]				
				-- =========================
				,VENDOR.*,
				-- =========================
				STATUS_VENDOR.D_STATUS_VENDOR, CATEGORY_VENDOR.D_CATEGORY_VENDOR
				-- =========================
				,ISNULL([D_ADDRESS_VENDOR_1],'') AS [D_ADDRESS_VENDOR_1]
				,ISNULL([D_ADDRESS_VENDOR_2],'') AS [D_ADDRESS_VENDOR_2]		
				,ISNULL([C_ADDRESS_VENDOR]	,'') AS [C_ADDRESS_VENDOR]		
				,ISNULL([O_ADDRESS_VENDOR]	,10) AS [O_ADDRESS_VENDOR]			
				,ISNULL([CITY]				,'') AS [CITY]					
				,ISNULL([STATE_GEO]			,'') AS [STATE_GEO]				
				,ISNULL([POSTAL_CODE]		,'') AS [POSTAL_CODE]		
				,ISNULL([NUMBER_EXTERIOR]	,'') AS [NUMBER_EXTERIOR]		
				,ISNULL([NUMBER_INSIDE]		,'') AS [NUMBER_INSIDE]				
				-- =========================	 AS ====================
				,ISNULL([1_FIRST_NAME]		,'') AS [1_FIRST_NAME]				
				,ISNULL([1_MIDDLE_NAME]		,'') AS [1_MIDDLE_NAME]				
				,ISNULL([2_FIRST_NAME]		,'') AS [2_FIRST_NAME]				
				,ISNULL([2_MIDDLE_NAME]		,'') AS [2_MIDDLE_NAME]				
				,ISNULL([C_CONTACT_VENDOR]	,'') AS [C_CONTACT_VENDOR]			
				,ISNULL([1_EMAIL]			,'') AS [1_EMAIL]					
				,ISNULL([1_PHONE]			,'') AS [1_PHONE]					
				,ISNULL([2_EMAIL]			,'') AS [2_EMAIL]					
				,ISNULL([2_PHONE]			,'') AS [2_PHONE]									
		FROM	VENDOR
		LEFT JOIN STATUS_VENDOR ON VENDOR.K_STATUS_VENDOR=STATUS_VENDOR.K_STATUS_VENDOR
		LEFT JOIN CATEGORY_VENDOR ON VENDOR.K_CATEGORY_VENDOR=CATEGORY_VENDOR.K_CATEGORY_VENDOR
		LEFT JOIN ADDRESS_VENDOR ON VENDOR.K_VENDOR=ADDRESS_VENDOR.K_VENDOR
		LEFT JOIN CONTACT_VENDOR ON VENDOR.K_VENDOR=CONTACT_VENDOR.K_VENDOR
		AND		VENDOR.K_VENDOR=@PP_K_VENDOR
		AND		VENDOR.L_BORRADO<>1
		
	-- ////////////////////////////////////////////////////////////////////
GO


	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_VENDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_VENDOR]
GO

-- EXECUTE [dbo].[PG_IN_VENDOR] 0, 139,												
--				'TEST VENDOR 3' , '' , 
--				'TEST200230IT' , 'TEST200201IT@TEST.VENDOR' , '6660000000' , 30 , 
--				1,0,
--				'CALLE VENDOR' , 'COLONIA VENDOR' , 'COMMENTS' , 
--				'CIUDAD VENDOR', 'ESTADO VENDOR' , '32000' , '123' , '-A', 
--				'NOMBRE 1' , 'APELLIDO 1' , '' , '' , '' , 
--				'' , '' ,'' ,''															,'' 
CREATE PROCEDURE [dbo].[PG_IN_VENDOR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_D_VENDOR					VARCHAR(250),
	@PP_C_VENDOR					VARCHAR(255),
	-- ===========================
	@PP_RFC_VENDOR					VARCHAR(13),
	@PP_EMAIL						VARCHAR(100),
	@PP_PHONE						VARCHAR(100),
	@PP_N_CREDIT_DAYS				INT,
	-- ===========================
	@PP_K_STATUS_VENDOR				INT,
	@PP_K_CATEGORY_VENDOR			INT,
	-- ============================-- ============================
	@PP_D_ADDRESS_VENDOR_1			VARCHAR (255) ,	-- STREET
	@PP_D_ADDRESS_VENDOR_2			VARCHAR (255) ,	-- COLONY, FRACC, 
	-- ============================
	@PP_CITY						VARCHAR (100) ,
	@PP_STATE_GEO					VARCHAR (100),
	@PP_POSTAL_CODE					VARCHAR (10),
	@PP_NUMBER_EXTERIOR				VARCHAR (10),
	@PP_NUMBER_INSIDE				VARCHAR (10),
	-- ============================-- ============================
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

DECLARE @VP_MENSAJE				VARCHAR(500) = ''
DECLARE @VP_K_VENDOR			INT = 0;	
DECLARE @VP_K_ADDRESS_VENDOR	INT = 0;	
DECLARE @VP_K_CONTACT_VENDOR	INT = 0
	
BEGIN TRANSACTION 
BEGIN TRY
-- /////////////////////////////////////////////////////////////////////

		EXECUTE [BD_GENERAL].dbo.[PG_SK_CATALOGO_K_MAX_GET]		@PP_K_SISTEMA_EXE, 'COMPRAS',
																'VENDOR', 'K_VENDOR',
																@OU_K_TABLA_DISPONIBLE = @VP_K_VENDOR	OUTPUT
		
		EXECUTE [BD_GENERAL].dbo.[PG_SK_CATALOGO_K_MAX_GET]		@PP_K_SISTEMA_EXE, 'COMPRAS',
																'ADDRESS_VENDOR', 'K_ADDRESS_VENDOR',
																@OU_K_TABLA_DISPONIBLE = @VP_K_ADDRESS_VENDOR	OUTPUT		

		EXECUTE [BD_GENERAL].dbo.[PG_SK_CATALOGO_K_MAX_GET]		@PP_K_SISTEMA_EXE, 'COMPRAS',
																'CONTACT_VENDOR', 'K_CONTACT_VENDOR',
																@OU_K_TABLA_DISPONIBLE = @VP_K_CONTACT_VENDOR	OUTPUT
		
	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_VENDOR_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@VP_K_VENDOR, 
												@PP_D_VENDOR, @PP_RFC_VENDOR,
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- //////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
	BEGIN		
	--============================================================================
	--======================================INSERTAR EL VENDOR
	--============================================================================
		INSERT INTO VENDOR
			(	[K_VENDOR], [D_VENDOR], 
				[C_VENDOR], [O_VENDOR],
				-- ===========================
				[BUSINESS_NAME], [RFC_VENDOR], 
				[EMAIL], [PHONE], 
				[N_CREDIT_DAYS],
				-- ===========================
				[K_STATUS_VENDOR],[K_CATEGORY_VENDOR],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_VENDOR, @PP_D_VENDOR, 
				@PP_C_VENDOR, 10,
				-- ===========================
				@PP_D_VENDOR, @PP_RFC_VENDOR, 
				@PP_EMAIL, @PP_PHONE,
				@PP_N_CREDIT_DAYS,
				-- ===========================
				@PP_K_STATUS_VENDOR, @PP_K_CATEGORY_VENDOR,
				-- ============================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )

			IF @@ROWCOUNT = 0
				BEGIN
					--DECLARE @VP_ERROR_1 VARCHAR(250)='THE VENDOR WAS NOT INSERTED. [VENDOR#'+CONVERT(VARCHAR(10),@VP_K_VENDOR)+']'
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='The vendor was not inserted. [VENDOR#'+CONVERT(VARCHAR(10),@VP_K_VENDOR)+']'
				END
		
--		RAISERROR ('ERROR DE PRUEBAS', 16, 1 ) --MENSAJE - Severity -State.
		IF @VP_MENSAJE=''
		BEGIN
		--============================================================================
		--======================================INSERTAR EL ADDRESS_VENDOR
		--============================================================================
		INSERT INTO ADDRESS_VENDOR
			(	[K_VENDOR]			,
				[K_ADDRESS_VENDOR]	,			
				[D_ADDRESS_VENDOR_1],	[D_ADDRESS_VENDOR_2]	,			
				[C_ADDRESS_VENDOR]	,	[O_ADDRESS_VENDOR]		,
				-- =======================
				[CITY]				,	[STATE_GEO]	,
				[POSTAL_CODE]		,
				[NUMBER_EXTERIOR]	,	[NUMBER_INSIDE]		,
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_VENDOR			,
				@VP_K_ADDRESS_VENDOR	,
				@PP_D_ADDRESS_VENDOR_1	,	@PP_D_ADDRESS_VENDOR_2	,		
				@PP_D_VENDOR	,	10	,			
				-- ============================
				@PP_CITY			,		@PP_STATE_GEO		,
				@PP_POSTAL_CODE		,			
				@PP_NUMBER_EXTERIOR	,		@PP_NUMBER_INSIDE	,			
				-- ============================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )
			IF @@ROWCOUNT = 0
				BEGIN
				DECLARE @VP_ERROR_1 VARCHAR(250)='The addres was not inserted.[VENDOR#'+CONVERT(VARCHAR(10),@VP_K_VENDOR)+' //ADDRESS#'+CONVERT(VARCHAR(10),@VP_K_ADDRESS_VENDOR)+']'
					RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
				--	SET @VP_MENSAJE='The vendor was not inserted. [VENDOR#'+CONVERT(VARCHAR(10),@VP_K_VENDOR)+']'
				END
		END

--		RAISERROR ('ERROR DE PRUEBAS 2', 16, 1 ) --MENSAJE - Severity -State.
		IF @VP_MENSAJE=''
		BEGIN
		--============================================================================
		--======================================INSERTAR EL CONTACT_VENDOR
		--============================================================================
		INSERT INTO CONTACT_VENDOR
			(	[K_VENDOR]			,
				[K_CONTACT_VENDOR]	,	[1_FIRST_NAME]		,
				[1_MIDDLE_NAME]		,	[2_FIRST_NAME]		,
				[2_MIDDLE_NAME]		,	[C_CONTACT_VENDOR]	,
				-- ===========================
				[1_EMAIL]			,	[1_PHONE]			,
				[2_EMAIL]			,	[2_PHONE]			,
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_VENDOR		,
				@VP_K_CONTACT_VENDOR,	@PP_1_FIRST_NAME		,		
				@PP_1_MIDDLE_NAME	,	@PP_2_FIRST_NAME		,		
				@PP_2_MIDDLE_NAME	,	@PP_D_VENDOR	,
				-- ============================	
--				@PP_1_EMAIL			,	@PP_1_PHONE				,	
--				@PP_2_EMAIL			,	@PP_2_PHONE				,	
				-- ============================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )
			IF @@ROWCOUNT = 0
				BEGIN
				DECLARE @VP_ERROR_2 VARCHAR(250)='The contact was not inserted.[VENDOR#'+CONVERT(VARCHAR(10),@VP_K_VENDOR)+' //CONTACT#'+CONVERT(VARCHAR(10),@VP_K_CONTACT_VENDOR)+']'
					RAISERROR (@VP_ERROR_2, 16, 1 ) --MENSAJE - Severity -State.
				--	SET @VP_MENSAJE='The vendor was not inserted. [VENDOR#'+CONVERT(VARCHAR(10),@VP_K_VENDOR)+']'
				END
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
		SET		@VP_MENSAJE = 'Not is possible [Insert] at [VENDOR]: ' + @VP_MENSAJE 
	END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_VENDOR AS CLAVE
	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_UP_VENDOR] 0, 139,												
--				379,												
--				'TEST VENDOR 3' , '' , 
--				'TEST200220IT' , 'TEST200201IT@TEST.VENDOR' , '6660000000' , 30 , 
--				1,0,
--				1,
--				'CALLE VENDOR' , 'COLONIA VENDOR' , 'COMMENTS' , 
--				'CIUDAD VENDOR', 'ESTADO VENDOR' , '32000' , '123' , '-A',
--				1, 
--				'NOMBRE 1' , 'APELLIDO 1' , '' , '' , '' , 
--				'' , '' ,'' ,''														
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_VENDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_VENDOR]
GO

CREATE PROCEDURE [dbo].[PG_UP_VENDOR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VENDOR					INT,
	@PP_D_VENDOR					VARCHAR(250),
	@PP_C_VENDOR					VARCHAR(255),
	-- ===========================
	@PP_RFC_VENDOR					VARCHAR(13),
	@PP_EMAIL						VARCHAR(100),
	@PP_PHONE						VARCHAR(100),
	@PP_N_CREDIT_DAYS				INT,
	-- ===========================
	@PP_K_STATUS_VENDOR				INT,
	@PP_K_CATEGORY_VENDOR			INT,
	-- ============================-- ============================
	@PP_K_ADDRESS_VENDOR			INT,
	@PP_D_ADDRESS_VENDOR_1			VARCHAR (255) ,	-- STREET
	@PP_D_ADDRESS_VENDOR_2			VARCHAR (255) ,	-- COLONY, FRACC, 
	-- ============================
	@PP_CITY						VARCHAR (100) ,
	@PP_STATE_GEO					VARCHAR (100),
	@PP_POSTAL_CODE					VARCHAR (10),
	@PP_NUMBER_EXTERIOR				VARCHAR (10),
	@PP_NUMBER_INSIDE				VARCHAR (10),
	-- ============================-- ============================
	@PP_K_CONTACT_VENDOR			INT,
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
		EXECUTE [dbo].[PG_RN_VENDOR_UPDATE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_VENDOR, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_VENDOR_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_VENDOR,@PP_D_VENDOR, @PP_RFC_VENDOR,
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
	BEGIN
		UPDATE	VENDOR
		SET		
				[D_VENDOR]						= @PP_D_VENDOR,
				[C_VENDOR]						= @PP_C_VENDOR,
				-- ========================== -- ===========================
				[BUSINESS_NAME]					= @PP_D_VENDOR,				--@PP_BUSINESS_NAME,
				[RFC_VENDOR]					= @PP_RFC_VENDOR,
				[EMAIL]							= @PP_EMAIL,
				[PHONE]							= @PP_PHONE,
				[N_CREDIT_DAYS]					= @PP_N_CREDIT_DAYS,
				-- ========================== -- ===========================
				[K_STATUS_VENDOR]				= @PP_K_STATUS_VENDOR,
				[K_CATEGORY_VENDOR]				= @PP_K_CATEGORY_VENDOR,		
				-- ========================== -- ============================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION
		WHERE	[K_VENDOR]=@PP_K_VENDOR
		IF @@ROWCOUNT = 0
			BEGIN
				SET @VP_MENSAJE='The vendor was not updated. [VENDOR#'+CONVERT(VARCHAR(10),@PP_K_VENDOR)+']'
			END
		
		IF @VP_MENSAJE=''
		BEGIN
			UPDATE	ADDRESS_VENDOR
			SET
					[D_ADDRESS_VENDOR_1]		= @PP_D_ADDRESS_VENDOR_1	,	
					[D_ADDRESS_VENDOR_2]		= @PP_D_ADDRESS_VENDOR_2	,		
					[C_ADDRESS_VENDOR]			= @PP_D_VENDOR				,	
					-- =======================	= -- =========================
					[CITY]						= @PP_CITY			,		
					[STATE_GEO]					= @PP_STATE_GEO		,
					[POSTAL_CODE]				= @PP_POSTAL_CODE		,		
					[NUMBER_EXTERIOR]			= @PP_NUMBER_EXTERIOR	,		
					[NUMBER_INSIDE]				= @PP_NUMBER_INSIDE	,		
					-- ========================== -- ============================
					[F_CAMBIO]					= GETDATE(), 
					[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION
			WHERE	[K_ADDRESS_VENDOR]=@PP_K_ADDRESS_VENDOR			
			AND		[K_VENDOR]=@PP_K_VENDOR
			IF @@ROWCOUNT = 0
				BEGIN
				DECLARE @VP_ERROR_1 VARCHAR(250)='The address was not updated.[VENDOR#'+CONVERT(VARCHAR(10),@PP_K_VENDOR)+' //ADDRESS#'+CONVERT(VARCHAR(10),@PP_K_ADDRESS_VENDOR)+']'
					RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
				END
		END

		IF @VP_MENSAJE=''
		BEGIN
			UPDATE	CONTACT_VENDOR
			SET													
					[1_FIRST_NAME]					= @PP_1_FIRST_NAME		,
					[1_MIDDLE_NAME]					= @PP_1_MIDDLE_NAME		,		
					[2_FIRST_NAME]					= @PP_2_FIRST_NAME		,		
					[2_MIDDLE_NAME]					= @PP_2_MIDDLE_NAME		,		
					[C_CONTACT_VENDOR]				= @PP_D_VENDOR			,		
					-- ========================== -- ============================
--					[1_EMAIL]						= @PP_1_EMAIL			,			
--					[1_PHONE]						= @PP_1_PHONE			,			
--					[2_EMAIL]						= @PP_2_EMAIL			,			
--					[2_PHONE]						= @PP_2_PHONE			,		
					-- ========================== -- ============================
					[F_CAMBIO]						= GETDATE()				, 
					[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION
			WHERE	[K_CONTACT_VENDOR]=@PP_K_CONTACT_VENDOR			
			AND		[K_VENDOR]=@PP_K_VENDOR
			IF @@ROWCOUNT = 0
				BEGIN
				DECLARE @VP_ERROR_2 VARCHAR(250)='The contact was not updated.[VENDOR#'+CONVERT(VARCHAR(10),@PP_K_VENDOR)+' //CONTACT# '+CONVERT(VARCHAR(10),@PP_K_CONTACT_VENDOR)+']'
					RAISERROR (@VP_ERROR_2, 16, 1 ) --MENSAJE - Severity -State.
				END
		END	
	END
--	RAISERROR ('ERROR DE PRUEBAS 3', 16, 1 ) --MENSAJE - Severity -State.
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
		SET		@VP_MENSAJE = 'Not is possible [Update] at [VENDOR]: ' + @VP_MENSAJE 
	END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_VENDOR AS CLAVE
	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

--	EXECUTE [dbo].[PG_DL_VENDOR] 0,139,380,2,2
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_VENDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_VENDOR]
GO

CREATE PROCEDURE [dbo].[PG_DL_VENDOR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VENDOR					INT,
	@PP_K_ADDRESS_VENDOR			INT,
	@PP_K_CONTACT_VENDOR			INT
AS
DECLARE @VP_MENSAJE				VARCHAR(300) = ''
BEGIN TRANSACTION 
BEGIN TRY
--/////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_VENDOR_DELETE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_VENDOR, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	--////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
	BEGIN		
		UPDATE	VENDOR
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_VENDOR=@PP_K_VENDOR
		IF @@ROWCOUNT = 0
			BEGIN
				SET @VP_MENSAJE='The vendor was not updated. [VENDOR#'+CONVERT(VARCHAR(10),@PP_K_VENDOR)+']'
			END
		IF @VP_MENSAJE=''
		BEGIN		
			UPDATE	ADDRESS_VENDOR
			SET		
					[L_BORRADO]				= 1,
					-- ====================
					[F_BAJA]				= GETDATE(), 
					[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
			WHERE	K_ADDRESS_VENDOR=@PP_K_ADDRESS_VENDOR
			IF @@ROWCOUNT = 0
				BEGIN
				DECLARE @VP_ERROR_1 VARCHAR(250)='The address was not deleted.[VENDOR#'+CONVERT(VARCHAR(10),@PP_K_VENDOR)+' //ADDRESS#'+CONVERT(VARCHAR(10),@PP_K_ADDRESS_VENDOR)+']'
					RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
				END
		END

		IF @VP_MENSAJE=''
		BEGIN		
			UPDATE	CONTACT_VENDOR
			SET		
					[L_BORRADO]				= 1,
					-- ====================
					[F_BAJA]				= GETDATE(), 
					[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
			WHERE	K_CONTACT_VENDOR=@PP_K_CONTACT_VENDOR		
			IF @@ROWCOUNT = 0
				BEGIN
				DECLARE @VP_ERROR_2 VARCHAR(250)='The contact was not updated.[VENDOR#'+CONVERT(VARCHAR(10),@PP_K_VENDOR)+' //CONTACT#'+CONVERT(VARCHAR(10),@PP_K_CONTACT_VENDOR)+']'
					RAISERROR (@VP_ERROR_2, 16, 1 ) --MENSAJE - Severity -State.
				END
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

	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		SET		@VP_MENSAJE = 'Not is possible [Update] at [VENDOR]: ' + @VP_MENSAJE 
	END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_VENDOR AS CLAVE
	-- //////////////////////////////////////////////////////////////
	
	-- //////////////////////////////////////////////////////////////	
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
