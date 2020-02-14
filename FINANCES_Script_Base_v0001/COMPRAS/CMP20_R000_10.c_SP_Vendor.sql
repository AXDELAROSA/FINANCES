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

-- EXECUTE [dbo].[PG_LI_VENDOR] 0,139,'',-1,-1,-1
CREATE PROCEDURE [dbo].[PG_LI_VENDOR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_BUSCAR						VARCHAR(200),
	@PP_K_STATUS_VENDOR				INT,
	@PP_K_CATEGORY_VENDOR			INT
--	@PP_K_STATE_GEO					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1
		
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS	INT =5000	
	-- =========================================	
	
	DECLARE @VP_K_FOLIO				INT

	EXECUTE [COT19_Cotizaciones_V9999_R0].DBO.[PG_RN_OBTENER_ID_X_REFERENCIA]			
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

-- EXECUTE [dbo].[PG_SK_VENDOR] 0,139,379
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
			
		SELECT	TOP (@VP_LI_N_REGISTROS)
				VENDOR.*,
				STATUS_VENDOR.D_STATUS_VENDOR, CATEGORY_VENDOR.D_CATEGORY_VENDOR
--				STATE_GEO.D_STATE_GEO
				--,D_USUARIO AS D_USUARIO_CAMBIO
				-- =====================
		FROM	VENDOR, 
				STATUS_VENDOR, CATEGORY_VENDOR
--				COT19_Cotizaciones_V9999_R0.DBO.STATE_GEO
				--,USUARIO
				-- =====================
		WHERE	VENDOR.K_STATUS_VENDOR = STATUS_VENDOR.K_STATUS_VENDOR
		AND		VENDOR.K_CATEGORY_VENDOR = CATEGORY_VENDOR.K_CATEGORY_VENDOR
--		AND		VENDOR.TAX_K_STATE = STATE_GEO.K_STATE_GEO
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

-- EXECUTE [dbo].[PG_IN_VENDOR] 0, 139, 'TEST VENDOR' , '' , 'TEST VENDOR' , 'TEST200201IT' , 'TEST200201IT@TEST.VENDOR' , '6660000000' , '30' , 'CALLE FISCAL' , '' , '' , 'COLONIA FISCAL' , 'POBLACION FISCAL' , '30000' , 'MUNICIPIO FISCAL' , 8 , 'CALLE OFICINA' , '' , '' , 'COLONIA OFICINA' , 'POBLACION OFICINA' , '32000' , 'MUNICIPIO OFICINA' , 8 , 1 , 0, 'CONTACTO VENTAS' , '' , 'CONTACTO@VENTAS' , 'CONTACTO PAGOS' , '' , 'CONTACTO@PAGOS'
CREATE PROCEDURE [dbo].[PG_IN_VENDOR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_D_VENDOR					VARCHAR(100),
	@PP_C_VENDOR					VARCHAR(255),
	-- ===========================
	@PP_BUSINESS_NAME				VARCHAR(250),
	@PP_RFC_VENDOR					VARCHAR(13),
	@PP_EMAIL						VARCHAR(100),
	@PP_PHONE						VARCHAR(100),
	@PP_N_CREDIT_DAYS				INT,
	-- ===========================
	@PP_K_STATUS_VENDOR				INT,
	@PP_K_CATEGORY_VENDOR			INT
	-- ============================
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	DECLARE @VP_K_VENDOR			INT = 0

		EXECUTE [DATA_02Pruebas].dbo.[PG_SK_CATALOGO_K_MAX_GET]		@PP_K_SISTEMA_EXE, 'COMPRAS',
																	'VENDOR', 'K_VENDOR',
													@OU_K_TABLA_DISPONIBLE = @VP_K_VENDOR	OUTPUT

	
	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_VENDOR_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@VP_K_VENDOR, 
												@PP_D_VENDOR, @PP_RFC_VENDOR,
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
		-- //////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
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
				@PP_BUSINESS_NAME, @PP_RFC_VENDOR, 
				@PP_EMAIL, @PP_PHONE,
				@PP_N_CREDIT_DAYS,
				-- ===========================
				@PP_K_STATUS_VENDOR, @PP_K_CATEGORY_VENDOR,
				-- ============================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Insert] at [VENDOR]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#VENDOR.'+CONVERT(VARCHAR(10),@VP_K_VENDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_VENDOR AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_SK_VENDOR] 0,139,379
-- EXECUTE [dbo].[PG_UP_VENDOR] 0, 139, 379,'TEST VENDOR' , 'FOR TEST' , 'TEST VENDOR' , 'TEST200201IT' , 'TEST200201IT@TEST.VENDOR' , '6660000000' , '30' , 'CALLE FISCAL' , '' , '' , 'COLONIA FISCAL' , 'POBLACION FISCAL' , '30000' , 'MUNICIPIO FISCAL' , 8 , 'CALLE OFICINA' , '' , '' , 'COLONIA OFICINA' , 'POBLACION OFICINA' , '32000' , 'MUNICIPIO OFICINA' , 8 , 1 , 0, 'CONTACTO VENTAS' , '' , 'CONTACTO@VENTAS' , 'CONTACTO PAGOS' , '' , 'CONTACTO@PAGOS'
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_VENDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_VENDOR]
GO

CREATE PROCEDURE [dbo].[PG_UP_VENDOR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VENDOR					INT,
	@PP_D_VENDOR					VARCHAR(100),
	@PP_C_VENDOR					VARCHAR(255),
	-- ===========================
	@PP_BUSINESS_NAME				VARCHAR(250),
	@PP_RFC_VENDOR					VARCHAR(13),
	@PP_EMAIL						VARCHAR(100),
	@PP_PHONE						VARCHAR(100),
	@PP_N_CREDIT_DAYS				INT,
	-- ===========================
	@PP_K_STATUS_VENDOR				INT,
	@PP_K_CATEGORY_VENDOR			INT
	-- ============================
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_VENDOR_UPDATE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_VENDOR, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_VENDOR_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_VENDOR, 
												@PP_D_VENDOR, @PP_RFC_VENDOR,
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	VENDOR
		SET		
				[D_VENDOR]						= @PP_D_VENDOR,
				[C_VENDOR]						= @PP_C_VENDOR,
				[O_VENDOR]						= 10,
				-- ========================== -- ===========================
				[BUSINESS_NAME]					= @PP_BUSINESS_NAME,
				[RFC_VENDOR]					= @PP_RFC_VENDOR,
				[EMAIL]							= @PP_EMAIL,
				[PHONE]							= @PP_PHONE,
				[N_CREDIT_DAYS]					= @PP_N_CREDIT_DAYS,
				-- ========================== -- ===========================
				[K_STATUS_VENDOR]				= @PP_K_STATUS_VENDOR,
				[K_CATEGORY_VENDOR]				= @PP_K_CATEGORY_VENDOR,		
				-- ========================== -- ============================
				[F_CAMBIO]							= GETDATE(), 
				[K_USUARIO_CAMBIO]					= @PP_K_USUARIO_ACCION
		WHERE	K_VENDOR=@PP_K_VENDOR
	
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Update] at [VENDOR]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#VENDOR.'+CONVERT(VARCHAR(10),@PP_K_VENDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_VENDOR AS CLAVE
	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

--	EXECUTE [dbo].[PG_DL_VENDOR] 0,139,379
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_VENDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_VENDOR]
GO

CREATE PROCEDURE [dbo].[PG_DL_VENDOR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VENDOR					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

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
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Delete] at [VENDOR]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#VENDOR.'+CONVERT(VARCHAR(10),@PP_K_VENDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_VENDOR AS CLAVE

	-- //////////////////////////////////////////////////////////////	
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
