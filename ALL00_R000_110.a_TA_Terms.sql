-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		BD_GENERAL
-- // MODULE:			ALL
-- // OPERATION:		TABLA
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200224
-- ////////////////////////////////////////////////////////////// 

USE [BD_GENERAL]
GO

-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TERMS]') AND type in (N'U'))
	DROP TABLE [dbo].[TERMS]
GO

-- //////////////////////////////////////////////////////////////
-- // TERMS
-- // TABLA QUE CONTIENE LOS TEMINOS POSIBLES DE COMPRA
-- //////////////////////////////////////////////////////////////
--	SELECT * FROM TERMS

CREATE TABLE [dbo].[TERMS] (
	[K_TERMS]					[INT]				NOT NULL,
	[D_TERMS]					[VARCHAR]	(250)	NOT NULL,
	[S_TERMS]					[VARCHAR]	(10)	NOT NULL,
	[O_TERMS]					[INT]				NOT NULL,
	[C_TERMS]					[VARCHAR]	(500)	NOT NULL,
	[L_TERMS]					[INT]				NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TERMS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TERMS]
GO

CREATE PROCEDURE [dbo].[PG_CI_TERMS]
	@PP_K_SISTEMA_EXE		INT,
	-- ========================================
	@PP_K_TERMS		INT,
	@PP_D_TERMS		VARCHAR(100),
	@PP_S_TERMS		VARCHAR(10),
	@PP_O_TERMS		INT,
	@PP_C_TERMS		VARCHAR(255),
	@PP_L_TERMS		INT
AS	
	-- ===============================
	DECLARE @VP_K_EXIST	INT

	SELECT	@VP_K_EXIST =	K_TERMS
							FROM	TERMS
							WHERE	K_TERMS=@PP_K_TERMS
	-- ===============================

	IF @VP_K_EXIST IS NULL
		INSERT INTO TERMS	
			(	K_TERMS,				D_TERMS, 
				S_TERMS,				O_TERMS,
				C_TERMS,
				L_TERMS				)		
		VALUES	
			(	@PP_K_TERMS,			@PP_D_TERMS,	
				@PP_S_TERMS,			@PP_O_TERMS,
				@PP_C_TERMS,
				@PP_L_TERMS			)
	ELSE
		UPDATE	TERMS
		SET		D_TERMS	= @PP_D_TERMS,	
				S_TERMS	= @PP_S_TERMS,			
				O_TERMS	= @PP_O_TERMS,
				C_TERMS	= @PP_C_TERMS,
				L_TERMS	= @PP_L_TERMS	
		WHERE	K_TERMS=@PP_K_TERMS

	-- =========================================================
GO

-- ===============================================
SET NOCOUNT ON
-- ===============================================
EXECUTE [dbo].[PG_CI_TERMS] 0, 0, '(TO DEFINE)' ,		'2DFNE', 10 , '' , 1
EXECUTE [dbo].[PG_CI_TERMS] 0, 1, 'CASH PAYMENT' ,		'CASHP', 10 , '' , 1
EXECUTE [dbo].[PG_CI_TERMS] 0, 2, 'CREDIT' ,			'CREDI', 10 , '' , 1
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TERMS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TERMS]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////