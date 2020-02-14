-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		DATA_02
-- // MODULE:			ALL
-- // OPERATION:		TABLA
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200213
-- ////////////////////////////////////////////////////////////// 

USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CURRENCY]') AND type in (N'U'))
	DROP TABLE [dbo].[CURRENCY]
GO

-- //////////////////////////////////////////////////////////////
-- // CURRENCY
-- // TABLA QUE CONTIENE LOS TIPOS DE MONEDA CON SUS SIGLAS
-- // DE ACUERDO AL ISO 4217
-- //////////////////////////////////////////////////////////////
--	SELECT * FROM CURRENCY

CREATE TABLE [dbo].[CURRENCY] (
	[K_CURRENCY]					[INT]				NOT NULL,
	[D_CURRENCY]					[VARCHAR]	(250)	NOT NULL,
	[S_CURRENCY]					[VARCHAR]	(10)	NOT NULL,
	[O_CURRENCY]					[INT]				NOT NULL,
	[C_CURRENCY]					[VARCHAR]	(500)	NOT NULL,
	[L_CURRENCY]					[INT]				NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_CURRENCY]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_CURRENCY]
GO

CREATE PROCEDURE [dbo].[PG_CI_CURRENCY]
	@PP_K_SISTEMA_EXE		INT,
	-- ========================================
	@PP_K_CURRENCY		INT,
	@PP_D_CURRENCY		VARCHAR(100),
	@PP_S_CURRENCY		VARCHAR(10),
	@PP_O_CURRENCY		INT,
	@PP_C_CURRENCY		VARCHAR(255),
	@PP_L_CURRENCY		INT
AS	
	-- ===============================
	DECLARE @VP_K_EXIST	INT

	SELECT	@VP_K_EXIST =	K_CURRENCY
							FROM	CURRENCY
							WHERE	K_CURRENCY=@PP_K_CURRENCY

	-- ===============================

	IF @VP_K_EXIST IS NULL
		INSERT INTO CURRENCY	
			(	K_CURRENCY,				D_CURRENCY, 
				S_CURRENCY,				O_CURRENCY,
				C_CURRENCY,
				L_CURRENCY				)		
		VALUES	
			(	@PP_K_CURRENCY,			@PP_D_CURRENCY,	
				@PP_S_CURRENCY,			@PP_O_CURRENCY,
				@PP_C_CURRENCY,
				@PP_L_CURRENCY			)
	ELSE
		UPDATE	CURRENCY
		SET		D_CURRENCY	= @PP_D_CURRENCY,	
				S_CURRENCY	= @PP_S_CURRENCY,			
				O_CURRENCY	= @PP_O_CURRENCY,
				C_CURRENCY	= @PP_C_CURRENCY,
				L_CURRENCY	= @PP_L_CURRENCY	
		WHERE	K_CURRENCY=@PP_K_CURRENCY

	-- =========================================================
GO

-- ===============================================
SET NOCOUNT ON
-- ===============================================

--EXECUTE [dbo].[PG_CI_CURRENCY] 0, 0, 'NOT AVAILABLE!',		'??',   1,  '', 1
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 1, 'EACHES',				'EA', 10, '', 1
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 2, 'SQUARE METERS',		'SM', 20, '', 1
EXECUTE [dbo].[PG_CI_CURRENCY] 0, 3, 'SQUARE FEET',			'SF', 30, '', 1		
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_CURRENCY]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_CURRENCY]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////