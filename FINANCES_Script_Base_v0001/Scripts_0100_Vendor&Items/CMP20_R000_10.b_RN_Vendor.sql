-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			VENDOR
-- // OPERATION:		REGLAS DE NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200206
-- ////////////////////////////////////////////////////////////// 

--USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_UNIQUE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_VENDOR_UNIQUE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_VENDOR_UNIQUE]
GO


CREATE PROCEDURE [dbo].[PG_RN_VENDOR_UNIQUE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_VENDOR						[INT],	
	@PP_D_VENDOR						[VARCHAR] (250),
	@PP_RFC_VENDOR						[VARCHAR] (25),
		-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (500)		OUTPUT
AS
	DECLARE @VP_RESULTADO				VARCHAR(500) = ''
		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
	BEGIN	
		DECLARE @VP_N_VENDOR_X_D_VENDOR			INT
		
		SELECT	@VP_N_VENDOR_X_D_VENDOR =		COUNT	(VENDOR.K_VENDOR)
												FROM	VENDOR
												WHERE	VENDOR.K_VENDOR<>@PP_K_VENDOR
												AND		VENDOR.D_VENDOR=@PP_D_VENDOR										
		-- =============================
			IF @VP_N_VENDOR_X_D_VENDOR>0
			BEGIN
				SET @VP_RESULTADO =  'There are already [VENDORS] with that Description ['+@PP_D_VENDOR+'].'
			END
	END			

	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
	BEGIN	
		DECLARE @VP_N_VENDOR_X_RFC_VENDOR		INT = 0

		IF @PP_RFC_VENDOR=''			-- SOLAMENTE APLICA LA VALIDACION CUANDO EL RFC_VENDOR NO VIENE VACIO
		BEGIN 
			SET		@VP_N_VENDOR_X_RFC_VENDOR =		0
		END
	END
	ELSE
	BEGIN
			SELECT	@VP_N_VENDOR_X_RFC_VENDOR =		COUNT	(VENDOR.K_VENDOR)
												FROM	VENDOR
												WHERE	VENDOR.K_VENDOR<>@PP_K_VENDOR
												AND		VENDOR.RFC_VENDOR=@PP_RFC_VENDOR	
												AND		@PP_RFC_VENDOR<>''			
		
			IF @VP_N_VENDOR_X_RFC_VENDOR>0
			BEGIN
				SET @VP_RESULTADO =  'There are already [VENDORS] with that RFC ['+@PP_RFC_VENDOR+'].' 
			END
	END
		
	-- ///////////////////////////////////////////
	
	IF @VP_RESULTADO<>''
	BEGIN
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //UNI//'
	END
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_BORRABLE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_VENDOR_ITS_DELETEABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_VENDOR_ITS_DELETEABLE]
GO

CREATE PROCEDURE [dbo].[PG_RN_VENDOR_ITS_DELETEABLE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_VENDOR						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
-- /////////////////////////////////////////////////////

	DECLARE @VP_N_FACTURA_X_VENDOR		INT = 0
/*
	-- ADR: FALTA AGREGAR EL CODIGO QUE VALIDE ESTE CASO.
	SELECT	@VP_N_FACTURA_X_VENDOR =		COUNT	(VENDOR.K_VENDOR)
											FROM	VENDOR,FACTURA
											WHERE	PLANTA.K_VENDOR=VENDOR.K_VENDOR	
											AND		VENDOR.K_VENDOR=@PP_K_VENDOR										
*/
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_N_FACTURA_X_VENDOR>0
			SET @VP_RESULTADO =  'There are [INVOICE] assigned.' 
		
	-- /////////////////////////////////////////////////////

	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EXISTS
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_VENDOR_EXISTS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_VENDOR_EXISTS]
GO


CREATE PROCEDURE [dbo].[PG_RN_VENDOR_EXISTS]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_VENDOR						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_VENDOR			INT
	DECLARE @VP_L_BORRADO			INT
		
	SELECT	@VP_K_VENDOR =		VENDOR.K_VENDOR,
			@VP_L_BORRADO	=		VENDOR.L_BORRADO
									FROM	VENDOR
									WHERE	VENDOR.K_VENDOR=@PP_K_VENDOR										
	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_VENDOR IS NULL )
			SET @VP_RESULTADO =  'The [VENDOR] does not exist.' 
	
	-- ===========================

	IF @VP_RESULTADO=''
		IF @VP_L_BORRADO=1
			SET @VP_RESULTADO =  'The [VENDOR] was down.' 
					
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_VENDOR_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_VENDOR_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_RN_VENDOR_DELETE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_VENDOR						[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_VENDOR_EXISTS]			@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_VENDOR,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_VENDOR_ITS_DELETEABLE]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_VENDOR,	 
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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_VENDOR_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_VENDOR_INSERT]
GO

CREATE PROCEDURE [dbo].[PG_RN_VENDOR_INSERT]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_VENDOR						[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS
	DECLARE @VP_RESULTADO				VARCHAR(300) = ''		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		--EXECUTE [dbo].[PG_RN_VENDOR_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
		--										@PP_K_VENDOR,	@PP_D_VENDOR,	@PP_RFC_VENDOR, 
		--										-- ===========================		
												--@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
		--EXECUTE [dbo].[PG_RN_VENDOR_EXISTS]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
		--										@PP_K_VENDOR,	 
		--										@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_VENDOR_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_VENDOR_UPDATE]
GO


CREATE PROCEDURE [dbo].[PG_RN_VENDOR_UPDATE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_VENDOR						[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_VENDOR_EXISTS]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_VENDOR,	 
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
