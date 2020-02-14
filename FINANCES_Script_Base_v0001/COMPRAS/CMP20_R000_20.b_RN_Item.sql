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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_SUPPLIER_UNIQUE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_SUPPLIER_UNIQUE]
GO


CREATE PROCEDURE [dbo].[PG_RN_SUPPLIER_UNIQUE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_SUPPLIER						[INT],	
	@PP_D_SUPPLIER						[VARCHAR] (100),
	@PP_RFC_SUPPLIER					[VARCHAR] (100),
		-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		BEGIN
	
		DECLARE @VP_N_SUPPLIER_X_D_SUPPLIER		INT
		
		SELECT	@VP_N_SUPPLIER_X_D_SUPPLIER =		COUNT	(SUPPLIER.K_SUPPLIER)
													FROM	SUPPLIER
													WHERE	SUPPLIER.K_SUPPLIER<>@PP_K_SUPPLIER
													AND		SUPPLIER.D_SUPPLIER=@PP_D_SUPPLIER										
		-- =============================

		IF @VP_RESULTADO=''
			IF @VP_N_SUPPLIER_X_D_SUPPLIER>0
				SET @VP_RESULTADO =  'There are already [SUPPLIERS] with that Description ['+@PP_D_SUPPLIER+'].' 
		END	
		
	-- ///////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		BEGIN
	
		DECLARE @VP_N_SUPPLIER_X_RFC_SUPPLIER		INT = 0

		IF @PP_RFC_SUPPLIER=''			-- SOLAMENTE APLICA LA VALIDACION CUANDO EL RFC_SUPPLIER NO VIENE VACIO 
			SET		@VP_N_SUPPLIER_X_RFC_SUPPLIER =		0
		ELSE
			SELECT	@VP_N_SUPPLIER_X_RFC_SUPPLIER =		COUNT	(SUPPLIER.K_SUPPLIER)
												FROM	SUPPLIER
												WHERE	SUPPLIER.K_SUPPLIER<>@PP_K_SUPPLIER
												AND		SUPPLIER.RFC_SUPPLIER=@PP_RFC_SUPPLIER	
												AND		@PP_RFC_SUPPLIER<>''				
		-- =============================

		IF @VP_RESULTADO=''
			IF @VP_N_SUPPLIER_X_RFC_SUPPLIER>0
				SET @VP_RESULTADO =  'There are already [SUPPLIERS] with that RFC ['+@PP_RFC_SUPPLIER+'].' 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_SUPPLIER_ITS_DELETEABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_SUPPLIER_ITS_DELETEABLE]
GO

CREATE PROCEDURE [dbo].[PG_RN_SUPPLIER_ITS_DELETEABLE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_SUPPLIER						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
-- /////////////////////////////////////////////////////

	DECLARE @VP_N_FACTURA_X_SUPPLIER		INT = 0
/*
	-- ADR: FALTA AGREGAR EL CODIGO QUE VALIDE ESTE CASO.
	SELECT	@VP_N_FACTURA_X_SUPPLIER =		COUNT	(SUPPLIER.K_SUPPLIER)
											FROM	SUPPLIER,FACTURA
											WHERE	PLANTA.K_SUPPLIER=SUPPLIER.K_SUPPLIER	
											AND		SUPPLIER.K_SUPPLIER=@PP_K_SUPPLIER										
*/
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_N_FACTURA_X_SUPPLIER>0
			SET @VP_RESULTADO =  'There are [INVOICE] assigned.' 
		
	-- /////////////////////////////////////////////////////

	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EXISTS
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_SUPPLIER_EXISTS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_SUPPLIER_EXISTS]
GO


CREATE PROCEDURE [dbo].[PG_RN_SUPPLIER_EXISTS]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_SUPPLIER						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_SUPPLIER			INT
	DECLARE @VP_L_BORRADO			INT
		
	SELECT	@VP_K_SUPPLIER =		SUPPLIER.K_SUPPLIER,
			@VP_L_BORRADO	=		SUPPLIER.L_BORRADO
									FROM	SUPPLIER
									WHERE	SUPPLIER.K_SUPPLIER=@PP_K_SUPPLIER										
	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_SUPPLIER IS NULL )
			SET @VP_RESULTADO =  'The [SUPPLIER] does not exist.' 
	
	-- ===========================

	IF @VP_RESULTADO=''
		IF @VP_L_BORRADO=1
			SET @VP_RESULTADO =  'The [SUPPLIER] was down.' 
					
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_SUPPLIER_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_SUPPLIER_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_RN_SUPPLIER_DELETE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_SUPPLIER						[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_SUPPLIER_EXISTS]			@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_SUPPLIER,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_SUPPLIER_ITS_DELETEABLE]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_SUPPLIER,	 
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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_SUPPLIER_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_SUPPLIER_INSERT]
GO


CREATE PROCEDURE [dbo].[PG_RN_SUPPLIER_INSERT]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_SUPPLIER						[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_SUPPLIER_EXISTS]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_SUPPLIER,	 
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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_SUPPLIER_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_SUPPLIER_UPDATE]
GO


CREATE PROCEDURE [dbo].[PG_RN_SUPPLIER_UPDATE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_SUPPLIER						[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_SUPPLIER_EXISTS]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_SUPPLIER,	 
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
