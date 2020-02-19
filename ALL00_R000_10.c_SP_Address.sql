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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_ADDRESS_GEO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_ADDRESS_GEO]
GO

-- EXECUTE [dbo].[PG_LI_ADDRESS_GEO] 0,139,'',-1,-1,-1
CREATE PROCEDURE [dbo].[PG_LI_ADDRESS_GEO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_BUSCAR						VARCHAR(200),
	@PP_K_STATE_GEO					INT
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
				ADDRESS_GEO.*,
				STATE_GEO.D_STATE_GEO,
				STATE_GEO.S_STATE_GEO,
				USUARIO AS D_USUARIO_CAMBIO
				-- =============================	
	FROM		ADDRESS_GEO, 
				STATUS_ADDRESS_GEO, CATEGORY_ADDRESS_GEO,
				[BD_GENERAL].DBO.STATE_GEO
				,DATA_02.DBO.users_pearl
				-- =============================
	WHERE		ADDRESS_GEO.K_STATE_GEO=STATE_GEO.K_STATE_GEO
	AND			ADDRESS_GEO.K_USUARIO_CAMBIO=DATA_02.DBO.users_pearl.codigo
				-- =============================
	AND			(	ADDRESS_GEO.K_ADDRESS_GEO=@VP_K_FOLIO
				OR	ADDRESS_GEO.D_ADDRESS_GEO_1					LIKE '%'+@PP_BUSCAR+'%'
				OR	ADDRESS_GEO.D_ADDRESS_GEO_2					LIKE '%'+@PP_BUSCAR+'%' 
				OR	ADDRESS_GEO.CITY							LIKE '%'+@PP_BUSCAR+'%'
				OR	ADDRESS_GEO.POSTAL_CODE						LIKE '%'+@PP_BUSCAR+'%' )
				-- =============================
	AND			( @PP_K_STATE_GEO =-1				OR	ADDRESS_GEO.K_STATE_GEO=@PP_K_STATE_GEO )
				-- =============================
	AND			ADDRESS_GEO.L_BORRADO<>1
	ORDER BY	D_ADDRESS_GEO_1,D_ADDRESS_GEO_2,POSTAL_CODE	DESC
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_ADDRESS_GEO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_ADDRESS_GEO]
GO

-- EXECUTE [dbo].[PG_SK_ADDRESS_GEO] 0,139,379
CREATE PROCEDURE [dbo].[PG_SK_ADDRESS_GEO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_ADDRESS_GEO					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT = 100
	
		IF @VP_MENSAJE<>''
			SET @VP_LI_N_REGISTROS = 0
			
	SELECT		TOP (@VP_LI_N_REGISTROS)
				ADDRESS_GEO.*,
				STATE_GEO.D_STATE_GEO,
				STATE_GEO.S_STATE_GEO,
				USUARIO AS D_USUARIO_CAMBIO
				-- =============================	
	FROM		ADDRESS_GEO, 
				STATUS_ADDRESS_GEO, CATEGORY_ADDRESS_GEO,
				[BD_GENERAL].DBO.STATE_GEO
				,DATA_02.DBO.users_pearl
				-- =============================
	WHERE		ADDRESS_GEO.K_STATE_GEO=STATE_GEO.K_STATE_GEO
	AND			ADDRESS_GEO.K_USUARIO_CAMBIO=DATA_02.DBO.users_pearl.codigo
		
	-- ////////////////////////////////////////////////////////////////////
GO



	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_ADDRESS_GEO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_ADDRESS_GEO]
GO

-- EXECUTE [dbo].[PG_IN_ADDRESS_GEO] 0, 139, 'TEST ADDRESS_GEO' , '' , 'TEST ADDRESS_GEO' , 'TEST200201IT' , 'TEST200201IT@TEST.ADDRESS_GEO' , '6660000000' , '30' , 'CALLE FISCAL' , '' , '' , 'COLONIA FISCAL' , 'POBLACION FISCAL' , '30000' , 'MUNICIPIO FISCAL' , 8 , 'CALLE OFICINA' , '' , '' , 'COLONIA OFICINA' , 'POBLACION OFICINA' , '32000' , 'MUNICIPIO OFICINA' , 8 , 1 , 0, 'CONTACTO VENTAS' , '' , 'CONTACTO@VENTAS' , 'CONTACTO PAGOS' , '' , 'CONTACTO@PAGOS'
CREATE PROCEDURE [dbo].[PG_IN_ADDRESS_GEO]
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================			
	@PP_D_ADDRESS_GEO_1				[VARCHAR](255),
	@PP_D_ADDRESS_GEO_2				[VARCHAR](255),
	@PP_C_ADDRESS_GEO				[VARCHAR](255),
	-- ============================
	@PP_CITY						[VARCHAR](100),
	@PP_POSTAL_CODE					[VARCHAR](10),
	@PP_NUMBER_EXTERIOR				[VARCHAR](100),
	@PP_NUMBER_INSIDE				[VARCHAR](100),
	-- ============================
	@PP_K_STATE_GEO					[INT]
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	DECLARE @VP_K_ADDRESS_GEO			INT = 0

		EXECUTE [BD_GENERAL].dbo.[PG_SK_CATALOGO_K_MAX_GET]		@PP_K_SISTEMA_EXE, 'COMPRAS',
																'ADDRESS_GEO', 'K_ADDRESS_GEO',
													@OU_K_TABLA_DISPONIBLE = @VP_K_ADDRESS_GEO	OUTPUT

		-- //////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		INSERT INTO ADDRESS_GEO
			(	[K_ADDRESS_GEO]		,			
				[D_ADDRESS_GEO_1]	,			[D_ADDRESS_GEO_2]	,			
				[C_ADDRESS_GEO]		,			[O_ADDRESS_GEO]		,
				-- =======================
				[CITY]				,			[POSTAL_CODE]		,
				[NUMBER_EXTERIOR]	,			[NUMBER_INSIDE]		,
				-- =======================
				[K_STATE_GEO]		,
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_ADDRESS_GEO	,
				@PP_D_ADDRESS_GEO_1	,			@PP_D_ADDRESS_GEO_2	,		
				@PP_C_ADDRESS_GEO	,			10	,			
				-- ============================
				@PP_CITY			,		@PP_POSTAL_CODE		,			
				@PP_NUMBER_EXTERIOR	,		@PP_NUMBER_INSIDE	,			
				-- ============================
				@PP_K_STATE_GEO		,
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Insert] at [ADDRESS_GEO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#ADDRESS_GEO.'+CONVERT(VARCHAR(10),@VP_K_ADDRESS_GEO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_ADDRESS_GEO AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_SK_ADDRESS_GEO] 0,139,379
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ADDRESS_GEO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_ADDRESS_GEO]
GO

CREATE PROCEDURE [dbo].[PG_UP_ADDRESS_GEO]
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_K_ADDRESS_GEO				[INT],			
	@PP_D_ADDRESS_GEO_1				[VARCHAR](255),
	@PP_D_ADDRESS_GEO_2				[VARCHAR](255),
	@PP_C_ADDRESS_GEO				[VARCHAR](255),
	@PP_O_ADDRESS_GEO				[INT],
	-- ============================
	@PP_CITY						[VARCHAR](100),
	@PP_POSTAL_CODE					[VARCHAR](10),
	@PP_NUMBER_EXTERIOR				[VARCHAR](100),
	@PP_NUMBER_INSIDE				[VARCHAR](100),
	-- ============================
	@PP_K_STATE_GEO					[INT]
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ADDRESS_GEO_UPDATE]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_ADDRESS_GEO, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
		
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	ADDRESS_GEO
		SET		
				[K_ADDRESS_GEO]				 = @PP_K_ADDRESS_GEO,				
				[D_ADDRESS_GEO_1]			 = @PP_D_ADDRESS_GEO_1,				
				[D_ADDRESS_GEO_2]			 = @PP_D_ADDRESS_GEO_2,				
				[C_ADDRESS_GEO]				 = @PP_C_ADDRESS_GEO,				
				[O_ADDRESS_GEO]				 = 10,				
				-- ========================= -- ============================
				[CITY]						 = @PP_CITY,						
				[POSTAL_CODE]				 = @PP_POSTAL_CODE,					
				[NUMBER_EXTERIOR]			 = @PP_NUMBER_EXTERIOR,				
				[NUMBER_INSIDE]				 = @PP_NUMBER_INSIDE,				
				-- ========================= -- ============================
				[K_STATE_GEO]				 = @PP_K_STATE_GEO,					
				-- ========================= -- ============================
				[F_CAMBIO]							= GETDATE(), 
				[K_USUARIO_CAMBIO]					= @PP_K_USUARIO_ACCION
		WHERE	K_ADDRESS_GEO=@PP_K_ADDRESS_GEO
	
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Update] at [ADDRESS_GEO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#ADDRESS_GEO.'+CONVERT(VARCHAR(10),@PP_K_ADDRESS_GEO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ADDRESS_GEO AS CLAVE
	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

--	EXECUTE [dbo].[PG_DL_ADDRESS_GEO] 0,139,379
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_ADDRESS_GEO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_ADDRESS_GEO]
GO

CREATE PROCEDURE [dbo].[PG_DL_ADDRESS_GEO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_ADDRESS_GEO					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ADDRESS_GEO_DELETE]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_ADDRESS_GEO, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	ADDRESS_GEO
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_ADDRESS_GEO=@PP_K_ADDRESS_GEO
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Delete] at [ADDRESS_GEO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#ADDRESS_GEO.'+CONVERT(VARCHAR(10),@PP_K_ADDRESS_GEO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ADDRESS_GEO AS CLAVE

	-- //////////////////////////////////////////////////////////////	
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
