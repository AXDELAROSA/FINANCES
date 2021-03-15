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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_MERMA_LOTE_COMPRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_MERMA_LOTE_COMPRADO]
GO

/*
 EXEC	[dbo].[PG_LI_MERMA_LOTE_COMPRADO] 0,144,  '' , '( TODOS )' , '2021/03/01' , '2021/03/15' 
*/

CREATE PROCEDURE [dbo].[PG_LI_MERMA_LOTE_COMPRADO]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_BUSCAR							VARCHAR(50),
	@PP_COLOR							VARCHAR(50),
	@PP_F_INICIO						DATE,
	@PP_F_FIN							DATE
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	DECLARE @TBL_REPORTE_MERMA_LOTE_COMPRADO AS TABLE(
		[K_MERMA_LOTE_COMPRADO]				INT,
		-- =============================	
		[NUMERO_FACTURA]					VARCHAR(50),		
		[COLOR]								VARCHAR(50),	
		D_COLOR								VARCHAR(150),		
		[LOT_CRUST]							VARCHAR(50),				
		[TOTAL_PIEL]						INT,			
		[TOTAL_SQFT]						DECIMAL(13,2),	
		[MEDIDA_PIEL_COMPRADA]				DECIMAL(13,2),	
		-- =============================
		[TOTAL_PIEL_RECIBIDA]				INT,
		[TOTAL_SQFT_RECIBIDO]				DECIMAL(13,2),
		[MEDIDA_PIEL_RECIBIDA]				DECIMAL(13,2),
		-- =============================		
		[COMENTARIO]						VARCHAR(255),
		[F_MERMA_LOTE_COMPRADO]				DATE,
		D_USUARIO_PEARL						VARCHAR(100)
		-- =============================	
	)

	-- ///////////////////////////////////////////
	INSERT INTO @TBL_REPORTE_MERMA_LOTE_COMPRADO
	SELECT
			[K_MERMA_LOTE_COMPRADO],
			-- =============================	
			[NUMERO_FACTURA],		
			[COLOR],	
			LTRIM(RTRIM(item_desc_1)) AS D_COLOR,		
			[LOT_CRUST],				
			[TOTAL_PIEL],			
			[TOTAL_SQFT],	
			CONVERT(DECIMAL(13,2),([TOTAL_SQFT] / [TOTAL_PIEL])),		
			-- =============================
			ISNULL( ( SELECT  SUM(CONVERT(INT, LTRIM(RTRIM(THIDES))))
			FROM HIDESHDR_SQL
			WHERE SUBSTRING(CLOT, 2, 6) LIKE '%' + SUBSTRING([LOT_CRUST], 2, 5) + '%' AND CUSTOMER <> 'XX'), 0) AS TOTAL_PIEL_RECIBIDA,
			-- =============================
			ISNULL( ( SELECT SUM(CONVERT(DECIMAL(13,2), LTRIM(RTRIM(TAREA)))) 
			FROM HIDESHDR_SQL
			WHERE SUBSTRING(CLOT, 2, 6) LIKE '%' + SUBSTRING([LOT_CRUST], 2, 5) + '%' AND CUSTOMER <> 'XX'), 0) AS TOTAL_SQFT_RECIBIDO,
			-- =============================		
			( CASE WHEN ISNULL( ( SELECT  SUM(CONVERT(INT, LTRIM(RTRIM(THIDES))))
								FROM HIDESHDR_SQL
								WHERE SUBSTRING(CLOT, 2, 6) LIKE '%' + SUBSTRING([LOT_CRUST], 2, 5) + '%' AND CUSTOMER <> 'XX'), 0) > 0 
					THEN ( ISNULL( ( SELECT SUM(CONVERT(DECIMAL(13,2), LTRIM(RTRIM(TAREA)))) 
									FROM HIDESHDR_SQL
									WHERE SUBSTRING(CLOT, 2, 6) LIKE '%' + SUBSTRING([LOT_CRUST], 2, 5) + '%' AND CUSTOMER <> 'XX'), 0) 
									/  
							ISNULL( ( SELECT  SUM(CONVERT(INT, LTRIM(RTRIM(THIDES))))
									FROM HIDESHDR_SQL
									WHERE SUBSTRING(CLOT, 2, 6) LIKE '%' + SUBSTRING([LOT_CRUST], 2, 5) + '%' AND CUSTOMER <> 'XX'), 0))
					ELSE 0 END ),
			-- =============================
			[COMENTARIO],
			CONVERT(DATE,[F_MERMA_LOTE_COMPRADO]) AS [F_MERMA_LOTE_COMPRADO],	
			D_USUARIO_PEARL
			-- =============================	
	FROM	[MERMA_LOTE_COMPRADO]
	INNER JOIN IMITMIDX_SQL ON	LTRIM(RTRIM(item_no)) = COLOR
	INNER JOIN BD_GENERAL.dbo.USUARIO_PEARL ON USUARIO_PEARL.K_USUARIO_PEARL = [MERMA_LOTE_COMPRADO].[K_USUARIO_CAMBIO]
	WHERE	(	NUMERO_FACTURA							LIKE '%'+@PP_BUSCAR+'%'
			OR	LOT_CRUST								LIKE '%'+@PP_BUSCAR+'%'  )
			-- =============================
	AND		( @PP_COLOR = '( TODOS )'		OR	COLOR = @PP_COLOR )
	-- =============================
	AND CONVERT(DATE,F_MERMA_LOTE_COMPRADO) >= @PP_F_INICIO
	AND	CONVERT(DATE,F_MERMA_LOTE_COMPRADO) <= @PP_F_FIN	
	-- =============================
	ORDER BY	COLOR, LOT_CRUST, F_MERMA_LOTE_COMPRADO

	-- ////////////////////////////////////////////////

	SELECT [K_MERMA_LOTE_COMPRADO],			
		   -- =============================
		   [NUMERO_FACTURA],				
		   [COLOR],							
		   D_COLOR,							
		   [LOT_CRUST],						
		   [TOTAL_PIEL],					
		   [TOTAL_SQFT],
		   [MEDIDA_PIEL_COMPRADA],				
		   -- =============================
		   [TOTAL_PIEL_RECIBIDA],				
		   [TOTAL_SQFT_RECIBIDO],				
		   [MEDIDA_PIEL_RECIBIDA],
		   -- =============================
		   ([TOTAL_PIEL] - TOTAL_PIEL_RECIBIDA) AS DIFERENCIA_EN_PIELES,
		   ( CASE WHEN [TOTAL_PIEL_RECIBIDA] > 0 
					THEN CONVERT(DECIMAL(13,2), (([MEDIDA_PIEL_COMPRADA] - [MEDIDA_PIEL_RECIBIDA]) / [MEDIDA_PIEL_COMPRADA]))
					ELSE 0 END ) AS DIFERENCIA_EN_SQF,
		    -- =============================
		   [COMENTARIO],					
		   [F_MERMA_LOTE_COMPRADO],			
		   D_USUARIO_PEARL					
		   -- =============================
	FROM @TBL_REPORTE_MERMA_LOTE_COMPRADO
	-- ////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_MERMA_LOTE_COMPRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_MERMA_LOTE_COMPRADO]
GO

/*
 EXEC	[dbo].[PG_SK_MERMA_LOTE_COMPRADO] 0,144, 1

*/

CREATE PROCEDURE [dbo].[PG_SK_MERMA_LOTE_COMPRADO]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_MERMA_LOTE_COMPRADO			INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////
	SELECT
			[K_MERMA_LOTE_COMPRADO],
			-- =====================
			[NUMERO_FACTURA],		
			[COLOR],					
			[LOT_CRUST],				
			[TOTAL_PIEL],			
			[TOTAL_SQFT],			
			-- =====================
			[COMENTARIO],
			CONVERT(DATE,[F_MERMA_LOTE_COMPRADO]) AS [F_MERMA_LOTE_COMPRADO],	
			D_USUARIO_PEARL
			-- =============================	
	FROM	[MERMA_LOTE_COMPRADO]
	INNER JOIN BD_GENERAL.dbo.USUARIO_PEARL ON USUARIO_PEARL.K_USUARIO_PEARL = [MERMA_LOTE_COMPRADO].[K_USUARIO_CAMBIO]
	WHERE	[K_MERMA_LOTE_COMPRADO] = @PP_K_MERMA_LOTE_COMPRADO

	-- ////////////////////////////////////////////////
	-- ////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_MERMA_LOTE_COMPRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_MERMA_LOTE_COMPRADO]
GO
-- EXEC [PG_IN_MERMA_LOTE_COMPRADO] 0,144,    '245/22' 
CREATE PROCEDURE [dbo].[PG_IN_MERMA_LOTE_COMPRADO]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_NUMERO_FACTURA					VARCHAR(50),
	@PP_COLOR							VARCHAR(50),
	@PP_LOT_CRUST						VARCHAR(50),		
	@PP_TOTAL_PIEL						INT,		
	@PP_TOTAL_SQFT						DECIMAL(13,2),
	@PP_COMENTARIO						VARCHAR(255)	
	-- ============================		
AS			

	DECLARE @VP_MENSAJE			VARCHAR(300)	= ''
	
	-- // SECCION#1 ////////////////////////////////////////////////////////// VALIDACIONES
		EXECUTE [dbo].[PG_RN_MERMA_LOTE_COMPRADO]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_COLOR, @PP_LOT_CRUST,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- // SECCION#2 ////////////////////////////////////////////////////////// ACCION A REALIZAR
	IF @VP_MENSAJE=''
		BEGIN
			BEGIN TRANSACTION 
			BEGIN TRY
				INSERT INTO [MERMA_LOTE_COMPRADO](	[NUMERO_FACTURA],		
												[COLOR],					.
												[LOT_CRUST],			
												[TOTAL_PIEL],			
												[TOTAL_SQFT],			
												-- =====================
												[COMENTARIO],
												[F_MERMA_LOTE_COMPRADO],
												-- ===========================
												[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
												[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )	
									VALUES(		@PP_NUMERO_FACTURA,
												@PP_COLOR,			
												@PP_LOT_CRUST,		
												@PP_TOTAL_PIEL,		
												@PP_TOTAL_SQFT,	
												@PP_COMENTARIO,
												GETDATE(),
												-- ===========================
												@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
												0, 0, NULL	)

				IF @@ROWCOUNT = 0
					RAISERROR ('ERROR: No es posible [Guardar] los datos del lote en la tabla [MERMA_LOTE_COMPRADO]:', 16, 1 ) --MENSAJE - Severity -State.
				-- //////////////////////////////////////////////////////////////

			COMMIT TRANSACTION 
			END TRY
	
			BEGIN CATCH
				/* Ocurrió un error, deshacemos los cambios*/ 
				ROLLBACK TRANSACTION
				DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
				SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
				SET @VP_MENSAJE = 'ERROR: //TRANSAC. PG_IN_MERMA_LOTE_COMPRADO // ' + @VP_ERROR_TRANS
			END CATCH
	
		END

	-- // SECCION#3 ////////////////////////////////////////////////////////// MENSAJE DE SALIDA
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		--SET		@VP_MENSAJE = 'No es posible [Guardar] el cobro de la Factura en [FACTURA_COBRADA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Lot.]' +  @PP_LOT_CRUST
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_LOT_CRUST AS CLAVE

	-- //////////////////////////////////////////////////////////////
	
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_MERMA_LOTE_COMPRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_MERMA_LOTE_COMPRADO]
GO
-- EXEC [PG_UP_MERMA_LOTE_COMPRADO] 0,144,    '245/22' 
CREATE PROCEDURE [dbo].[PG_UP_MERMA_LOTE_COMPRADO]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_MERMA_LOTE_COMPRADO			INT,
	@PP_NUMERO_FACTURA					VARCHAR(50),
	@PP_COLOR							VARCHAR(50),
	@PP_LOT_CRUST						VARCHAR(50),		
	@PP_TOTAL_PIEL						INT,		
	@PP_TOTAL_SQFT						DECIMAL(13,2),
	@PP_COMENTARIO						VARCHAR(255)		
	-- ============================		
AS			

	DECLARE @VP_MENSAJE			VARCHAR(300)	= ''
	
	-- // SECCION#2 ////////////////////////////////////////////////////////// ACCION A REALIZAR
	IF @VP_MENSAJE=''
		BEGIN
			BEGIN TRANSACTION 
			BEGIN TRY

				UPDATE [MERMA_LOTE_COMPRADO]	
					SET	[NUMERO_FACTURA]	= @PP_NUMERO_FACTURA,	
						[COLOR]				= @PP_COLOR,
						[LOT_CRUST]			= @PP_LOT_CRUST,			
						[TOTAL_PIEL]		= @PP_TOTAL_PIEL,			
						[TOTAL_SQFT]		= @PP_TOTAL_SQFT,		
						[COMENTARIO]		= @PP_COMENTARIO,
						-- ======================
						[K_USUARIO_CAMBIO]	= @PP_K_USUARIO_ACCION,
						[F_CAMBIO]			= GETDATE()
				WHERE K_MERMA_LOTE_COMPRADO = @PP_K_MERMA_LOTE_COMPRADO
							
				IF @@ROWCOUNT = 0
					RAISERROR ('ERROR: No es posible [Actualizar] los datos del lote en la tabla [MERMA_LOTE_COMPRADO]:', 16, 1 ) --MENSAJE - Severity -State.
				-- //////////////////////////////////////////////////////////////

			COMMIT TRANSACTION 
			END TRY
	
			BEGIN CATCH
				/* Ocurrió un error, deshacemos los cambios*/ 
				ROLLBACK TRANSACTION
				DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
				SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
				SET @VP_MENSAJE = 'ERROR: //TRANSAC. PG_UP_MERMA_LOTE_COMPRADO // ' + @VP_ERROR_TRANS
			END CATCH
	
		END

	-- // SECCION#3 ////////////////////////////////////////////////////////// MENSAJE DE SALIDA
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		--SET		@VP_MENSAJE = 'No es posible [Guardar] el cobro de la Factura en [FACTURA_COBRADA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Lot.]' +  @PP_LOT_CRUST
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_LOT_CRUST AS CLAVE

	-- //////////////////////////////////////////////////////////////
	
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_MERMA_LOTE_COMPRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_MERMA_LOTE_COMPRADO]
GO
-- EXEC [PG_DL_MERMA_LOTE_COMPRADO] 0,144,    1
CREATE PROCEDURE [dbo].[PG_DL_MERMA_LOTE_COMPRADO]
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_MERMA_LOTE_COMPRADO			INT
	-- ============================		
AS			

	DECLARE @VP_MENSAJE			VARCHAR(300)	= ''
	
	-- // SECCION#2 ////////////////////////////////////////////////////////// ACCION A REALIZAR
	IF @VP_MENSAJE=''
		BEGIN
			BEGIN TRANSACTION 
			BEGIN TRY
		
				DELETE MERMA_LOTE_COMPRADO 
				WHERE K_MERMA_LOTE_COMPRADO = @PP_K_MERMA_LOTE_COMPRADO

				IF @@ROWCOUNT = 0
					RAISERROR ('ERROR: No es posible [Eliminar] los datos del lote en la tabla [MERMA_LOTE_COMPRADO]:', 16, 1 ) --MENSAJE - Severity -State.
				-- //////////////////////////////////////////////////////////////

			COMMIT TRANSACTION 
			END TRY
	
			BEGIN CATCH
				/* Ocurrió un error, deshacemos los cambios*/ 
				ROLLBACK TRANSACTION
				DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
				SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
				SET @VP_MENSAJE = 'ERROR: //TRANSAC. PG_DL_MERMA_LOTE_COMPRADO // ' + @VP_ERROR_TRANS
			END CATCH
	
		END

	-- // SECCION#3 ////////////////////////////////////////////////////////// MENSAJE DE SALIDA
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		--SET		@VP_MENSAJE = 'No es posible [Guardar] el cobro de la Factura en [FACTURA_COBRADA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Id.]' + CONVERT(VARCHAR(10), @PP_K_MERMA_LOTE_COMPRADO)
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MERMA_LOTE_COMPRADO AS CLAVE

	-- //////////////////////////////////////////////////////////////
	
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
