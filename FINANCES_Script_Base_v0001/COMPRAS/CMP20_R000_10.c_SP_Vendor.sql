-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			COMPRAS
-- // OPERATION:		TABLA
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
	@PP_K_STATUS_VENDOR			INT,
	@PP_K_CATEGORY_VENDOR			INT,
	@PP_K_STATE						INT
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
				STATUS_VENDOR.D_STATUS_VENDOR, CATEGORY_VENDOR.D_CATEGORY_VENDOR, STATE_GEO.D_STATE_GEO,
				STATUS_VENDOR.S_STATUS_VENDOR, CATEGORY_VENDOR.S_CATEGORY_VENDOR, STATE_GEO.S_STATE_GEO
				--,D_USUARIO AS D_USUARIO_CAMBIO
				-- =============================	
	FROM		VENDOR, 
				STATUS_VENDOR, CATEGORY_VENDOR,
				COT19_Cotizaciones_V9999_R0.DBO.STATE_GEO
				--,USUARIO
				-- =============================
	WHERE		VENDOR.K_STATUS_VENDOR=STATUS_VENDOR.K_STATUS_VENDOR
	AND			VENDOR.K_CATEGORY_VENDOR=CATEGORY_VENDOR.K_CATEGORY_VENDOR
	AND			(	VENDOR.TAX_K_STATE = STATE_GEO.K_STATE_GEO
				OR	VENDOR.OFFICE_K_STATE = STATE_GEO.K_STATE_GEO )
--	AND			VENDOR.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
				-- =============================
	AND			(	VENDOR.K_VENDOR=@VP_K_FOLIO
				OR	VENDOR.BUSINESS_NAME					LIKE '%'+@PP_BUSCAR+'%'
				OR	VENDOR.D_VENDOR					LIKE '%'+@PP_BUSCAR+'%' 
				OR	VENDOR.RFC_VENDOR				LIKE '%'+@PP_BUSCAR+'%'
				OR	VENDOR.C_VENDOR					LIKE '%'+@PP_BUSCAR+'%' )
				-- =============================
	AND			( @PP_K_STATE =-1				OR	VENDOR.TAX_K_STATE=@PP_K_STATE )
	AND			( @PP_K_STATE =-1				OR	VENDOR.OFFICE_K_STATE=@PP_K_STATE )
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
				STATUS_VENDOR.D_STATUS_VENDOR, CATEGORY_VENDOR.D_CATEGORY_VENDOR,
				STATE_GEO.D_STATE_GEO
				--,D_USUARIO AS D_USUARIO_CAMBIO
				-- =====================
		FROM	VENDOR, 
				STATUS_VENDOR, CATEGORY_VENDOR,
				COT19_Cotizaciones_V9999_R0.DBO.STATE_GEO
				--,USUARIO
				-- =====================
		WHERE	VENDOR.K_STATUS_VENDOR = STATUS_VENDOR.K_STATUS_VENDOR
		AND		VENDOR.K_CATEGORY_VENDOR = CATEGORY_VENDOR.K_CATEGORY_VENDOR
		AND		VENDOR.TAX_K_STATE = STATE_GEO.K_STATE_GEO
		AND		VENDOR.OFFICE_K_STATE = STATE_GEO.K_STATE_GEO
		AND		VENDOR.K_VENDOR=@PP_K_VENDOR
		
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
	@PP_RFC_VENDOR				VARCHAR(13),
	@PP_EMAIL						VARCHAR(100),
	@PP_PHONE						VARCHAR(100),
	@PP_N_CREDIT_DAYS				INT,
	-- ===========================
	@PP_TAX_STREET					VARCHAR(100),
	@PP_TAX_NUMBER_EXTERIOR			VARCHAR(100),
	@PP_TAX_NUMBER_INSIDE			VARCHAR(100),
	@PP_TAX_COLONY					VARCHAR(100),
	@PP_TAX_POPULATION				VARCHAR(100),
	@PP_TAX_POSTAL_CODE				VARCHAR(100),
	@PP_TAX_MUNICIPALITY			VARCHAR(100),
	@PP_TAX_K_STATE					INT,
	-- ===========================
	@PP_OFFICE_STREET				VARCHAR(100),
	@PP_OFFICE_NUMBER_EXTERIOR		VARCHAR(100),
	@PP_OFFICE_NUMBER_INSIDE		VARCHAR(100),
	@PP_OFFICE_COLONY				VARCHAR(100),
	@PP_OFFICE_POPULATION			VARCHAR(100),
	@PP_OFFICE_POSTAL_CODE			VARCHAR(100),
	@PP_OFFICE_MUNICIPALITY			VARCHAR(100),
	@PP_OFFICE_K_STATE				INT,
	-- ===========================
	@PP_K_STATUS_VENDOR			INT,
	@PP_K_CATEGORY_VENDOR			INT,
	-- ============================
	@PP_CONTACT_SALES_NAME			VARCHAR(100),
	@PP_CONTACT_SALES_PHONE			VARCHAR(100),
	@PP_CONTACT_SALES_EMAIL			VARCHAR(100),
	-- ============================
	@PP_CONTACT_PAYMENT_NAME		VARCHAR(100),
	@PP_CONTACT_PAYMENT_PHONE		VARCHAR(100),
	@PP_CONTACT_PAYMENT_EMAIL		VARCHAR(100)
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
				[TAX_STREET], [TAX_NUMBER_EXTERIOR], [TAX_NUMBER_INSIDE], 
				[TAX_COLONY], [TAX_POPULATION],
				[TAX_POSTAL_CODE],[TAX_MUNICIPALITY], [TAX_K_STATE], 
				-- ===========================
				[OFFICE_STREET], [OFFICE_NUMBER_EXTERIOR], [OFFICE_NUMBER_INSIDE], 
				[OFFICE_COLONY], [OFFICE_POPULATION],
				[OFFICE_POSTAL_CODE],[OFFICE_MUNICIPALITY], [OFFICE_K_STATE], 
				-- ===========================

				[K_STATUS_VENDOR],[K_CATEGORY_VENDOR],
				-- ===========================
				[CONTACT_SALES_NAME],[CONTACT_SALES_PHONE],[CONTACT_SALES_EMAIL],
				-- ===========================
				[CONTACT_PAYMENTS_NAME],[CONTACT_PAYMENTS_PHONE],[CONTACT_PAYMENTS_EMAIL],
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
				@PP_TAX_STREET, @PP_TAX_NUMBER_EXTERIOR, @PP_TAX_NUMBER_INSIDE,
				@PP_TAX_COLONY, @PP_TAX_POPULATION,
				@PP_TAX_POSTAL_CODE, @PP_TAX_MUNICIPALITY, @PP_TAX_K_STATE, 
				-- ===========================
				@PP_OFFICE_STREET, @PP_OFFICE_NUMBER_EXTERIOR, @PP_OFFICE_NUMBER_INSIDE,
				@PP_OFFICE_COLONY, @PP_OFFICE_POPULATION,
				@PP_OFFICE_POSTAL_CODE, @PP_OFFICE_MUNICIPALITY, @PP_OFFICE_K_STATE, 
				-- ===========================
				@PP_K_STATUS_VENDOR, @PP_K_CATEGORY_VENDOR,
				-- ============================
				@PP_CONTACT_SALES_NAME, @PP_CONTACT_SALES_PHONE,
				@PP_CONTACT_SALES_EMAIL,
				-- ============================
				@PP_CONTACT_PAYMENT_NAME, @PP_CONTACT_PAYMENT_PHONE,
				@PP_CONTACT_PAYMENT_EMAIL,		
				-- ===========================
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
	@PP_RFC_VENDOR				VARCHAR(13),
	@PP_EMAIL						VARCHAR(100),
	@PP_PHONE						VARCHAR(100),
	@PP_N_CREDIT_DAYS				INT,
	-- ===========================
	@PP_TAX_STREET					VARCHAR(100),
	@PP_TAX_NUMBER_EXTERIOR			VARCHAR(100),
	@PP_TAX_NUMBER_INSIDE			VARCHAR(100),
	@PP_TAX_COLONY					VARCHAR(100),
	@PP_TAX_POPULATION				VARCHAR(100),
	@PP_TAX_POSTAL_CODE				VARCHAR(100),
	@PP_TAX_MUNICIPALITY			VARCHAR(100),
	@PP_TAX_K_STATE					INT,
	-- ===========================
	@PP_OFFICE_STREET				VARCHAR(100),
	@PP_OFFICE_NUMBER_EXTERIOR		VARCHAR(100),
	@PP_OFFICE_NUMBER_INSIDE		VARCHAR(100),
	@PP_OFFICE_COLONY				VARCHAR(100),
	@PP_OFFICE_POPULATION			VARCHAR(100),
	@PP_OFFICE_POSTAL_CODE			VARCHAR(100),
	@PP_OFFICE_MUNICIPALITY			VARCHAR(100),
	@PP_OFFICE_K_STATE				INT,
	-- ===========================
	@PP_K_STATUS_VENDOR			INT,
	@PP_K_CATEGORY_VENDOR			INT,
	-- ============================
	@PP_CONTACT_SALES_NAME			VARCHAR(100),
	@PP_CONTACT_SALES_PHONE			VARCHAR(100),
	@PP_CONTACT_SALES_EMAIL			VARCHAR(100),
	-- ============================
	@PP_CONTACT_PAYMENT_NAME		VARCHAR(100),
	@PP_CONTACT_PAYMENT_PHONE		VARCHAR(100),
	@PP_CONTACT_PAYMENT_EMAIL		VARCHAR(100)
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
				[D_VENDOR]					= @PP_D_VENDOR,
				[C_VENDOR]					= @PP_C_VENDOR,
				[O_VENDOR]					= 10,
				-- ========================== -- ===========================
				[BUSINESS_NAME]					= @PP_BUSINESS_NAME,
				[RFC_VENDOR]					= @PP_RFC_VENDOR,
				[EMAIL]							= @PP_EMAIL,
				[PHONE]							= @PP_PHONE,
				[N_CREDIT_DAYS]					= @PP_N_CREDIT_DAYS,
				-- ========================== -- ===========================
				[TAX_STREET]					= @PP_TAX_STREET,
				[TAX_NUMBER_EXTERIOR]			= @PP_TAX_NUMBER_EXTERIOR,
				[TAX_NUMBER_INSIDE]				= @PP_TAX_NUMBER_INSIDE,
				[TAX_COLONY]					= @PP_TAX_COLONY,
				[TAX_POPULATION]				= @PP_TAX_POPULATION,
				[TAX_POSTAL_CODE]				= @PP_TAX_POSTAL_CODE,
				[TAX_MUNICIPALITY]				= @PP_TAX_MUNICIPALITY,
				[TAX_K_STATE]					= @PP_TAX_K_STATE,
				-- ========================== -- ===========================
				[OFFICE_STREET]					= @PP_TAX_STREET,
				[OFFICE_NUMBER_EXTERIOR]		= @PP_TAX_NUMBER_EXTERIOR,
				[OFFICE_NUMBER_INSIDE]			= @PP_TAX_NUMBER_INSIDE,
				[OFFICE_COLONY]					= @PP_TAX_COLONY,
				[OFFICE_POPULATION]				= @PP_TAX_POPULATION,
				[OFFICE_POSTAL_CODE]			= @PP_TAX_POSTAL_CODE,
				[OFFICE_MUNICIPALITY]			= @PP_TAX_MUNICIPALITY,
				[OFFICE_K_STATE]				= @PP_TAX_K_STATE,
				-- ========================== -- ===========================
				[K_STATUS_VENDOR]				= @PP_K_STATUS_VENDOR,
				[K_CATEGORY_VENDOR]			= @PP_K_CATEGORY_VENDOR,		
				-- ========================== -- ============================
				[CONTACT_SALES_NAME]			= @PP_CONTACT_SALES_NAME,
				[CONTACT_SALES_PHONE]			= @PP_CONTACT_SALES_PHONE,
				[CONTACT_SALES_EMAIL]			= @PP_CONTACT_SALES_EMAIL,
				-- ========================== -- ============================
				[CONTACT_PAYMENTS_NAME]			= @PP_CONTACT_PAYMENT_NAME,
				[CONTACT_PAYMENTS_PHONE]			= @PP_CONTACT_PAYMENT_PHONE,
				[CONTACT_PAYMENTS_EMAIL]			= @PP_CONTACT_PAYMENT_EMAIL,		
				-- ====================
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
