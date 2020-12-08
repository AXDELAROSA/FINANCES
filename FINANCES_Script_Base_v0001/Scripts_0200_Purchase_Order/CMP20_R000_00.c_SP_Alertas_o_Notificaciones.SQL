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
--		 EXECUTE [dbo].[PG_SK_ALERTAS_64] 0,41,6002
--		 EXECUTE [dbo].[PG_SK_ALERTAS_64] 0,41,6003
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
	
	IF	@PP_K_GRUPO_APROBADOR	=	6003
	BEGIN	
		SELECT		@VP_EXISTE=COUNT(K_USUARIO)
					-- =============================	
		FROM		BD_GENERAL.DBO.GRUPO_APROBADOR
					-- =============================
		WHERE		K_USUARIO=@PP_K_USUARIO_ACCION
		AND			K_TIPO_GRUPO_APROBADOR=@PP_K_GRUPO_APROBADOR
		AND			K_ESTATUS_GRUPO_APROBADOR=1

		IF @VP_EXISTE>0
		BEGIN
			IF	@PP_K_USUARIO_ACCION IN (57)	--(57,139)
			BEGIN
				SELECT	@VP_PENDIENTES=COUNT(K_HEADER_PURCHASE_ORDER)
				FROM	COMPRAS.DBO.HEADER_PURCHASE_ORDER
				WHERE	K_STATUS_PURCHASE_ORDER=4

			END
			ELSE IF @PP_K_USUARIO_ACCION IN (62, 42, 44, 47, 56, 60, 41)--, 139)
			BEGIN
				DECLARE	@VP_GERENTE INT

				SELECT @VP_GERENTE=
					(	CASE
								WHEN	@PP_K_USUARIO_ACCION=62 THEN	(7945)			-- RH					PATRICIACH
								WHEN	@PP_K_USUARIO_ACCION=44 THEN	(22)			-- PRODUCCION			GUILLERMOM
		-- CAMBIO_FIRMA			--WHEN	@PP_K_USUARIO_ACCION=44 THEN	(22)			-- PRODUCCION			GUILLERMOM
		-- CAMBIO_FIRMA			--WHEN	@PP_K_USUARIO_ACCION=156 THEN	(11928)			-- MANTENIMIENTO		OMARG	(156)
								WHEN	@PP_K_USUARIO_ACCION=56 THEN	(4475)			-- MATERIALES			MANUELG
								WHEN	@PP_K_USUARIO_ACCION=47 THEN	(1299)			-- CALIDAD				MIGUELC
								WHEN	@PP_K_USUARIO_ACCION=42 THEN	(181)			-- PROYECTOS			OMARD			
								WHEN	@PP_K_USUARIO_ACCION=41 THEN	(6142)			-- SISTEMAS				RAFAELF	(41)	
								WHEN	@PP_K_USUARIO_ACCION=60 THEN	(67)			-- FINANZAS				ADRIANAD
								--WHEN	@PP_K_USUARIO_ACCION= THEN	(52)			-- GERENTE				JORGEH
						END )

				SELECT	@VP_PENDIENTES=COUNT(K_HEADER_PURCHASE_ORDER)
				FROM	COMPRAS.DBO.HEADER_PURCHASE_ORDER
				WHERE	K_STATUS_PURCHASE_ORDER=2
				AND		K_APPROVED_BY=@VP_GERENTE
					
			END
		
			IF @VP_PENDIENTES>0
				BEGIN
					SET @VP_MENSAJE='EXISTEN ORDENES DE COMPRA POR AUTORIZAR'
				END
		END
	END
	SELECT  @VP_MENSAJE AS MENSAJE
	-- ////////////////////////////////////////////////////////////////////
GO
