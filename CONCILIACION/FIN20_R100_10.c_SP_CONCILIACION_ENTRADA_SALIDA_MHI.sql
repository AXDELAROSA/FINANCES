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
 EXEC	[dbo].[PG_PR_CONCILIACION_ENTRADA_MATERIAL] 0,0,   '2020/09/01' , '2020/09/03' 
*/
CREATE PROCEDURE [dbo].[PG_PR_CONCILIACION_ENTRADA_MATERIAL]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_F_INICIO					DATE,
	@PP_F_FIN						DATE
	-- ===========================
AS
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
					ORDER BY TDATE, TYPE, COLOR
				
				OPEN CU_ENTRADA_MATERIAL
				FETCH NEXT FROM CU_ENTRADA_MATERIAL INTO @VP_TDATE, @VP_TYPE, @VP_COLOR, @VP_CLOT, @VP_PLOT, @VP_STATUS, @VP_PCOLOR, @VP_THIDES, @VP_TAREA, @VP_AVGAREA, @VP_INVOICE
							
	-- /		///////////////////SE RECORRE EL CURSOR//////////////////////////	
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

								IF @VP_TYPE_ANTERIOR = @VP_TYPE AND @VP_PLOT_ANTERIOR = @VP_PLOT
									BEGIN
										SET @VP_PLOT_CONTADOR = @VP_PLOT_CONTADOR + 1
										SET @VP_HORSE = @VP_PLOT_CONTADOR
									END
								ELSE
									BEGIN
										SET @VP_PLOT_CONTADOR	= 1
									END

								IF @VP_TYPE_ANTERIOR <> @VP_TYPE
									BEGIN
										SET @VP_PLOT_CONTADOR	= 1
										DECLARE @VP_TOTAL_HIDE	INT = 0
										DECLARE @VP_TOTAL_SQF	DECIMAL(13,2) = 0

										-- ////////////////////SE OBTINEN LOS TOTALES DE ESE TIPO//////////////////////////	
										SELECT	@VP_TOTAL_HIDE	= SUM(CONVERT(INT, LTRIM(RTRIM(THIDES)))),
												@VP_TOTAL_SQF	= SUM(CONVERT(DECIMAL(13,2), LTRIM(RTRIM(TAREA))))
										FROM HIDESHDR_SQL   
										WHERE LTRIM(RTRIM(TDATE)) =  @VP_TDATE_ANTERIOR
										AND LTRIM(RTRIM(TYPE)) = @VP_TYPE_ANTERIOR

										-- ////////////////////SE INGRESA EL REGISTRO EN @VP_ENTRADA_PIEL_MHI_TBL//////////////////////////	
										INSERT INTO @VP_ENTRADA_PIEL_MHI_TBL
											SELECT	'19990101', '', '', 
													'', '', 
													'Total Tipo por Dia:', @VP_TOTAL_HIDE, @VP_TOTAL_SQF, '',
													'', '', ''
									END

								IF @VP_TDATE_ANTERIOR <> @VP_TDATE
									BEGIN
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
				AND LTRIM(RTRIM(TYPE)) = @VP_TYPE_ANTERIOR

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
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL]
GO
/* 
 EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL] 0,0,   '2020/07/01', '2020/07/30', '2015 WK KL'
*/
CREATE PROCEDURE [dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_F_INICIO					DATE,
	@PP_F_FIN						DATE,
	@PP_PROGRAMA					VARCHAR(50)
	-- ===========================
AS
	
	-- //////////////SE CREA TABLA TEMPORAL PARA INGRESAR TOTALES/////////////////////////////
	DECLARE @VP_SALIDA_PIEL_MHI_TBL AS TABLE(
			ID				INT	IDENTITY(1,1),
			CDATE			VARCHAR(50),
			PROD_CAT_DESC	VARCHAR(50),
			TYPE			VARCHAR(50),
			PART_NO			VARCHAR(50),
			CUS_PART_NO		VARCHAR(50),
			PRICE			VARCHAR(50),
			QTY				VARCHAR(50),
			INV_NO			VARCHAR(50),
			PACKING_NO		VARCHAR(50)
			
		)

		DECLARE @VP_N_RESULTADO_BUSQUEDA INT = 0
		SELECT	@VP_N_RESULTADO_BUSQUEDA = COUNT(ID)
		FROM	pf_schst
		INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
		WHERE	TYPE='e' 
		AND		CDATE >= @PP_F_INICIO
		AND		CDATE <= @PP_F_FIN
		AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = @PP_PROGRAMA

		IF @VP_N_RESULTADO_BUSQUEDA > 0
			BEGIN
				-- //////////////SE DECLARAN LAS VARIABLES A USAR/////////////////////////////
				DECLARE @VP_CDATE			VARCHAR(50) = ''
				DECLARE @VP_PROD_CAT_DESC	VARCHAR(50) = ''
				DECLARE @VP_TYPE			VARCHAR(50) = ''
				DECLARE @VP_PART_NO			VARCHAR(50) = ''
				DECLARE @VP_CUS_PART_NO		VARCHAR(50) = ''
				DECLARE @VP_QTY				VARCHAR(50) = ''
				DECLARE @VP_PACKING_NO		VARCHAR(50) = ''
				DECLARE @VP_INV_NO			VARCHAR(50) = ''
				-- ===========================
				DECLARE @VP_CDATE_ANTERIOR			VARCHAR(50) = ''
				DECLARE @VP_PROD_CAT_DESC_ANTERIOR	VARCHAR(50) = ''
				DECLARE @VP_TYPE_ANTERIOR			VARCHAR(50) = ''
				DECLARE @VP_PACKING_NO_ANTERIOR		VARCHAR(50) = ''
				DECLARE @VP_INV_NO_ANTERIOR			VARCHAR(50) = ''

				-- //////////////SE CREA EL CURSOR/////////////////////////////
				DECLARE CU_SALIDA_MATERIAL CURSOR 
				FOR SELECT	CONVERT(DATE, CDATE) CDATE, 
						LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) AS PROD_CAT_DESC, 
						LTRIM(RTRIM(item_desc_1)) AS TYPE, 
						LTRIM(RTRIM(pf_schst.part_no)) AS PART_NO, 
						LTRIM(RTRIM(pf_schst.cus_part_no)) AS CUS_PART_NO, 
						SUM(qty) AS QTY, 
						ISNULL(LTRIM(RTRIM(packing_no)), '') AS PACKING_NO,
						ISNULL(LTRIM(RTRIM(inv_no)), 'N/F') AS INV_NO
				FROM pf_schst 
				INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(item_no)) = CONCAT('F', SUBSTRING(part_no, (LEN(LTRIM(RTRIM(part_no))) - 5), 6))
				INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
				WHERE TYPE='e' 
				AND CDATE >= @PP_F_INICIO
				AND CDATE <= @PP_F_FIN
				AND	(	packing_no IS NOT NULL
							OR inv_no IS NOT NULL )
				AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = @PP_PROGRAMA
				GROUP BY	CDATE, LTRIM(RTRIM(part_no)), LTRIM(RTRIM(cus_part_no)), 
							LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)),  LTRIM(RTRIM(packing_no)), 
							LTRIM(RTRIM(inv_no)), LTRIM(RTRIM(item_desc_1))
				ORDER BY	LTRIM(RTRIM(item_desc_1)), LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)), 
							CDATE, LTRIM(RTRIM(packing_no)), LTRIM(RTRIM(inv_no))  ,
							LTRIM(RTRIM(part_no)), LTRIM(RTRIM(cus_part_no)) ASC
				
				OPEN CU_SALIDA_MATERIAL
				FETCH NEXT FROM CU_SALIDA_MATERIAL INTO @VP_CDATE, @VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO, @VP_QTY, @VP_PACKING_NO, @VP_INV_NO			
											
				-- ////////////////////SE RECORRE EL CURSOR//////////////////////////	
				WHILE @@FETCH_STATUS = 0
					BEGIN
						IF @VP_PACKING_NO = ''
							SET @VP_PACKING_NO = @VP_INV_NO

						DECLARE @VP_N_SALIDA_PIEL_MHI INT = 0
						SELECT @VP_N_SALIDA_PIEL_MHI = COUNT(CDATE)
						FROM @VP_SALIDA_PIEL_MHI_TBL

						DECLARE @VP_PRICE DECIMAL(13,2) = 0
						IF @VP_INV_NO = 'N/F'
							SELECT TOP 1 @VP_PRICE = prc_or_disc_1 
							FROM OEPRCFIL_SQL 
							WHERE SUBSTRING(filler_0001,CHARINDEX(@VP_PART_NO, OEPRCFIL_SQL.filler_0001),25) = @VP_PART_NO 

						IF @VP_INV_NO <> 'N/F'
							SELECT @VP_PRICE =  CONVERT(VARCHAR(10), ISNULL(unit_price, 0))
							FROM OELINHST_SQL 
							WHERE CONVERT(VARCHAR(15),OELINHST_SQL.inv_no) = @VP_INV_NO
												AND OELINHST_SQL.cus_item_no = @VP_CUS_PART_NO
							ORDER BY A4GLIdentity DESC

						IF @VP_N_SALIDA_PIEL_MHI IS NULL 
							SET @VP_N_SALIDA_PIEL_MHI = 0

						IF @VP_N_SALIDA_PIEL_MHI > 0
							BEGIN
								IF (  @VP_INV_NO_ANTERIOR <> @VP_INV_NO )
									BEGIN
										IF @VP_INV_NO_ANTERIOR <> 'N/F'
											BEGIN
												DECLARE @VP_TOTAL_INV_NO	DECIMAL(13,2) = 0

												-- ////////////////////SE OBTINEN LOS TOTALES DE ESE TIPO//////////////////////////	
												SELECT @VP_TOTAL_INV_NO = tot_sls_amt 
												FROM OEHDRHST_SQL 
												WHERE LTRIM(RTRIM(inv_no)) = @VP_INV_NO_ANTERIOR

												-- ////////////////////SE INGRESA EL REGISTRO EN @VP_SALIDA_PIEL_MHI_TBL//////////////////////////	
												INSERT INTO @VP_SALIDA_PIEL_MHI_TBL
												SELECT	'1999-01-01', '', '', '', '', '', 'Total Factura:', @VP_TOTAL_INV_NO, ''
											END
										ELSE
											BEGIN
												INSERT INTO @VP_SALIDA_PIEL_MHI_TBL
												SELECT	'1999-01-01', '', '', '', '', '','', '', ''
											END
									END

								IF @VP_CDATE_ANTERIOR <> @VP_CDATE
									BEGIN
										IF @VP_PROD_CAT_DESC_ANTERIOR <> @VP_PROD_CAT_DESC
											BEGIN
												INSERT INTO @VP_SALIDA_PIEL_MHI_TBL
													SELECT	'1999-01-01', CONCAT('Dia: ', (CONVERT(DATE,@VP_CDATE))), CONCAT('Programa: ', @VP_PROD_CAT_DESC), '', '','', '', '', ''
											END
										ELSE
											BEGIN
												INSERT INTO @VP_SALIDA_PIEL_MHI_TBL
													SELECT	'1999-01-01', CONCAT('Dia: ', (CONVERT(DATE,@VP_CDATE))), '', '', '', '', '', '', ''
											END
									END

								-- ////////////////////SE INGRESA EL REGISTRO EN @VP_SALIDA_PIEL_MHI_TBL//////////////////////////	
								INSERT INTO @VP_SALIDA_PIEL_MHI_TBL
									SELECT	@VP_CDATE, @VP_PROD_CAT_DESC, 
											@VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO,  
											@VP_PRICE, @VP_QTY, @VP_INV_NO, @VP_PACKING_NO

							END
						ELSE
							BEGIN
								INSERT INTO @VP_SALIDA_PIEL_MHI_TBL
									SELECT	'1999-01-01', CONCAT('Dia: ', (CONVERT(DATE,@VP_CDATE))), CONCAT('Programa: ', @VP_PROD_CAT_DESC), '', '', '', '', '', ''

								-- ////////////////////SE INGRESA EL REGISTRO EN @VP_SALIDA_PIEL_MHI_TBL//////////////////////////	
								INSERT INTO @VP_SALIDA_PIEL_MHI_TBL
									SELECT	@VP_CDATE, @VP_PROD_CAT_DESC, 
											@VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO,
											@VP_PRICE, @VP_QTY, @VP_INV_NO, @VP_PACKING_NO
							END

						-- ////////////////////SE ASIGNA LOS VALORES LAS VARIABLES//////////////////////////	
						SET @VP_CDATE_ANTERIOR			= @VP_CDATE
						SET @VP_PROD_CAT_DESC_ANTERIOR	= @VP_PROD_CAT_DESC
						SET @VP_TYPE_ANTERIOR			= @VP_TYPE
						SET @VP_PACKING_NO_ANTERIOR		= @VP_PACKING_NO
						SET @VP_INV_NO_ANTERIOR			= @VP_INV_NO
						
						FETCH NEXT FROM CU_SALIDA_MATERIAL INTO @VP_CDATE, @VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO, @VP_QTY, @VP_PACKING_NO, @VP_INV_NO			
					END
					
				-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
				CLOSE CU_SALIDA_MATERIAL
				DEALLOCATE CU_SALIDA_MATERIAL

			IF ( @VP_INV_NO_ANTERIOR IS NOT NULL )
				BEGIN
					-- ////////////////////SE OBTINEN LOS TOTALES DE ESE TIPO//////////////////////////	
					SELECT @VP_TOTAL_INV_NO = tot_sls_amt 
					FROM OEHDRHST_SQL 
					WHERE LTRIM(RTRIM(inv_no)) = @VP_INV_NO_ANTERIOR

					-- ////////////////////SE INGRESA EL REGISTRO EN @VP_SALIDA_PIEL_MHI_TBL//////////////////////////	
					INSERT INTO @VP_SALIDA_PIEL_MHI_TBL
					SELECT	'1999-01-01', '', '', '', '', '', 'Total Factura:', @VP_TOTAL_INV_NO, ''
				END

			-- ////////////////////SE INGRESAN UN REGISTRO VACIO PARA DESPUES INGRESAR TOTALES//////////////////////////
			INSERT INTO @VP_SALIDA_PIEL_MHI_TBL
						SELECT	'1999-01-01', '','', '', '', '', '', '', ''

			-- ////////////////////SE INGRESAN LOS TOTALES POR PROGRAMA//////////////////////////	
			--SET @VP_PROD_CAT_DESC	= '' 
			--SET @VP_QTY				= ''
				
			--DECLARE CU_TOTAL_SALIDA_MATERIAL CURSOR 
			--FOR SELECT	DISTINCT PROD_CAT_DESC
			--	FROM @VP_SALIDA_PIEL_MHI_TBL 
			--	WHERE CDATE <> '19990101'

			--OPEN CU_TOTAL_SALIDA_MATERIAL
			--FETCH NEXT FROM CU_TOTAL_SALIDA_MATERIAL INTO @VP_PROD_CAT_DESC		
											
			-- ////////////////////SE RECORRE EL CURSOR//////////////////////////	
			--WHILE @@FETCH_STATUS = 0
			--	BEGIN
					INSERT INTO @VP_SALIDA_PIEL_MHI_TBL
						SELECT	'1999-01-01', 'Programa', 'Type', 'Part No.', 'Cust Part No.', 'Total Qty', '', '', ''

					INSERT INTO @VP_SALIDA_PIEL_MHI_TBL
					SELECT	'1999-01-01',
							LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) AS PROD_CAT_DESC, 
							LTRIM(RTRIM(IMITMIDX_SQL.item_desc_1)) AS TYPE, 
							LTRIM(RTRIM(pf_schst.part_no)) AS PART_NO, 
							LTRIM(RTRIM(pf_schst.cus_part_no)) AS CUS_PART_NO, 
							SUM(pf_schst.qty) AS QTY,
							'',
							'',
							''
					FROM pf_schst
					INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(item_no)) = CONCAT('F', SUBSTRING(part_no, (LEN(LTRIM(RTRIM(part_no))) - 5), 6))
					INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
					WHERE pf_schst.TYPE='e' 
					AND pf_schst.CDATE >= @PP_F_INICIO
					AND pf_schst.CDATE <= @PP_F_FIN
					AND	(	pf_schst.packing_no IS NOT NULL
								OR pf_schst.inv_no IS NOT NULL )
					AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = @PP_PROGRAMA
					GROUP BY	LTRIM(RTRIM(pf_schst.part_no)), LTRIM(RTRIM(pf_schst.cus_part_no)), 
								LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)),  LTRIM(RTRIM(IMITMIDX_SQL.item_desc_1))
					ORDER BY	LTRIM(RTRIM(pf_schst.cus_part_no)) ASC

					-- ////////////////////SE OPTIENE EL TOTAL DE los kist PARA EL PROGRAMA//////////////////////////	
				
						SELECT	@VP_QTY = SUM(qty)
								FROM pf_schst
								INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
								WHERE TYPE='e' 
								AND CDATE >= @PP_F_INICIO
								AND CDATE <= @PP_F_FIN
								AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = @PP_PROGRAMA

						INSERT INTO @VP_SALIDA_PIEL_MHI_TBL
					SELECT		'1999-01-01', '','', '', 'Total Kits por Programa:', @VP_QTY, '', '', ''

					-- ////////////////////SE OPTIENE EL TOTAL DE LA FACTURA POR PROGRAMA//////////////////////////	
					DECLARE @VP_TOTAL_FACTURA_X_PROGRAMA AS DECIMAL(13,2) = 0
					SELECT @VP_TOTAL_FACTURA_X_PROGRAMA = SUM(tot_sls_amt)
					FROM OEHDRHST_SQL 
					WHERE inv_no IN (	SELECT DISTINCT  CONVERT(INT,LTRIM(RTRIM(pf_schst.inv_no)))
										FROM pf_schst
										INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
										WHERE TYPE='e' 
										AND CDATE >= @PP_F_INICIO
										AND CDATE <= @PP_F_FIN
										AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = @PP_PROGRAMA)

					INSERT INTO @VP_SALIDA_PIEL_MHI_TBL
						SELECT	'1999-01-01', '','', '', 'Total Factura por Programa:', @VP_TOTAL_FACTURA_X_PROGRAMA, '', '', ''

					--INSERT INTO @VP_SALIDA_PIEL_MHI_TBL
					--	SELECT	'19990101', '','', '', '', '''', '', ''
					
			--		FETCH NEXT FROM CU_TOTAL_SALIDA_MATERIAL INTO @VP_PROD_CAT_DESC	
			--	END
					
			--	-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
			--	CLOSE CU_TOTAL_SALIDA_MATERIAL
			--	DEALLOCATE CU_TOTAL_SALIDA_MATERIAL
			END

		-- ////////////////////SE SELECCIONAN LOS VALORES INGRESADOS//////////////////////////	
		SELECT	CDATE,			
				PROD_CAT_DESC,	
				TYPE,			
				PART_NO,		 
				CUS_PART_NO,	
				PRICE,
				QTY,
				INV_NO,				
				PACKING_NO		
		FROM @VP_SALIDA_PIEL_MHI_TBL AS SALIDA
		ORDER BY ID ASC
	-- ////////////////////////////////////////////////
	-- ////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
