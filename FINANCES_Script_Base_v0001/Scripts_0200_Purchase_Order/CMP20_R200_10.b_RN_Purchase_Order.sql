-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			PURCHASE_ORDER
-- // OPERATION:		REGLAS DE NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200224
-- ////////////////////////////////////////////////////////////// 

USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_UNIQUE
-- //////////////////////////////////////////////////////////////


--IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PURCHASE_ORDER_UNIQUE]') AND type in (N'P', N'PC'))
--	DROP PROCEDURE [dbo].[PG_RN_PURCHASE_ORDER_UNIQUE]
--GO


--CREATE PROCEDURE [dbo].[PG_RN_PURCHASE_ORDER_UNIQUE]
--	@PP_K_SISTEMA_EXE					[INT],
--	@PP_K_USUARIO_ACCION				[INT],
--	-- ===========================		
--	@PP_K_PURCHASE_ORDER				[INT],	
--	@PP_D_PURCHASE_ORDER				[VARCHAR] (250),
--	@PP_RFC_PURCHASE_ORDER				[VARCHAR] (25),
--		-- ===========================		
--	@OU_RESULTADO_VALIDACION			[VARCHAR] (500)		OUTPUT
--AS
--	DECLARE @VP_RESULTADO				VARCHAR(500) = ''
		
--	-- ///////////////////////////////////////////
--	--IF @VP_RESULTADO=''
--	--BEGIN	
--	--	DECLARE @VP_N_PURCHASE_ORDER_X_D_PURCHASE_ORDER			INT
		
--	--	SELECT	@VP_N_PURCHASE_ORDER_X_D_PURCHASE_ORDER =		COUNT	(PURCHASE_ORDER.K_PURCHASE_ORDER)
--	--											FROM	PURCHASE_ORDER
--	--											WHERE	PURCHASE_ORDER.K_PURCHASE_ORDER<>@PP_K_PURCHASE_ORDER
--	--											AND		PURCHASE_ORDER.D_PURCHASE_ORDER=@PP_D_PURCHASE_ORDER										
--	--	-- =============================
--	--		IF @VP_N_PURCHASE_ORDER_X_D_PURCHASE_ORDER>0
--	--		BEGIN
--	--			SET @VP_RESULTADO =  'There are already [PURCHASE_ORDERS] with that Description ['+@PP_D_PURCHASE_ORDER+'].'
--	--		END
--	--END			

--	---- ///////////////////////////////////////////
--	--IF @VP_RESULTADO=''
--	--BEGIN	
--	--	DECLARE @VP_N_PURCHASE_ORDER_X_RFC_PURCHASE_ORDER		INT = 0

--	--	IF @PP_RFC_PURCHASE_ORDER=''			-- SOLAMENTE APLICA LA VALIDACION CUANDO EL RFC_PURCHASE_ORDER NO VIENE VACIO
--	--	BEGIN 
--	--		SET		@VP_N_PURCHASE_ORDER_X_RFC_PURCHASE_ORDER =		0
--	--	END
--	--END
--	--ELSE
--	--BEGIN
--	--		SELECT	@VP_N_PURCHASE_ORDER_X_RFC_PURCHASE_ORDER =		COUNT	(PURCHASE_ORDER.K_PURCHASE_ORDER)
--	--											FROM	PURCHASE_ORDER
--	--											WHERE	PURCHASE_ORDER.K_PURCHASE_ORDER<>@PP_K_PURCHASE_ORDER
--	--											AND		PURCHASE_ORDER.RFC_PURCHASE_ORDER=@PP_RFC_PURCHASE_ORDER	
--	--											AND		@PP_RFC_PURCHASE_ORDER<>''			
		
--	--		IF @VP_N_PURCHASE_ORDER_X_RFC_PURCHASE_ORDER>0
--	--		BEGIN
--	--			SET @VP_RESULTADO =  'There are already [PURCHASE_ORDERS] with that RFC ['+@PP_RFC_PURCHASE_ORDER+'].' 
--	--		END
--	--END
		
--	---- ///////////////////////////////////////////
	
--	--IF @VP_RESULTADO<>''
--	--BEGIN
--	--	SET	@VP_RESULTADO = @VP_RESULTADO + ' //UNI//'
--	--END
	
--	-- ///////////////////////////////////////////
		
--	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

--	-- /////////////////////////////////////////////////////
--GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_BORRABLE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PURCHASE_ORDER_ITS_DELETEABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PURCHASE_ORDER_ITS_DELETEABLE]
GO

CREATE PROCEDURE [dbo].[PG_RN_PURCHASE_ORDER_ITS_DELETEABLE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_HEADER_PURCHASE_ORDER			[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
-- /////////////////////////////////////////////////////

	DECLARE @VP_N_FACTURA_X_PURCHASE_ORDER		INT = 0
/*
	-- ADR: FALTA AGREGAR EL CODIGO QUE VALIDE ESTE CASO.
	SELECT	@VP_N_FACTURA_X_PURCHASE_ORDER =		COUNT	(PURCHASE_ORDER.K_PURCHASE_ORDER)
											FROM	PURCHASE_ORDER,FACTURA
											WHERE	PLANTA.K_PURCHASE_ORDER=PURCHASE_ORDER.K_PURCHASE_ORDER	
											AND		PURCHASE_ORDER.K_PURCHASE_ORDER=@PP_K_PURCHASE_ORDER										
*/
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_N_FACTURA_X_PURCHASE_ORDER>0
			SET @VP_RESULTADO =  'There are [INVOICE] assigned.' 
		
	-- /////////////////////////////////////////////////////

	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EXISTS
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PURCHASE_ORDER_EXISTS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PURCHASE_ORDER_EXISTS]
GO


CREATE PROCEDURE [dbo].[PG_RN_PURCHASE_ORDER_EXISTS]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_HEADER_PURCHASE_ORDER			[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_HEADER_PURCHASE_ORDER	INT
	DECLARE @VP_L_BORRADO			INT
		
	SELECT	@VP_K_HEADER_PURCHASE_ORDER = HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER,
			@VP_L_BORRADO	=			HEADER_PURCHASE_ORDER.L_BORRADO
									FROM	HEADER_PURCHASE_ORDER
									WHERE	HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_HEADER_PURCHASE_ORDER IS NULL )
			SET @VP_RESULTADO =  'The [PURCHASE_ORDER] does not exist.' 
	
	-- ===========================

	IF @VP_RESULTADO=''
		IF @VP_L_BORRADO=1
			SET @VP_RESULTADO =  'The [PURCHASE_ORDER] was down.' 
					
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PURCHASE_ORDER_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PURCHASE_ORDER_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PURCHASE_ORDER_DELETE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_HEADER_PURCHASE_ORDER			[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PURCHASE_ORDER_EXISTS]			@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_HEADER_PURCHASE_ORDER,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PURCHASE_ORDER_ITS_DELETEABLE]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_HEADER_PURCHASE_ORDER,	 
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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PURCHASE_ORDER_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PURCHASE_ORDER_INSERT]
GO


CREATE PROCEDURE [dbo].[PG_RN_PURCHASE_ORDER_INSERT]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_HEADER_PURCHASE_ORDER			[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PURCHASE_ORDER_EXISTS]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_HEADER_PURCHASE_ORDER,
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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PURCHASE_ORDER_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PURCHASE_ORDER_UPDATE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PURCHASE_ORDER_UPDATE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_HEADER_PURCHASE_ORDER			[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PURCHASE_ORDER_EXISTS]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_HEADER_PURCHASE_ORDER,	 
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