-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	[DATA_02Pruebas]
-- // MODULO:			FINANZAS CONCILIACION
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			FEG
-- // Fecha creación:	23/SEP/2020
-- //////////////////////////////////////////////////////////////  

USE [DATA_02]
GO

-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_CONCILIACION_ENTRADA_MATERIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_CONCILIACION_ENTRADA_MATERIAL]
GO
/* 
 EXEC	[dbo].[PG_PR_CONCILIACION_ENTRADA_MATERIAL] 0,0,    '2020/09/01' , '2020/10/07' , 'CHRYSLER NAPPA  TX7'  
*/
CREATE PROCEDURE [dbo].[PG_PR_CONCILIACION_ENTRADA_MATERIAL]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_F_INICIO					DATE,
	@PP_F_FIN						DATE,
	@PP_TYPE						VARCHAR(150)
	-- ===========================
AS
	
	DECLARE @VP_COLOR_PEARL VARCHAR(50) = @PP_TYPE --''

	--SELECT	TOP(1) @VP_COLOR_PEARL = PCOLOR
	--FROM	HIDESHDR_SQL
	--WHERE LTRIM(RTRIM(TYPE)) = @PP_TYPE

	-- //////////////SE CREA TABLA TEMPORAL PARA INGRESAR TOTALES/////////////////////////////
	DECLARE @VP_ENTRADA_PIEL_MHI_TBL AS TABLE(
			ID			INT	IDENTITY(1,1),
			TDATE		VARCHAR(50),
			TYPE		VARCHAR(50),
			COLOR		VARCHAR(50),
			HORSE		VARCHAR(50),
			CLOT		VARCHAR(50),
			PLOT		VARCHAR(50),
			THIDES		VARCHAR(50),
			TAREA		VARCHAR(50),
			AVGAREA		VARCHAR(50),
			STATUS		VARCHAR(50),
			PCOLOR		VARCHAR(50),
			INVOICE		VARCHAR(50)
		)

		DECLARE @VP_N_RESULTADO_BUSQUEDA INT = 0
		SELECT	@VP_N_RESULTADO_BUSQUEDA = COUNT(ID)
		FROM	HIDESHDR_SQL
		WHERE	dbo.CONVERT_INT_TO_DATE(CONVERT(INT,TDATE)) >= @PP_F_INICIO 
		AND		dbo.CONVERT_INT_TO_DATE(CONVERT(INT,TDATE)) <= @PP_F_FIN
		AND		LTRIM(RTRIM(PCOLOR)) = @VP_COLOR_PEARL
		--AND		LTRIM(RTRIM(TYPE)) = @PP_TYPE

		IF @VP_N_RESULTADO_BUSQUEDA > 0
			BEGIN
				-- //////////////SE DECLARAN LAS VARIABLES A USAR/////////////////////////////
				DECLARE @VP_TDATE	VARCHAR(50) = ''
				DECLARE @VP_TYPE	VARCHAR(50) = ''
				DECLARE @VP_COLOR	VARCHAR(50) = ''
				DECLARE @VP_CLOT	VARCHAR(50) = ''
				DECLARE @VP_PLOT	VARCHAR(50) = ''
				DECLARE @VP_STATUS	VARCHAR(50) = ''
				DECLARE @VP_PCOLOR	VARCHAR(50) = ''
				DECLARE @VP_THIDES	VARCHAR(50) = ''
				DECLARE @VP_TAREA	VARCHAR(50) = ''
				DECLARE @VP_AVGAREA	VARCHAR(50) = ''
				DECLARE @VP_INVOICE	VARCHAR(50) = ''
				-- ===========================
				DECLARE @VP_TDATE_ANTERIOR	VARCHAR(50) = ''
				DECLARE @VP_TYPE_ANTERIOR	VARCHAR(50) = ''
				DECLARE @VP_COLOR_ANTERIOR	VARCHAR(50) = ''
				DECLARE @VP_PLOT_ANTERIOR	VARCHAR(50) = ''
				DECLARE @VP_PLOT_CONTADOR		INT = 1

				-- //////////////SE CREA EL CURSOR/////////////////////////////
				DECLARE CU_ENTRADA_MATERIAL CURSOR 
				FOR SELECT	LTRIM(RTRIM(TDATE))		AS TDATE,
							LTRIM(RTRIM(TYPE))		AS TYPE,
							LTRIM(RTRIM(COLOR))		AS COLOR,
							CONCAT('K',SUBSTRING(LTRIM(RTRIM(PLOT)),1,(LEN(LTRIM(RTRIM(PLOT))) - 1)))		AS CLOT,
							LTRIM(RTRIM(PLOT))		AS PLOT,
							LTRIM(RTRIM(STATUS))	AS STATUS,
							LTRIM(RTRIM(PCOLOR))	AS PCOLOR,
							LTRIM(RTRIM(THIDES))	AS THIDES,
							LTRIM(RTRIM(TAREA))		AS TAREA,
							LTRIM(RTRIM(AVGAREA))	AS AVGAREA,
							LTRIM(RTRIM(INVOICE))	AS INVOICE
					FROM	HIDESHDR_SQL
					WHERE	dbo.CONVERT_INT_TO_DATE(CONVERT(INT,TDATE)) >= @PP_F_INICIO 
					AND		dbo.CONVERT_INT_TO_DATE(CONVERT(INT,TDATE)) <= @PP_F_FIN
					AND		LTRIM(RTRIM(PCOLOR)) = @VP_COLOR_PEARL
					--AND		LTRIM(RTRIM(TYPE)) = @PP_TYPE
					ORDER BY TDATE, PLOT --, TYPE, COLOR
				
				OPEN CU_ENTRADA_MATERIAL
				FETCH NEXT FROM CU_ENTRADA_MATERIAL INTO @VP_TDATE, @VP_TYPE, @VP_COLOR, @VP_CLOT, @VP_PLOT, @VP_STATUS, @VP_PCOLOR, @VP_THIDES, @VP_TAREA, @VP_AVGAREA, @VP_INVOICE
							
				-- ////////////////////SE RECORRE EL CURSOR//////////////////////////	
				WHILE @@FETCH_STATUS = 0
					BEGIN
						DECLARE @VP_N_ENTRADA_PIEL_MHI INT = 0
						SELECT @VP_N_ENTRADA_PIEL_MHI = COUNT(TDATE)
						FROM @VP_ENTRADA_PIEL_MHI_TBL

						IF @VP_N_ENTRADA_PIEL_MHI IS NULL 
							SET @VP_N_ENTRADA_PIEL_MHI = 0

						IF @VP_N_ENTRADA_PIEL_MHI > 0
							BEGIN
								DECLARE @VP_HORSE INT = 1

								--IF @VP_TYPE_ANTERIOR = @VP_TYPE AND @VP_PLOT_ANTERIOR = @VP_PLOT
								IF @VP_TDATE_ANTERIOR = @VP_TDATE AND @VP_PLOT_ANTERIOR = @VP_PLOT
									BEGIN
										SET @VP_PLOT_CONTADOR = @VP_PLOT_CONTADOR + 1
										SET @VP_HORSE = @VP_PLOT_CONTADOR
									END
								ELSE
									BEGIN
										SET @VP_PLOT_CONTADOR	= 1
									END

								--IF @VP_TYPE_ANTERIOR <> @VP_TYPE
								--	BEGIN
								--		SET @VP_PLOT_CONTADOR	= 1
								--		DECLARE @VP_TOTAL_HIDE	INT = 0
								--		DECLARE @VP_TOTAL_SQF	DECIMAL(13,2) = 0

								--		-- ////////////////////SE OBTINEN LOS TOTALES DE ESE TIPO//////////////////////////	
								--		SELECT	@VP_TOTAL_HIDE	= SUM(CONVERT(INT, LTRIM(RTRIM(THIDES)))),
								--				@VP_TOTAL_SQF	= SUM(CONVERT(DECIMAL(13,2), LTRIM(RTRIM(TAREA))))
								--		FROM HIDESHDR_SQL   
								--		WHERE LTRIM(RTRIM(TDATE)) =  @VP_TDATE_ANTERIOR
								--		AND LTRIM(RTRIM(TYPE)) = @VP_TYPE_ANTERIOR

								--		-- ////////////////////SE INGRESA EL REGISTRO EN @VP_ENTRADA_PIEL_MHI_TBL//////////////////////////	
								--		INSERT INTO @VP_ENTRADA_PIEL_MHI_TBL
								--			SELECT	'19990101', '', '', 
								--					'', '', 
								--					'Total Tipo por Dia:', @VP_TOTAL_HIDE, @VP_TOTAL_SQF, '',
								--					'', '', ''
								--	END

								IF @VP_TDATE_ANTERIOR <> @VP_TDATE
									BEGIN
										DECLARE @VP_TOTAL_HIDE	INT = 0
										DECLARE @VP_TOTAL_SQF	DECIMAL(13,2) = 0

										-- ////////////////////SE OBTINEN LOS TOTALES DE ESE TIPO//////////////////////////	
										SELECT	@VP_TOTAL_HIDE	= SUM(CONVERT(INT, LTRIM(RTRIM(THIDES)))),
												@VP_TOTAL_SQF	= SUM(CONVERT(DECIMAL(13,2), LTRIM(RTRIM(TAREA))))
										FROM HIDESHDR_SQL   
										WHERE LTRIM(RTRIM(TDATE)) =  @VP_TDATE_ANTERIOR
										AND		LTRIM(RTRIM(PCOLOR)) = @VP_COLOR_PEARL
										--AND LTRIM(RTRIM(TYPE)) = @VP_TYPE_ANTERIOR

										-- ////////////////////SE INGRESA EL REGISTRO EN @VP_ENTRADA_PIEL_MHI_TBL//////////////////////////	
										INSERT INTO @VP_ENTRADA_PIEL_MHI_TBL
											SELECT	'19990101', '', '', 
													'', '', 
													'Total Tipo por Dia:', @VP_TOTAL_HIDE, @VP_TOTAL_SQF, '',
													'', '', ''

											-- ////////////////////SE INGRESA EL REGISTRO EN @VP_ENTRADA_PIEL_MHI_TBL//////////////////////////	
										INSERT INTO @VP_ENTRADA_PIEL_MHI_TBL
											SELECT	'19990101', CONCAT('Dia: ', dbo.CONVERT_INT_TO_DATE(CONVERT(INT,@VP_TDATE))), '', 
													'', '', 
													'', '', '', 
													'', '', '', ''
									END
									-- ////////////////////SE INGRESA EL REGISTRO EN @VP_ENTRADA_PIEL_MHI_TBL//////////////////////////	
								INSERT INTO @VP_ENTRADA_PIEL_MHI_TBL
									SELECT	@VP_TDATE, @VP_TYPE, @VP_COLOR, 
											@VP_HORSE, @VP_CLOT, 
											@VP_PLOT, @VP_THIDES, @VP_TAREA, 
											@VP_AVGAREA, @VP_STATUS, @VP_PCOLOR, @VP_INVOICE

							END
						ELSE
							BEGIN
									INSERT INTO @VP_ENTRADA_PIEL_MHI_TBL
											SELECT	'19990101', CONCAT('Dia: ', dbo.CONVERT_INT_TO_DATE(CONVERT(INT,@VP_TDATE))), '', 
													'', '', 
													'', '', '', 
													'', '', '', ''
								-- ////////////////////SE INGRESA EL REGISTRO EN @VP_ENTRADA_PIEL_MHI_TBL//////////////////////////	
								INSERT INTO @VP_ENTRADA_PIEL_MHI_TBL
									SELECT	@VP_TDATE, @VP_TYPE, @VP_COLOR, 
											@VP_PLOT_CONTADOR, @VP_CLOT, 
											@VP_PLOT, @VP_THIDES, @VP_TAREA, 
											@VP_AVGAREA, @VP_STATUS, @VP_PCOLOR, @VP_INVOICE
							END

						-- ////////////////////SE ASIGNA LOS VALORES LAS VARIABLES//////////////////////////	
						SET @VP_TDATE_ANTERIOR = @VP_TDATE
						SET @VP_TYPE_ANTERIOR	= @VP_TYPE
						SET @VP_COLOR_ANTERIOR	= @VP_COLOR
						SET @VP_PLOT_ANTERIOR	= @VP_PLOT
						
						FETCH NEXT FROM CU_ENTRADA_MATERIAL INTO @VP_TDATE, @VP_TYPE, @VP_COLOR, @VP_CLOT, @VP_PLOT, @VP_STATUS, @VP_PCOLOR, @VP_THIDES, @VP_TAREA, @VP_AVGAREA, @VP_INVOICE
					END
					
				-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
				CLOSE CU_ENTRADA_MATERIAL
				DEALLOCATE CU_ENTRADA_MATERIAL

				-- ////////////////////SE OBTINEN LOS TOTALES DE ESE TIPO//////////////////////////	
				SELECT	@VP_TOTAL_HIDE	= SUM(CONVERT(INT,THIDES)),
						@VP_TOTAL_SQF	= SUM(CONVERT(DECIMAL(13,2),TAREA))
				FROM HIDESHDR_SQL   
				WHERE LTRIM(RTRIM(TDATE)) =  @VP_TDATE --dbo.CONVERT_INT_TO_DATE(CONVERT(INT,LDATE)) =  @PP_F_INICIO
				AND		LTRIM(RTRIM(PCOLOR)) = @VP_COLOR_PEARL
				--AND LTRIM(RTRIM(TYPE)) = @VP_TYPE_ANTERIOR

				-- ////////////////////SE INGRESA EL REGISTRO DEL ULTIMO TIPO EN @VP_ENTRADA_PIEL_MHI_TBL//////////////////////////	
				INSERT INTO @VP_ENTRADA_PIEL_MHI_TBL
					SELECT	'19990101', '', '', 
							'', '', 
							'Total Tipo por Dia:', @VP_TOTAL_HIDE, @VP_TOTAL_SQF, 
							'', '', '', ''

				-- ////////////////////SE INGRESA EL REGISTRO DE LA SUMA TOTAL DE LOS REGISTROS EN @VP_ENTRADA_PIEL_MHI_TBL//////////////////////////	
				DECLARE @VP_TOTAL_HIDE_GENERAL	INT = 0
				DECLARE @VP_TOTAL_SQF_GENERAL	DECIMAL(13,2) = 0
				
				SELECT	@VP_TOTAL_HIDE_GENERAL	= SUM(CONVERT(INT,THIDES)),
						@VP_TOTAL_SQF_GENERAL	= SUM(CONVERT(DECIMAL(13,2),TAREA))
				FROM HIDESHDR_SQL   
				WHERE	dbo.CONVERT_INT_TO_DATE(CONVERT(INT,TDATE)) >= @PP_F_INICIO 
				AND		dbo.CONVERT_INT_TO_DATE(CONVERT(INT,TDATE)) <= @PP_F_FIN
				AND		LTRIM(RTRIM(PCOLOR)) = @VP_COLOR_PEARL
				--AND		LTRIM(RTRIM(TYPE)) = @PP_TYPE

				INSERT INTO @VP_ENTRADA_PIEL_MHI_TBL

					SELECT	'19990101', '', '', 
							'', '', 
							'Total General:', @VP_TOTAL_HIDE_GENERAL, @VP_TOTAL_SQF_GENERAL, 
							'', '', '', ''

					
				-- ////////////////////SE OBTIENE VALORES POR LOTE PRIMERO UN REGISTRO VACIO Y LUEGO EL EMCABEZADO//////////////////////////
				INSERT INTO @VP_ENTRADA_PIEL_MHI_TBL
					SELECT	'19990101', '', '', 
							'', '', 
							'', '', '', 
							'', '', '', ''
				
				INSERT INTO @VP_ENTRADA_PIEL_MHI_TBL
				SELECT	'19990101', '', '', 'Type', 
						'Crust Lot #','AVG per Hide','# Hides', 'Qty SQF', 
						'', '', '', ''

				-- //////////////SE CREA EL CURSOR/////////////////////////////
				DECLARE @VP_TOTAL_HIDE_X_LOTE	INT = 0
				DECLARE @VP_TOTAL_SQF_LOTE	DECIMAL(13,2) = 0
				SET @VP_TYPE = ''
				SET @VP_CLOT = ''

				DECLARE CU_ENTRADA_LOTE_TOTAL CURSOR 
				FOR	SELECT	TYPE, 
							CLOT, 
							SUM(CONVERT(DECIMAL(13,4),THIDES)), 
							SUM(CONVERT(DECIMAL(13,4),TAREA))
					FROM	@VP_ENTRADA_PIEL_MHI_TBL
					WHERE TDATE <> '19990101'
					GROUP BY TYPE, CLOT
					ORDER BY TYPE, CLOT

				OPEN CU_ENTRADA_LOTE_TOTAL
					FETCH NEXT FROM CU_ENTRADA_LOTE_TOTAL INTO @VP_TYPE, @VP_CLOT, @VP_TOTAL_HIDE_X_LOTE, @VP_TOTAL_SQF_LOTE
								
				-- ////////////////////SE RECORRE EL CURSOR//////////////////////////	
				WHILE @@FETCH_STATUS = 0
					BEGIN
						DECLARE @VP_AVG_X_HIDE DECIMAL(13,2) = 0
						SET @VP_AVG_X_HIDE = CONVERT(DECIMAL(13,2), @VP_TOTAL_SQF_LOTE) / CONVERT(DECIMAL(13,2), @VP_TOTAL_HIDE_X_LOTE)

						INSERT INTO @VP_ENTRADA_PIEL_MHI_TBL
						SELECT	'19990101', '', '', @VP_TYPE, 
						@VP_CLOT, @VP_AVG_X_HIDE,@VP_TOTAL_HIDE_X_LOTE, @VP_TOTAL_SQF_LOTE, 
						'', '', '', ''

						FETCH NEXT FROM CU_ENTRADA_LOTE_TOTAL INTO @VP_TYPE, @VP_CLOT, @VP_TOTAL_HIDE_X_LOTE, @VP_TOTAL_SQF_LOTE
					END
						
				-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
				CLOSE CU_ENTRADA_LOTE_TOTAL
				DEALLOCATE CU_ENTRADA_LOTE_TOTAL
			END

		-- ////////////////////SE SELECCIONAN LOS VALORES INGRESADOS//////////////////////////	
		SELECT	CASE WHEN TDATE = '19990101' THEN ''
					ELSE TDATE END AS TDATE, 
				CASE WHEN TDATE = '19990101' THEN ''
					ELSE dbo.CONVERT_INT_TO_DATE(CONVERT(INT,TDATE)) END AS F_LLEGADA, 
				TYPE,	
				COLOR,	
				HORSE,	
				CLOT,	
				PLOT,
				THIDES,	
				TAREA,	
				AVGAREA,	
				STATUS,	
				PCOLOR,
				INVOICE
		FROM @VP_ENTRADA_PIEL_MHI_TBL
		ORDER BY ID ASC
	-- ////////////////////////////////////////////////
	-- ////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
