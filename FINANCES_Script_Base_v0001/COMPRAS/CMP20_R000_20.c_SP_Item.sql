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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_SUPPLIER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_SUPPLIER]
GO

-- EXECUTE [dbo].[PG_LI_SUPPLIER] 0,139,'',-1,-1,-1
CREATE PROCEDURE [dbo].[PG_LI_SUPPLIER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_BUSCAR						VARCHAR(200),
	@PP_K_STATUS_SUPPLIER			INT,
	@PP_K_CATEGORY_SUPPLIER			INT,
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
				SUPPLIER.*,
				STATUS_SUPPLIER.D_STATUS_SUPPLIER, CATEGORY_SUPPLIER.D_CATEGORY_SUPPLIER, STATE_GEO.D_STATE_GEO,
				STATUS_SUPPLIER.S_STATUS_SUPPLIER, CATEGORY_SUPPLIER.S_CATEGORY_SUPPLIER, STATE_GEO.S_STATE_GEO
				--,D_USUARIO AS D_USUARIO_CAMBIO
				-- =============================	
	FROM		SUPPLIER, 
				STATUS_SUPPLIER, CATEGORY_SUPPLIER,
				COT19_Cotizaciones_V9999_R0.DBO.STATE_GEO
				--,USUARIO
				-- =============================
	WHERE		SUPPLIER.K_STATUS_SUPPLIER=STATUS_SUPPLIER.K_STATUS_SUPPLIER
	AND			SUPPLIER.K_CATEGORY_SUPPLIER=CATEGORY_SUPPLIER.K_CATEGORY_SUPPLIER
	AND			(	SUPPLIER.TAX_K_STATE = STATE_GEO.K_STATE_GEO
				OR	SUPPLIER.OFFICE_K_STATE = STATE_GEO.K_STATE_GEO )
--	AND			SUPPLIER.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
				-- =============================
	AND			(	SUPPLIER.K_SUPPLIER=@VP_K_FOLIO
				OR	SUPPLIER.BUSINESS_NAME					LIKE '%'+@PP_BUSCAR+'%'
				OR	SUPPLIER.D_SUPPLIER					LIKE '%'+@PP_BUSCAR+'%' 
				OR	SUPPLIER.RFC_SUPPLIER				LIKE '%'+@PP_BUSCAR+'%'
				OR	SUPPLIER.C_SUPPLIER					LIKE '%'+@PP_BUSCAR+'%' )
				-- =============================
	AND			( @PP_K_STATE =-1				OR	SUPPLIER.TAX_K_STATE=@PP_K_STATE )
	AND			( @PP_K_STATE =-1				OR	SUPPLIER.OFFICE_K_STATE=@PP_K_STATE )
	AND			( @PP_K_STATUS_SUPPLIER	=-1		OR	SUPPLIER.K_STATUS_SUPPLIER=@PP_K_STATUS_SUPPLIER )
	AND			( @PP_K_CATEGORY_SUPPLIER =-1		OR	SUPPLIER.K_CATEGORY_SUPPLIER=@PP_K_CATEGORY_SUPPLIER )
				-- =============================
	AND			SUPPLIER.L_BORRADO<>1
	ORDER BY	D_SUPPLIER,K_CATEGORY_SUPPLIER	DESC
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_SUPPLIER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_SUPPLIER]
GO

-- EXECUTE [dbo].[PG_SK_SUPPLIER] 0,139,379
CREATE PROCEDURE [dbo].[PG_SK_SUPPLIER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_SUPPLIER					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT = 100
	
		IF @VP_MENSAJE<>''
			SET @VP_LI_N_REGISTROS = 0
			
		SELECT	TOP (@VP_LI_N_REGISTROS)
				SUPPLIER.*,
				STATUS_SUPPLIER.D_STATUS_SUPPLIER, CATEGORY_SUPPLIER.D_CATEGORY_SUPPLIER,
				STATE_GEO.D_STATE_GEO
				--,D_USUARIO AS D_USUARIO_CAMBIO
				-- =====================
		FROM	SUPPLIER, 
				STATUS_SUPPLIER, CATEGORY_SUPPLIER,
				COT19_Cotizaciones_V9999_R0.DBO.STATE_GEO
				--,USUARIO
				-- =====================
		WHERE	SUPPLIER.K_STATUS_SUPPLIER = STATUS_SUPPLIER.K_STATUS_SUPPLIER
		AND		SUPPLIER.K_CATEGORY_SUPPLIER = CATEGORY_SUPPLIER.K_CATEGORY_SUPPLIER
		AND		SUPPLIER.TAX_K_STATE = STATE_GEO.K_STATE_GEO
		AND		SUPPLIER.OFFICE_K_STATE = STATE_GEO.K_STATE_GEO
		AND		SUPPLIER.K_SUPPLIER=@PP_K_SUPPLIER
		
	-- ////////////////////////////////////////////////////////////////////
GO



	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_SUPPLIER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_SUPPLIER]
GO

-- EXECUTE [dbo].[PG_IN_SUPPLIER] 0, 139, 'TEST SUPPLIER' , '' , 'TEST SUPPLIER' , 'TEST200201IT' , 'TEST200201IT@TEST.SUPPLIER' , '6660000000' , '30' , 'CALLE FISCAL' , '' , '' , 'COLONIA FISCAL' , 'POBLACION FISCAL' , '30000' , 'MUNICIPIO FISCAL' , 8 , 'CALLE OFICINA' , '' , '' , 'COLONIA OFICINA' , 'POBLACION OFICINA' , '32000' , 'MUNICIPIO OFICINA' , 8 , 1 , 0, 'CONTACTO VENTAS' , '' , 'CONTACTO@VENTAS' , 'CONTACTO PAGOS' , '' , 'CONTACTO@PAGOS'
CREATE PROCEDURE [dbo].[PG_IN_SUPPLIER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_D_SUPPLIER					VARCHAR(100),
	@PP_C_SUPPLIER					VARCHAR(255),
	-- ===========================
	@PP_BUSINESS_NAME				VARCHAR(250),
	@PP_RFC_SUPPLIER				VARCHAR(13),
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
	@PP_K_STATUS_SUPPLIER			INT,
	@PP_K_CATEGORY_SUPPLIER			INT,
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
	DECLARE @VP_K_SUPPLIER			INT = 0

		EXECUTE [DATA_02Pruebas].dbo.[PG_SK_CATALOGO_K_MAX_GET]		@PP_K_SISTEMA_EXE, 'COMPRAS',
																	'SUPPLIER', 'K_SUPPLIER',
													@OU_K_TABLA_DISPONIBLE = @VP_K_SUPPLIER	OUTPUT

	
	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_SUPPLIER_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@VP_K_SUPPLIER, 
													@PP_D_SUPPLIER, @PP_RFC_SUPPLIER,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
		-- //////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		INSERT INTO SUPPLIER
			(	[K_SUPPLIER], [D_SUPPLIER], 
				[C_SUPPLIER], [O_SUPPLIER],
				-- ===========================
				[BUSINESS_NAME], [RFC_SUPPLIER], 
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

				[K_STATUS_SUPPLIER],[K_CATEGORY_SUPPLIER],
				-- ===========================
				[CONTACT_SALES_NAME],[CONTACT_SALES_PHONE],[CONTACT_SALES_EMAIL],
				-- ===========================
				[CONTACT_PAYMENTS_NAME],[CONTACT_PAYMENTS_PHONE],[CONTACT_PAYMENTS_EMAIL],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_SUPPLIER, @PP_D_SUPPLIER, 
				@PP_C_SUPPLIER, 10,
				-- ===========================
				@PP_BUSINESS_NAME, @PP_RFC_SUPPLIER, 
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
				@PP_K_STATUS_SUPPLIER, @PP_K_CATEGORY_SUPPLIER,
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
		
		SET		@VP_MENSAJE = 'Not is possible [Insert] at [SUPPLIER]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#SUPPLIER.'+CONVERT(VARCHAR(10),@VP_K_SUPPLIER)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_SUPPLIER AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_SK_SUPPLIER] 0,139,379
-- EXECUTE [dbo].[PG_UP_SUPPLIER] 0, 139, 379,'TEST SUPPLIER' , 'FOR TEST' , 'TEST SUPPLIER' , 'TEST200201IT' , 'TEST200201IT@TEST.SUPPLIER' , '6660000000' , '30' , 'CALLE FISCAL' , '' , '' , 'COLONIA FISCAL' , 'POBLACION FISCAL' , '30000' , 'MUNICIPIO FISCAL' , 8 , 'CALLE OFICINA' , '' , '' , 'COLONIA OFICINA' , 'POBLACION OFICINA' , '32000' , 'MUNICIPIO OFICINA' , 8 , 1 , 0, 'CONTACTO VENTAS' , '' , 'CONTACTO@VENTAS' , 'CONTACTO PAGOS' , '' , 'CONTACTO@PAGOS'
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_SUPPLIER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_SUPPLIER]
GO

CREATE PROCEDURE [dbo].[PG_UP_SUPPLIER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_SUPPLIER					INT,
	@PP_D_SUPPLIER					VARCHAR(100),
	@PP_C_SUPPLIER					VARCHAR(255),
	-- ===========================
	@PP_BUSINESS_NAME				VARCHAR(250),
	@PP_RFC_SUPPLIER				VARCHAR(13),
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
	@PP_K_STATUS_SUPPLIER			INT,
	@PP_K_CATEGORY_SUPPLIER			INT,
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
		EXECUTE [dbo].[PG_RN_SUPPLIER_UPDATE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_SUPPLIER, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_SUPPLIER_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_SUPPLIER, 
													@PP_D_SUPPLIER, @PP_RFC_SUPPLIER,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	SUPPLIER
		SET		
				[D_SUPPLIER]					= @PP_D_SUPPLIER,
				[C_SUPPLIER]					= @PP_C_SUPPLIER,
				[O_SUPPLIER]					= 10,
				-- ========================== -- ===========================
				[BUSINESS_NAME]					= @PP_BUSINESS_NAME,
				[RFC_SUPPLIER]					= @PP_RFC_SUPPLIER,
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
				[K_STATUS_SUPPLIER]				= @PP_K_STATUS_SUPPLIER,
				[K_CATEGORY_SUPPLIER]			= @PP_K_CATEGORY_SUPPLIER,		
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
		WHERE	K_SUPPLIER=@PP_K_SUPPLIER
	
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Update] at [SUPPLIER]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#SUPPLIER.'+CONVERT(VARCHAR(10),@PP_K_SUPPLIER)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_SUPPLIER AS CLAVE
	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

--	EXECUTE [dbo].[PG_DL_SUPPLIER] 0,139,379
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_SUPPLIER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_SUPPLIER]
GO

CREATE PROCEDURE [dbo].[PG_DL_SUPPLIER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_SUPPLIER					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_SUPPLIER_DELETE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_SUPPLIER, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	SUPPLIER
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_SUPPLIER=@PP_K_SUPPLIER
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Delete] at [SUPPLIER]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#SUPPLIER.'+CONVERT(VARCHAR(10),@PP_K_SUPPLIER)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_SUPPLIER AS CLAVE

	-- //////////////////////////////////////////////////////////////	
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
