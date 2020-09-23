-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			ALL
-- // OPERATION:		TABLA
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200917
-- ////////////////////////////////////////////////////////////// 

-- USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ALERTA_COMPRAS]') AND type in (N'U'))
	DROP TABLE [dbo].[ALERTA_COMPRAS]
GO

-- //////////////////////////////////////////////////////////////
-- // ALERTA_COMPRAS
-- // TABLA QUE CONTIENE LOS TEMINOS POSIBLES DE COMPRA
-- //////////////////////////////////////////////////////////////
--	SELECT * FROM ALERTA_COMPRAS
CREATE TABLE [dbo].[ALERTA_COMPRAS] (
	[K_USUARIO]							[INT]				NOT NULL,
	[K_TIPO_NOTIFICACION]				[INT]				NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ALERTA_COMPRAS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ALERTA_COMPRAS]
GO

CREATE PROCEDURE [dbo].[PG_CI_ALERTA_COMPRAS]
	@PP_K_SISTEMA_EXE			INT,
	-- ========================================
	@PP_K_USUARIO_ACCION		INT,
	@PP_K_TIPO_NOTIFICACION		INT,
	@PP_DELETE					INT
AS	
	-- ===============================
	DECLARE @VP_K_EXIST	INT

	SELECT	@VP_K_EXIST =	K_USUARIO
							FROM	ALERTA_COMPRAS
							WHERE	K_USUARIO=@PP_K_USUARIO_ACCION
							AND		K_TIPO_NOTIFICACION=@PP_K_TIPO_NOTIFICACION
	-- ===============================
	IF @VP_K_EXIST IS NULL
	BEGIN
		INSERT INTO ALERTA_COMPRAS	
			(	K_USUARIO,				K_TIPO_NOTIFICACION		)		
		VALUES	
			(	@PP_K_USUARIO_ACCION,			@PP_K_TIPO_NOTIFICACION		)
	END
	ELSE
	BEGIN
		IF @PP_DELETE=1
		BEGIN
			DELETE FROM ALERTA_COMPRAS
			WHERE	K_USUARIO=@PP_K_USUARIO_ACCION
			AND		K_TIPO_NOTIFICACION=@PP_K_TIPO_NOTIFICACION
		END
	END

	-- =========================================================
GO

-- ===============================================
SET NOCOUNT ON
-- ===============================================
EXECUTE [dbo].[PG_CI_ALERTA_COMPRAS] 0, 139,	1,	0	--EMAIL
EXECUTE [dbo].[PG_CI_ALERTA_COMPRAS] 0, 139,	2,	1	--PEARL
EXECUTE [dbo].[PG_CI_ALERTA_COMPRAS] 0, 57,		1,	0
EXECUTE [dbo].[PG_CI_ALERTA_COMPRAS] 0, 57,		2,	1
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////