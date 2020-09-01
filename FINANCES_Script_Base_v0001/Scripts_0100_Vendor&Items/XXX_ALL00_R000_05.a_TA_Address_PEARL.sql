-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		SETTINGS_GENERAL
-- // MODULE:			ALL
-- // OPERATION:		TABLA
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200707
-- ////////////////////////////////////////////////////////////// 

USE	[BD_GENERAL]
--USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ADDRESS_PEARL]') AND type in (N'U'))
	DROP TABLE [dbo].[ADDRESS_PEARL]
GO
-- ////////////////////////////////////////////////////////////////
-- //					ADDRESS_PEARL
-- //////////////////////////////////////////////////////////////
-- // TABLA QUE CONTIENE LA DIRECCIÓN DE LA EMPRESA Y DE LA BODEGA
-- // EN EL PASO,TX
-- //////////////////////////////////////////////////////////////
--	SELECT * FROM ADDRESS_PEARL
CREATE TABLE [dbo].[ADDRESS_PEARL] (
	[K_ADDRESS_PEARL]			[INT] NOT NULL,			
	[D_ADDRESS_PEARL_1]			[VARCHAR](255) NOT NULL,	--street
	[D_ADDRESS_PEARL_2]			[VARCHAR](255) NOT NULL,	--colony, fracc, 
	[C_ADDRESS_PEARL]			[VARCHAR](255) NOT NULL,
	[O_ADDRESS_PEARL]			[INT] NOT NULL,
	-- ============================
	[PHONE]						[VARCHAR](50),
	[FAX]						[VARCHAR](50),
	[RFC]						[VARCHAR](50),
	-- ============================
	[CITY]						[VARCHAR](100) NOT NULL, 
	[STATE_GEO]					[VARCHAR](100) NOT NULL,
	[COUNTRY]					[VARCHAR](100) NOT NULL,
	[POSTAL_CODE]				[VARCHAR](10) NULL,
	[NUMBER_EXTERIOR]			[VARCHAR](100) NULL,
	[NUMBER_INSIDE]				[VARCHAR](100) NULL
	-- ============================
	--[K_CITY]					[INT] NOT NULL,
	--[K_STATE_GEO]				[INT] NOT NULL,
	--[K_COUNTRY]				[INT] NOT NULL
) ON [PRIMARY]
GO
-- //////////////////////////////////////////////////////
ALTER TABLE [dbo].[ADDRESS_PEARL]
	ADD CONSTRAINT [PK_ADDRESS_PEARL]
		PRIMARY KEY CLUSTERED ([K_ADDRESS_PEARL])
GO
-- //////////////////////////////////////////////////////
ALTER TABLE [dbo].[ADDRESS_PEARL] 
	ADD		[K_USUARIO_ALTA]			[INT] NOT NULL,
			[F_ALTA]					[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]			[INT] NOT NULL,
			[F_CAMBIO]					[DATETIME] NOT NULL,
			[L_BORRADO]					[INT] NOT NULL,
			[K_USUARIO_BAJA]			[INT] NULL,
			[F_BAJA]					[DATETIME] NULL;
GO

-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ADDRESS_PEARL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ADDRESS_PEARL]
GO

CREATE PROCEDURE [dbo].[PG_CI_ADDRESS_PEARL]
	@PP_K_SISTEMA_EXE			INT,
	-- ========================================
	@PP_K_ADDRESS_PEARL			INT,			
	@PP_D_ADDRESS_PEARL_1		VARCHAR(255),	--street
	@PP_D_ADDRESS_PEARL_2		VARCHAR(255),	--colony, fracc, 
	@PP_C_ADDRESS_PEARL			VARCHAR(255),
	@PP_O_ADDRESS_PEARL			INT,
	-- ============================
	@PP_PHONE					VARCHAR(50),
	@PP_FAX						VARCHAR(50),
	@PP_RFC						VARCHAR(50),
	-- ============================
	@PP_CITY					VARCHAR(100), 
	@PP_STATE_GEO				VARCHAR(100),
	@PP_COUNTRY					VARCHAR(100),
	@PP_POSTAL_CODE				VARCHAR(10),
	@PP_NUMBER_EXTERIOR			VARCHAR(100),
	@PP_NUMBER_INSIDE			VARCHAR(100)
	-- ============================
AS	
	-- ===============================
	--DECLARE @VP_K_EXIST	INT
	--SELECT	@VP_K_EXIST =	K_ADDRESS_PEARL
	--						FROM	ADDRESS_PEARL
	--						WHERE	K_ADDRESS_PEARL=@PP_K_ADDRESS_PEARL
	-- ===============================
	--IF @VP_K_EXIST IS NULL
		INSERT INTO ADDRESS_PEARL	
			(	K_ADDRESS_PEARL		,	
				D_ADDRESS_PEARL_1	,	
				D_ADDRESS_PEARL_2	,	
				C_ADDRESS_PEARL		,	
				O_ADDRESS_PEARL		,	
				-- =========================
				[PHONE]				,
				[FAX]				,
				[RFC]				,
				-- =========================
				CITY				,	
				STATE_GEO			,	
				COUNTRY				,	
				POSTAL_CODE			,	
				NUMBER_EXTERIOR		,	
				NUMBER_INSIDE			)		
		VALUES	
			(	@PP_K_ADDRESS_PEARL		,	
				@PP_D_ADDRESS_PEARL_1	,	
				@PP_D_ADDRESS_PEARL_2	,	
				@PP_C_ADDRESS_PEARL		,	
				@PP_O_ADDRESS_PEARL		,	
				-- =========================
				@PP_PHONE				,
				@PP_FAX					,
				@PP_RFC					,
				-- =========================
				@PP_CITY				,	
				@PP_STATE_GEO			,	
				@PP_COUNTRY				,	
				@PP_POSTAL_CODE			,	
				@PP_NUMBER_EXTERIOR		,	
				@PP_NUMBER_INSIDE			)
	--ELSE
	--	UPDATE	ADDRESS_PEARL
	--	SET		D_ADDRESS_PEARL	= @PP_D_ADDRESS_PEARL,	
	--			S_ADDRESS_PEARL	= @PP_S_ADDRESS_PEARL,			
	--			O_ADDRESS_PEARL	= @PP_O_ADDRESS_PEARL,
	--			C_ADDRESS_PEARL	= @PP_C_ADDRESS_PEARL,
	--			L_ADDRESS_PEARL	= @PP_L_ADDRESS_PEARL	
	--	WHERE	K_ADDRESS_PEARL=@PP_K_ADDRESS_PEARL
	-- =========================================================
GO
-- ===============================================
SET NOCOUNT ON
-- ===============================================
EXECUTE [dbo].[PG_CI_ADDRESS_PEARL] 0, 0, 'NOT ASSIGNED',	'???????', 'NOT ASSIGNED', 0, '','','','NOT ASSIGNED', 'NOT ASSIGNED', 'NOT ASSIGNED', '00000', '0000','000'
EXECUTE [dbo].[PG_CI_ADDRESS_PEARL] 0, 1, 'AV. ROSA MARÍA FUENTES',	'PARQUE INDUSTRIAL FUENTES',  'ADDRESS PEARL', 0, '8925800','8925801','HME 951127-VC5','CD. JUÁREZ', 'CHIHUAHUA', 'MÉXICO', '32320', '7050-A','000'
EXECUTE [dbo].[PG_CI_ADDRESS_PEARL] 0, 2, 'ROJAS DR.',	'',  'ADDRESS WAREHOUSE USA', 0, '','','','EL PASO', 'TEXAS', 'UNITED STATES OF AMERICA', '79936', '11323','000'
EXECUTE [dbo].[PG_CI_ADDRESS_PEARL] 0, 3, 'PMB 319',	'EDGEMERE',  'ADDRESS BILL USA', 0, '','','','EL PASO', 'TEXAS', 'UNITED STATES OF AMERICA', '79925', '6248','000'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ADDRESS_PEARL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ADDRESS_PEARL]
GO
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////