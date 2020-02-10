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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PROVIDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PROVIDER]
GO


CREATE PROCEDURE [dbo].[PG_LI_PROVIDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_BUSCAR						VARCHAR(200),
	@PP_K_ESTATUS_PROVIDER			INT,
	@PP_K_CATEGORIA_PROVIDER		INT,
	@PP_FISCAL_K_ESTADO				INT,
	@PP_OFICINA_K_ESTADO			INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1
		
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															@VP_L_APLICAR_MAX_ROWS,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- =========================================	
	
	DECLARE @VP_K_FOLIO				INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]				@PP_BUSCAR, 
																@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
		
	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	SELECT		TOP (@VP_LI_N_REGISTROS)
				PROVIDER.*,
				ESTATUS_PROVIDER.D_ESTATUS_PROVIDER, CATEGORIA_PROVIDER.D_CATEGORIA_PROVIDER, ESTADO.D_ESTADO,
				ESTATUS_PROVIDER.S_ESTATUS_PROVIDER, CATEGORIA_PROVIDER.S_CATEGORIA_PROVIDER, ESTADO.S_ESTADO,
				D_USUARIO AS D_USUARIO_CAMBIO
				-- =============================	
	FROM		PROVIDER, 
				ESTATUS_PROVIDER, CATEGORIA_PROVIDER,
				ESTADO,
				USUARIO
				-- =============================
	WHERE		PROVIDER.K_ESTATUS_PROVIDER=ESTATUS_PROVIDER.K_ESTATUS_PROVIDER
	AND			PROVIDER.K_CATEGORIA_PROVIDER=CATEGORIA_PROVIDERK_CATEGORIA_PROVIDER
	AND			(	PROVIDER.FISCAL_K_ESTADO = ESTADO.K_ESTADO
				OR	PROVIDER.OFICINA_K_ESTADO = ESTADO.K_ESTADO )
	AND			PROVIDER.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
				-- =============================
	AND			(	PROVIDER.K_PROVIDER=@VP_K_FOLIO
				OR	PROVIDER.RAZON_SOCIAL					LIKE '%'+@PP_BUSCAR+'%'
				OR	PROVIDER.D_PROVIDER					LIKE '%'+@PP_BUSCAR+'%' 
				OR	PROVIDER.RFC_PROVIDER				LIKE '%'+@PP_BUSCAR+'%'
				OR	PROVIDER.C_PROVIDER					LIKE '%'+@PP_BUSCAR+'%' )
				-- =============================
	AND			( @PP_FISCAL_K_ESTADO =-1			OR	PROVIDER.FISCAL_K_ESTADO=@PP_FISCAL_K_ESTADO )
	AND			( @PP_OFICINA_K_ESTADO =-1			OR	PROVIDER.OFICINA_K_ESTADO=@PP_OFICINA_K_ESTADO )
	AND			( @PP_K_ESTATUS_PROVIDER	=-1		OR	PROVIDER.K_ESTATUS_PROVIDER=@PP_K_ESTATUS_PROVIDER )
	AND			( @PP_K_CATEGORIA_PROVIDER =-1		OR	PROVIDER.K_CATEGORIA_PROVIDER=@PP_K_CATEGORIA_PROVIDER )
				-- =============================
	ORDER BY	K_PROVIDER	DESC
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_PROVIDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_PROVIDER]
GO


CREATE PROCEDURE [dbo].[PG_SK_PROVIDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PROVIDER					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT = 100
	
		IF @VP_MENSAJE<>''
			SET @VP_LI_N_REGISTROS = 0
			
		SELECT	TOP (@VP_LI_N_REGISTROS)
				PROVIDER.*,
				ESTATUS_PROVIDER.D_ESTATUS_PROVIDER, CATEGORIA_PROVIDERD_CATEGORIA_PROVIDER,
				ESTADO.D_ESTADO,
				D_USUARIO AS D_USUARIO_CAMBIO
				-- =====================
		FROM	PROVIDER, 
				ESTATUS_PROVIDER, CATEGORIA_PROVIDER,
				ESTADO,
				USUARIO
				-- =====================
		WHERE	PROVIDER.K_ESTATUS_PROVIDER = ESTATUS_PROVIDER.K_ESTATUS_PROVIDER
		AND		PROVIDER.K_CATEGORIA_PROVIDER = CATEGORIA_PROVIDERK_CATEGORIA_PROVIDER
		AND		PROVIDER.FISCAL_K_ESTADO = ESTADO.K_ESTADO
		AND		PROVIDER.OFICINA_K_ESTADO = ESTADO.K_ESTADO
		AND		PROVIDER.K_PROVIDER=@PP_K_PROVIDER
		
	-- ////////////////////////////////////////////////////////////////////
GO



	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PROVIDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PROVIDER]
GO


CREATE PROCEDURE [dbo].[PG_IN_PROVIDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_D_PROVIDER					VARCHAR(100),
	@PP_C_PROVIDER					VARCHAR(255),
	@PP_S_PROVIDER					VARCHAR(10),
	-- ===========================
	@PP_RAZON_SOCIAL				VARCHAR(100),
	@PP_RFC_PROVIDER				VARCHAR(13),
	@PP_CURP						VARCHAR(100),
	@PP_CORREO						VARCHAR(100),
	@PP_TELEFONO					VARCHAR(100),
	@PP_N_DIAS_CREDITO				INT,
	-- ===========================
	@PP_FISCAL_CALLE				VARCHAR(100),
	@PP_FISCAL_NUMERO_EXTERIOR		VARCHAR(100),
	@PP_FISCAL_NUMERO_INTERIOR		VARCHAR(100),
	@PP_FISCAL_COLONIA				VARCHAR(100),
	@PP_FISCAL_POBLACION			VARCHAR(100),
	@PP_FISCAL_CP					VARCHAR(100),
	@PP_FISCAL_MUNICIPIO			VARCHAR(100),
	@PP_FISCAL_K_ESTADO				INT,
	-- ===========================
	@PP_OFICINA_CALLE				VARCHAR(100),
	@PP_OFICINA_NUMERO_EXTERIOR		VARCHAR(100),
	@PP_OFICINA_NUMERO_INTERIOR		VARCHAR(100),
	@PP_OFICINA_COLONIA				VARCHAR(100),
	@PP_OFICINA_POBLACION			VARCHAR(100),
	@PP_OFICINA_CP					VARCHAR(100),
	@PP_OFICINA_MUNICIPIO			VARCHAR(100),
	@PP_OFICINA_K_ESTADO			INT,
	-- ===========================
	@PP_K_ESTATUS_PROVIDER			INT,
	@PP_K_CATEGORIA_PROVIDER		INT,
	-- ============================
	@PP_CONTACTO_VENTA				VARCHAR(100),
	@PP_CONTACTO_VENTA_TELEFONO		VARCHAR(100),
	@PP_CONTACTO_VENTA_CORREO		VARCHAR(100),
	-- ============================
	@PP_CONTACTO_PAGO				VARCHAR(100),
	@PP_CONTACTO_PAGO_TELEFONO		VARCHAR(100),
	@PP_CONTACTO_PAGO_CORREO		VARCHAR(100)
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	DECLARE @VP_K_PROVIDER			INT = 0

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'PROVIDER', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_PROVIDER	OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVIDER_UNIQUE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@VP_K_PROVIDER, 
													@PP_D_PROVIDER, @PP_RFC_PROVIDER,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
		-- //////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		INSERT INTO PROVIDER
			(	[K_PROVIDER], [D_PROVIDER], 
				[C_PROVIDER], [S_PROVIDER], 
				[O_PROVIDER],
				-- ===========================
				[RAZON_SOCIAL],	[RFC_PROVIDER], 
				[CURP],	[CORREO], [TELEFONO], 
				[N_DIAS_CREDITO],
				-- ===========================
				[FISCAL_CALLE], [FISCAL_NUMERO_EXTERIOR], [FISCAL_NUMERO_INTERIOR], 
				[FISCAL_COLONIA], [FISCAL_POBLACION],
				[FISCAL_CP],[FISCAL_MUNICIPIO], [FISCAL_K_ESTADO], 
				-- ===========================
				[OFICINA_CALLE], [OFICINA_NUMERO_EXTERIOR], [OFICINA_NUMERO_INTERIOR], 
				[OFICINA_COLONIA], [OFICINA_POBLACION],
				[OFICINA_CP],[OFICINA_MUNICIPIO], [OFICINA_K_ESTADO], 
				-- ===========================

				[K_ESTATUS_PROVIDER],[K_CATEGORIA_PROVIDER],
				-- ===========================
				[CONTACTO_VENTA],[CONTACTO_VENTA_TELEFONO],[CONTACTO_VENTA_CORREO],
				-- ===========================
				[CONTACTO_PAGO],[CONTACTO_PAGO_TELEFONO],[CONTACTO_PAGO_CORREO],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_PROVIDER, @PP_D_PROVIDER, 
				@PP_C_PROVIDER, @PP_S_PROVIDER,
				10,
				-- ===========================
				@PP_RAZON_SOCIAL, @PP_RFC_PROVIDER, 
				@PP_CURP, @PP_CORREO, @PP_TELEFONO,
				@PP_N_DIAS_CREDITO,
				-- ===========================
				@PP_FISCAL_CALLE, @PP_FISCAL_NUMERO_EXTERIOR, @PP_FISCAL_NUMERO_INTERIOR,
				@PP_FISCAL_COLONIA, @PP_FISCAL_POBLACION,
				@PP_FISCAL_CP, @PP_FISCAL_MUNICIPIO, @PP_FISCAL_K_ESTADO, 
				-- ===========================
				@PP_OFICINA_CALLE, @PP_OFICINA_NUMERO_EXTERIOR, @PP_OFICINA_NUMERO_INTERIOR,
				@PP_OFICINA_COLONIA, @PP_OFICINA_POBLACION,
				@PP_OFICINA_CP, @PP_OFICINA_MUNICIPIO, @PP_OFICINA_K_ESTADO, 
				-- ===========================
				@PP_K_ESTATUS_PROVIDER, @PP_K_CATEGORIA_PROVIDER,
				-- ============================
				@PP_CONTACTO_VENTA, @PP_CONTACTO_VENTA_TELEFONO,
				@PP_CONTACTO_VENTA_CORREO,
				-- ============================
				@PP_CONTACTO_PAGO, @PP_CONTACTO_PAGO_TELEFONO,
				@PP_CONTACTO_PAGO_CORREO,		
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Insert] at [PROVIDER]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PROVIDER.'+CONVERT(VARCHAR(10),@VP_K_PROVIDER)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PROVIDER AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PROVIDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PROVIDER]
GO

CREATE PROCEDURE [dbo].[PG_UP_PROVIDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PROVIDER					INT,
	@PP_D_PROVIDER					VARCHAR(100),
	@PP_C_PROVIDER					VARCHAR(255),
	@PP_S_PROVIDER					VARCHAR(10),
	-- ===========================
	@PP_RAZON_SOCIAL				VARCHAR(100),
	@PP_RFC_PROVIDER				VARCHAR(13),
	@PP_CURP						VARCHAR(100),
	@PP_CORREO						VARCHAR(100),
	@PP_TELEFONO					VARCHAR(100),
	@PP_N_DIAS_CREDITO				INT,
	-- ===========================
	@PP_FISCAL_CALLE				VARCHAR(100),
	@PP_FISCAL_NUMERO_EXTERIOR		VARCHAR(100),
	@PP_FISCAL_NUMERO_INTERIOR		VARCHAR(100),
	@PP_FISCAL_COLONIA				VARCHAR(100),
	@PP_FISCAL_POBLACION			VARCHAR(100),
	@PP_FISCAL_CP					VARCHAR(100),
	@PP_FISCAL_MUNICIPIO			VARCHAR(100),
	@PP_FISCAL_K_ESTADO				INT,
	-- ===========================
	@PP_OFICINA_CALLE				VARCHAR(100),
	@PP_OFICINA_NUMERO_EXTERIOR		VARCHAR(100),
	@PP_OFICINA_NUMERO_INTERIOR		VARCHAR(100),
	@PP_OFICINA_COLONIA				VARCHAR(100),
	@PP_OFICINA_POBLACION			VARCHAR(100),
	@PP_OFICINA_CP					VARCHAR(100),
	@PP_OFICINA_MUNICIPIO			VARCHAR(100),
	@PP_OFICINA_K_ESTADO			INT,
	-- ===========================
	@PP_K_ESTATUS_PROVIDER			INT,
	@PP_K_CATEGORIA_PROVIDER		INT,
	-- ============================
	@PP_CONTACTO_VENTA				VARCHAR(100),
	@PP_CONTACTO_VENTA_TELEFONO		VARCHAR(100),
	@PP_CONTACTO_VENTA_CORREO		VARCHAR(100),
	-- ============================
	@PP_CONTACTO_PAGO				VARCHAR(100),
	@PP_CONTACTO_PAGO_TELEFONO		VARCHAR(100),
	@PP_CONTACTO_PAGO_CORREO		VARCHAR(100)
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVIDER_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_PROVIDER, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVIDER_UNIQUE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_PROVIDER, 
													@PP_D_PROVIDER, @PP_RFC_PROVIDER,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	PROVIDER
		SET		
				[D_PROVIDER]						= @PP_D_PROVIDER,
				[C_PROVIDER]						= @PP_C_PROVIDER,
				[S_PROVIDER]						= @PP_S_PROVIDER,
				[O_PROVIDER]						= 10,
				-- ========================== -- ===========================
				[RAZON_SOCIAL]						= @PP_RAZON_SOCIAL,
				[RFC_PROVIDER]						= @PP_RFC_PROVIDER,				
				[CURP]								= @PP_CURP,
				[CORREO]							= @PP_CORREO,
				[TELEFONO]							= @PP_TELEFONO,
				[N_DIAS_CREDITO]					= [N_DIAS_CREDITO],
				-- ========================== -- ===========================
				[FISCAL_CALLE]						= @PP_FISCAL_CALLE,
				[FISCAL_NUMERO_EXTERIOR]			= @PP_FISCAL_NUMERO_EXTERIOR,
				[FISCAL_NUMERO_INTERIOR]			= @PP_FISCAL_NUMERO_INTERIOR,
				[FISCAL_COLONIA]					= @PP_FISCAL_COLONIA,
				[FISCAL_POBLACION]					= @PP_FISCAL_POBLACION,
				[FISCAL_CP]							= @PP_FISCAL_CP,
				[FISCAL_MUNICIPIO]					= @PP_FISCAL_MUNICIPIO,
				[FISCAL_K_ESTADO]					= @PP_FISCAL_K_ESTADO,
				-- ========================== -- ===========================
				[OFICINA_CALLE]						= @PP_FISCAL_CALLE,
				[OFICINA_NUMERO_EXTERIOR]			= @PP_FISCAL_NUMERO_EXTERIOR,
				[OFICINA_NUMERO_INTERIOR]			= @PP_FISCAL_NUMERO_INTERIOR,
				[OFICINA_COLONIA]					= @PP_FISCAL_COLONIA,
				[OFICINA_POBLACION]					= @PP_FISCAL_POBLACION,
				[OFICINA_CP]						= @PP_FISCAL_CP,
				[OFICINA_MUNICIPIO]					= @PP_FISCAL_MUNICIPIO,
				[OFICINA_K_ESTADO]					= @PP_FISCAL_K_ESTADO,
				-- ========================== -- ===========================
				[K_ESTATUS_PROVIDER]				= @PP_K_ESTATUS_PROVIDER,
				[K_CATEGORIA_PROVIDER]				= @PP_K_CATEGORIA_PROVIDER,		
				-- ========================== -- ============================
				[CONTACTO_VENTA]					= @PP_CONTACTO_VENTA,
				[CONTACTO_VENTA_TELEFONO]			= @PP_CONTACTO_VENTA_TELEFONO,
				[CONTACTO_VENTA_CORREO]				= @PP_CONTACTO_VENTA_CORREO,
				-- ========================== -- ============================
				[CONTACTO_PAGO]						= @PP_CONTACTO_PAGO,
				[CONTACTO_PAGO_TELEFONO]			= @PP_CONTACTO_PAGO_TELEFONO,
				[CONTACTO_PAGO_CORREO]				= @PP_CONTACTO_PAGO_CORREO,		
				-- ====================
				[F_CAMBIO]							= GETDATE(), 
				[K_USUARIO_CAMBIO]					= @PP_K_USUARIO_ACCION
		WHERE	K_PROVIDER=@PP_K_PROVIDER
	
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Update] at [PROVIDER]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PROVIDER.'+CONVERT(VARCHAR(10),@PP_K_PROVIDER)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PROVIDER AS CLAVE
	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_PROVIDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_PROVIDER]
GO


CREATE PROCEDURE [dbo].[PG_DL_PROVIDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PROVIDER					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVIDER_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_PROVIDER, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	PROVIDER
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_PROVIDER=@PP_K_PROVIDER
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'Not is possible [Delete] at [PROVIDER]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PROVIDER.'+CONVERT(VARCHAR(10),@PP_K_PROVIDER)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PROVIDER AS CLAVE

	-- //////////////////////////////////////////////////////////////	
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
