-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			ITEM
-- // OPERATION:		CARGA INICIAL
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200206
-- ////////////////////////////////////////////////////////////// 

USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////

-- SELECT * FROM ITEM
-- //////////////////////////////////////////////////////////////
-- //				CI - ITEM
-- //						DROPs
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ITEM]
GO


CREATE PROCEDURE [dbo].[PG_CI_ITEM]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VENDOR					[INT] ,								
	@PP_K_ITEM						[INT] ,								
	@PP_D_ITEM						[VARCHAR](250),
	@PP_O_ITEM						[INT],
	 -- ============================	
	@PP_PART_NUMBER_ITEM_VENDOR		[VARCHAR](250),
	@PP_PART_NUMBER_ITEM_PEARL		[VARCHAR](250),
	 -- ============================		 
	@PP_TRADEMARK_ITEM				[VARCHAR](100),
	@PP_MODEL_ITEM					[VARCHAR](100),
	@PP_PRICE_ITEM					[DECIMAL](10,4),		
	-- ============================			
	@PP_K_STATUS_ITEM				[INT] ,
	@PP_K_TYPE_ITEM					[INT] ,
	@PP_K_UNIT_OF_ITEM				[INT] ,
	-- ============================			
	@PP_K_CURRENCY					[INT] 
AS				
	-- ===========================

	INSERT INTO ITEM
			(	[K_VENDOR]	,
				[K_ITEM]	,		[D_ITEM]	, 
				[O_ITEM]	,
				 -- ============================
				[PART_NUMBER_ITEM_VENDOR]		,
				[PART_NUMBER_ITEM_PEARL]		,
				 -- ============================
				[TRADEMARK_ITEM]		,
				[MODEL_ITEM]		,	[PRICE_ITEM]		,			
				-- ============================	
				[K_STATUS_ITEM]		,	[K_TYPE_ITEM]		,
				[K_UNIT_OF_ITEM]	,
				-- ============================	
				[K_CURRENCY]		,
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@PP_K_VENDOR,
				@PP_K_ITEM	, 		@PP_D_ITEM	,
				10			,
				-- ===========================
				@PP_PART_NUMBER_ITEM_VENDOR		,
				@PP_PART_NUMBER_ITEM_PEARL		,
				-- ===========================
				@PP_TRADEMARK_ITEM		,	
				@PP_MODEL_ITEM		,	@PP_PRICE_ITEM		,			
				-- ===========================
				@PP_K_STATUS_ITEM	,	@PP_K_TYPE_ITEM		,			
				@PP_K_UNIT_OF_ITEM	,			
				-- ============================
				@PP_K_CURRENCY		,		
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )
		
GO


-- ==========================================================

-- ==========================================================
-- SELECT * FROM VENDOR
-- SELECT * FROM ITEM
-- ===============================================
SET NOCOUNT ON
-- ===============================================
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 322, 1, 'CONVERTIDOR VGA - HDMI' , 10 , '75121213154' , 0 , 'STEREN', 'HO325A3' , 350 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 322, 2, 'PANTALLA' , 10 , '75181743238' , 0 , 'SAMSUNG', 'CNDSL4653' , 13500 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 322, 3, 'MOUSE INALÁMBRICO' , 10 , '75212008280' , 0 , 'MICROSOFT', 'ALKSDF1546' , 150 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 322, 4, 'TECLADO INALÁMBRICO' , 10 , '75242273322' , 0 , 'MICROSOFT', 'AD45F4ADSF' , 180 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 322, 5, 'CÁMARA HD' , 10 , '75272538364' , 0 , 'MICROSOFT', 'ADSF54ADS' , 1560 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 322, 7, 'BULBO 36 VOLTS' , 10 , '75333068448' , 0 , 'BULBO 36 VOLTS', '36WSS' , 55 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 322, 8, 'BOCINA AUDIO HD' , 10 , '75363333490' , 0 , 'STEREN', 'JOURNS25' , 320 , 1 , 1,8,1

EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 295, 9, 'PANTALLA LED' , 10 , '75181744321' , 0 , 'SAMSUNG', 'CNDSL4653' , 13500 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 295, 10, 'CÁMARA HD-4K' , 10 , '75272534321' , 0 , 'SAMSUNG', 'ADSF54ADS' , 1560 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 295, 11, 'CELULAR GALAXY' , 10 , '75302801234' , 0 , 'SAMSUNG', 'S10' , 7980 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 295, 12, 'BOCINAAUDIO HD' , 10 , '75363331234' , 0 , 'STEREN', 'JOURNS25' , 320 , 1 , 1,8,1

-- PRODUCTOS PARA PRUEBA
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 1, 13, 'CONVERTIDOR VGA - HDMI' , 10 , '75121213154' , 0 , 'STEREN', 'HO325A3' , 350 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 1, 14, 'PANTALLA' , 10 , '75181743238' , 0 , 'SAMSUNG', 'CNDSL4653' , 13500 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 1, 15, 'MOUSE INALÁMBRICO' , 10 , '75212008280' , 0 , 'MICROSOFT', 'ALKSDF1546' , 150 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 1, 16, 'TECLADO INALÁMBRICO' , 10 , '75242273322' , 0 , 'MICROSOFT', 'AD45F4ADSF' , 180 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 1, 17, 'CÁMARA HD' , 10 , '75272538364' , 0 , 'MICROSOFT', 'ADSF54ADS' , 1560 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 1, 18, 'BULBO 36 VOLTS' , 10 , '75333068448' , 0 , 'BULBO 36 VOLTS', '36WSS' , 55 , 1 , 1,8,1
EXECUTE [dbo].[PG_CI_ITEM] 0, 139, 1, 19, 'BOCINA AUDIO HD' , 10 , '75363333490' , 0 , 'STEREN', 'JOURNS25' , 320 , 1 , 1,8,1
-- ===============================================
SET NOCOUNT OFF
-- ===============================================


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ITEM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ITEM]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////



