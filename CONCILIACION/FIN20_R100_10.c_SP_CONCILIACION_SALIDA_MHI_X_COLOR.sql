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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR]
GO

/* 
	EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR] 0,0,  '2020/07/01' , '2020/07/30' , '2015 WK KL' , 'CHRYSLER NAPPA DX9' 

	EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR] 0,0, '2020/08/01', '2020/08/31', 'WK GLDL', 'CHRYSLER NAPPA DX9'
	EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR] 0,0, '2020/08/01', '2020/08/31', 'WK GLDL', 'CHRYSLER NAPPA HL1'
	EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR] 0,0, '2020/08/01', '2020/08/31', 'WK GLDL', 'CHRYSLER NAPPA LT5'

*/
CREATE PROCEDURE [dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_F_INICIO					DATE,
	@PP_F_FIN						DATE,
	@PP_PROGRAMA					VARCHAR(50),
	@PP_COLOR						VARCHAR(150)
	-- ===========================
AS
	
	-- //////////////SE CREA TABLA TEMPORAL PARA INGRESAR TOTALES/////////////////////////////
	CREATE TABLE #SALIDA_MATERIAL_MHI(
			ID				INT	IDENTITY(1,1),
			PROD_CAT_DESC	VARCHAR(150) DEFAULT '',
			TYPE			VARCHAR(150) DEFAULT '',
			PART_NO			VARCHAR(150) DEFAULT '',
			CUS_PART_NO		VARCHAR(150) DEFAULT '',
			NET_AREA		VARCHAR(150) DEFAULT '',
			DIA				VARCHAR(150) DEFAULT '',
			PACKING			VARCHAR(150) DEFAULT '',
			QTY				VARCHAR(150) DEFAULT '',
			MOUNT			VARCHAR(150) DEFAULT '',
			PRECIO			VARCHAR(150) DEFAULT '',
			ACUMULADO		VARCHAR(150) DEFAULT '',
			INVOICE			VARCHAR(150) DEFAULT ''
		)
		SET NOCOUNT ON

		-- //////////////SE DECLARAN LAS VARIABLES A USAR/////////////////////////////
		DECLARE @VP_CUS_PART_NO_PRINCIPAL VARCHAR(50) = '', @VP_PROD_CAT_DESC_PRINCIPAL VARCHAR(50) = '', @VP_TYPE_PRINCIPAL VARCHAR(50) = ''
		DECLARE @VP_CUS_PART_NO	VARCHAR(50) = '', @VP_CDATE	VARCHAR(50) = '', @VP_PROD_CAT_DESC	VARCHAR(50) = '', @VP_TYPE VARCHAR(50) = ''
		DECLARE  @VP_PART_NO VARCHAR(50) = '', @VP_QTY VARCHAR(50) = '', @VP_PACKING_NO	VARCHAR(50) = '', @VP_INV_NO VARCHAR(50) = ''
		-- ===========================
		DECLARE	@VP_TOTAL_INV_NO DECIMAL(13,2) = 0, @VP_AMOUNT VARCHAR(15) = '', @VP_NET_AREA DECIMAL(13,5) = 0

		-- //////////////SE CREA EL CURSOR/////////////////////////////
		DECLARE CU_SALIDA_MATERIAL CURSOR 
		FOR SELECT	DISTINCT LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)), LTRIM(RTRIM(item_desc_1)), LTRIM(RTRIM(pf_schst.cus_part_no)) AS CUS_PART_NO
			FROM pf_schst 
			-- ===========================
			INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
					AND LTRIM(RTRIM(PROD_CAT_DESC)) <> 'DO NOT DELETE'
					AND LTRIM(RTRIM(PROD_CAT_DESC)) <> 'OBSOLETE'
			-- ===========================
			INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(item_no)) = CONCAT('F', SUBSTRING(part_no, (LEN(LTRIM(RTRIM(part_no))) - 5), 6))
					AND SUBSTRING(LTRIM(RTRIM(item_no)),1,1) = 'F'
			-- ===========================
			WHERE TYPE = 'e' -- ENBARCADO
			AND CDATE >= @PP_F_INICIO
			AND CDATE <= @PP_F_FIN	
			AND	(	packing_no IS NOT NULL
						OR inv_no IS NOT NULL )
			AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = @PP_PROGRAMA
			AND LTRIM(RTRIM(item_desc_1)) = @PP_COLOR
			ORDER BY	LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)), 
						LTRIM(RTRIM(item_desc_1)),
						LTRIM(RTRIM(pf_schst.cus_part_no)) ASC
			SET NOCOUNT ON
		
		OPEN CU_SALIDA_MATERIAL
		FETCH NEXT FROM CU_SALIDA_MATERIAL INTO @VP_PROD_CAT_DESC_PRINCIPAL, @VP_TYPE_PRINCIPAL, @VP_CUS_PART_NO_PRINCIPAL		
									
		-- ////////////////////SE RECORRE EL CURSOR//////////////////////////	
		WHILE @@FETCH_STATUS = 0
			BEGIN
				DECLARE CU_SALIDA_MATERIAL_X_DIA CURSOR 
				FOR SELECT	CONVERT(DATE, CDATE2) CDATE, 
							LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) AS PROD_CAT_DESC, 
							LTRIM(RTRIM(item_desc_1)) AS TYPE, 
							LTRIM(RTRIM(pf_schst.part_no)) AS PART_NO, 
							LTRIM(RTRIM(pf_schst.cus_part_no)) AS CUS_PART_NO, 
							SUM(qty) AS QTY, 
							--ISNULL(LTRIM(RTRIM(packing_no)), '') AS PACKING_NO,
							CASE WHEN ISNULL(LTRIM(RTRIM(inv_no)), '') = '' THEN ISNULL(LTRIM(RTRIM(packing_no)), '')
								ELSE ISNULL(LTRIM(RTRIM(inv_no)), '') END AS PACKING_NO ,
							ISNULL(LTRIM(RTRIM(inv_no)), 'N/F') AS INV_NO
					FROM pf_schst 
					INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(item_no)) = CONCAT('F', SUBSTRING(part_no, (LEN(LTRIM(RTRIM(part_no))) - 5), 6))
					AND SUBSTRING(LTRIM(RTRIM(item_no)), 1,1) = 'F'
					INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
					AND LTRIM(RTRIM(PROD_CAT_DESC)) <> 'DO NOT DELETE'
					AND LTRIM(RTRIM(PROD_CAT_DESC)) <> 'OBSOLETE'
					WHERE TYPE = 'e' -- ENBARCADO
					AND CDATE >= @PP_F_INICIO
					AND CDATE <= @PP_F_FIN	
					AND	(	packing_no IS NOT NULL
								OR inv_no IS NOT NULL )
					AND LTRIM(RTRIM(pf_schst.cus_part_no)) = @VP_CUS_PART_NO_PRINCIPAL
					AND LTRIM(RTRIM(item_desc_1)) = @VP_TYPE_PRINCIPAL
					AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = @VP_PROD_CAT_DESC_PRINCIPAL
					GROUP BY	CDATE2, LTRIM(RTRIM(part_no)), LTRIM(RTRIM(cus_part_no)), 
								LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)),  LTRIM(RTRIM(packing_no)), 
								LTRIM(RTRIM(inv_no)), LTRIM(RTRIM(item_desc_1))
					ORDER BY	LTRIM(RTRIM(item_desc_1)), LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)), 
								CDATE2, LTRIM(RTRIM(packing_no)), LTRIM(RTRIM(inv_no)),
								LTRIM(RTRIM(part_no)), LTRIM(RTRIM(cus_part_no)) ASC
				SET NOCOUNT ON

				OPEN CU_SALIDA_MATERIAL_X_DIA
				FETCH NEXT FROM CU_SALIDA_MATERIAL_X_DIA INTO @VP_CDATE, @VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO, @VP_QTY, @VP_PACKING_NO, @VP_INV_NO			
									
				-- ////////////////////SE RECORRE EL CURSOR//////////////////////////	
				WHILE @@FETCH_STATUS = 0
					BEGIN
						-- ///////////SE INICIALIZAN LAS VARIABLES/////////////////////////////////////
						DECLARE @VP_PACKING_ORIGINAL VARCHAR(150) = @VP_PACKING_NO

						SET @VP_TOTAL_INV_NO = 0
						SET @VP_AMOUNT = ''

						-- ///////////SE ASIGNA EL PACKING/////////////////////////////////////
						IF @VP_PACKING_NO = ''
							SET @VP_PACKING_NO = @VP_INV_NO

						-- ///////////SE OBTIENE EL TOTAL DE LA FACTURA/////////////////////////////////////
						IF @VP_INV_NO <> 'N/F'
							BEGIN
								SELECT @VP_TOTAL_INV_NO = SUM(qty_to_ship * unit_price)
								FROM OELINHST_SQL 
								WHERE inv_no = @VP_INV_NO
								AND  LTRIM(RTRIM(item_desc_2)) = @VP_TYPE
								SET NOCOUNT ON

								SET @VP_AMOUNT =  CONVERT(VARCHAR(15),@VP_TOTAL_INV_NO)

								SELECT	TOP 1 @VP_PACKING_ORIGINAL = ISNULL(packing_no, '')
								FROM pf_schst 
								INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(item_no)) = CONCAT('F', SUBSTRING(part_no, (LEN(LTRIM(RTRIM(part_no))) - 5), 6))
								AND SUBSTRING(LTRIM(RTRIM(item_no)),1,1) = 'F'
								WHERE TYPE = 'e' -- ENBARCADO
								AND CDATE >= @PP_F_INICIO
								AND CDATE <= @PP_F_FIN	
								AND	(	packing_no IS NOT NULL
											OR inv_no IS NOT NULL )
								AND LTRIM(RTRIM(item_desc_1)) = @VP_TYPE_PRINCIPAL
								AND inv_no = @VP_INV_NO
							END								

						-- /////////SE OBTIENE EL PRECIO DEL NUMERO DE PARTE///////////////////////////////////////
						DECLARE @VP_PRECIO_CUS_PART_NO DECIMAL(13,2) = 0
						IF @VP_INV_NO <> 'N/F'
							BEGIN
								SELECT @VP_PRECIO_CUS_PART_NO = Unit_price
								FROM OELINHST_SQL 
								WHERE inv_no = @VP_INV_NO
								AND  LTRIM(RTRIM(item_desc_2)) = @VP_TYPE
								AND LTRIM(RTRIM(CUS_ITEM_NO)) = @VP_CUS_PART_NO
								SET NOCOUNT ON

								IF @VP_PRECIO_CUS_PART_NO IS NULL 
									SET @VP_PRECIO_CUS_PART_NO = 0

							END
						ELSE
							BEGIN
								SELECT TOP 1 @VP_PRECIO_CUS_PART_NO = prc_or_disc_1 
								FROM OEPRCFIL_SQL WHERE LTRIM(RTRIM(filler_0001)) LIKE '%'+ @VP_PART_NO +'%' 
								ORDER BY END_DT DESC

								IF @VP_PRECIO_CUS_PART_NO IS NULL 
									SET @VP_PRECIO_CUS_PART_NO = 0
							END

						SELECT   @VP_NET_AREA = ISNULL(cube_width, 0) 
						FROM IMITMIDX_SQL
						WHERE LTRIM(RTRIM(item_no)) = @VP_PART_NO	
						
						---- ////////////////////////////////////////////////
						IF @VP_INV_NO <> 'N/F' AND @VP_PRECIO_CUS_PART_NO = 0
							SET @VP_PRECIO_CUS_PART_NO = 0
						ELSE
						INSERT INTO	#SALIDA_MATERIAL_MHI(
															PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO, NET_AREA,
															DIA, PACKING, QTY, MOUNT, PRECIO, INVOICE
														)
												VALUES(
															@VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO, @VP_NET_AREA,
															@VP_CDATE, @VP_PACKING_NO, @VP_QTY, @VP_AMOUNT, @VP_PRECIO_CUS_PART_NO, @VP_PACKING_ORIGINAL
														)
			
						FETCH NEXT FROM CU_SALIDA_MATERIAL_X_DIA INTO @VP_CDATE, @VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO, @VP_QTY, @VP_PACKING_NO, @VP_INV_NO			
					END

					DECLARE @VP_TOTAL_QTY INT = 0
					SELECT @VP_TOTAL_QTY = SUM(CONVERT(INT, ISNULL(QTY, '0'))) 
					FROM #SALIDA_MATERIAL_MHI AS SALIDA
					WHERE CUS_PART_NO = @VP_CUS_PART_NO
					
					IF @VP_TOTAL_QTY IS NULL
						SET @VP_TOTAL_QTY = 0

					UPDATE #SALIDA_MATERIAL_MHI
						SET ACUMULADO = @VP_TOTAL_QTY
					WHERE CUS_PART_NO = @VP_CUS_PART_NO
					 
				-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
				CLOSE CU_SALIDA_MATERIAL_X_DIA
				DEALLOCATE CU_SALIDA_MATERIAL_X_DIA									

				FETCH NEXT FROM CU_SALIDA_MATERIAL INTO @VP_PROD_CAT_DESC_PRINCIPAL, @VP_TYPE_PRINCIPAL, @VP_CUS_PART_NO_PRINCIPAL				
			END
			
		-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
		CLOSE CU_SALIDA_MATERIAL
		DEALLOCATE CU_SALIDA_MATERIAL

		-- ////////////////////SE VALIDA SI HAY RESULTADOS EN LA BUSQUEDA//////////////////////////
		DECLARE @VP_N_MATERIAL_SALIDA INT = 0

		--SELECT *
		--FROM #SALIDA_MATERIAL_MHI
		--WHERE CUS_PART_NO = '201025A'
		--ORDER BY DIA,PACKING

		SELECT @VP_N_MATERIAL_SALIDA = COUNT(ID) 
		FROM #SALIDA_MATERIAL_MHI

		IF @VP_N_MATERIAL_SALIDA IS NULL
			SET @VP_N_MATERIAL_SALIDA = 0

		IF @VP_N_MATERIAL_SALIDA > 0
			BEGIN
				-- ////////////////////SE OBTIENEN LOS DATOS DE LOS PACKING DINAMICAMENTE QUE SE CONVERTIRAN EN LAS COLUMNAS DE LA TABLA//////////////////////////	
				DECLARE @cols1 AS NVARCHAR(MAX), @query1 AS NVARCHAR(MAX), @query AS NVARCHAR(MAX), @query2 AS NVARCHAR(MAX), @query3 AS NVARCHAR(MAX)
				select @cols1 = STUFF(( SELECT ',' + QUOTENAME(PACKING) 
										FROM #SALIDA_MATERIAL_MHI 
										--WHERE TYPE = 'CHRYSLER NAPPA DX9'
										GROUP BY DIA,PACKING
										ORDER BY DIA,PACKING
										FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') ,1,1,'' ) 									 										 			
											 			
				SET @query1 = N'SELECT  ''''  PROD_CAT_DESC,  ''''  TYPE, ''DATE''  PART_NO, '''' NET_AREA, '''' YIELD, ''''  CUS_PART_NO, '''' PRECIO, '''' ACUMULADO, ' + @cols1 + N' into [tempdb].[dbo].[FECHA]  from ( SELECT  DIA, PACKING from #SALIDA_MATERIAL_MHI group by  DIA, PACKING ) x pivot ( MAX(DIA) for PACKING in (' + @cols1 + N') ) p ' 
				EXEC sp_executesql @query1;			
				
				SET @query2 = N'SELECT   ''''  PROD_CAT_DESC,  ''''  TYPE, ''PACKING''  PART_NO, '''' NET_AREA, '''' YIELD, ''''  CUS_PART_NO, '''' PRECIO, '''' ACUMULADO, ' + @cols1 + N' into [tempdb].[dbo].[PACKING]  from ( SELECT  INVOICE, PACKING from #SALIDA_MATERIAL_MHI group by  DIA, PACKING, INVOICE) x pivot ( MAX(INVOICE) for PACKING in (' + @cols1 + N') ) p ' 
				EXEC sp_executesql @query2;		 			
											 			
				SET @query2 = N'SELECT   ''''  PROD_CAT_DESC,  ''''  TYPE, ''INVOICE''  PART_NO, '''' NET_AREA, '''' YIELD, ''''  CUS_PART_NO, '''' PRECIO, '''' ACUMULADO, ' + @cols1 + N' into [tempdb].[dbo].[INVOICE]  from ( SELECT  PACKING AS PACKING_NO, PACKING from #SALIDA_MATERIAL_MHI group by  DIA, PACKING) x pivot ( MAX(PACKING_NO) for PACKING in (' + @cols1 + N') ) p ' 
				EXEC sp_executesql @query2;
								 										 								 			
				SET @query3 = N'SELECT  ''''  PROD_CAT_DESC,  ''''  TYPE, ''AMOUNT''  PART_NO, '''' NET_AREA, '''' YIELD,  ''''  CUS_PART_NO, '''' PRECIO, '''' ACUMULADO, ' + @cols1 + N' into [tempdb].[dbo].[AMOUNT]  from ( SELECT  MOUNT, PACKING from #SALIDA_MATERIAL_MHI group by  DIA, PACKING, MOUNT ) x pivot ( MAX(MOUNT) for PACKING in (' + @cols1 + N') ) p ' 
				EXEC sp_executesql @query3;

				SET @query = N'SELECT PROD_CAT_DESC, TYPE, PART_NO,  NET_AREA, ''          '' YIELD,  CUS_PART_NO,  PRECIO, ACUMULADO, ' + @cols1 + N' into [tempdb].[dbo].[QTY_KIT]  from ( SELECT PROD_CAT_DESC, TYPE, PART_NO, NET_AREA, CUS_PART_NO, PRECIO, ACUMULADO,  QTY, PACKING from #SALIDA_MATERIAL_MHI ) x pivot ( MAX(QTY) for PACKING in (' + @cols1 + N') ) p ' 
				EXEC sp_executesql @query;

				-- ///////SE CREA TABLA TEMPORAL [TOTALES] CON DATOS DE TABLA TEMPORAL [QTY_KIT]/////////////////////////////////////////
				SELECT * INTO [tempdb].[dbo].[TOTALES] FROM [tempdb].[dbo].[QTY_KIT]
				SET NOCOUNT ON
				  
				-- ///////SE BORRAN LOS DATOS DE TABLA TEMPORAL [TOTALES]/////////////////////////////////////////
				DELETE [tempdb].[dbo].[TOTALES]
				SET NOCOUNT ON

				-- ///////SE COPIAN LOS DATOS DE TABLA TEMPORAL [FECHA] A [TOTALES]/////////////////////////////////////////
				INSERT INTO [tempdb].[dbo].[TOTALES]
				SELECT * FROM [tempdb].[dbo].[FECHA]
				SET NOCOUNT ON

				-- ///////SE COPIAN LOS DATOS DE TABLA TEMPORAL [INVOICE] A [TOTALES]/////////////////////////////////////////
				INSERT INTO [tempdb].[dbo].[TOTALES]
				SELECT * FROM [tempdb].[dbo].[PACKING] 
				SET NOCOUNT ON

				-- ///////SE COPIAN LOS DATOS DE TABLA TEMPORAL [INVOICE] A [TOTALES]/////////////////////////////////////////
				INSERT INTO [tempdb].[dbo].[TOTALES]
				SELECT * FROM [tempdb].[dbo].[INVOICE] 
				SET NOCOUNT ON

				-- ///////SE COPIAN LOS DATOS DE TABLA TEMPORAL [AMOUNT] A [TOTALES]/////////////////////////////////////////
				INSERT INTO [tempdb].[dbo].[TOTALES]
				SELECT * FROM [tempdb].[dbo].[AMOUNT] 
				SET NOCOUNT ON

				-- ///////SE COPIAN LOS DATOS DE TABLA TEMPORAL [QTY_KIT] A [TOTALES]/////////////////////////////////////////
				INSERT INTO [tempdb].[dbo].[TOTALES]
				SELECT * FROM [tempdb].[dbo].[QTY_KIT] ORDER BY CUS_PART_NO ASC
				SET NOCOUNT ON

				-- ///////SE OBTIENE EL TOTAL DE LAS FACTURAS/////////////////////////////////////////
				DECLARE @VP_TOTAL_FACTURA DECIMAL(13,2) = 0
				SELECT	@VP_TOTAL_FACTURA = SUM(qty_to_ship * unit_price)
				FROM OELINHST_SQL 
				WHERE INV_NO IN (	SELECT DISTINCT PACKING FROM #SALIDA_MATERIAL_MHI
									WHERE --TYPE = 'CHRYSLER NAPPA DX9'
									--AND 
									PACKING NOT LIKE '%-%' )
				AND LTRIM(RTRIM(item_desc_2)) = @PP_COLOR
				 SET NOCOUNT ON

				IF @VP_TOTAL_FACTURA IS NULL 
					SET @VP_TOTAL_FACTURA = 0

				-- ///////SE ACTUALIZA EL CAMPO DE TOTALES CON EL VALOR DE LAS FACTURAS/////////////////////////////////////////
				UPDATE [tempdb].[dbo].[TOTALES]
					SET ACUMULADO = @VP_TOTAL_FACTURA
				WHERE PART_NO = 'AMOUNT'
				SET NOCOUNT ON

				-- //////////SE OBTIENE EL COLOR DEL NUMERO DE PARTE//////////////////////////////////////
				DECLARE @VP_COLOR VARCHAR(50) = ''
				SELECT TOP 1 @VP_COLOR = LTRIM(RTRIM(PART_NO)) 
				FROM #SALIDA_MATERIAL_MHI 
				--WHERE TYPE = 'CHRYSLER NAPPA DX9'
				SET NOCOUNT ON
										
				-- //////////SE CREA TABLA TEMPORAL PARA OBTENER DATOS DEL CORTE DEL COLOR//////////////////////////////////////
				DECLARE @VP_PIELES_CORTADAS_X_MES_X_COLOR_TBL TABLE(
					ID				INT IDENTITY(1,1),
					JOBNO			VARCHAR(20),
					LOTE			VARCHAR(50),
					HIDESQM			DECIMAL(13,4),
					PATTERNSQM		DECIMAL(13,4),
					HIDES			INT,
					COLOR			VARCHAR(50),
					LOWUTILCD		VARCHAR(10)
				)
				SET NOCOUNT ON

				-- //////////SE OBTENEN DATOS DEL CORTE DEL COLOR EN LA FECHA ESPECIFICADA//////////////////////////////////////
				INSERT INTO @VP_PIELES_CORTADAS_X_MES_X_COLOR_TBL
				SELECT DISTINCT  cccuthst_sql.jobno, cccuthst_sql.lotno, cccuthst_sql.hidesqm, cccuthst_sql.patternsqm, cccuthst_sql.hides, cccuthst_sql.colour, cccuthst_sql.Lowutilcd
				        FROM cccuthst_sql INNER JOIN ccjobhst_sql ON cccuthst_sql.jobno = ccjobhst_sql.jobno
							WHERE	ccjobhst_sql.datecompleted >=[dbo].[CONVERT_DATE_TO_INT](@PP_F_INICIO,'yyyyMMdd') 
						AND		ccjobhst_sql.datecompleted <= [dbo].[CONVERT_DATE_TO_INT](@PP_F_FIN,'yyyyMMdd') 
				AND		LTRIM(RTRIM(cccuthst_sql.colour)) = CONCAT('F', SUBSTRING(@VP_COLOR, LEN(@VP_COLOR) -5 ,6 ))
				AND cccuthst_sql.hidesqm <> 0
				SET NOCOUNT ON

				DECLARE @VP_N_PIEL INT= 0 
				SELECT @VP_N_PIEL = COUNT(HIDES)
				FROM @VP_PIELES_CORTADAS_X_MES_X_COLOR_TBL
				WHERE ROUND((( patternsqm /  hidesqm) * 100) ,0) >= 1

				-- //////////SE OBTENEN EL TOTSL SQM USADO//////////////////////////////////////
				DECLARE @VP_TOTAL_SQM_USADO DECIMAL(13,2) = 0
				SELECT  @VP_TOTAL_SQM_USADO = @VP_TOTAL_SQM_USADO + ROUND(((patternsqm / hidesqm) * 100) ,0) 
				FROM @VP_PIELES_CORTADAS_X_MES_X_COLOR_TBL
				WHERE ROUND((( patternsqm /  hidesqm) * 100) ,0) >= 1

				-- //////////SE BORRA EL CONTENIDO DE LA TABLA TEMPORAL//////////////////////////////////////
				DELETE @VP_PIELES_CORTADAS_X_MES_X_COLOR_TBL
				SET NOCOUNT ON

				-- //////////SE OBTIENE LA UTILIZACION//////////////////////////////////////
				DECLARE @VP_UTILIZACION DECIMAL(13,2) = @VP_TOTAL_SQM_USADO / @VP_N_PIEL

				-- ////////SE ACTUALIZA LA UTILIZACION PARA EL COLOR////////////////////////////////////////
				UPDATE	[tempdb].[dbo].[TOTALES]
					SET YIELD = CONVERT(VARCHAR(5),@VP_UTILIZACION)
				WHERE PART_NO = 'AMOUNT'
				SET NOCOUNT ON

				-- //////////////SE CREA EL CURSOR/////////////////////////////
				SET @VP_NET_AREA = 0
				SET @VP_CUS_PART_NO = ''
				DECLARE @VP_ACUMULADO INT = 0
				DECLARE @VP_TOTAL_PACKING INT = 0

				DECLARE CU_YIELD CURSOR 
				FOR SELECT	CUS_PART_NO, CONVERT(DECIMAL(13,5), NET_AREA) AS NET_AREA, CONVERT(INT, ACUMULADO) AS ACUMULADO
					FROM [tempdb].[dbo].[TOTALES] 
					WHERE CUS_PART_NO <> ''
					-- ===========================

				OPEN CU_YIELD
				FETCH NEXT FROM CU_YIELD INTO @VP_CUS_PART_NO, @VP_NET_AREA, @VP_ACUMULADO
									
				-- ////////////////////SE RECORRE EL CURSOR//////////////////////////	
				WHILE @@FETCH_STATUS = 0
					BEGIN						
						SET @VP_TOTAL_PACKING = @VP_TOTAL_PACKING + @VP_ACUMULADO

						DECLARE @VP_YIELD DECIMAL (13,2) = 0
						SET @VP_YIELD = ( @VP_NET_AREA / @VP_UTILIZACION * 100 ) * @VP_ACUMULADO

						UPDATE [tempdb].[dbo].[TOTALES] 
							SET YIELD = CONVERT(VARCHAR(15), @VP_YIELD)
						WHERE CUS_PART_NO = @VP_CUS_PART_NO
						SET NOCOUNT ON

						FETCH NEXT FROM CU_YIELD INTO @VP_CUS_PART_NO, @VP_NET_AREA, @VP_ACUMULADO			
					END
			
				-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
				CLOSE CU_YIELD
				DEALLOCATE CU_YIELD
				
				UPDATE [tempdb].[dbo].[TOTALES] 
					SET ACUMULADO = CONVERT(VARCHAR(15), @VP_TOTAL_PACKING)
				WHERE PART_NO = 'PACKING'
				SET NOCOUNT ON

				-- ////////SE SELECCIONANA EL CONTENIDO DE LA TABLA TEMPORAL TOTALES////////////////////////////////////////
				SELECT * FROM [tempdb].[dbo].[TOTALES] ORDER BY CUS_PART_NO

				-- ////////SE BORRAN LAS TABLAS TEMPORALES////////////////////////////////////////
				DROP TABLE [tempdb].[dbo].[FECHA]
				SET NOCOUNT ON

				DROP TABLE [tempdb].[dbo].[PACKING]
				SET NOCOUNT ON

				DROP TABLE [tempdb].[dbo].[INVOICE]
				SET NOCOUNT ON

				DROP TABLE [tempdb].[dbo].[AMOUNT]
				SET NOCOUNT ON

				DROP TABLE [tempdb].[dbo].[QTY_KIT]
				SET NOCOUNT ON

				DROP TABLE [tempdb].[dbo].[TOTALES]
				SET NOCOUNT ON

				DROP TABLE #SALIDA_MATERIAL_MHI
				SET NOCOUNT ON
			END
		--ELSE
		--	BEGIN
		--		SELECT ''
		--	END
	-- ////////////////////////////////////////////////

	 /*
	 USE DATA_02PRUEBAS
	 EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR] 0,0, '2020/11/01', '2020/11/30', '2015 WK KL', 'CAPRI BLACK DX9'

	 EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR] 0,0, '2020/08/01', '2020/08/30', 'WK GLDL', 'CHRYSLER NAPPA DX9'
	 EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR] 0,0, '2020/11/01', '2020/11/30', 'WK GLDL', 'CHRYSLER NAPPA HL1'
	 EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR] 0,0, '2020/11/01', '2020/11/30', 'WK GLDL', 'CHRYSLER NAPPA LT5'
				
	*/
	-- ////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
