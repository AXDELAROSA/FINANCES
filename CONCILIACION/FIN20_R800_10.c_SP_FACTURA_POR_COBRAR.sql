-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	[DATA_02Pruebas]
-- // MODULO:			EMBARQUES
-- // OPERACION:		LIBERACION / STORED PROCEDURES
-- //////////////////////////////////////////////////////////////
-- // Autor:			FEG
-- // Fecha creación:	16/11/2020
-- //////////////////////////////////////////////////////////////  

USE [DATA_02]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_OEHDRHST_SQL_FACTURA_POR_COBRAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_OEHDRHST_SQL_FACTURA_POR_COBRAR]
GO

/*
 EXEC	[dbo].[PG_LI_OEHDRHST_SQL_FACTURA_POR_COBRAR] 0,144, 554210, 'MAGN03', '2021/01/11' , '2021/01/11' 
 --'( TODOS )
 EXEC	[dbo].[PG_LI_OEHDRHST_SQL_FACTURA_POR_COBRAR] 0,144, 0 , '( TODOS )' , '2021/01/05' , '2021/01/05' 
*/

CREATE PROCEDURE [dbo].[PG_LI_OEHDRHST_SQL_FACTURA_POR_COBRAR]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_FACTURA							INT,
	@PP_CLIENTE							VARCHAR(10),
	@PP_F_INICIAL						DATE,
	@PP_F_FINAL							DATE

AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////
	IF @PP_FACTURA <> 0
		BEGIN
			SELECT	
					( CASE WHEN (	SELECT COUNT([K_FACTURA_COBRADA]) 
									FROM [FACTURA_COBRADA] 
									WHERE NUMERO_FACTURA = inv_no	) > 0 THEN 1 
							ELSE 0 END ) AS 'COBRADO',
					--===========================================
					LTRIM(RTRIM(CUS_NO))			AS CLIENTE,
					LTRIM(RTRIM(ORD_NO))			AS ORDEN_FACTURACION,
					LTRIM(RTRIM(OE_PO_NO))			AS PO,
					LTRIM(RTRIM(user_def_fld_5))	AS PACKING,
					Inv_NO							AS FACTURA,
					tot_sls_amt						AS TOTAL_FACTURA,
					LTRIM(RTRIM(AR_TERMS_CD))		AS DIA_CREDITO,
					CONVERT(VARCHAR(10), DBO.CONVERT_INT_TO_DATE(inv_dt)) AS F_FACTURA,
					UPPER(LTRIM(RTRIM([USER_NAME]))) AS USUARIO_FACTURA,
					--===========================================
					( CASE WHEN (	SELECT COUNT([K_FACTURA_COBRADA]) 
									FROM [FACTURA_COBRADA] 
									WHERE NUMERO_FACTURA = inv_no	) > 0 
								THEN (	SELECT CONVERT(VARCHAR(10), CONVERT(DATE,[F_FACTURA_COBRADA])) 
										FROM [FACTURA_COBRADA] 
										WHERE NUMERO_FACTURA = inv_no	)
						ELSE '-' END ) AS 'F_FACTURA_COBRADA',
					--===========================================
					ISNULL((	SELECT [D_USUARIO_PEARL] 
								FROM [FACTURA_COBRADA] 
								INNER JOIN BD_GENERAL.dbo.USUARIO_PEARL ON USUARIO_PEARL.K_USUARIO_PEARL = [FACTURA_COBRADA].[K_USUARIO_CAMBIO]
								WHERE NUMERO_FACTURA = inv_no
								), '-'	) AS 'USUARIO_COBRO'
					--===========================================
			FROM	OEHDRHST_SQL
			WHERE	INV_NO = @PP_FACTURA 
		END
	ELSE
		BEGIN
			SELECT	
					( CASE WHEN (	SELECT COUNT([K_FACTURA_COBRADA]) 
									FROM [FACTURA_COBRADA] 
									WHERE NUMERO_FACTURA = inv_no	) > 0 THEN 1 
							ELSE 0 END ) AS 'COBRADO',
					--===========================================
					LTRIM(RTRIM(CUS_NO))			AS CLIENTE,
					LTRIM(RTRIM(ORD_NO))			AS ORDEN_FACTURACION,
					LTRIM(RTRIM(OE_PO_NO))			AS PO,
					LTRIM(RTRIM(user_def_fld_5))	AS PACKING,
					Inv_NO							AS FACTURA,
					tot_sls_amt						AS TOTAL_FACTURA,
					LTRIM(RTRIM(AR_TERMS_CD))		AS DIA_CREDITO,
					CONVERT(VARCHAR(10), DBO.CONVERT_INT_TO_DATE(inv_dt)) AS F_FACTURA,
					UPPER(LTRIM(RTRIM([USER_NAME]))) AS USUARIO_FACTURA,
					--===========================================
					( CASE WHEN (	SELECT COUNT([K_FACTURA_COBRADA]) 
									FROM [FACTURA_COBRADA] 
									WHERE NUMERO_FACTURA = inv_no	) > 0 
								THEN (	SELECT CONVERT(VARCHAR(10), CONVERT(DATE,[F_FACTURA_COBRADA])) 
										FROM [FACTURA_COBRADA] 
										WHERE NUMERO_FACTURA = inv_no	)
							ELSE '-' END ) AS 'F_FACTURA_COBRADA',
					--===========================================
					ISNULL((	SELECT [D_USUARIO_PEARL] 
								FROM [FACTURA_COBRADA] 
								INNER JOIN BD_GENERAL.dbo.USUARIO_PEARL ON USUARIO_PEARL.K_USUARIO_PEARL = [FACTURA_COBRADA].[K_USUARIO_CAMBIO]
								WHERE NUMERO_FACTURA = inv_no
								), '-'	) AS 'USUARIO_COBRO'
					--===========================================
			FROM	OEHDRHST_SQL
			WHERE	( @PP_CLIENTE = '( TODOS )'		OR	cus_no = @PP_CLIENTE )
			AND		DBO.CONVERT_INT_TO_DATE(inv_dt) >= @PP_F_INICIAL
			AND		DBO.CONVERT_INT_TO_DATE(inv_dt) <= @PP_F_FINAL
			
							-- =============================
			ORDER BY	A4GLIdentity ASC
		END
	-- ////////////////////////////////////////////////
	-- ////////////////////////////////////////////////
GO





IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_OEHDRHST_SQL_FACTURA_POR_COBRAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_OEHDRHST_SQL_FACTURA_POR_COBRAR]
GO

/*
 EXEC	[dbo].[PG_SK_OEHDRHST_SQL_FACTURA_POR_COBRAR] 0,144, 554210
*/

CREATE PROCEDURE [dbo].[PG_SK_OEHDRHST_SQL_FACTURA_POR_COBRAR]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_FACTURA							INT

AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////
	SELECT	
			( CASE WHEN (	SELECT COUNT([K_FACTURA_COBRADA]) 
							FROM [FACTURA_COBRADA] 
							WHERE NUMERO_FACTURA = inv_no	) > 0 THEN 1 
					ELSE 0 END ) AS 'COBRADO',
			--===========================================
			LTRIM(RTRIM(CUS_NO))			AS CLIENTE,
			LTRIM(RTRIM(ORD_NO))			AS ORDEN_FACTURACION,
			LTRIM(RTRIM(OE_PO_NO))			AS PO,
			LTRIM(RTRIM(user_def_fld_5))	AS PACKING,
			Inv_NO							AS FACTURA,
			tot_sls_amt						AS TOTAL_FACTURA,
			LTRIM(RTRIM(AR_TERMS_CD))		AS DIA_CREDITO,
			CONVERT(VARCHAR(10), DBO.CONVERT_INT_TO_DATE(inv_dt)) AS F_FACTURA,
			UPPER(LTRIM(RTRIM([USER_NAME]))) AS USUARIO_FACTURA,
			--===========================================
			( CASE WHEN (	SELECT COUNT([K_FACTURA_COBRADA]) 
							FROM [FACTURA_COBRADA] 
							WHERE NUMERO_FACTURA = inv_no	) > 0 
						THEN (	SELECT CONVERT(VARCHAR(10), CONVERT(DATE,[F_FACTURA_COBRADA])) 
								FROM [FACTURA_COBRADA] 
								WHERE NUMERO_FACTURA = inv_no	)
				ELSE '-' END ) AS 'F_FACTURA_COBRADA',
			--===========================================
			ISNULL((	SELECT [D_USUARIO_PEARL] 
						FROM [FACTURA_COBRADA] 
						INNER JOIN BD_GENERAL.dbo.USUARIO_PEARL ON USUARIO_PEARL.K_USUARIO_PEARL = [FACTURA_COBRADA].[K_USUARIO_CAMBIO]
						WHERE NUMERO_FACTURA = inv_no
						), '-'	) AS 'USUARIO_COBRO'
			--===========================================
	FROM	OEHDRHST_SQL
	WHERE	INV_NO = @PP_FACTURA 
		
	-- ////////////////////////////////////////////////
	-- ////////////////////////////////////////////////
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_OELINHST_SQL_FACTURA_POR_COBRAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_OELINHST_SQL_FACTURA_POR_COBRAR]
GO

/*
 EXEC	[dbo].[PG_SK_OELINHST_SQL_FACTURA_POR_COBRAR] 0,144, 554210
*/

CREATE PROCEDURE [dbo].[PG_SK_OELINHST_SQL_FACTURA_POR_COBRAR]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_FACTURA							INT

AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////
	SELECT	INV_NO				AS FACTURA,
			CUS_NO				AS CLIENTE,
			LTRIM(RTRIM(ITEM_NO)) AS N_PEARL,
			LTRIM(RTRIM(cus_item_no)) AS N_CLIENTE,
			LTRIM(RTRIM(item_desc_1)) AS DESCRIPCION,
			qty_to_ship				AS CANTIDAD,
			UNIT_PRICE				AS PRECIO,
			SLS_AMT					AS TOTAL_NUMERO_PARTE
			--===========================================
	FROM	OELINHST_SQL
	WHERE	INV_NO = @PP_FACTURA 
		
	-- ////////////////////////////////////////////////
	-- ////////////////////////////////////////////////
GO






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_FACTURA_COBRADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_FACTURA_COBRADA]
GO
-- EXEC [PG_UP_ESTATUS_A_INGRESO_INVENTARIO_EMBARQUE] 0,144,    '245/22' 
CREATE PROCEDURE [dbo].[PG_IN_FACTURA_COBRADA]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_FACTURA							INT,
	@PP_F_COBRO							DATE
	-- ============================		
AS			

	DECLARE @VP_MENSAJE			VARCHAR(300)	= ''
	
	-- // SECCION#2 ////////////////////////////////////////////////////////// ACCION A REALIZAR
	IF @VP_MENSAJE=''
		BEGIN
			BEGIN TRANSACTION 
			BEGIN TRY
				-- /////////////SE INGRESA LA FACTURA_COBRADA//////////////////////////////
			
				INSERT INTO FACTURA_COBRADA(	[NUMERO_FACTURA], 
												[F_FACTURA_COBRADA],	
												-- ===========================
												[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
												[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )	
									VALUES(		@PP_FACTURA,
												@PP_F_COBRO,
												-- ===========================
												@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
												0, 0, NULL	)

				IF @@ROWCOUNT = 0
					RAISERROR ('ERROR: No es posible [Guardar] el cobro de la Factura en [FACTURA_COBRADA]:', 16, 1 ) --MENSAJE - Severity -State.
				-- //////////////////////////////////////////////////////////////

			COMMIT TRANSACTION 
			END TRY
	
			BEGIN CATCH
				/* Ocurrió un error, deshacemos los cambios*/ 
				ROLLBACK TRANSACTION
				DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
				SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
				SET @VP_MENSAJE = 'ERROR: //TRANSAC. PG_IN_FACTURA_COBRADA // ' + @VP_ERROR_TRANS
			END CATCH
	
		END

	-- // SECCION#3 ////////////////////////////////////////////////////////// MENSAJE DE SALIDA
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		--SET		@VP_MENSAJE = 'No es posible [Guardar] el cobro de la Factura en [FACTURA_COBRADA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#FACT.]' + CONVERT(VARCHAR(10), @PP_FACTURA)
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_FACTURA AS CLAVE

	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_FACTURA_COBRADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_FACTURA_COBRADA]
GO
-- EXEC [PG_UP_ESTATUS_A_INGRESO_INVENTARIO_EMBARQUE] 0,144,    '245/22' 
CREATE PROCEDURE [dbo].[PG_DL_FACTURA_COBRADA]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_FACTURA							INT
	-- ============================		
AS			

	DECLARE @VP_MENSAJE			VARCHAR(300)	= ''
	
	-- // SECCION#2 ////////////////////////////////////////////////////////// ACCION A REALIZAR
	IF @VP_MENSAJE=''
		BEGIN
			BEGIN TRANSACTION 
			BEGIN TRY
				-- /////////////SE INGRESA LA FACTURA_COBRADA//////////////////////////////
				DELETE FACTURA_COBRADA 
				WHERE NUMERO_FACTURA = @PP_FACTURA

				IF @@ROWCOUNT = 0
					RAISERROR ('ERROR: No es posible [Eliminar] el cobro de la Factura en [FACTURA_COBRADA]:', 16, 1 ) --MENSAJE - Severity -State.
				-- //////////////////////////////////////////////////////////////

			COMMIT TRANSACTION 
			END TRY
	
			BEGIN CATCH
				/* Ocurrió un error, deshacemos los cambios*/ 
				ROLLBACK TRANSACTION
				DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
				SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
				SET @VP_MENSAJE = 'ERROR: //TRANSAC. PG_DL_FACTURA_COBRADA // ' + @VP_ERROR_TRANS
			END CATCH
	
		END

	-- // SECCION#3 ////////////////////////////////////////////////////////// MENSAJE DE SALIDA
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		--SET		@VP_MENSAJE = 'No es posible [Guardar] el cobro de la Factura en [FACTURA_COBRADA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#FACT.]' + CONVERT(VARCHAR(10), @PP_FACTURA)
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_FACTURA AS CLAVE

	-- //////////////////////////////////////////////////////////////
	
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
