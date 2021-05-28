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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR_TEST]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR_TEST]
GO

/* 
	EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR_TEST] 0,0,  '2020/12/22' , '2020/12/22' , 'RU PINNACLE' , 'CHRYSLER NAPPA RU LK5' 
	EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR_TEST] 0,0, '2020/08/01', '2020/08/31', 'WK GLDL', 'CHRYSLER NAPPA DX9'
	EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR_TEST] 0,0, '2020/08/01', '2020/08/31', 'WK GLDL', 'CHRYSLER NAPPA HL1'
	EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR_TEST] 0,0, '2020/08/01', '2020/08/31', 'WK GLDL', 'CHRYSLER NAPPA LT5'

*/
CREATE PROCEDURE [dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR_TEST]
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
	CREATE TABLE #SALIDA_MATERIAL_MHI_V2(
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
		DECLARE CU_SALIDA_MATERIAL_V2 CURSOR 
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
		
		OPEN CU_SALIDA_MATERIAL_V2
		FETCH NEXT FROM CU_SALIDA_MATERIAL_V2 INTO @VP_PROD_CAT_DESC_PRINCIPAL, @VP_TYPE_PRINCIPAL, @VP_CUS_PART_NO_PRINCIPAL		
									
		-- ////////////////////SE RECORRE EL CURSOR//////////////////////////	
		WHILE @@FETCH_STATUS = 0
			BEGIN
				DECLARE CU_SALIDA_MATERIAL_V2_X_DIA CURSOR 
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

				OPEN CU_SALIDA_MATERIAL_V2_X_DIA
				FETCH NEXT FROM CU_SALIDA_MATERIAL_V2_X_DIA INTO @VP_CDATE, @VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO, @VP_QTY, @VP_PACKING_NO, @VP_INV_NO			
									
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
						INSERT INTO	#SALIDA_MATERIAL_MHI_V2(
															PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO, NET_AREA,
															DIA, PACKING, QTY, MOUNT, PRECIO, INVOICE
														)
												VALUES(
															@VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO, @VP_NET_AREA,
															@VP_CDATE, @VP_PACKING_NO, @VP_QTY, @VP_AMOUNT, @VP_PRECIO_CUS_PART_NO, @VP_PACKING_ORIGINAL
														)
			
						FETCH NEXT FROM CU_SALIDA_MATERIAL_V2_X_DIA INTO @VP_CDATE, @VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO, @VP_QTY, @VP_PACKING_NO, @VP_INV_NO			
					END

					DECLARE @VP_TOTAL_QTY INT = 0
					SELECT @VP_TOTAL_QTY = SUM(CONVERT(INT, ISNULL(QTY, '0'))) 
					FROM #SALIDA_MATERIAL_MHI_V2 AS SALIDA
					WHERE CUS_PART_NO = @VP_CUS_PART_NO
					
					IF @VP_TOTAL_QTY IS NULL
						SET @VP_TOTAL_QTY = 0

					UPDATE #SALIDA_MATERIAL_MHI_V2
						SET ACUMULADO = @VP_TOTAL_QTY
					WHERE CUS_PART_NO = @VP_CUS_PART_NO
					 
				-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
				CLOSE CU_SALIDA_MATERIAL_V2_X_DIA
				DEALLOCATE CU_SALIDA_MATERIAL_V2_X_DIA									

				FETCH NEXT FROM CU_SALIDA_MATERIAL_V2 INTO @VP_PROD_CAT_DESC_PRINCIPAL, @VP_TYPE_PRINCIPAL, @VP_CUS_PART_NO_PRINCIPAL				
			END
			
		-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
		CLOSE CU_SALIDA_MATERIAL_V2
		DEALLOCATE CU_SALIDA_MATERIAL_V2


		-- //////////////SE CREA EL CURSOR PARA RECORRER LA TABLA DE INVENTARIO/////////////////////////////
		DECLARE CU_SALIDA_MATERIAL_V3 CURSOR 
		FOR SELECT	DISTINCT LTRIM(RTRIM(INVENTARIO_EMBARQUE.D_PROD_CAT)), LTRIM(RTRIM(item_desc_1)), LTRIM(RTRIM(INVENTARIO_EMBARQUE.cus_part_no)) AS CUS_PART_NO
			FROM INVENTARIO_EMBARQUE 
			-- ===========================
			INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(IMITMIDX_SQL.item_no)) = LTRIM(RTRIM(COLOR))
					AND SUBSTRING(LTRIM(RTRIM(IMITMIDX_SQL.item_no)),1,1) = 'F'
			-- ===========================
			WHERE CONVERT(DATE,F_INVENTARIO_EMBARQUE) >= @PP_F_INICIO
			AND CONVERT(DATE,F_INVENTARIO_EMBARQUE) <= @PP_F_FIN	
			AND LTRIM(RTRIM(INVENTARIO_EMBARQUE.D_PROD_CAT)) = @PP_PROGRAMA
			AND LTRIM(RTRIM(item_desc_1)) = @PP_COLOR
			AND K_ESTATUS_INVENTARIO_EMBARQUE IN (3,4)
			ORDER BY	LTRIM(RTRIM(INVENTARIO_EMBARQUE.D_PROD_CAT)), 
						LTRIM(RTRIM(item_desc_1)),
						LTRIM(RTRIM(INVENTARIO_EMBARQUE.cus_part_no)) ASC
			SET NOCOUNT ON
		
		OPEN CU_SALIDA_MATERIAL_V3
		FETCH NEXT FROM CU_SALIDA_MATERIAL_V3 INTO @VP_PROD_CAT_DESC_PRINCIPAL, @VP_TYPE_PRINCIPAL, @VP_CUS_PART_NO_PRINCIPAL		
									
		-- ////////////////////SE RECORRE EL CURSOR//////////////////////////	
		WHILE @@FETCH_STATUS = 0
			BEGIN
				DECLARE CU_SALIDA_MATERIAL_V3_X_DIA CURSOR 
				FOR SELECT	 CONVERT(DATE,F_INVENTARIO_EMBARQUE) CDATE, 
							LTRIM(RTRIM(INVENTARIO_EMBARQUE.D_PROD_CAT)) AS PROD_CAT_DESC, 
							LTRIM(RTRIM(item_desc_1)) AS TYPE, 
							LTRIM(RTRIM(INVENTARIO_EMBARQUE.ITEM_NO)) AS PART_NO, 
							LTRIM(RTRIM(INVENTARIO_EMBARQUE.CUS_PART_NO)) AS CUS_PART_NO, 
							SUM(qty) AS QTY, 
							CASE WHEN ISNULL(LTRIM(RTRIM(INVENTARIO_EMBARQUE.INVOICE_NO)), '') = '' THEN ISNULL(LTRIM(RTRIM(INVENTARIO_EMBARQUE.PACKING_NO)), '')
								ELSE ISNULL(LTRIM(RTRIM(INVENTARIO_EMBARQUE.INVOICE_NO)), '') END AS PACKING_NO ,
							ISNULL(LTRIM(RTRIM(INVENTARIO_EMBARQUE.INVOICE_NO)), 'N/F') AS INV_NO
					FROM INVENTARIO_EMBARQUE 
					INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(IMITMIDX_SQL.item_no)) = LTRIM(RTRIM(COLOR))
					AND SUBSTRING(LTRIM(RTRIM(IMITMIDX_SQL.item_no)), 1,1) = 'F'
					WHERE	CONVERT(DATE,F_INVENTARIO_EMBARQUE) >= @PP_F_INICIO
					AND CONVERT(DATE,F_INVENTARIO_EMBARQUE) <= @PP_F_FIN	
					AND K_ESTATUS_INVENTARIO_EMBARQUE IN (3,4)
					AND LTRIM(RTRIM(INVENTARIO_EMBARQUE.CUS_PART_NO)) = @VP_CUS_PART_NO_PRINCIPAL
					AND LTRIM(RTRIM(item_desc_1)) = @VP_TYPE_PRINCIPAL
					AND LTRIM(RTRIM(INVENTARIO_EMBARQUE.D_PROD_CAT)) = @VP_PROD_CAT_DESC_PRINCIPAL
					GROUP BY	CONVERT(DATE,F_INVENTARIO_EMBARQUE), LTRIM(RTRIM(INVENTARIO_EMBARQUE.ITEM_NO)), LTRIM(RTRIM(INVENTARIO_EMBARQUE.CUS_PART_NO)), 
								LTRIM(RTRIM(INVENTARIO_EMBARQUE.D_PROD_CAT)),  LTRIM(RTRIM(INVENTARIO_EMBARQUE.PACKING_NO)), 
								LTRIM(RTRIM(INVENTARIO_EMBARQUE.INVOICE_NO)), LTRIM(RTRIM(item_desc_1))
					ORDER BY	LTRIM(RTRIM(item_desc_1)), LTRIM(RTRIM(INVENTARIO_EMBARQUE.D_PROD_CAT)), 
								CONVERT(DATE,F_INVENTARIO_EMBARQUE), LTRIM(RTRIM(INVENTARIO_EMBARQUE.PACKING_NO)), LTRIM(RTRIM(INVENTARIO_EMBARQUE.INVOICE_NO)),
								LTRIM(RTRIM(INVENTARIO_EMBARQUE.ITEM_NO)), LTRIM(RTRIM(INVENTARIO_EMBARQUE.CUS_PART_NO)) ASC
				SET NOCOUNT ON

				OPEN CU_SALIDA_MATERIAL_V3_X_DIA
				FETCH NEXT FROM CU_SALIDA_MATERIAL_V3_X_DIA INTO @VP_CDATE, @VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO, @VP_QTY, @VP_PACKING_NO, @VP_INV_NO			
									
				-- ////////////////////SE RECORRE EL CURSOR//////////////////////////	
				WHILE @@FETCH_STATUS = 0
					BEGIN
						-- ///////////SE INICIALIZAN LAS VARIABLES/////////////////////////////////////
						SET @VP_PACKING_ORIGINAL  = @VP_PACKING_NO

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

								
								SELECT @VP_PACKING_ORIGINAL = PACKING_NO 
								FROM INVENTARIO_EMBARQUE 
								WHERE INVOICE_NO = @VP_INV_NO 

							END								

						-- /////////SE OBTIENE EL PRECIO DEL NUMERO DE PARTE///////////////////////////////////////
						SET @VP_PRECIO_CUS_PART_NO  = 0
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
						INSERT INTO	#SALIDA_MATERIAL_MHI_V2(
															PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO, NET_AREA,
															DIA, PACKING, QTY, MOUNT, PRECIO, INVOICE
														)
												VALUES(
															@VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO, @VP_NET_AREA,
															@VP_CDATE, @VP_PACKING_NO, @VP_QTY, @VP_AMOUNT, @VP_PRECIO_CUS_PART_NO, @VP_PACKING_ORIGINAL
														)
			
						FETCH NEXT FROM CU_SALIDA_MATERIAL_V3_X_DIA INTO @VP_CDATE, @VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO, @VP_QTY, @VP_PACKING_NO, @VP_INV_NO			
					END

					SET @VP_TOTAL_QTY  = 0
					SELECT @VP_TOTAL_QTY = SUM(CONVERT(INT, ISNULL(QTY, '0'))) 
					FROM #SALIDA_MATERIAL_MHI_V2 AS SALIDA
					WHERE CUS_PART_NO = @VP_CUS_PART_NO
					
					IF @VP_TOTAL_QTY IS NULL
						SET @VP_TOTAL_QTY = 0

					UPDATE #SALIDA_MATERIAL_MHI_V2
						SET ACUMULADO = @VP_TOTAL_QTY
					WHERE CUS_PART_NO = @VP_CUS_PART_NO
					 
				-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
				CLOSE CU_SALIDA_MATERIAL_V3_X_DIA
				DEALLOCATE CU_SALIDA_MATERIAL_V3_X_DIA									

				FETCH NEXT FROM CU_SALIDA_MATERIAL_V3 INTO @VP_PROD_CAT_DESC_PRINCIPAL, @VP_TYPE_PRINCIPAL, @VP_CUS_PART_NO_PRINCIPAL				
			END
			
		-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
		CLOSE CU_SALIDA_MATERIAL_V3
		DEALLOCATE CU_SALIDA_MATERIAL_V3

		-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
		SELECT *
		FROM #SALIDA_MATERIAL_MHI_V2
		--WHERE CUS_PART_NO = '201025A'
		ORDER BY DIA,PACKING

		DROP TABLE #SALIDA_MATERIAL_MHI_V2
		SET NOCOUNT ON
	-- ////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
