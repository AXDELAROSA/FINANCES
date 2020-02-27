-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			ALL
-- // OPERATION:		TABLA
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200224
-- ////////////////////////////////////////////////////////////// 

USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PLACED_BY]') AND type in (N'U'))
	DROP TABLE [dbo].[PLACED_BY]
GO

-- //////////////////////////////////////////////////////////////
-- // PLACED_BY
-- // TABLA QUE CONTIENE LOS TEMINOS POSIBLES DE COMPRA
-- //////////////////////////////////////////////////////////////
--	SELECT * FROM PLACED_BY

CREATE TABLE [dbo].[PLACED_BY] (
	[K_PLACED_BY]					[INT]				NOT NULL,
	[D_PLACED_BY]					[VARCHAR]	(250)	NOT NULL,
	[S_PLACED_BY]					[VARCHAR]	(10)	NOT NULL,
	[O_PLACED_BY]					[INT]				NOT NULL,
	[C_PLACED_BY]					[VARCHAR]	(500)	NOT NULL,
	[L_PLACED_BY]					[INT]				NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PLACED_BY]
	ADD CONSTRAINT [PK_PLACED_BY]
		PRIMARY KEY CLUSTERED ([K_PLACED_BY])	
GO

-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PLACED_BY]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PLACED_BY]
GO

CREATE PROCEDURE [dbo].[PG_CI_PLACED_BY]
	@PP_K_SISTEMA_EXE		INT,
	-- ========================================
	@PP_K_PLACED_BY		INT,
	@PP_D_PLACED_BY		VARCHAR(100),
	@PP_S_PLACED_BY		VARCHAR(10),
	@PP_O_PLACED_BY		INT,
	@PP_C_PLACED_BY		VARCHAR(255),
	@PP_L_PLACED_BY		INT
AS	
	-- ===============================
	DECLARE @VP_K_EXIST	INT

	SELECT	@VP_K_EXIST =	K_PLACED_BY
							FROM	PLACED_BY
							WHERE	K_PLACED_BY=@PP_K_PLACED_BY
	-- ===============================

	IF @VP_K_EXIST IS NULL
		INSERT INTO PLACED_BY	
			(	K_PLACED_BY,				D_PLACED_BY, 
				S_PLACED_BY,				O_PLACED_BY,
				C_PLACED_BY,
				L_PLACED_BY				)		
		VALUES	
			(	@PP_K_PLACED_BY,			@PP_D_PLACED_BY,	
				@PP_S_PLACED_BY,			@PP_O_PLACED_BY,
				@PP_C_PLACED_BY,
				@PP_L_PLACED_BY			)
	ELSE
		UPDATE	PLACED_BY
		SET		D_PLACED_BY	= @PP_D_PLACED_BY,	
				S_PLACED_BY	= @PP_S_PLACED_BY,			
				O_PLACED_BY	= @PP_O_PLACED_BY,
				C_PLACED_BY	= @PP_C_PLACED_BY,
				L_PLACED_BY	= @PP_L_PLACED_BY	
		WHERE	K_PLACED_BY=@PP_K_PLACED_BY

	-- =========================================================
GO

-- ===============================================
SET NOCOUNT ON
-- ===============================================
EXECUTE [dbo].[PG_CI_PLACED_BY] 0, 0, '(TO DEFINE)' ,		'2DFNE', 10 , '' , 0
EXECUTE [dbo].[PG_CI_PLACED_BY] 0, 1, 'E-MAIL' ,			'EMAIL', 10 , '' , 1
EXECUTE [dbo].[PG_CI_PLACED_BY] 0, 2, 'PHONE' ,				'PHONE', 10 , '' , 1
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PLACED_BY]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PLACED_BY]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////