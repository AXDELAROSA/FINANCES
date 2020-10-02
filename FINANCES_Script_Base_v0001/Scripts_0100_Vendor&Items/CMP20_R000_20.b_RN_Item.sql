-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			ITEM
-- // OPERATION:		REGLAS DE NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200217
-- ////////////////////////////////////////////////////////////// 

--USE [COMPRAS]
GO
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_UNIQUE
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_ITEM_UNIQUE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_ITEM_UNIQUE]
GO
CREATE PROCEDURE [dbo].[PG_RN_ITEM_UNIQUE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_VENDOR						[INT],	
	@PP_K_ITEM							[INT],	
	@PP_D_ITEM							[NVARCHAR] (MAX),
		-- ===========================		
	@PP_PART_NUMBER_ITEM_VENDOR			[VARCHAR] (100),
	@PP_PART_NUMBER_ITEM_PEARL			[VARCHAR] (100),
		-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS
	DECLARE @VP_RESULTADO				VARCHAR(300) = ''		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
	BEGIN	
		DECLARE @VP_N_ITEM_X_D_ITEM			INT		
		DECLARE @VP_N_ITEM_X_ITEM_VENDOR	INT		
		DECLARE @VP_N_ITEM_X_ITEM_PEARL		INT		

		SELECT	@VP_N_ITEM_X_D_ITEM		 =		COUNT	(ITEM.K_ITEM)
												FROM	ITEM
												WHERE	ITEM.K_ITEM<>@PP_K_ITEM
												AND		ITEM.K_VENDOR=@PP_K_VENDOR
												AND		ITEM.D_ITEM=@PP_D_ITEM

		IF @VP_N_ITEM_X_D_ITEM>0
		BEGIN
			DECLARE @PP_D_VENDOR VARCHAR(250)
				SELECT	@PP_D_VENDOR=ISNULL(D_VENDOR,'NOT AVAILABLE')
				FROM	VENDOR 
				WHERE K_VENDOR=@PP_K_VENDOR

				SET @VP_RESULTADO =  'There are already [ITEMS] with that Description ['+@PP_D_ITEM+']. In [VENDOR] ['+@PP_D_VENDOR+']' 		
		END
		
		IF @VP_RESULTADO=''
		BEGIN
			IF @PP_PART_NUMBER_ITEM_VENDOR<>''
			BEGIN
				SELECT	@VP_N_ITEM_X_ITEM_VENDOR =		COUNT	(ITEM.PART_NUMBER_ITEM_VENDOR)
														FROM	ITEM
														WHERE	ITEM.K_ITEM<>@PP_K_ITEM
														AND		ITEM.PART_NUMBER_ITEM_VENDOR=@PP_PART_NUMBER_ITEM_VENDOR

				IF @VP_N_ITEM_X_ITEM_VENDOR>0
				BEGIN
					SET @VP_RESULTADO =  'There are already [ITEMS] with that Item Vendor ['+@PP_PART_NUMBER_ITEM_VENDOR+']'
				END
			END
		END

		IF @VP_RESULTADO=''
		BEGIN
			IF @PP_PART_NUMBER_ITEM_PEARL<>''
			BEGIN
				SELECT	@VP_N_ITEM_X_ITEM_PEARL =		COUNT	(ITEM.PART_NUMBER_ITEM_PEARL)
														FROM	ITEM
														WHERE	ITEM.K_ITEM<>@PP_K_ITEM
														AND		ITEM.PART_NUMBER_ITEM_PEARL=@PP_PART_NUMBER_ITEM_PEARL

				IF @VP_N_ITEM_X_ITEM_PEARL>0
				BEGIN
					SET @VP_RESULTADO =  'There are already [ITEMS] with that Item Pearl ['+@PP_PART_NUMBER_ITEM_PEARL+']'
				END
			END
		END
		
		--ESTA VALIDACIÓN QUEDA PENDIENTE A FALTA DE SABER QUE SE HARÁ CON LA INFORMACIÓN DEL ITEM. EN EL SISTEMA PRODUCTIVO.
		--IF @VP_RESULTADO=''
		--BEGIN
		--	IF @PP_PART_NUMBER_ITEM_PEARL<>''
		--	BEGIN
		--		SELECT	@VP_N_ITEM_X_ITEM_PEARL =		COUNT(ITEM_NO)
		--												FROM	DATA_02.DBO.IMITMIDX_SQL
		--												WHERE	RTRIM(LTRIM(ITEM_NO))=@PP_PART_NUMBER_ITEM_PEARL

		--		IF @VP_N_ITEM_X_ITEM_PEARL>0
		--		BEGIN
		--			SET @VP_RESULTADO =  'There are already [ITEMS] with that Item Pearl in Engineering System ['+@PP_PART_NUMBER_ITEM_PEARL+']'
		--		END
		--	END
		--END
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
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_ITEM_ITS_DELETEABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_ITEM_ITS_DELETEABLE]
GO
CREATE PROCEDURE [dbo].[PG_RN_ITEM_ITS_DELETEABLE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_ITEM							[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS
	DECLARE @VP_RESULTADO				VARCHAR(300) = ''		
-- /////////////////////////////////////////////////////
	DECLARE @VP_PO_X_ITEM		INT = 0

	SELECT	@VP_PO_X_ITEM =		COUNT	(DETAILS_PURCHASE_ORDER.K_ITEM)
								FROM	DETAILS_PURCHASE_ORDER
								WHERE	DETAILS_PURCHASE_ORDER.K_ITEM=@PP_K_ITEM
	-- =============================
	IF @VP_RESULTADO=''
		IF @VP_PO_X_ITEM>0
			SET @VP_RESULTADO =  'The [ITEM] is added to one or more purchase orders.'
	-- /////////////////////////////////////////////////////
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO
	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EXISTS
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_ITEM_EXISTS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_ITEM_EXISTS]
GO
CREATE PROCEDURE [dbo].[PG_RN_ITEM_EXISTS]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_ITEM							[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS
	DECLARE @VP_RESULTADO				VARCHAR(300) = ''		
	-- /////////////////////////////////////////////////////
	DECLARE @VP_K_ITEM				INT
	DECLARE @VP_L_BORRADO			INT
		
	SELECT	@VP_K_ITEM		=		ITEM.K_ITEM,
			@VP_L_BORRADO	=		ITEM.L_BORRADO
									FROM	ITEM
									WHERE	ITEM.K_ITEM=@PP_K_ITEM										
	-- ===========================
	IF @VP_RESULTADO=''
		IF ( @VP_K_ITEM IS NULL )
			SET @VP_RESULTADO =  'The [ITEM] does not exist.' 	
	-- ===========================
	IF @VP_RESULTADO=''
		IF @VP_L_BORRADO=1
			SET @VP_RESULTADO =  'The [ITEM] was down.' 					
	-- /////////////////////////////////////////////////////	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO
	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CLAVE_EXISTE
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_ITEM_CLAVE_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_ITEM_CLAVE_EXISTE]
GO

CREATE PROCEDURE [dbo].[PG_RN_ITEM_CLAVE_EXISTE]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================		
	@PP_K_ITEM					INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(300)	OUTPUT
AS
	DECLARE @VP_RESULTADO		VARCHAR(300) = ''		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO='' 
		BEGIN
		DECLARE @VP_EXISTE_CLAVE	INT

		SELECT	@VP_EXISTE_CLAVE =	COUNT(K_ITEM)
									FROM	ITEM 
									WHERE K_ITEM=@PP_K_ITEM
		IF @VP_EXISTE_CLAVE>0
			SET @VP_RESULTADO =  '[ITEM] ID not available.' 
		END			
	-- ///////////////////////////////////////////		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO
	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_DELETE
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_ITEM_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_ITEM_DELETE]
GO
CREATE PROCEDURE [dbo].[PG_RN_ITEM_DELETE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_ITEM							[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS
	DECLARE @VP_RESULTADO				VARCHAR(300) = ''		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_ITEM_EXISTS]			@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_ITEM,	 
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_ITEM_ITS_DELETEABLE]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_ITEM,	 
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
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_ITEM_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_ITEM_INSERT]
GO
CREATE PROCEDURE [dbo].[PG_RN_ITEM_INSERT]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_ITEM							[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS
	DECLARE @VP_RESULTADO				VARCHAR(300) = ''		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_ITEM_CLAVE_EXISTE]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_ITEM,	 
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
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_ITEM_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_ITEM_UPDATE]
GO
CREATE PROCEDURE [dbo].[PG_RN_ITEM_UPDATE]
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_ITEM							[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS
	DECLARE @VP_RESULTADO				VARCHAR(300) = ''		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_ITEM_EXISTS]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_ITEM,	 
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
