-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		SETTINGS_GENERAL
-- // MODULE:			ALL
-- // OPERATION:		TABLA
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200213
-- ////////////////////////////////////////////////////////////// 

--USE [SETTINGS_GENERAL]
USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_CONTACT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_CONTACT]
GO

-- EXECUTE [dbo].[PG_LI_CONTACT] 0,139,'',-1,-1,-1
CREATE PROCEDURE [dbo].[PG_LI_CONTACT]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_BUSCAR						VARCHAR(200)
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
				CONTACT.*,
				USUARIO AS D_USUARIO_CAMBIO
				-- =============================	
	FROM		CONTACT, 
				DATA_02.DBO.users_pearl
				-- =============================
	WHERE		CONTACT.K_USUARIO_CAMBIO=DATA_02.DBO.users_pearl.codigo
				-- =============================
	AND			(	CONTACT.K_CONTACT=@VP_K_FOLIO
				OR	CONTACT.FIRST_NAME				LIKE '%'+@PP_BUSCAR+'%'
				OR	CONTACT.MIDDLE_NAME				LIKE '%'+@PP_BUSCAR+'%' 
				OR	CONTACT.LAST_NAME				LIKE '%'+@PP_BUSCAR+'%' )
				-- =============================
	AND			CONTACT.L_BORRADO<>1
	ORDER BY	MIDDLE_NAME,LAST_NAME,FIRST_NAME	DESC
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CONTACT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CONTACT]
GO

-- EXECUTE [dbo].[PG_SK_CONTACT] 0,139,379
CREATE PROCEDURE [dbo].[PG_SK_CONTACT]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_CONTACT					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT = 100
	
		IF @VP_MENSAJE<>''
			SET @VP_LI_N_REGISTROS = 0
			
	SELECT		TOP (@VP_LI_N_REGISTROS)
				CONTACT.*,
				USUARIO AS D_USUARIO_CAMBIO
				-- =============================	
	FROM		CONTACT, 
				DATA_02.DBO.users_pearl
				-- =============================
	WHERE		CONTACT.K_USUARIO_CAMBIO=DATA_02.DBO.users_pearl.codigo
				-- =====================
	AND			CONTACT.K_CONTACT=@PP_K_CONTACT
				-- =====================
		
	-- ////////////////////////////////////////////////////////////////////
GO



	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_CONTACT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_CONTACT]
GO

-- EXECUTE [dbo].[PG_IN_CONTACT] 0, 139, 'TEST CONTACT' , '' , 'TEST CONTACT' , 'TEST200201IT' , 'TEST200201IT@TEST.CONTACT' , '6660000000' , '30' , 'CALLE FISCAL' , '' , '' , 'COLONIA FISCAL' , 'POBLACION FISCAL' , '30000' , 'MUNICIPIO FISCAL' , 8 , 'CALLE OFICINA' , '' , '' , 'COLONIA OFICINA' , 'POBLACION OFICINA' , '32000' , 'MUNICIPIO OFICINA' , 8 , 1 , 0, 'CONTACTO VENTAS' , '' , 'CONTACTO@VENTAS' , 'CONTACTO PAGOS' , '' , 'CONTACTO@PAGOS'
CREATE PROCEDURE [dbo].[PG_IN_CONTACT]
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================			
	@PP_FIRST_NAME				[VARCHAR](255),
	@PP_MIDDLE_NAME				[VARCHAR](255),
	@PP_LAST_NAME				[VARCHAR](255),
	@PP_C_CONTACT				[VARCHAR](500),
	-- ============================
	@PP_EMAIL					[VARCHAR](100),
	@PP_PHONE					[VARCHAR](25) 
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	DECLARE @VP_K_CONTACT			INT = 0

		EXECUTE [DATA_02Pruebas].dbo.[PG_SK_CATALOGO_K_MAX_GET]		@PP_K_SISTEMA_EXE, 'COMPRAS',
																	'CONTACT', 'K_CONTACT',
													@OU_K_TABLA_DISPONIBLE = @VP_K_CONTACT	OUTPUT

		-- //////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		INSERT INTO CONTACT
			(	[K_CONTACT]		,		
				[FIRST_NAME]	,				[MIDDLE_NAME]	,		
				[LAST_NAME]		,				[C_CONTACT]		,		
				-- ======================
				[EMAIL]			,				[PHONE]			,
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_CONTACT	,
				@PP_FIRST_NAME	,			@PP_MIDDLE_NAME	,			
				@PP_LAST_NAME	,			@PP_C_CONTACT	,			
				-- ==========================
				@PP_EMAIL		,			@PP_PHONE		,			
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Insert] at [CONTACT]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CONTACT.'+CONVERT(VARCHAR(10),@VP_K_CONTACT)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_CONTACT AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_SK_CONTACT] 0,139,379
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_CONTACT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_CONTACT]
GO

CREATE PROCEDURE [dbo].[PG_UP_CONTACT]
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_K_CONTACT				[INT],			
	@PP_FIRST_NAME				[VARCHAR](255),
	@PP_MIDDLE_NAME				[VARCHAR](255),
	@PP_LAST_NAME				[VARCHAR](255),
	@PP_C_CONTACT				[VARCHAR](500),
	-- ============================
	@PP_EMAIL					[VARCHAR](100),
	@PP_PHONE					[VARCHAR](25) 
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CONTACT_UPDATE]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_CONTACT, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
		
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	CONTACT
		SET		
				[K_CONTACT]				 = @PP_K_CONTACT,				
				[FIRST_NAME]			 = @PP_FIRST_NAME,				
				[MIDDLE_NAME]			 = @PP_MIDDLE_NAME,				
				[LAST_NAME]				 = @PP_LAST_NAME,				
				[C_CONTACT]				 = @PP_C_CONTACT,				
				-- ===================== = -- =========================
				[EMAIL]					 = @PP_EMAIL,					
				[PHONE]					 = @PP_PHONE,									
				-- ========================= -- ============================
				[F_CAMBIO]							= GETDATE(), 
				[K_USUARIO_CAMBIO]					= @PP_K_USUARIO_ACCION
		WHERE	K_CONTACT=@PP_K_CONTACT
	
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Update] at [CONTACT]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CONTACT.'+CONVERT(VARCHAR(10),@PP_K_CONTACT)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CONTACT AS CLAVE
	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

--	EXECUTE [dbo].[PG_DL_CONTACT] 0,139,379
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_CONTACT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_CONTACT]
GO

CREATE PROCEDURE [dbo].[PG_DL_CONTACT]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_CONTACT					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CONTACT_DELETE]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_CONTACT, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	CONTACT
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_CONTACT=@PP_K_CONTACT
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Delete] at [CONTACT]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CONTACT.'+CONVERT(VARCHAR(10),@PP_K_CONTACT)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CONTACT AS CLAVE

	-- //////////////////////////////////////////////////////////////	
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
