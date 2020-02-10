-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			COMPRAS
-- // OPERATION:		REGLAS DE NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200206
-- ////////////////////////////////////////////////////////////// 

USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_UNIQUE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVIDER_UNIQUE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVIDER_UNIQUE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVIDER_UNIQUE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVIDER						[INT],	
	@PP_D_PROVIDER						[VARCHAR] (100),
	@PP_RFC_PROVIDER					[VARCHAR] (100),
		-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		BEGIN
	
		DECLARE @VP_N_PROVIDER_X_D_PROVIDER		INT
		
		SELECT	@VP_N_PROVIDER_X_D_PROVIDER =		COUNT	(PROVIDER.K_PROVIDER)
													FROM	PROVIDER
													WHERE	PROVIDER.K_PROVIDER<>@PP_K_PROVIDER
													AND		PROVIDER.D_PROVIDER=@PP_D_PROVIDER										
		-- =============================

		IF @VP_RESULTADO=''
			IF @VP_N_PROVIDER_X_D_PROVIDER>0
				SET @VP_RESULTADO =  'There are already [PROVIDERS] with that Description ['+@PP_D_PROVIDER+'].' 
		END	
		
	-- ///////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		BEGIN
	
		DECLARE @VP_N_PROVIDER_X_RFC_PROVIDER		INT = 0

		IF @PP_RFC_PROVIDER=''			-- SOLAMENTE APLICA LA VALIDACION CUANDO EL RFC_PROVIDER NO VIENE VACIO 
			SET		@VP_N_PROVIDER_X_RFC_PROVIDER =		0
		ELSE
			SELECT	@VP_N_PROVIDER_X_RFC_PROVIDER =		COUNT	(PROVIDER.K_PROVIDER)
												FROM	PROVIDER
												WHERE	PROVIDER.K_PROVIDER<>@PP_K_PROVIDER
												AND		PROVIDER.RFC_PROVIDER=@PP_RFC_PROVIDER	
												AND		@PP_RFC_PROVIDER<>''				
		-- =============================

		IF @VP_RESULTADO=''
			IF @VP_N_PROVIDER_X_RFC_PROVIDER>0
				SET @VP_RESULTADO =  'There are already [PROVIDERS] with that RFC ['+@PP_RFC_PROVIDER+'].' 
		END	
		
	-- ///////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //UNI//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_BORRABLE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVIDER_ITS_DELETEABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVIDER_ITS_DELETEABLE]
GO

CREATE PROCEDURE [dbo].[PG_RN_PROVIDER_ITS_DELETEABLE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVIDER						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
-- /////////////////////////////////////////////////////

	DECLARE @VP_N_FACTURA_X_PROVIDER		INT = 0
/*
	-- ADR: FALTA AGREGAR EL CODIGO QUE VALIDE ESTE CASO.
	SELECT	@VP_N_FACTURA_X_PROVIDER =		COUNT	(PROVIDER.K_PROVIDER)
											FROM	PROVIDER,FACTURA
											WHERE	PLANTA.K_PROVIDER=PROVIDER.K_PROVIDER	
											AND		PROVIDER.K_PROVIDER=@PP_K_PROVIDER										
*/
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_N_FACTURA_X_PROVIDER>0
			SET @VP_RESULTADO =  'There are [INVOICE] assigned.' 
		
	-- /////////////////////////////////////////////////////

	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EXISTS
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVIDER_EXISTS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVIDER_EXISTS]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVIDER_EXISTS]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVIDER						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_PROVIDER			INT
	DECLARE @VP_L_BORRADO			INT
		
	SELECT	@VP_K_PROVIDER =		PROVIDER.K_PROVIDER,
			@VP_L_BORRADO	=		PROVIDER.L_BORRADO
									FROM	PROVIDER
									WHERE	PROVIDER.K_PROVIDER=@PP_K_PROVIDER										
	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_PROVIDER IS NULL )
			SET @VP_RESULTADO =  'The [PROVIDER] does not exist.' 
	
	-- ===========================

	IF @VP_RESULTADO=''
		IF @VP_L_BORRADO=1
			SET @VP_RESULTADO =  'The [PROVIDER] was down.' 
					
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVIDER_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVIDER_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVIDER_DELETE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVIDER						[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PROVIDER_EXISTS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PROVIDER,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PROVIDER_ITS_DELETEABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PROVIDER,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //DEL//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVIDER_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVIDER_INSERT]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVIDER_INSERT]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVIDER						[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PROVIDER_EXISTS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_PROVIDER,	 
												@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	-- ///////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //INS//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_UPDATE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVIDER_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVIDER_UPDATE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVIDER_UPDATE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVIDER						[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PROVIDER_EXISTS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_PROVIDER,	 
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //UPD//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
