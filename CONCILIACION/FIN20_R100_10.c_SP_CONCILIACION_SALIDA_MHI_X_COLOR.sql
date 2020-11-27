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

USE [DATA_02Pruebas]
GO

-- //////////////////////////////////////////////////////////////

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR]
GO

/* 
 EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR] 0,0, '2020/07/01', '2020/07/31', '2015 WK KL', ''
 EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR] 0,0,	'2020/07/01', '2020/07/31', 'WK GLDL', '' 
*/
CREATE PROCEDURE [dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_F_INICIO					DATE,
	@PP_F_FIN						DATE,
	@PP_PROGRAMA					VARCHAR(50),
	@PP_COLOR						VARCHAR(50)
	-- ===========================
AS
	

	-- //////////////SE CREA TABLA TEMPORAL PARA INGRESAR TOTALES/////////////////////////////
	CREATE TABLE #SALIDA_MATERIAL_MHI(
			ID				INT	IDENTITY(1,1),
			PROD_CAT_DESC	VARCHAR(150) DEFAULT '',
			TYPE			VARCHAR(150) DEFAULT '',
			PART_NO			VARCHAR(150) DEFAULT '',
			CUS_PART_NO		VARCHAR(150) DEFAULT '',
			DIA				VARCHAR(150) DEFAULT '',
			PACKING			VARCHAR(150) DEFAULT '',
			INVOICE			VARCHAR(150) DEFAULT '',
			QTY				VARCHAR(150) DEFAULT '',
			PRECIO			VARCHAR(150) DEFAULT '',
			MOUNT			VARCHAR(150) DEFAULT ''
		)
		SET NOCOUNT ON
		
		DECLARE @VP_N_RESULTADO_BUSQUEDA INT = 0
		SELECT	@VP_N_RESULTADO_BUSQUEDA = COUNT(ID)
		FROM	pf_schst
		INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
		AND LTRIM(RTRIM(PROD_CAT_DESC)) <> 'DO NOT DELETE'
		AND LTRIM(RTRIM(PROD_CAT_DESC)) <> 'OBSOLETE'
		WHERE	TYPE = 'e' -- ENBARCADO
		AND		packing_no IS NOT NULL
		AND		CDATE >= @PP_F_INICIO
		AND		CDATE <= @PP_F_FIN
		AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = @PP_PROGRAMA

		IF @VP_N_RESULTADO_BUSQUEDA > 0
			BEGIN
				-- //////////////SE DECLARAN LAS VARIABLES A USAR/////////////////////////////
				DECLARE @VP_CUS_PART_NO_PRINCIPAL VARCHAR(50) = '', @VP_PROD_CAT_DESC_PRINCIPAL VARCHAR(50) = '', @VP_TYPE_PRINCIPAL VARCHAR(50) = ''
				DECLARE @VP_CUS_PART_NO	VARCHAR(50) = '', @VP_CDATE	VARCHAR(50) = '', @VP_PROD_CAT_DESC	VARCHAR(50) = '', @VP_TYPE VARCHAR(50) = ''
				DECLARE  @VP_PART_NO VARCHAR(50) = '', @VP_QTY VARCHAR(50) = '', @VP_PACKING_NO	VARCHAR(50) = '', @VP_INV_NO VARCHAR(50) = ''
				-- ===========================
				DECLARE	@VP_DIA		VARCHAR(50) = '', @VP_TOTAL_INV_NO DECIMAL(13,2) = 0, @VP_AMOUNT VARCHAR(15) = ''

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
							GROUP BY	CDATE, LTRIM(RTRIM(part_no)), LTRIM(RTRIM(cus_part_no)), 
										LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)),  LTRIM(RTRIM(packing_no)), 
										LTRIM(RTRIM(inv_no)), LTRIM(RTRIM(item_desc_1))
							ORDER BY	LTRIM(RTRIM(item_desc_1)), LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)), 
										CDATE, LTRIM(RTRIM(packing_no)), LTRIM(RTRIM(inv_no)),
										LTRIM(RTRIM(part_no)), LTRIM(RTRIM(cus_part_no)) ASC
						SET NOCOUNT ON

						OPEN CU_SALIDA_MATERIAL_X_DIA
						FETCH NEXT FROM CU_SALIDA_MATERIAL_X_DIA INTO @VP_CDATE, @VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO, @VP_QTY, @VP_PACKING_NO, @VP_INV_NO			
											
						-- ////////////////////SE RECORRE EL CURSOR//////////////////////////	
						WHILE @@FETCH_STATUS = 0
							BEGIN
								-- ///////////SE INICIALIZAN LAS VARIABLES/////////////////////////////////////
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

								INSERT INTO	#SALIDA_MATERIAL_MHI(
																	PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO,
																	DIA, PACKING, INVOICE, QTY, PRECIO, MOUNT
																)
														VALUES(
																	@VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO,
																	@VP_CDATE, @VP_PACKING_NO, @VP_INV_NO, @VP_QTY, @VP_PRECIO_CUS_PART_NO,  @VP_AMOUNT
																)
					
								FETCH NEXT FROM CU_SALIDA_MATERIAL_X_DIA INTO @VP_CDATE, @VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO, @VP_QTY, @VP_PACKING_NO, @VP_INV_NO			
							END
					
						-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
						CLOSE CU_SALIDA_MATERIAL_X_DIA
						DEALLOCATE CU_SALIDA_MATERIAL_X_DIA									

						FETCH NEXT FROM CU_SALIDA_MATERIAL INTO @VP_PROD_CAT_DESC_PRINCIPAL, @VP_TYPE_PRINCIPAL, @VP_CUS_PART_NO_PRINCIPAL				
					END
					
				-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
				CLOSE CU_SALIDA_MATERIAL
				DEALLOCATE CU_SALIDA_MATERIAL
		END

		-- ////////////////////SE SELECCIONAN LOS VALORES INGRESADOS//////////////////////////	
		--SELECT	*
		--FROM #SALIDA_MATERIAL_MHI AS SALIDA 
		--WHERE CUS_PART_NO = '173632Q'
		--ORDER BY TYPE, DIA,PACKING, CUS_PART_NO

		DECLARE @cols AS NVARCHAR(MAX), @query AS NVARCHAR(MAX) 
		
		select @cols = STUFF((SELECT ',' + QUOTENAME(PACKING) 
								from #SALIDA_MATERIAL_MHI WHERE TYPE = 'CHRYSLER NAPPA DX9'
									group by DIA,PACKING
									order by DIA
									 FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') ,1,1,'') 
									 	
									 			
									 			
		set @query = N'SELECT PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO, PRECIO, ' + @cols + N' into [tempdb].[dbo].[temptable]  from ( SELECT PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO, PRECIO, QTY, PACKING from #SALIDA_MATERIAL_MHI WHERE TYPE = ''CHRYSLER NAPPA DX9'' ) x pivot ( MAX(QTY) for PACKING in (' + @cols + N') ) p ' 
		
		exec sp_executesql @query;

		SELECT * FROM [tempdb].[dbo].[temptable] ORDER BY CUS_PART_NO

		DROP TABLE [tempdb].[dbo].[temptable]

		DROP TABLE #SALIDA_MATERIAL_MHI
		SET NOCOUNT ON
	-- ////////////////////////////////////////////////

	 /*
	 EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR] 0,0, '2020/07/01', '2020/07/30', '2015 WK KL', ''
	 EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_X_COLOR] 0,0, '2020/08/01', '2020/08/30', 'WK GLDL', ''
	*/
	-- ////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
