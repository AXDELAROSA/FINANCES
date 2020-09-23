-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	[BD_GENERAL]
-- // MODULO:			MENU
-- // OPERACION:		VERIFICAR ALERTAS
-- //////////////////////////////////////////////////////////////
-- // Autor:			AX
-- // Fecha creación:	20200917
-- ////////////////////////////////////////////////////////////// 

-- USE [BD_GENERAL] 
GO

-- //////////////////////////////////////////////////////////////
-- //	STORED PROCEDURE ---> PARA MOSTRAR ALERTAS 
-- //	DE ORDENES PENDIENTES.
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_ALERTAS_64]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_ALERTAS_64]
GO
--		 EXECUTE [dbo].[PG_SK_ALERTAS_64] 0,139,6004
CREATE PROCEDURE [dbo].[PG_SK_ALERTAS_64]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_GRUPO_APROBADOR			INT
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''	
	DECLARE @VP_EXISTE				INT
	DECLARE @VP_PENDIENTES			INT
	-- ///////////////////////////////////////////		
	SELECT		@VP_EXISTE=COUNT(K_USUARIO)
				-- =============================	
	FROM		BD_GENERAL.DBO.GRUPO_APROBADOR
				-- =============================
	WHERE		K_USUARIO=@PP_K_USUARIO_ACCION
	AND			K_TIPO_GRUPO_APROBADOR=@PP_K_GRUPO_APROBADOR
	AND			K_ESTATUS_GRUPO_APROBADOR=1

	IF @VP_EXISTE>0
	BEGIN
		IF	@PP_K_USUARIO_ACCION IN (57,139)
		BEGIN
			SELECT	@VP_PENDIENTES=COUNT(K_HEADER_PURCHASE_ORDER)
			FROM	COMPRAS.DBO.HEADER_PURCHASE_ORDER
			WHERE	K_STATUS_PURCHASE_ORDER=4
		END
		ELSE IF @PP_K_USUARIO_ACCION IN (62, 42, 44, 47, 56, 60, 139)
		BEGIN
			SELECT	@VP_PENDIENTES=COUNT(K_HEADER_PURCHASE_ORDER)
			FROM	COMPRAS.DBO.HEADER_PURCHASE_ORDER
			WHERE	K_STATUS_PURCHASE_ORDER=2
		END
	
		IF @VP_PENDIENTES>0
			BEGIN
				SET @VP_MENSAJE='EXISTEN ORDENES DE COMPRA POR AUTORIZAR'
			END
	END

	SELECT  @VP_MENSAJE AS MENSAJE
	-- ////////////////////////////////////////////////////////////////////
GO
