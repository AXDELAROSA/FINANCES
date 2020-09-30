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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_ULTRA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_ULTRA]
GO
/* 
 EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_ULTRA] 0,0,   '2020/07/01', '2020/07/30', '2015 WK KL'
 EXEC	[dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_ULTRA] 0,0,	'2020/07/01', '2020/07/31', 'WK GLDL'  
*/
CREATE PROCEDURE [dbo].[PG_PR_CONCILIACION_SALIDA_MATERIAL_ULTRA]
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
			PROD_CAT_DESC	VARCHAR(150) DEFAULT '',
			TYPE			VARCHAR(150) DEFAULT '',
			PART_NO			VARCHAR(150) DEFAULT '',
			CUS_PART_NO		VARCHAR(150) DEFAULT '',
			DIA_1			VARCHAR(150) DEFAULT '',
			DIA_2			VARCHAR(150) DEFAULT '',
			DIA_3			VARCHAR(150) DEFAULT '',
			DIA_4			VARCHAR(150) DEFAULT '',
			DIA_5			VARCHAR(150) DEFAULT '',
			DIA_6			VARCHAR(150) DEFAULT '',
			DIA_7			VARCHAR(150) DEFAULT '',
			DIA_8			VARCHAR(150) DEFAULT '',
			DIA_9			VARCHAR(150) DEFAULT '',
			DIA_10			VARCHAR(150) DEFAULT '',
			DIA_11			VARCHAR(150) DEFAULT '',
			DIA_12			VARCHAR(150) DEFAULT '',
			DIA_13			VARCHAR(150) DEFAULT '',
			DIA_14			VARCHAR(150) DEFAULT '',
			DIA_15			VARCHAR(150) DEFAULT '',
			DIA_16			VARCHAR(150) DEFAULT '',
			DIA_17			VARCHAR(150) DEFAULT '',
			DIA_18			VARCHAR(150) DEFAULT '',
			DIA_19			VARCHAR(150) DEFAULT '',
			DIA_20			VARCHAR(150) DEFAULT '',
			DIA_21			VARCHAR(150) DEFAULT '',
			DIA_22			VARCHAR(150) DEFAULT '',
			DIA_23			VARCHAR(150) DEFAULT '',
			DIA_24			VARCHAR(150) DEFAULT '',
			DIA_25			VARCHAR(150) DEFAULT '',
			DIA_26			VARCHAR(150) DEFAULT '',
			DIA_27			VARCHAR(150) DEFAULT '',
			DIA_28			VARCHAR(150) DEFAULT '',
			DIA_29			VARCHAR(150) DEFAULT '',
			DIA_30			VARCHAR(150) DEFAULT '',
			DIA_31			VARCHAR(150) DEFAULT '',
			ACUMULADO		VARCHAR(150) DEFAULT '',
			PRECIO			VARCHAR(150) DEFAULT ''
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
				DECLARE @VP_CUS_PART_NO_PRINCIPAL VARCHAR(50) = '', @VP_PROD_CAT_DESC_PRINCIPAL VARCHAR(50) = '', @VP_TYPE_PRINCIPAL VARCHAR(50) = ''
				DECLARE @VP_CUS_PART_NO	VARCHAR(50) = '', @VP_CDATE	VARCHAR(50) = '', @VP_PROD_CAT_DESC	VARCHAR(50) = '', @VP_TYPE VARCHAR(50) = ''
				DECLARE  @VP_PART_NO VARCHAR(50) = '', @VP_QTY VARCHAR(50) = '', @VP_PACKING_NO	VARCHAR(50) = '', @VP_INV_NO VARCHAR(50) = ''
				-- ===========================
				DECLARE @VP_CDATE_ANTERIOR VARCHAR(50) = '', @VP_PROD_CAT_DESC_ANTERIOR	VARCHAR(50) = '', @VP_TYPE_ANTERIOR	VARCHAR(50) = ''
				DECLARE @VP_PACKING_NO_ANTERIOR		VARCHAR(50) = '', @VP_INV_NO_ANTERIOR VARCHAR(50) = ''
				-- ===========================
				DECLARE	@VP_DIA_1	VARCHAR(50) = '', @VP_DIA_2		VARCHAR(50) = '', @VP_DIA_3		VARCHAR(50) = '', @VP_DIA_4		VARCHAR(50)	= '', @VP_DIA_5		VARCHAR(50) = ''
				DECLARE @VP_DIA_6	VARCHAR(50) = '', @VP_DIA_7		VARCHAR(50) = '', @VP_DIA_8		VARCHAR(50) = '', @VP_DIA_9		VARCHAR(50)	= '', @VP_DIA_10	VARCHAR(50) = ''
				DECLARE @VP_DIA_11	VARCHAR(50) = '', @VP_DIA_12	VARCHAR(50) = '', @VP_DIA_13	VARCHAR(50) = '', @VP_DIA_14	VARCHAR(50)	= '', @VP_DIA_15	VARCHAR(50) = ''
				DECLARE @VP_DIA_16	VARCHAR(50) = '', @VP_DIA_17	VARCHAR(50) = '', @VP_DIA_18	VARCHAR(50) = '', @VP_DIA_19	VARCHAR(50)	= '', @VP_DIA_20	VARCHAR(50) = ''
				DECLARE @VP_DIA_21	VARCHAR(50) = '', @VP_DIA_22	VARCHAR(50) = '', @VP_DIA_23	VARCHAR(50) = '', @VP_DIA_24	VARCHAR(50)	= '', @VP_DIA_25	VARCHAR(50) = ''
				DECLARE @VP_DIA_26	VARCHAR(50) = '', @VP_DIA_27	VARCHAR(50) = '', @VP_DIA_28	VARCHAR(50) = '', @VP_DIA_29	VARCHAR(50)	= '', @VP_DIA_30	VARCHAR(50) = ''
				DECLARE @VP_DIA_31	VARCHAR(50) = '', @VP_DIA		VARCHAR(50) = '', @VP_TOTAL_INV_NO DECIMAL(13,2) = 0, @VP_AMOUNT VARCHAR(15) = ''

				-- //////////////SE CREA EL CURSOR/////////////////////////////
				DECLARE CU_SALIDA_MATERIAL CURSOR 
				FOR SELECT	DISTINCT LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)), LTRIM(RTRIM(item_desc_1)), LTRIM(RTRIM(pf_schst.cus_part_no)) AS CUS_PART_NO
					FROM pf_schst 
					INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
					INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(item_no)) = CONCAT('F', SUBSTRING(part_no, (LEN(LTRIM(RTRIM(part_no))) - 5), 6))
					WHERE TYPE='e' 
					AND CDATE >= @PP_F_INICIO
					AND CDATE <= @PP_F_FIN	
					AND	(	packing_no IS NOT NULL
								OR inv_no IS NOT NULL )
					AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = @PP_PROGRAMA
					--AND LTRIM(RTRIM(item_desc_1)) = 'CHRYSLER NAPPA DX9' -- para pruebas
					ORDER BY	LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)), 
								LTRIM(RTRIM(item_desc_1)),
								LTRIM(RTRIM(pf_schst.cus_part_no)) ASC

				
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
							INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
							WHERE TYPE='e' 
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
										CDATE, LTRIM(RTRIM(packing_no)), LTRIM(RTRIM(inv_no))  ,
										LTRIM(RTRIM(part_no)), LTRIM(RTRIM(cus_part_no)) ASC
						
						OPEN CU_SALIDA_MATERIAL_X_DIA
						FETCH NEXT FROM CU_SALIDA_MATERIAL_X_DIA INTO @VP_CDATE, @VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO, @VP_QTY, @VP_PACKING_NO, @VP_INV_NO			
											
						-- ////////////////////SE RECORRE EL CURSOR//////////////////////////	
						WHILE @@FETCH_STATUS = 0
							BEGIN
								SET @VP_DIA  =   SUBSTRING(@VP_CDATE,9, 2)

								SET @VP_DIA_1  = ''
								SET @VP_DIA_2  = ''
								SET @VP_DIA_3  = ''
								SET @VP_DIA_4  = ''
								SET @VP_DIA_5  = ''
								SET @VP_DIA_6  = ''
								SET @VP_DIA_7  = ''
								SET @VP_DIA_8  = ''
								SET @VP_DIA_9  = ''
								SET @VP_DIA_10 = ''
								SET @VP_DIA_11 = ''
								SET @VP_DIA_12 = ''
								SET @VP_DIA_13 = ''
								SET @VP_DIA_14 = ''
								SET @VP_DIA_15 = ''
								SET @VP_DIA_16 = ''
								SET @VP_DIA_17 = ''
								SET @VP_DIA_18 = ''
								SET @VP_DIA_19 = ''
								SET @VP_DIA_20 = ''
								SET @VP_DIA_21 = ''
								SET @VP_DIA_22 = ''
								SET @VP_DIA_23 = ''
								SET @VP_DIA_24 = ''
								SET @VP_DIA_25 = ''
								SET @VP_DIA_26 = ''
								SET @VP_DIA_27 = ''
								SET @VP_DIA_28 = ''
								SET @VP_DIA_29 = ''
								SET @VP_DIA_30 = ''
								SET @VP_DIA_31 = ''

								IF @VP_DIA = '01' 
									SET @VP_DIA_1 = @VP_CDATE

								IF @VP_DIA = '02' 
									SET @VP_DIA_2 = @VP_CDATE

								IF @VP_DIA = '03' 
									SET @VP_DIA_3 = @VP_CDATE
	
								IF @VP_DIA = '04' 
									SET @VP_DIA_4 = @VP_CDATE

								IF @VP_DIA = '05' 
									SET @VP_DIA_5 = @VP_CDATE

								IF @VP_DIA = '06' 
									SET @VP_DIA_6 = @VP_CDATE

								IF @VP_DIA = '07' 
									SET @VP_DIA_7 = @VP_CDATE

								IF @VP_DIA = '08' 
									SET @VP_DIA_8 = @VP_CDATE

								IF @VP_DIA = '9' 
									SET @VP_DIA_9 = @VP_CDATE

								IF @VP_DIA = '10' 
									SET @VP_DIA_10 = @VP_CDATE

								IF @VP_DIA = '11' 
									SET @VP_DIA_11 = @VP_CDATE

								IF @VP_DIA = '12' 
									SET @VP_DIA_12 = @VP_CDATE

								IF @VP_DIA = '13' 
									SET @VP_DIA_13 = @VP_CDATE

								IF @VP_DIA = '14' 
									SET @VP_DIA_14 = @VP_CDATE

								IF @VP_DIA = '15' 
									SET @VP_DIA_15 = @VP_CDATE

								IF @VP_DIA = '16' 
									SET @VP_DIA_16 = @VP_CDATE

								IF @VP_DIA = '17' 
									SET @VP_DIA_17 = @VP_CDATE

								IF @VP_DIA = '18' 
									SET @VP_DIA_18 = @VP_CDATE

								IF @VP_DIA = '19' 
									SET @VP_DIA_19 = @VP_CDATE

								IF @VP_DIA = '20' 
									SET @VP_DIA_20 = @VP_CDATE

								IF @VP_DIA = '21' 
									SET @VP_DIA_21 = @VP_CDATE

								IF @VP_DIA = '22' 
									SET @VP_DIA_22 = @VP_CDATE

								IF @VP_DIA = '23' 
									SET @VP_DIA_23 = @VP_CDATE

								IF @VP_DIA = '24' 
									SET @VP_DIA_24 = @VP_CDATE

								IF @VP_DIA = '25' 
									SET @VP_DIA_25 = @VP_CDATE

								IF @VP_DIA = '26' 
									SET @VP_DIA_26 = @VP_CDATE

								IF @VP_DIA = '27' 
									SET @VP_DIA_27 = @VP_CDATE

								IF @VP_DIA = '28' 
									SET @VP_DIA_28 = @VP_CDATE

								IF @VP_DIA = '29' 
									SET @VP_DIA_29 = @VP_CDATE

								IF @VP_DIA = '30' 
									SET @VP_DIA_30 = @VP_CDATE

								IF @VP_DIA = '31' 
									SET @VP_DIA_31 = @VP_CDATE

								IF @VP_PACKING_NO = ''
									SET @VP_PACKING_NO = @VP_INV_NO

								DECLARE @VP_N_SALIDA_PIEL_MHI INT = 0
								SELECT @VP_N_SALIDA_PIEL_MHI = COUNT(ID)
								FROM @VP_SALIDA_PIEL_MHI_TBL

								IF @VP_N_SALIDA_PIEL_MHI IS NULL 
									SET @VP_N_SALIDA_PIEL_MHI = 0

								IF @VP_N_SALIDA_PIEL_MHI > 0
									BEGIN
										SET @VP_N_SALIDA_PIEL_MHI = 0
										SELECT @VP_N_SALIDA_PIEL_MHI = COUNT(ID)
										FROM @VP_SALIDA_PIEL_MHI_TBL
										WHERE PROD_CAT_DESC = @VP_PROD_CAT_DESC
										AND	TYPE = @VP_TYPE

										IF @VP_N_SALIDA_PIEL_MHI > 0
											BEGIN
												SET @VP_N_SALIDA_PIEL_MHI = 0

												SELECT @VP_N_SALIDA_PIEL_MHI = COUNT(ID)
												FROM @VP_SALIDA_PIEL_MHI_TBL
												WHERE CUS_PART_NO = @VP_CUS_PART_NO
												AND PROD_CAT_DESC = @VP_PROD_CAT_DESC
												AND	TYPE = @VP_TYPE

												IF @VP_N_SALIDA_PIEL_MHI IS NULL 
													SET @VP_N_SALIDA_PIEL_MHI = 0

												IF @VP_N_SALIDA_PIEL_MHI > 0
													BEGIN
														-- UPDATE DATE
														UPDATE	@VP_SALIDA_PIEL_MHI_TBL 	
															SET	DIA_1	= 	( CASE WHEN @VP_DIA = '01' THEN @VP_CDATE  ELSE DIA_1 END ), 
																DIA_2	= 	( CASE WHEN @VP_DIA = '02' THEN @VP_CDATE  ELSE DIA_2 END ),  
																DIA_3	= 	( CASE WHEN @VP_DIA = '03' THEN @VP_CDATE  ELSE DIA_3 END ),  
																DIA_4	= 	( CASE WHEN @VP_DIA = '04' THEN @VP_CDATE  ELSE DIA_4 END ),  
																DIA_5	= 	( CASE WHEN @VP_DIA = '05' THEN @VP_CDATE  ELSE DIA_5 END ),  
																DIA_6	= 	( CASE WHEN @VP_DIA = '06' THEN @VP_CDATE  ELSE DIA_6 END ),  
																DIA_7	= 	( CASE WHEN @VP_DIA = '07' THEN @VP_CDATE  ELSE DIA_7 END ),  
																DIA_8	= 	( CASE WHEN @VP_DIA = '08' THEN @VP_CDATE  ELSE DIA_8 END ),  
																DIA_9	= 	( CASE WHEN @VP_DIA = '09' THEN @VP_CDATE  ELSE DIA_9 END ),  
																DIA_10	= 	( CASE WHEN @VP_DIA = '10' THEN @VP_CDATE  ELSE DIA_10 END ),	
																DIA_11	= 	( CASE WHEN @VP_DIA = '11' THEN @VP_CDATE  ELSE DIA_11 END ),	 
																DIA_12	= 	( CASE WHEN @VP_DIA = '12' THEN @VP_CDATE  ELSE DIA_12 END ),	 
																DIA_13	= 	( CASE WHEN @VP_DIA = '13' THEN @VP_CDATE  ELSE DIA_13 END ),	 
																DIA_14	= 	( CASE WHEN @VP_DIA = '14' THEN @VP_CDATE  ELSE DIA_14 END ),	 
																DIA_15	= 	( CASE WHEN @VP_DIA = '15' THEN @VP_CDATE  ELSE DIA_15 END ),	 
																DIA_16	= 	( CASE WHEN @VP_DIA = '16' THEN @VP_CDATE  ELSE DIA_16 END ),	 
																DIA_17	= 	( CASE WHEN @VP_DIA = '17' THEN @VP_CDATE  ELSE DIA_17 END ),	 
																DIA_18	= 	( CASE WHEN @VP_DIA = '18' THEN @VP_CDATE  ELSE DIA_18 END ),	 
																DIA_19	= 	( CASE WHEN @VP_DIA = '19' THEN @VP_CDATE  ELSE DIA_19 END ),	 
																DIA_20	= 	( CASE WHEN @VP_DIA = '20' THEN @VP_CDATE  ELSE DIA_20 END ),
																DIA_21	= 	( CASE WHEN @VP_DIA = '21' THEN @VP_CDATE  ELSE DIA_21 END ), 
																DIA_22	= 	( CASE WHEN @VP_DIA = '22' THEN @VP_CDATE  ELSE DIA_22 END ), 
																DIA_23	= 	( CASE WHEN @VP_DIA = '23' THEN @VP_CDATE  ELSE DIA_23 END ), 
																DIA_24	= 	( CASE WHEN @VP_DIA = '24' THEN @VP_CDATE  ELSE DIA_24 END ), 
																DIA_25	= 	( CASE WHEN @VP_DIA = '25' THEN @VP_CDATE  ELSE DIA_25 END ), 
																DIA_26	= 	( CASE WHEN @VP_DIA = '26' THEN @VP_CDATE  ELSE DIA_26 END ), 
																DIA_27	= 	( CASE WHEN @VP_DIA = '27' THEN @VP_CDATE  ELSE DIA_27 END ), 
																DIA_28	= 	( CASE WHEN @VP_DIA = '28' THEN @VP_CDATE  ELSE DIA_28 END ),
																DIA_29	= 	( CASE WHEN @VP_DIA = '29' THEN @VP_CDATE  ELSE DIA_29 END ), 
																DIA_30	= 	( CASE WHEN @VP_DIA = '30' THEN @VP_CDATE  ELSE DIA_30 END ),	
																DIA_31	= 	( CASE WHEN @VP_DIA = '31' THEN @VP_CDATE  ELSE DIA_31 END )
														WHERE CUS_PART_NO = 'DATE'	
														AND TYPE = @VP_TYPE				
																						
														
														-- UPDATE PACKING
														UPDATE	@VP_SALIDA_PIEL_MHI_TBL 	
															SET	DIA_1	= 	( CASE WHEN @VP_DIA = '01' AND DIA_1  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '01' AND DIA_1  <> '' AND DIA_1  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_1  WHEN @VP_DIA = '01' AND DIA_1  <> '' AND DIA_1  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_1 ,'/', @VP_PACKING_NO) ELSE DIA_1 END ),
																DIA_2	= 	( CASE WHEN @VP_DIA = '02' AND DIA_2  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '02' AND DIA_2  <> '' AND DIA_2  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_2  WHEN @VP_DIA = '02' AND DIA_2  <> '' AND DIA_2  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_2 ,'/', @VP_PACKING_NO) ELSE DIA_2 END ), 
																DIA_3	= 	( CASE WHEN @VP_DIA = '03' AND DIA_3  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '03' AND DIA_3  <> '' AND DIA_3  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_3  WHEN @VP_DIA = '03' AND DIA_3  <> '' AND DIA_3  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_3 ,'/', @VP_PACKING_NO) ELSE DIA_3 END ),
																DIA_4	= 	( CASE WHEN @VP_DIA = '04' AND DIA_4  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '04' AND DIA_4  <> '' AND DIA_4  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_4  WHEN @VP_DIA = '04' AND DIA_4  <> '' AND DIA_4  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_4 ,'/', @VP_PACKING_NO) ELSE DIA_4 END ),
																DIA_5	= 	( CASE WHEN @VP_DIA = '05' AND DIA_5  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '05' AND DIA_5  <> '' AND DIA_5  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_5  WHEN @VP_DIA = '05' AND DIA_5  <> '' AND DIA_5  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_5 ,'/', @VP_PACKING_NO) ELSE DIA_5 END ),
																DIA_6	= 	( CASE WHEN @VP_DIA = '06' AND DIA_6  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '06' AND DIA_6  <> '' AND DIA_6  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_6  WHEN @VP_DIA = '06' AND DIA_6  <> '' AND DIA_6  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_6 ,'/', @VP_PACKING_NO) ELSE DIA_6 END ),
																DIA_7	= 	( CASE WHEN @VP_DIA = '07' AND DIA_7  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '07' AND DIA_7  <> '' AND DIA_7  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_7  WHEN @VP_DIA = '07' AND DIA_7  <> '' AND DIA_7  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_7 ,'/', @VP_PACKING_NO) ELSE DIA_7 END ),
																DIA_8	= 	( CASE WHEN @VP_DIA = '08' AND DIA_8  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '08' AND DIA_8  <> '' AND DIA_8  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_8  WHEN @VP_DIA = '08' AND DIA_8  <> '' AND DIA_8  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_8 ,'/', @VP_PACKING_NO) ELSE DIA_8 END ),
																DIA_9	= 	( CASE WHEN @VP_DIA = '09' AND DIA_9  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '09' AND DIA_9  <> '' AND DIA_9  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_9  WHEN @VP_DIA = '09' AND DIA_9  <> '' AND DIA_9  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_9 ,'/', @VP_PACKING_NO) ELSE DIA_9 END ),
																DIA_10	= 	( CASE WHEN @VP_DIA = '10' AND DIA_10 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '10' AND DIA_10 <> '' AND DIA_10 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_10 WHEN @VP_DIA = '10' AND DIA_10 <> '' AND DIA_10 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_10,'/', @VP_PACKING_NO) ELSE DIA_10 END ),
																DIA_11	= 	( CASE WHEN @VP_DIA = '11' AND DIA_11 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '11' AND DIA_11 <> '' AND DIA_11 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_11 WHEN @VP_DIA = '11' AND DIA_11 <> '' AND DIA_11 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_11,'/', @VP_PACKING_NO) ELSE DIA_11 END ),
																DIA_12	= 	( CASE WHEN @VP_DIA = '12' AND DIA_12 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '12' AND DIA_12 <> '' AND DIA_12 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_12 WHEN @VP_DIA = '12' AND DIA_12 <> '' AND DIA_12 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_12,'/', @VP_PACKING_NO) ELSE DIA_12 END ),
																DIA_13	= 	( CASE WHEN @VP_DIA = '13' AND DIA_13 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '13' AND DIA_13 <> '' AND DIA_13 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_13 WHEN @VP_DIA = '13' AND DIA_13 <> '' AND DIA_13 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_13,'/', @VP_PACKING_NO) ELSE DIA_13 END ),
																DIA_14	= 	( CASE WHEN @VP_DIA = '14' AND DIA_14 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '14' AND DIA_14 <> '' AND DIA_14 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_14 WHEN @VP_DIA = '14' AND DIA_14 <> '' AND DIA_14 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_14,'/', @VP_PACKING_NO) ELSE DIA_14 END ),
																DIA_15	= 	( CASE WHEN @VP_DIA = '15' AND DIA_15 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '15' AND DIA_15 <> '' AND DIA_15 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_15 WHEN @VP_DIA = '15' AND DIA_15 <> '' AND DIA_15 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_15,'/', @VP_PACKING_NO) ELSE DIA_15 END ),
																DIA_16	= 	( CASE WHEN @VP_DIA = '16' AND DIA_16 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '16' AND DIA_16 <> '' AND DIA_16 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_16 WHEN @VP_DIA = '16' AND DIA_16 <> '' AND DIA_16 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_16,'/', @VP_PACKING_NO) ELSE DIA_16 END ),	 
																DIA_17	= 	( CASE WHEN @VP_DIA = '17' AND DIA_17 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '17' AND DIA_17 <> '' AND DIA_17 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_17 WHEN @VP_DIA = '17' AND DIA_17 <> '' AND DIA_17 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_17,'/', @VP_PACKING_NO) ELSE DIA_17 END ),	 
																DIA_18	= 	( CASE WHEN @VP_DIA = '18' AND DIA_18 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '18' AND DIA_18 <> '' AND DIA_18 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_18 WHEN @VP_DIA = '18' AND DIA_18 <> '' AND DIA_18 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_18,'/', @VP_PACKING_NO) ELSE DIA_18 END ),	 
																DIA_19	= 	( CASE WHEN @VP_DIA = '19' AND DIA_19 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '19' AND DIA_19 <> '' AND DIA_19 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_19 WHEN @VP_DIA = '19' AND DIA_19 <> '' AND DIA_19 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_19,'/', @VP_PACKING_NO) ELSE DIA_19 END ),	 
																DIA_20	= 	( CASE WHEN @VP_DIA = '20' AND DIA_20 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '20' AND DIA_20 <> '' AND DIA_20 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_20 WHEN @VP_DIA = '20' AND DIA_20 <> '' AND DIA_20 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_20,'/', @VP_PACKING_NO) ELSE DIA_20 END ),
																DIA_21	= 	( CASE WHEN @VP_DIA = '21' AND DIA_21 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '21' AND DIA_21 <> '' AND DIA_21 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_21 WHEN @VP_DIA = '21' AND DIA_21 <> '' AND DIA_21 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_21,'/', @VP_PACKING_NO) ELSE DIA_21 END ),
																DIA_22	= 	( CASE WHEN @VP_DIA = '22' AND DIA_22 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '22' AND DIA_22 <> '' AND DIA_22 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_22 WHEN @VP_DIA = '22' AND DIA_22 <> '' AND DIA_22 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_22,'/', @VP_PACKING_NO) ELSE DIA_22 END ),
																DIA_23	= 	( CASE WHEN @VP_DIA = '23' AND DIA_23 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '23' AND DIA_23 <> '' AND DIA_23 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_23 WHEN @VP_DIA = '23' AND DIA_23 <> '' AND DIA_23 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_23,'/', @VP_PACKING_NO) ELSE DIA_23 END ),
																DIA_24	= 	( CASE WHEN @VP_DIA = '24' AND DIA_24 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '24' AND DIA_24 <> '' AND DIA_24 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_24 WHEN @VP_DIA = '24' AND DIA_24 <> '' AND DIA_24 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_24,'/', @VP_PACKING_NO) ELSE DIA_24 END ),
																DIA_25	= 	( CASE WHEN @VP_DIA = '25' AND DIA_25 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '25' AND DIA_25 <> '' AND DIA_25 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_25 WHEN @VP_DIA = '25' AND DIA_25 <> '' AND DIA_25 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_25,'/', @VP_PACKING_NO) ELSE DIA_25 END ),
																DIA_26	= 	( CASE WHEN @VP_DIA = '26' AND DIA_26 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '26' AND DIA_26 <> '' AND DIA_26 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_26 WHEN @VP_DIA = '26' AND DIA_26 <> '' AND DIA_26 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_26,'/', @VP_PACKING_NO) ELSE DIA_26 END ), 
																DIA_27	= 	( CASE WHEN @VP_DIA = '27' AND DIA_27 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '27' AND DIA_27 <> '' AND DIA_27 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_27 WHEN @VP_DIA = '27' AND DIA_27 <> '' AND DIA_27 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_27,'/', @VP_PACKING_NO) ELSE DIA_27 END ), 
																DIA_28	= 	( CASE WHEN @VP_DIA = '28' AND DIA_28 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '28' AND DIA_28 <> '' AND DIA_28 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_28 WHEN @VP_DIA = '28' AND DIA_28 <> '' AND DIA_28 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_28,'/', @VP_PACKING_NO) ELSE DIA_28 END ),
																DIA_29	= 	( CASE WHEN @VP_DIA = '29' AND DIA_29 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '29' AND DIA_29 <> '' AND DIA_29 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_29 WHEN @VP_DIA = '29' AND DIA_29 <> '' AND DIA_29 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_29,'/', @VP_PACKING_NO) ELSE DIA_29 END ),
																DIA_30	= 	( CASE WHEN @VP_DIA = '30' AND DIA_30 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '30' AND DIA_30 <> '' AND DIA_30 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_30 WHEN @VP_DIA = '30' AND DIA_30 <> '' AND DIA_30 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_30,'/', @VP_PACKING_NO) ELSE DIA_30 END ),	
																DIA_31	= 	( CASE WHEN @VP_DIA = '31' AND DIA_31 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '31' AND DIA_31 <> '' AND DIA_31 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_31 WHEN @VP_DIA = '31' AND DIA_31 <> '' AND DIA_31 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_31,'/', @VP_PACKING_NO) ELSE DIA_31 END )
														WHERE CUS_PART_NO = 'PACKING'	
														AND TYPE = @VP_TYPE

														-- UPDATE INVOICE
														UPDATE	@VP_SALIDA_PIEL_MHI_TBL 	
															SET	DIA_1	= 	( CASE WHEN @VP_DIA = '01' AND DIA_1  = '' THEN @VP_INV_NO WHEN @VP_DIA = '01' AND DIA_1  <> '' AND DIA_1  LIKE '%' + @VP_INV_NO + '%' THEN DIA_1  WHEN @VP_DIA = '01' AND DIA_1  <> '' AND DIA_1  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_1 ,'/', @VP_INV_NO) ELSE DIA_1 END ),
																DIA_2	= 	( CASE WHEN @VP_DIA = '02' AND DIA_2  = '' THEN @VP_INV_NO WHEN @VP_DIA = '02' AND DIA_2  <> '' AND DIA_2  LIKE '%' + @VP_INV_NO + '%' THEN DIA_2  WHEN @VP_DIA = '02' AND DIA_2  <> '' AND DIA_2  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_2 ,'/', @VP_INV_NO) ELSE DIA_2 END ), 
																DIA_3	= 	( CASE WHEN @VP_DIA = '03' AND DIA_3  = '' THEN @VP_INV_NO WHEN @VP_DIA = '03' AND DIA_3  <> '' AND DIA_3  LIKE '%' + @VP_INV_NO + '%' THEN DIA_3  WHEN @VP_DIA = '03' AND DIA_3  <> '' AND DIA_3  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_3 ,'/', @VP_INV_NO) ELSE DIA_3 END ),
																DIA_4	= 	( CASE WHEN @VP_DIA = '04' AND DIA_4  = '' THEN @VP_INV_NO WHEN @VP_DIA = '04' AND DIA_4  <> '' AND DIA_4  LIKE '%' + @VP_INV_NO + '%' THEN DIA_4  WHEN @VP_DIA = '04' AND DIA_4  <> '' AND DIA_4  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_4 ,'/', @VP_INV_NO) ELSE DIA_4 END ),
																DIA_5	= 	( CASE WHEN @VP_DIA = '05' AND DIA_5  = '' THEN @VP_INV_NO WHEN @VP_DIA = '05' AND DIA_5  <> '' AND DIA_5  LIKE '%' + @VP_INV_NO + '%' THEN DIA_5  WHEN @VP_DIA = '05' AND DIA_5  <> '' AND DIA_5  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_5 ,'/', @VP_INV_NO) ELSE DIA_5 END ),
																DIA_6	= 	( CASE WHEN @VP_DIA = '06' AND DIA_6  = '' THEN @VP_INV_NO WHEN @VP_DIA = '06' AND DIA_6  <> '' AND DIA_6  LIKE '%' + @VP_INV_NO + '%' THEN DIA_6  WHEN @VP_DIA = '06' AND DIA_6  <> '' AND DIA_6  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_6 ,'/', @VP_INV_NO) ELSE DIA_6 END ),
																DIA_7	= 	( CASE WHEN @VP_DIA = '07' AND DIA_7  = '' THEN @VP_INV_NO WHEN @VP_DIA = '07' AND DIA_7  <> '' AND DIA_7  LIKE '%' + @VP_INV_NO + '%' THEN DIA_7  WHEN @VP_DIA = '07' AND DIA_7  <> '' AND DIA_7  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_7 ,'/', @VP_INV_NO) ELSE DIA_7 END ),
																DIA_8	= 	( CASE WHEN @VP_DIA = '08' AND DIA_8  = '' THEN @VP_INV_NO WHEN @VP_DIA = '08' AND DIA_8  <> '' AND DIA_8  LIKE '%' + @VP_INV_NO + '%' THEN DIA_8  WHEN @VP_DIA = '08' AND DIA_8  <> '' AND DIA_8  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_8 ,'/', @VP_INV_NO) ELSE DIA_8 END ),
																DIA_9	= 	( CASE WHEN @VP_DIA = '09' AND DIA_9  = '' THEN @VP_INV_NO WHEN @VP_DIA = '09' AND DIA_9  <> '' AND DIA_9  LIKE '%' + @VP_INV_NO + '%' THEN DIA_9  WHEN @VP_DIA = '09' AND DIA_9  <> '' AND DIA_9  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_9 ,'/', @VP_INV_NO) ELSE DIA_9 END ),
																DIA_10	= 	( CASE WHEN @VP_DIA = '10' AND DIA_10 = '' THEN @VP_INV_NO WHEN @VP_DIA = '10' AND DIA_10 <> '' AND DIA_10 LIKE '%' + @VP_INV_NO + '%' THEN DIA_10 WHEN @VP_DIA = '10' AND DIA_10 <> '' AND DIA_10 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_10,'/', @VP_INV_NO) ELSE DIA_10 END ),	
																DIA_11	= 	( CASE WHEN @VP_DIA = '11' AND DIA_11 = '' THEN @VP_INV_NO WHEN @VP_DIA = '11' AND DIA_11 <> '' AND DIA_11 LIKE '%' + @VP_INV_NO + '%' THEN DIA_11 WHEN @VP_DIA = '11' AND DIA_11 <> '' AND DIA_11 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_11,'/', @VP_INV_NO) ELSE DIA_11 END ),	 
																DIA_12	= 	( CASE WHEN @VP_DIA = '12' AND DIA_12 = '' THEN @VP_INV_NO WHEN @VP_DIA = '12' AND DIA_12 <> '' AND DIA_12 LIKE '%' + @VP_INV_NO + '%' THEN DIA_12 WHEN @VP_DIA = '12' AND DIA_12 <> '' AND DIA_12 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_12,'/', @VP_INV_NO) ELSE DIA_12 END ),	 
																DIA_13	= 	( CASE WHEN @VP_DIA = '13' AND DIA_13 = '' THEN @VP_INV_NO WHEN @VP_DIA = '13' AND DIA_13 <> '' AND DIA_13 LIKE '%' + @VP_INV_NO + '%' THEN DIA_13 WHEN @VP_DIA = '13' AND DIA_13 <> '' AND DIA_13 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_13,'/', @VP_INV_NO) ELSE DIA_13 END ),	 
																DIA_14	= 	( CASE WHEN @VP_DIA = '14' AND DIA_14 = '' THEN @VP_INV_NO WHEN @VP_DIA = '14' AND DIA_14 <> '' AND DIA_14 LIKE '%' + @VP_INV_NO + '%' THEN DIA_14 WHEN @VP_DIA = '14' AND DIA_14 <> '' AND DIA_14 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_14,'/', @VP_INV_NO) ELSE DIA_14 END ),	 
																DIA_15	= 	( CASE WHEN @VP_DIA = '15' AND DIA_15 = '' THEN @VP_INV_NO WHEN @VP_DIA = '15' AND DIA_15 <> '' AND DIA_15 LIKE '%' + @VP_INV_NO + '%' THEN DIA_15 WHEN @VP_DIA = '15' AND DIA_15 <> '' AND DIA_15 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_15,'/', @VP_INV_NO) ELSE DIA_15 END ),	 
																DIA_16	= 	( CASE WHEN @VP_DIA = '16' AND DIA_16 = '' THEN @VP_INV_NO WHEN @VP_DIA = '16' AND DIA_16 <> '' AND DIA_16 LIKE '%' + @VP_INV_NO + '%' THEN DIA_16 WHEN @VP_DIA = '16' AND DIA_16 <> '' AND DIA_16 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_16,'/', @VP_INV_NO) ELSE DIA_16 END ),	 
																DIA_17	= 	( CASE WHEN @VP_DIA = '17' AND DIA_17 = '' THEN @VP_INV_NO WHEN @VP_DIA = '17' AND DIA_17 <> '' AND DIA_17 LIKE '%' + @VP_INV_NO + '%' THEN DIA_17 WHEN @VP_DIA = '17' AND DIA_17 <> '' AND DIA_17 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_17,'/', @VP_INV_NO) ELSE DIA_17 END ),	 
																DIA_18	= 	( CASE WHEN @VP_DIA = '18' AND DIA_18 = '' THEN @VP_INV_NO WHEN @VP_DIA = '18' AND DIA_18 <> '' AND DIA_18 LIKE '%' + @VP_INV_NO + '%' THEN DIA_18 WHEN @VP_DIA = '18' AND DIA_18 <> '' AND DIA_18 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_18,'/', @VP_INV_NO) ELSE DIA_18 END ),	 
																DIA_19	= 	( CASE WHEN @VP_DIA = '19' AND DIA_19 = '' THEN @VP_INV_NO WHEN @VP_DIA = '19' AND DIA_19 <> '' AND DIA_19 LIKE '%' + @VP_INV_NO + '%' THEN DIA_19 WHEN @VP_DIA = '19' AND DIA_19 <> '' AND DIA_19 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_19,'/', @VP_INV_NO) ELSE DIA_19 END ),	 
																DIA_20	= 	( CASE WHEN @VP_DIA = '20' AND DIA_20 = '' THEN @VP_INV_NO WHEN @VP_DIA = '20' AND DIA_20 <> '' AND DIA_20 LIKE '%' + @VP_INV_NO + '%' THEN DIA_20 WHEN @VP_DIA = '20' AND DIA_20 <> '' AND DIA_20 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_20,'/', @VP_INV_NO) ELSE DIA_20 END ),
																DIA_21	= 	( CASE WHEN @VP_DIA = '21' AND DIA_21 = '' THEN @VP_INV_NO WHEN @VP_DIA = '21' AND DIA_21 <> '' AND DIA_21 LIKE '%' + @VP_INV_NO + '%' THEN DIA_21 WHEN @VP_DIA = '21' AND DIA_21 <> '' AND DIA_21 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_21,'/', @VP_INV_NO) ELSE DIA_21 END ), 
																DIA_22	= 	( CASE WHEN @VP_DIA = '22' AND DIA_22 = '' THEN @VP_INV_NO WHEN @VP_DIA = '22' AND DIA_22 <> '' AND DIA_22 LIKE '%' + @VP_INV_NO + '%' THEN DIA_22 WHEN @VP_DIA = '22' AND DIA_22 <> '' AND DIA_22 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_22,'/', @VP_INV_NO) ELSE DIA_22 END ), 
																DIA_23	= 	( CASE WHEN @VP_DIA = '23' AND DIA_23 = '' THEN @VP_INV_NO WHEN @VP_DIA = '23' AND DIA_23 <> '' AND DIA_23 LIKE '%' + @VP_INV_NO + '%' THEN DIA_23 WHEN @VP_DIA = '23' AND DIA_23 <> '' AND DIA_23 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_23,'/', @VP_INV_NO) ELSE DIA_23 END ), 
																DIA_24	= 	( CASE WHEN @VP_DIA = '24' AND DIA_24 = '' THEN @VP_INV_NO WHEN @VP_DIA = '24' AND DIA_24 <> '' AND DIA_24 LIKE '%' + @VP_INV_NO + '%' THEN DIA_24 WHEN @VP_DIA = '24' AND DIA_24 <> '' AND DIA_24 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_24,'/', @VP_INV_NO) ELSE DIA_24 END ), 
																DIA_25	= 	( CASE WHEN @VP_DIA = '25' AND DIA_25 = '' THEN @VP_INV_NO WHEN @VP_DIA = '25' AND DIA_25 <> '' AND DIA_25 LIKE '%' + @VP_INV_NO + '%' THEN DIA_25 WHEN @VP_DIA = '25' AND DIA_25 <> '' AND DIA_25 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_25,'/', @VP_INV_NO) ELSE DIA_25 END ), 
																DIA_26	= 	( CASE WHEN @VP_DIA = '26' AND DIA_26 = '' THEN @VP_INV_NO WHEN @VP_DIA = '26' AND DIA_26 <> '' AND DIA_26 LIKE '%' + @VP_INV_NO + '%' THEN DIA_26 WHEN @VP_DIA = '26' AND DIA_26 <> '' AND DIA_26 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_26,'/', @VP_INV_NO) ELSE DIA_26 END ), 
																DIA_27	= 	( CASE WHEN @VP_DIA = '27' AND DIA_27 = '' THEN @VP_INV_NO WHEN @VP_DIA = '27' AND DIA_27 <> '' AND DIA_27 LIKE '%' + @VP_INV_NO + '%' THEN DIA_27 WHEN @VP_DIA = '27' AND DIA_27 <> '' AND DIA_27 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_27,'/', @VP_INV_NO) ELSE DIA_27 END ), 
																DIA_28	= 	( CASE WHEN @VP_DIA = '28' AND DIA_28 = '' THEN @VP_INV_NO WHEN @VP_DIA = '28' AND DIA_28 <> '' AND DIA_28 LIKE '%' + @VP_INV_NO + '%' THEN DIA_28 WHEN @VP_DIA = '28' AND DIA_28 <> '' AND DIA_28 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_28,'/', @VP_INV_NO) ELSE DIA_28 END ),
																DIA_29	= 	( CASE WHEN @VP_DIA = '29' AND DIA_29 = '' THEN @VP_INV_NO WHEN @VP_DIA = '29' AND DIA_29 <> '' AND DIA_29 LIKE '%' + @VP_INV_NO + '%' THEN DIA_29 WHEN @VP_DIA = '29' AND DIA_29 <> '' AND DIA_29 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_29,'/', @VP_INV_NO) ELSE DIA_29 END ), 
																DIA_30	= 	( CASE WHEN @VP_DIA = '30' AND DIA_30 = '' THEN @VP_INV_NO WHEN @VP_DIA = '30' AND DIA_30 <> '' AND DIA_30 LIKE '%' + @VP_INV_NO + '%' THEN DIA_30 WHEN @VP_DIA = '30' AND DIA_30 <> '' AND DIA_30 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_30,'/', @VP_INV_NO) ELSE DIA_30 END ),	
																DIA_31	= 	( CASE WHEN @VP_DIA = '31' AND DIA_31 = '' THEN @VP_INV_NO WHEN @VP_DIA = '31' AND DIA_31 <> '' AND DIA_31 LIKE '%' + @VP_INV_NO + '%' THEN DIA_31 WHEN @VP_DIA = '31' AND DIA_31 <> '' AND DIA_31 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_31,'/', @VP_INV_NO) ELSE DIA_31 END )
														WHERE CUS_PART_NO = 'INVOICE'
														AND TYPE = @VP_TYPE				

														IF @VP_INV_NO <> 'N/F'
															BEGIN
																SELECT @VP_TOTAL_INV_NO = SUM(qty_to_ship * unit_price)
																FROM OELINHST_SQL 
																WHERE LTRIM(RTRIM(inv_no)) = @VP_INV_NO
																AND  LTRIM(RTRIM(item_desc_2)) = @VP_TYPE
															
																SET @VP_AMOUNT =  CONVERT(VARCHAR(15),@VP_TOTAL_INV_NO)
															END																			

														-- UPDATE AMOUNT
														UPDATE	@VP_SALIDA_PIEL_MHI_TBL 	
															SET	DIA_1	= 	( CASE WHEN @VP_DIA = '01' AND DIA_1  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '01' AND DIA_1  <> '' AND DIA_1  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_1  WHEN @VP_DIA = '01' AND DIA_1  <> '' AND DIA_1  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_1 ,'/', @VP_AMOUNT) ELSE DIA_1 END ),
																DIA_2	= 	( CASE WHEN @VP_DIA = '02' AND DIA_2  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '02' AND DIA_2  <> '' AND DIA_2  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_2  WHEN @VP_DIA = '02' AND DIA_2  <> '' AND DIA_2  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_2 ,'/', @VP_AMOUNT) ELSE DIA_2 END ), 
																DIA_3	= 	( CASE WHEN @VP_DIA = '03' AND DIA_3  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '03' AND DIA_3  <> '' AND DIA_3  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_3  WHEN @VP_DIA = '03' AND DIA_3  <> '' AND DIA_3  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_3 ,'/', @VP_AMOUNT) ELSE DIA_3 END ),
																DIA_4	= 	( CASE WHEN @VP_DIA = '04' AND DIA_4  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '04' AND DIA_4  <> '' AND DIA_4  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_4  WHEN @VP_DIA = '04' AND DIA_4  <> '' AND DIA_4  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_4 ,'/', @VP_AMOUNT) ELSE DIA_4 END ),
																DIA_5	= 	( CASE WHEN @VP_DIA = '05' AND DIA_5  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '05' AND DIA_5  <> '' AND DIA_5  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_5  WHEN @VP_DIA = '05' AND DIA_5  <> '' AND DIA_5  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_5 ,'/', @VP_AMOUNT) ELSE DIA_5 END ),
																DIA_6	= 	( CASE WHEN @VP_DIA = '06' AND DIA_6  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '06' AND DIA_6  <> '' AND DIA_6  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_6  WHEN @VP_DIA = '06' AND DIA_6  <> '' AND DIA_6  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_6 ,'/', @VP_AMOUNT) ELSE DIA_6 END ),
																DIA_7	= 	( CASE WHEN @VP_DIA = '07' AND DIA_7  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '07' AND DIA_7  <> '' AND DIA_7  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_7  WHEN @VP_DIA = '07' AND DIA_7  <> '' AND DIA_7  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_7 ,'/', @VP_AMOUNT) ELSE DIA_7 END ),
																DIA_8	= 	( CASE WHEN @VP_DIA = '08' AND DIA_8  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '08' AND DIA_8  <> '' AND DIA_8  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_8  WHEN @VP_DIA = '08' AND DIA_8  <> '' AND DIA_8  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_8 ,'/', @VP_AMOUNT) ELSE DIA_8 END ),
																DIA_9	= 	( CASE WHEN @VP_DIA = '09' AND DIA_9  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '09' AND DIA_9  <> '' AND DIA_9  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_9  WHEN @VP_DIA = '09' AND DIA_9  <> '' AND DIA_9  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_9 ,'/', @VP_AMOUNT) ELSE DIA_9 END ),
																DIA_10	= 	( CASE WHEN @VP_DIA = '10' AND DIA_10 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '10' AND DIA_10 <> '' AND DIA_10 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_10 WHEN @VP_DIA = '10' AND DIA_10 <> '' AND DIA_10 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_10,'/', @VP_AMOUNT) ELSE DIA_10 END ),	
																DIA_11	= 	( CASE WHEN @VP_DIA = '11' AND DIA_11 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '11' AND DIA_11 <> '' AND DIA_11 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_11 WHEN @VP_DIA = '11' AND DIA_11 <> '' AND DIA_11 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_11,'/', @VP_AMOUNT) ELSE DIA_11 END ),	 
																DIA_12	= 	( CASE WHEN @VP_DIA = '12' AND DIA_12 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '12' AND DIA_12 <> '' AND DIA_12 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_12 WHEN @VP_DIA = '12' AND DIA_12 <> '' AND DIA_12 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_12,'/', @VP_AMOUNT) ELSE DIA_12 END ),	 
																DIA_13	= 	( CASE WHEN @VP_DIA = '13' AND DIA_13 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '13' AND DIA_13 <> '' AND DIA_13 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_13 WHEN @VP_DIA = '13' AND DIA_13 <> '' AND DIA_13 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_13,'/', @VP_AMOUNT) ELSE DIA_13 END ),	 
																DIA_14	= 	( CASE WHEN @VP_DIA = '14' AND DIA_14 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '14' AND DIA_14 <> '' AND DIA_14 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_14 WHEN @VP_DIA = '14' AND DIA_14 <> '' AND DIA_14 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_14,'/', @VP_AMOUNT) ELSE DIA_14 END ),	 
																DIA_15	= 	( CASE WHEN @VP_DIA = '15' AND DIA_15 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '15' AND DIA_15 <> '' AND DIA_15 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_15 WHEN @VP_DIA = '15' AND DIA_15 <> '' AND DIA_15 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_15,'/', @VP_AMOUNT) ELSE DIA_15 END ),	 
																DIA_16	= 	( CASE WHEN @VP_DIA = '16' AND DIA_16 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '16' AND DIA_16 <> '' AND DIA_16 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_16 WHEN @VP_DIA = '16' AND DIA_16 <> '' AND DIA_16 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_16,'/', @VP_AMOUNT) ELSE DIA_16 END ),	 
																DIA_17	= 	( CASE WHEN @VP_DIA = '17' AND DIA_17 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '17' AND DIA_17 <> '' AND DIA_17 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_17 WHEN @VP_DIA = '17' AND DIA_17 <> '' AND DIA_17 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_17,'/', @VP_AMOUNT) ELSE DIA_17 END ),	 
																DIA_18	= 	( CASE WHEN @VP_DIA = '18' AND DIA_18 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '18' AND DIA_18 <> '' AND DIA_18 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_18 WHEN @VP_DIA = '18' AND DIA_18 <> '' AND DIA_18 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_18,'/', @VP_AMOUNT) ELSE DIA_18 END ),	 
																DIA_19	= 	( CASE WHEN @VP_DIA = '19' AND DIA_19 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '19' AND DIA_19 <> '' AND DIA_19 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_19 WHEN @VP_DIA = '19' AND DIA_19 <> '' AND DIA_19 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_19,'/', @VP_AMOUNT) ELSE DIA_19 END ),	 
																DIA_20	= 	( CASE WHEN @VP_DIA = '20' AND DIA_20 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '20' AND DIA_20 <> '' AND DIA_20 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_20 WHEN @VP_DIA = '20' AND DIA_20 <> '' AND DIA_20 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_20,'/', @VP_AMOUNT) ELSE DIA_20 END ),
																DIA_21	= 	( CASE WHEN @VP_DIA = '21' AND DIA_21 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '21' AND DIA_21 <> '' AND DIA_21 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_21 WHEN @VP_DIA = '21' AND DIA_21 <> '' AND DIA_21 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_21,'/', @VP_AMOUNT) ELSE DIA_21 END ), 
																DIA_22	= 	( CASE WHEN @VP_DIA = '22' AND DIA_22 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '22' AND DIA_22 <> '' AND DIA_22 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_22 WHEN @VP_DIA = '22' AND DIA_22 <> '' AND DIA_22 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_22,'/', @VP_AMOUNT) ELSE DIA_22 END ), 
																DIA_23	= 	( CASE WHEN @VP_DIA = '23' AND DIA_23 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '23' AND DIA_23 <> '' AND DIA_23 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_23 WHEN @VP_DIA = '23' AND DIA_23 <> '' AND DIA_23 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_23,'/', @VP_AMOUNT) ELSE DIA_23 END ), 
																DIA_24	= 	( CASE WHEN @VP_DIA = '24' AND DIA_24 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '24' AND DIA_24 <> '' AND DIA_24 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_24 WHEN @VP_DIA = '24' AND DIA_24 <> '' AND DIA_24 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_24,'/', @VP_AMOUNT) ELSE DIA_24 END ), 
																DIA_25	= 	( CASE WHEN @VP_DIA = '25' AND DIA_25 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '25' AND DIA_25 <> '' AND DIA_25 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_25 WHEN @VP_DIA = '25' AND DIA_25 <> '' AND DIA_25 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_25,'/', @VP_AMOUNT) ELSE DIA_25 END ), 
																DIA_26	= 	( CASE WHEN @VP_DIA = '26' AND DIA_26 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '26' AND DIA_26 <> '' AND DIA_26 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_26 WHEN @VP_DIA = '26' AND DIA_26 <> '' AND DIA_26 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_26,'/', @VP_AMOUNT) ELSE DIA_26 END ), 
																DIA_27	= 	( CASE WHEN @VP_DIA = '27' AND DIA_27 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '27' AND DIA_27 <> '' AND DIA_27 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_27 WHEN @VP_DIA = '27' AND DIA_27 <> '' AND DIA_27 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_27,'/', @VP_AMOUNT) ELSE DIA_27 END ), 
																DIA_28	= 	( CASE WHEN @VP_DIA = '28' AND DIA_28 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '28' AND DIA_28 <> '' AND DIA_28 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_28 WHEN @VP_DIA = '28' AND DIA_28 <> '' AND DIA_28 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_28,'/', @VP_AMOUNT) ELSE DIA_28 END ),
																DIA_29	= 	( CASE WHEN @VP_DIA = '29' AND DIA_29 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '29' AND DIA_29 <> '' AND DIA_29 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_29 WHEN @VP_DIA = '29' AND DIA_29 <> '' AND DIA_29 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_29,'/', @VP_AMOUNT) ELSE DIA_29 END ), 
																DIA_30	= 	( CASE WHEN @VP_DIA = '30' AND DIA_30 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '30' AND DIA_30 <> '' AND DIA_30 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_30 WHEN @VP_DIA = '30' AND DIA_30 <> '' AND DIA_30 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_30,'/', @VP_AMOUNT) ELSE DIA_30 END ),	
																DIA_31	= 	( CASE WHEN @VP_DIA = '31' AND DIA_31 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '31' AND DIA_31 <> '' AND DIA_31 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_31 WHEN @VP_DIA = '31' AND DIA_31 <> '' AND DIA_31 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_31,'/', @VP_AMOUNT) ELSE DIA_31 END )
														WHERE CUS_PART_NO = 'AMOUNT'	
														AND TYPE = @VP_TYPE	

														-- UPDATE QTY		
														UPDATE	@VP_SALIDA_PIEL_MHI_TBL 	
															SET	DIA_1	= 	( CASE WHEN @VP_DIA = '01' THEN ( CASE WHEN DIA_1 = '' THEN @VP_QTY ELSE CONCAT(DIA_1,'/', @VP_QTY) END) ELSE DIA_1 END ), 
																DIA_2	= 	( CASE WHEN @VP_DIA = '02' THEN ( CASE WHEN DIA_2 = '' THEN @VP_QTY ELSE CONCAT(DIA_2,'/', @VP_QTY) END) ELSE DIA_2 END ),    
																DIA_3	= 	( CASE WHEN @VP_DIA = '03' THEN ( CASE WHEN DIA_3 = '' THEN @VP_QTY ELSE CONCAT(DIA_3,'/', @VP_QTY) END) ELSE DIA_3 END ),    
																DIA_4	= 	( CASE WHEN @VP_DIA = '04' THEN ( CASE WHEN DIA_4 = '' THEN @VP_QTY ELSE CONCAT(DIA_4,'/', @VP_QTY) END) ELSE DIA_4 END ),    
																DIA_5	= 	( CASE WHEN @VP_DIA = '05' THEN ( CASE WHEN DIA_5 = '' THEN @VP_QTY ELSE CONCAT(DIA_5,'/', @VP_QTY) END) ELSE DIA_5 END ),    
																DIA_6	= 	( CASE WHEN @VP_DIA = '06' THEN ( CASE WHEN DIA_6 = '' THEN @VP_QTY ELSE CONCAT(DIA_6,'/', @VP_QTY) END) ELSE DIA_6 END ),    
																DIA_7	= 	( CASE WHEN @VP_DIA = '07' THEN ( CASE WHEN DIA_7 = '' THEN @VP_QTY ELSE CONCAT(DIA_7,'/', @VP_QTY) END) ELSE DIA_7 END ),    
																DIA_8	= 	( CASE WHEN @VP_DIA = '08' THEN ( CASE WHEN DIA_8 = '' THEN @VP_QTY ELSE CONCAT(DIA_8,'/', @VP_QTY) END) ELSE DIA_8 END ),    
																DIA_9	= 	( CASE WHEN @VP_DIA = '09' THEN ( CASE WHEN DIA_9 = '' THEN @VP_QTY ELSE CONCAT(DIA_9,'/', @VP_QTY) END) ELSE DIA_9 END ),    
																DIA_10	= 	( CASE WHEN @VP_DIA = '10' THEN ( CASE WHEN DIA_10 = '' THEN @VP_QTY ELSE CONCAT(DIA_10,'/', @VP_QTY) END) ELSE DIA_10 END ),	
																DIA_11	= 	( CASE WHEN @VP_DIA = '11' THEN ( CASE WHEN DIA_11 = '' THEN @VP_QTY ELSE CONCAT(DIA_11,'/', @VP_QTY) END) ELSE DIA_11 END ),	 
																DIA_12	= 	( CASE WHEN @VP_DIA = '12' THEN ( CASE WHEN DIA_12 = '' THEN @VP_QTY ELSE CONCAT(DIA_12,'/', @VP_QTY) END) ELSE DIA_12 END ),	 
																DIA_13	= 	( CASE WHEN @VP_DIA = '13' THEN ( CASE WHEN DIA_13 = '' THEN @VP_QTY ELSE CONCAT(DIA_13,'/', @VP_QTY) END) ELSE DIA_13 END ),	 
																DIA_14	= 	( CASE WHEN @VP_DIA = '14' THEN ( CASE WHEN DIA_14 = '' THEN @VP_QTY ELSE CONCAT(DIA_14,'/', @VP_QTY) END) ELSE DIA_14 END ),	 
																DIA_15	= 	( CASE WHEN @VP_DIA = '15' THEN ( CASE WHEN DIA_15 = '' THEN @VP_QTY ELSE CONCAT(DIA_15,'/', @VP_QTY) END) ELSE DIA_15 END ),	 
																DIA_16	= 	( CASE WHEN @VP_DIA = '16' THEN ( CASE WHEN DIA_16 = '' THEN @VP_QTY ELSE CONCAT(DIA_16,'/', @VP_QTY) END) ELSE DIA_16 END ),	 
																DIA_17	= 	( CASE WHEN @VP_DIA = '17' THEN ( CASE WHEN DIA_17 = '' THEN @VP_QTY ELSE CONCAT(DIA_17,'/', @VP_QTY) END) ELSE DIA_17 END ),	 
																DIA_18	= 	( CASE WHEN @VP_DIA = '18' THEN ( CASE WHEN DIA_18 = '' THEN @VP_QTY ELSE CONCAT(DIA_18,'/', @VP_QTY) END) ELSE DIA_18 END ),	 
																DIA_19	= 	( CASE WHEN @VP_DIA = '19' THEN ( CASE WHEN DIA_19 = '' THEN @VP_QTY ELSE CONCAT(DIA_19,'/', @VP_QTY) END) ELSE DIA_19 END ),	 
																DIA_20	= 	( CASE WHEN @VP_DIA = '20' THEN ( CASE WHEN DIA_20 = '' THEN @VP_QTY ELSE CONCAT(DIA_20,'/', @VP_QTY) END) ELSE DIA_20 END ),
																DIA_21	= 	( CASE WHEN @VP_DIA = '21' THEN ( CASE WHEN DIA_21 = '' THEN @VP_QTY ELSE CONCAT(DIA_21,'/', @VP_QTY) END) ELSE DIA_21 END ), 
																DIA_22	= 	( CASE WHEN @VP_DIA = '22' THEN ( CASE WHEN DIA_22 = '' THEN @VP_QTY ELSE CONCAT(DIA_22,'/', @VP_QTY) END) ELSE DIA_22 END ), 
																DIA_23	= 	( CASE WHEN @VP_DIA = '23' THEN ( CASE WHEN DIA_23 = '' THEN @VP_QTY ELSE CONCAT(DIA_23,'/', @VP_QTY) END) ELSE DIA_23 END ), 
																DIA_24	= 	( CASE WHEN @VP_DIA = '24' THEN ( CASE WHEN DIA_24 = '' THEN @VP_QTY ELSE CONCAT(DIA_24,'/', @VP_QTY) END) ELSE DIA_24 END ), 
																DIA_25	= 	( CASE WHEN @VP_DIA = '25' THEN ( CASE WHEN DIA_25 = '' THEN @VP_QTY ELSE CONCAT(DIA_25,'/', @VP_QTY) END) ELSE DIA_25 END ), 
																DIA_26	= 	( CASE WHEN @VP_DIA = '26' THEN ( CASE WHEN DIA_26 = '' THEN @VP_QTY ELSE CONCAT(DIA_26,'/', @VP_QTY) END) ELSE DIA_26 END ), 
																DIA_27	= 	( CASE WHEN @VP_DIA = '27' THEN ( CASE WHEN DIA_27 = '' THEN @VP_QTY ELSE CONCAT(DIA_27,'/', @VP_QTY) END) ELSE DIA_27 END ), 
																DIA_28	= 	( CASE WHEN @VP_DIA = '28' THEN ( CASE WHEN DIA_28 = '' THEN @VP_QTY ELSE CONCAT(DIA_28,'/', @VP_QTY) END) ELSE DIA_28 END ),
																DIA_29	= 	( CASE WHEN @VP_DIA = '29' THEN ( CASE WHEN DIA_29 = '' THEN @VP_QTY ELSE CONCAT(DIA_29,'/', @VP_QTY) END) ELSE DIA_29 END ), 
																DIA_30	= 	( CASE WHEN @VP_DIA = '30' THEN ( CASE WHEN DIA_30 = '' THEN @VP_QTY ELSE CONCAT(DIA_30,'/', @VP_QTY) END) ELSE DIA_30 END ),	
																DIA_31	= 	( CASE WHEN @VP_DIA = '31' THEN ( CASE WHEN DIA_31 = '' THEN @VP_QTY ELSE CONCAT(DIA_31,'/', @VP_QTY) END) ELSE DIA_31 END )
														WHERE CUS_PART_NO = @VP_CUS_PART_NO	
													END
												ELSE
													BEGIN
															-- UPDATE DATE
														UPDATE	@VP_SALIDA_PIEL_MHI_TBL 	
															SET	DIA_1	= 	( CASE WHEN @VP_DIA = '01' THEN @VP_CDATE  ELSE DIA_1 END ), 
																DIA_2	= 	( CASE WHEN @VP_DIA = '02' THEN @VP_CDATE  ELSE DIA_2 END ),  
																DIA_3	= 	( CASE WHEN @VP_DIA = '03' THEN @VP_CDATE  ELSE DIA_3 END ),  
																DIA_4	= 	( CASE WHEN @VP_DIA = '04' THEN @VP_CDATE  ELSE DIA_4 END ),  
																DIA_5	= 	( CASE WHEN @VP_DIA = '05' THEN @VP_CDATE  ELSE DIA_5 END ),  
																DIA_6	= 	( CASE WHEN @VP_DIA = '06' THEN @VP_CDATE  ELSE DIA_6 END ),  
																DIA_7	= 	( CASE WHEN @VP_DIA = '07' THEN @VP_CDATE  ELSE DIA_7 END ),  
																DIA_8	= 	( CASE WHEN @VP_DIA = '08' THEN @VP_CDATE  ELSE DIA_8 END ),  
																DIA_9	= 	( CASE WHEN @VP_DIA = '09' THEN @VP_CDATE  ELSE DIA_9 END ),  
																DIA_10	= 	( CASE WHEN @VP_DIA = '10' THEN @VP_CDATE  ELSE DIA_10 END ),	
																DIA_11	= 	( CASE WHEN @VP_DIA = '11' THEN @VP_CDATE  ELSE DIA_11 END ),	 
																DIA_12	= 	( CASE WHEN @VP_DIA = '12' THEN @VP_CDATE  ELSE DIA_12 END ),	 
																DIA_13	= 	( CASE WHEN @VP_DIA = '13' THEN @VP_CDATE  ELSE DIA_13 END ),	 
																DIA_14	= 	( CASE WHEN @VP_DIA = '14' THEN @VP_CDATE  ELSE DIA_14 END ),	 
																DIA_15	= 	( CASE WHEN @VP_DIA = '15' THEN @VP_CDATE  ELSE DIA_15 END ),	 
																DIA_16	= 	( CASE WHEN @VP_DIA = '16' THEN @VP_CDATE  ELSE DIA_16 END ),	 
																DIA_17	= 	( CASE WHEN @VP_DIA = '17' THEN @VP_CDATE  ELSE DIA_17 END ),	 
																DIA_18	= 	( CASE WHEN @VP_DIA = '18' THEN @VP_CDATE  ELSE DIA_18 END ),	 
																DIA_19	= 	( CASE WHEN @VP_DIA = '19' THEN @VP_CDATE  ELSE DIA_19 END ),	 
																DIA_20	= 	( CASE WHEN @VP_DIA = '20' THEN @VP_CDATE  ELSE DIA_20 END ),
																DIA_21	= 	( CASE WHEN @VP_DIA = '21' THEN @VP_CDATE  ELSE DIA_21 END ), 
																DIA_22	= 	( CASE WHEN @VP_DIA = '22' THEN @VP_CDATE  ELSE DIA_22 END ), 
																DIA_23	= 	( CASE WHEN @VP_DIA = '23' THEN @VP_CDATE  ELSE DIA_23 END ), 
																DIA_24	= 	( CASE WHEN @VP_DIA = '24' THEN @VP_CDATE  ELSE DIA_24 END ), 
																DIA_25	= 	( CASE WHEN @VP_DIA = '25' THEN @VP_CDATE  ELSE DIA_25 END ), 
																DIA_26	= 	( CASE WHEN @VP_DIA = '26' THEN @VP_CDATE  ELSE DIA_26 END ), 
																DIA_27	= 	( CASE WHEN @VP_DIA = '27' THEN @VP_CDATE  ELSE DIA_27 END ), 
																DIA_28	= 	( CASE WHEN @VP_DIA = '28' THEN @VP_CDATE  ELSE DIA_28 END ),
																DIA_29	= 	( CASE WHEN @VP_DIA = '29' THEN @VP_CDATE  ELSE DIA_29 END ), 
																DIA_30	= 	( CASE WHEN @VP_DIA = '30' THEN @VP_CDATE  ELSE DIA_30 END ),	
																DIA_31	= 	( CASE WHEN @VP_DIA = '31' THEN @VP_CDATE  ELSE DIA_31 END )
														WHERE CUS_PART_NO = 'DATE'	
														AND TYPE = @VP_TYPE				
																						
														
														-- UPDATE PACKING
														UPDATE	@VP_SALIDA_PIEL_MHI_TBL 	
															SET	DIA_1	= 	( CASE WHEN @VP_DIA = '01' AND DIA_1  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '01' AND DIA_1  <> '' AND DIA_1  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_1  WHEN @VP_DIA = '01' AND DIA_1  <> '' AND DIA_1  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_1 ,'/', @VP_PACKING_NO) ELSE DIA_1 END ),
																DIA_2	= 	( CASE WHEN @VP_DIA = '02' AND DIA_2  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '02' AND DIA_2  <> '' AND DIA_2  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_2  WHEN @VP_DIA = '02' AND DIA_2  <> '' AND DIA_2  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_2 ,'/', @VP_PACKING_NO) ELSE DIA_2 END ), 
																DIA_3	= 	( CASE WHEN @VP_DIA = '03' AND DIA_3  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '03' AND DIA_3  <> '' AND DIA_3  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_3  WHEN @VP_DIA = '03' AND DIA_3  <> '' AND DIA_3  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_3 ,'/', @VP_PACKING_NO) ELSE DIA_3 END ),
																DIA_4	= 	( CASE WHEN @VP_DIA = '04' AND DIA_4  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '04' AND DIA_4  <> '' AND DIA_4  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_4  WHEN @VP_DIA = '04' AND DIA_4  <> '' AND DIA_4  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_4 ,'/', @VP_PACKING_NO) ELSE DIA_4 END ),
																DIA_5	= 	( CASE WHEN @VP_DIA = '05' AND DIA_5  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '05' AND DIA_5  <> '' AND DIA_5  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_5  WHEN @VP_DIA = '05' AND DIA_5  <> '' AND DIA_5  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_5 ,'/', @VP_PACKING_NO) ELSE DIA_5 END ),
																DIA_6	= 	( CASE WHEN @VP_DIA = '06' AND DIA_6  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '06' AND DIA_6  <> '' AND DIA_6  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_6  WHEN @VP_DIA = '06' AND DIA_6  <> '' AND DIA_6  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_6 ,'/', @VP_PACKING_NO) ELSE DIA_6 END ),
																DIA_7	= 	( CASE WHEN @VP_DIA = '07' AND DIA_7  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '07' AND DIA_7  <> '' AND DIA_7  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_7  WHEN @VP_DIA = '07' AND DIA_7  <> '' AND DIA_7  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_7 ,'/', @VP_PACKING_NO) ELSE DIA_7 END ),
																DIA_8	= 	( CASE WHEN @VP_DIA = '08' AND DIA_8  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '08' AND DIA_8  <> '' AND DIA_8  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_8  WHEN @VP_DIA = '08' AND DIA_8  <> '' AND DIA_8  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_8 ,'/', @VP_PACKING_NO) ELSE DIA_8 END ),
																DIA_9	= 	( CASE WHEN @VP_DIA = '09' AND DIA_9  = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '09' AND DIA_9  <> '' AND DIA_9  LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_9  WHEN @VP_DIA = '09' AND DIA_9  <> '' AND DIA_9  NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_9 ,'/', @VP_PACKING_NO) ELSE DIA_9 END ),
																DIA_10	= 	( CASE WHEN @VP_DIA = '10' AND DIA_10 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '10' AND DIA_10 <> '' AND DIA_10 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_10 WHEN @VP_DIA = '10' AND DIA_10 <> '' AND DIA_10 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_10,'/', @VP_PACKING_NO) ELSE DIA_10 END ),
																DIA_11	= 	( CASE WHEN @VP_DIA = '11' AND DIA_11 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '11' AND DIA_11 <> '' AND DIA_11 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_11 WHEN @VP_DIA = '11' AND DIA_11 <> '' AND DIA_11 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_11,'/', @VP_PACKING_NO) ELSE DIA_11 END ),
																DIA_12	= 	( CASE WHEN @VP_DIA = '12' AND DIA_12 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '12' AND DIA_12 <> '' AND DIA_12 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_12 WHEN @VP_DIA = '12' AND DIA_12 <> '' AND DIA_12 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_12,'/', @VP_PACKING_NO) ELSE DIA_12 END ),
																DIA_13	= 	( CASE WHEN @VP_DIA = '13' AND DIA_13 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '13' AND DIA_13 <> '' AND DIA_13 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_13 WHEN @VP_DIA = '13' AND DIA_13 <> '' AND DIA_13 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_13,'/', @VP_PACKING_NO) ELSE DIA_13 END ),
																DIA_14	= 	( CASE WHEN @VP_DIA = '14' AND DIA_14 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '14' AND DIA_14 <> '' AND DIA_14 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_14 WHEN @VP_DIA = '14' AND DIA_14 <> '' AND DIA_14 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_14,'/', @VP_PACKING_NO) ELSE DIA_14 END ),
																DIA_15	= 	( CASE WHEN @VP_DIA = '15' AND DIA_15 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '15' AND DIA_15 <> '' AND DIA_15 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_15 WHEN @VP_DIA = '15' AND DIA_15 <> '' AND DIA_15 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_15,'/', @VP_PACKING_NO) ELSE DIA_15 END ),
																DIA_16	= 	( CASE WHEN @VP_DIA = '16' AND DIA_16 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '16' AND DIA_16 <> '' AND DIA_16 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_16 WHEN @VP_DIA = '16' AND DIA_16 <> '' AND DIA_16 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_16,'/', @VP_PACKING_NO) ELSE DIA_16 END ),	 
																DIA_17	= 	( CASE WHEN @VP_DIA = '17' AND DIA_17 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '17' AND DIA_17 <> '' AND DIA_17 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_17 WHEN @VP_DIA = '17' AND DIA_17 <> '' AND DIA_17 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_17,'/', @VP_PACKING_NO) ELSE DIA_17 END ),	 
																DIA_18	= 	( CASE WHEN @VP_DIA = '18' AND DIA_18 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '18' AND DIA_18 <> '' AND DIA_18 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_18 WHEN @VP_DIA = '18' AND DIA_18 <> '' AND DIA_18 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_18,'/', @VP_PACKING_NO) ELSE DIA_18 END ),	 
																DIA_19	= 	( CASE WHEN @VP_DIA = '19' AND DIA_19 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '19' AND DIA_19 <> '' AND DIA_19 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_19 WHEN @VP_DIA = '19' AND DIA_19 <> '' AND DIA_19 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_19,'/', @VP_PACKING_NO) ELSE DIA_19 END ),	 
																DIA_20	= 	( CASE WHEN @VP_DIA = '20' AND DIA_20 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '20' AND DIA_20 <> '' AND DIA_20 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_20 WHEN @VP_DIA = '20' AND DIA_20 <> '' AND DIA_20 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_20,'/', @VP_PACKING_NO) ELSE DIA_20 END ),
																DIA_21	= 	( CASE WHEN @VP_DIA = '21' AND DIA_21 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '21' AND DIA_21 <> '' AND DIA_21 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_21 WHEN @VP_DIA = '21' AND DIA_21 <> '' AND DIA_21 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_21,'/', @VP_PACKING_NO) ELSE DIA_21 END ),
																DIA_22	= 	( CASE WHEN @VP_DIA = '22' AND DIA_22 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '22' AND DIA_22 <> '' AND DIA_22 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_22 WHEN @VP_DIA = '22' AND DIA_22 <> '' AND DIA_22 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_22,'/', @VP_PACKING_NO) ELSE DIA_22 END ),
																DIA_23	= 	( CASE WHEN @VP_DIA = '23' AND DIA_23 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '23' AND DIA_23 <> '' AND DIA_23 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_23 WHEN @VP_DIA = '23' AND DIA_23 <> '' AND DIA_23 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_23,'/', @VP_PACKING_NO) ELSE DIA_23 END ),
																DIA_24	= 	( CASE WHEN @VP_DIA = '24' AND DIA_24 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '24' AND DIA_24 <> '' AND DIA_24 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_24 WHEN @VP_DIA = '24' AND DIA_24 <> '' AND DIA_24 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_24,'/', @VP_PACKING_NO) ELSE DIA_24 END ),
																DIA_25	= 	( CASE WHEN @VP_DIA = '25' AND DIA_25 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '25' AND DIA_25 <> '' AND DIA_25 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_25 WHEN @VP_DIA = '25' AND DIA_25 <> '' AND DIA_25 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_25,'/', @VP_PACKING_NO) ELSE DIA_25 END ),
																DIA_26	= 	( CASE WHEN @VP_DIA = '26' AND DIA_26 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '26' AND DIA_26 <> '' AND DIA_26 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_26 WHEN @VP_DIA = '26' AND DIA_26 <> '' AND DIA_26 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_26,'/', @VP_PACKING_NO) ELSE DIA_26 END ), 
																DIA_27	= 	( CASE WHEN @VP_DIA = '27' AND DIA_27 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '27' AND DIA_27 <> '' AND DIA_27 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_27 WHEN @VP_DIA = '27' AND DIA_27 <> '' AND DIA_27 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_27,'/', @VP_PACKING_NO) ELSE DIA_27 END ), 
																DIA_28	= 	( CASE WHEN @VP_DIA = '28' AND DIA_28 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '28' AND DIA_28 <> '' AND DIA_28 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_28 WHEN @VP_DIA = '28' AND DIA_28 <> '' AND DIA_28 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_28,'/', @VP_PACKING_NO) ELSE DIA_28 END ),
																DIA_29	= 	( CASE WHEN @VP_DIA = '29' AND DIA_29 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '29' AND DIA_29 <> '' AND DIA_29 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_29 WHEN @VP_DIA = '29' AND DIA_29 <> '' AND DIA_29 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_29,'/', @VP_PACKING_NO) ELSE DIA_29 END ),
																DIA_30	= 	( CASE WHEN @VP_DIA = '30' AND DIA_30 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '30' AND DIA_30 <> '' AND DIA_30 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_30 WHEN @VP_DIA = '30' AND DIA_30 <> '' AND DIA_30 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_30,'/', @VP_PACKING_NO) ELSE DIA_30 END ),	
																DIA_31	= 	( CASE WHEN @VP_DIA = '31' AND DIA_31 = '' THEN @VP_PACKING_NO WHEN @VP_DIA = '31' AND DIA_31 <> '' AND DIA_31 LIKE '%' + @VP_PACKING_NO + '%' THEN DIA_31 WHEN @VP_DIA = '31' AND DIA_31 <> '' AND DIA_31 NOT LIKE '%' + @VP_PACKING_NO + '%' THEN CONCAT(DIA_31,'/', @VP_PACKING_NO) ELSE DIA_31 END )
														WHERE CUS_PART_NO = 'PACKING'	
														AND TYPE = @VP_TYPE

														-- UPDATE INVOICE
														UPDATE	@VP_SALIDA_PIEL_MHI_TBL 	
															SET	DIA_1	= 	( CASE WHEN @VP_DIA = '01' AND DIA_1  = '' THEN @VP_INV_NO WHEN @VP_DIA = '01' AND DIA_1  <> '' AND DIA_1  LIKE '%' + @VP_INV_NO + '%' THEN DIA_1  WHEN @VP_DIA = '01' AND DIA_1  <> '' AND DIA_1  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_1 ,'/', @VP_INV_NO) ELSE DIA_1 END ),
																DIA_2	= 	( CASE WHEN @VP_DIA = '02' AND DIA_2  = '' THEN @VP_INV_NO WHEN @VP_DIA = '02' AND DIA_2  <> '' AND DIA_2  LIKE '%' + @VP_INV_NO + '%' THEN DIA_2  WHEN @VP_DIA = '02' AND DIA_2  <> '' AND DIA_2  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_2 ,'/', @VP_INV_NO) ELSE DIA_2 END ), 
																DIA_3	= 	( CASE WHEN @VP_DIA = '03' AND DIA_3  = '' THEN @VP_INV_NO WHEN @VP_DIA = '03' AND DIA_3  <> '' AND DIA_3  LIKE '%' + @VP_INV_NO + '%' THEN DIA_3  WHEN @VP_DIA = '03' AND DIA_3  <> '' AND DIA_3  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_3 ,'/', @VP_INV_NO) ELSE DIA_3 END ),
																DIA_4	= 	( CASE WHEN @VP_DIA = '04' AND DIA_4  = '' THEN @VP_INV_NO WHEN @VP_DIA = '04' AND DIA_4  <> '' AND DIA_4  LIKE '%' + @VP_INV_NO + '%' THEN DIA_4  WHEN @VP_DIA = '04' AND DIA_4  <> '' AND DIA_4  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_4 ,'/', @VP_INV_NO) ELSE DIA_4 END ),
																DIA_5	= 	( CASE WHEN @VP_DIA = '05' AND DIA_5  = '' THEN @VP_INV_NO WHEN @VP_DIA = '05' AND DIA_5  <> '' AND DIA_5  LIKE '%' + @VP_INV_NO + '%' THEN DIA_5  WHEN @VP_DIA = '05' AND DIA_5  <> '' AND DIA_5  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_5 ,'/', @VP_INV_NO) ELSE DIA_5 END ),
																DIA_6	= 	( CASE WHEN @VP_DIA = '06' AND DIA_6  = '' THEN @VP_INV_NO WHEN @VP_DIA = '06' AND DIA_6  <> '' AND DIA_6  LIKE '%' + @VP_INV_NO + '%' THEN DIA_6  WHEN @VP_DIA = '06' AND DIA_6  <> '' AND DIA_6  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_6 ,'/', @VP_INV_NO) ELSE DIA_6 END ),
																DIA_7	= 	( CASE WHEN @VP_DIA = '07' AND DIA_7  = '' THEN @VP_INV_NO WHEN @VP_DIA = '07' AND DIA_7  <> '' AND DIA_7  LIKE '%' + @VP_INV_NO + '%' THEN DIA_7  WHEN @VP_DIA = '07' AND DIA_7  <> '' AND DIA_7  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_7 ,'/', @VP_INV_NO) ELSE DIA_7 END ),
																DIA_8	= 	( CASE WHEN @VP_DIA = '08' AND DIA_8  = '' THEN @VP_INV_NO WHEN @VP_DIA = '08' AND DIA_8  <> '' AND DIA_8  LIKE '%' + @VP_INV_NO + '%' THEN DIA_8  WHEN @VP_DIA = '08' AND DIA_8  <> '' AND DIA_8  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_8 ,'/', @VP_INV_NO) ELSE DIA_8 END ),
																DIA_9	= 	( CASE WHEN @VP_DIA = '09' AND DIA_9  = '' THEN @VP_INV_NO WHEN @VP_DIA = '09' AND DIA_9  <> '' AND DIA_9  LIKE '%' + @VP_INV_NO + '%' THEN DIA_9  WHEN @VP_DIA = '09' AND DIA_9  <> '' AND DIA_9  NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_9 ,'/', @VP_INV_NO) ELSE DIA_9 END ),
																DIA_10	= 	( CASE WHEN @VP_DIA = '10' AND DIA_10 = '' THEN @VP_INV_NO WHEN @VP_DIA = '10' AND DIA_10 <> '' AND DIA_10 LIKE '%' + @VP_INV_NO + '%' THEN DIA_10 WHEN @VP_DIA = '10' AND DIA_10 <> '' AND DIA_10 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_10,'/', @VP_INV_NO) ELSE DIA_10 END ),	
																DIA_11	= 	( CASE WHEN @VP_DIA = '11' AND DIA_11 = '' THEN @VP_INV_NO WHEN @VP_DIA = '11' AND DIA_11 <> '' AND DIA_11 LIKE '%' + @VP_INV_NO + '%' THEN DIA_11 WHEN @VP_DIA = '11' AND DIA_11 <> '' AND DIA_11 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_11,'/', @VP_INV_NO) ELSE DIA_11 END ),	 
																DIA_12	= 	( CASE WHEN @VP_DIA = '12' AND DIA_12 = '' THEN @VP_INV_NO WHEN @VP_DIA = '12' AND DIA_12 <> '' AND DIA_12 LIKE '%' + @VP_INV_NO + '%' THEN DIA_12 WHEN @VP_DIA = '12' AND DIA_12 <> '' AND DIA_12 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_12,'/', @VP_INV_NO) ELSE DIA_12 END ),	 
																DIA_13	= 	( CASE WHEN @VP_DIA = '13' AND DIA_13 = '' THEN @VP_INV_NO WHEN @VP_DIA = '13' AND DIA_13 <> '' AND DIA_13 LIKE '%' + @VP_INV_NO + '%' THEN DIA_13 WHEN @VP_DIA = '13' AND DIA_13 <> '' AND DIA_13 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_13,'/', @VP_INV_NO) ELSE DIA_13 END ),	 
																DIA_14	= 	( CASE WHEN @VP_DIA = '14' AND DIA_14 = '' THEN @VP_INV_NO WHEN @VP_DIA = '14' AND DIA_14 <> '' AND DIA_14 LIKE '%' + @VP_INV_NO + '%' THEN DIA_14 WHEN @VP_DIA = '14' AND DIA_14 <> '' AND DIA_14 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_14,'/', @VP_INV_NO) ELSE DIA_14 END ),	 
																DIA_15	= 	( CASE WHEN @VP_DIA = '15' AND DIA_15 = '' THEN @VP_INV_NO WHEN @VP_DIA = '15' AND DIA_15 <> '' AND DIA_15 LIKE '%' + @VP_INV_NO + '%' THEN DIA_15 WHEN @VP_DIA = '15' AND DIA_15 <> '' AND DIA_15 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_15,'/', @VP_INV_NO) ELSE DIA_15 END ),	 
																DIA_16	= 	( CASE WHEN @VP_DIA = '16' AND DIA_16 = '' THEN @VP_INV_NO WHEN @VP_DIA = '16' AND DIA_16 <> '' AND DIA_16 LIKE '%' + @VP_INV_NO + '%' THEN DIA_16 WHEN @VP_DIA = '16' AND DIA_16 <> '' AND DIA_16 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_16,'/', @VP_INV_NO) ELSE DIA_16 END ),	 
																DIA_17	= 	( CASE WHEN @VP_DIA = '17' AND DIA_17 = '' THEN @VP_INV_NO WHEN @VP_DIA = '17' AND DIA_17 <> '' AND DIA_17 LIKE '%' + @VP_INV_NO + '%' THEN DIA_17 WHEN @VP_DIA = '17' AND DIA_17 <> '' AND DIA_17 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_17,'/', @VP_INV_NO) ELSE DIA_17 END ),	 
																DIA_18	= 	( CASE WHEN @VP_DIA = '18' AND DIA_18 = '' THEN @VP_INV_NO WHEN @VP_DIA = '18' AND DIA_18 <> '' AND DIA_18 LIKE '%' + @VP_INV_NO + '%' THEN DIA_18 WHEN @VP_DIA = '18' AND DIA_18 <> '' AND DIA_18 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_18,'/', @VP_INV_NO) ELSE DIA_18 END ),	 
																DIA_19	= 	( CASE WHEN @VP_DIA = '19' AND DIA_19 = '' THEN @VP_INV_NO WHEN @VP_DIA = '19' AND DIA_19 <> '' AND DIA_19 LIKE '%' + @VP_INV_NO + '%' THEN DIA_19 WHEN @VP_DIA = '19' AND DIA_19 <> '' AND DIA_19 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_19,'/', @VP_INV_NO) ELSE DIA_19 END ),	 
																DIA_20	= 	( CASE WHEN @VP_DIA = '20' AND DIA_20 = '' THEN @VP_INV_NO WHEN @VP_DIA = '20' AND DIA_20 <> '' AND DIA_20 LIKE '%' + @VP_INV_NO + '%' THEN DIA_20 WHEN @VP_DIA = '20' AND DIA_20 <> '' AND DIA_20 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_20,'/', @VP_INV_NO) ELSE DIA_20 END ),
																DIA_21	= 	( CASE WHEN @VP_DIA = '21' AND DIA_21 = '' THEN @VP_INV_NO WHEN @VP_DIA = '21' AND DIA_21 <> '' AND DIA_21 LIKE '%' + @VP_INV_NO + '%' THEN DIA_21 WHEN @VP_DIA = '21' AND DIA_21 <> '' AND DIA_21 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_21,'/', @VP_INV_NO) ELSE DIA_21 END ), 
																DIA_22	= 	( CASE WHEN @VP_DIA = '22' AND DIA_22 = '' THEN @VP_INV_NO WHEN @VP_DIA = '22' AND DIA_22 <> '' AND DIA_22 LIKE '%' + @VP_INV_NO + '%' THEN DIA_22 WHEN @VP_DIA = '22' AND DIA_22 <> '' AND DIA_22 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_22,'/', @VP_INV_NO) ELSE DIA_22 END ), 
																DIA_23	= 	( CASE WHEN @VP_DIA = '23' AND DIA_23 = '' THEN @VP_INV_NO WHEN @VP_DIA = '23' AND DIA_23 <> '' AND DIA_23 LIKE '%' + @VP_INV_NO + '%' THEN DIA_23 WHEN @VP_DIA = '23' AND DIA_23 <> '' AND DIA_23 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_23,'/', @VP_INV_NO) ELSE DIA_23 END ), 
																DIA_24	= 	( CASE WHEN @VP_DIA = '24' AND DIA_24 = '' THEN @VP_INV_NO WHEN @VP_DIA = '24' AND DIA_24 <> '' AND DIA_24 LIKE '%' + @VP_INV_NO + '%' THEN DIA_24 WHEN @VP_DIA = '24' AND DIA_24 <> '' AND DIA_24 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_24,'/', @VP_INV_NO) ELSE DIA_24 END ), 
																DIA_25	= 	( CASE WHEN @VP_DIA = '25' AND DIA_25 = '' THEN @VP_INV_NO WHEN @VP_DIA = '25' AND DIA_25 <> '' AND DIA_25 LIKE '%' + @VP_INV_NO + '%' THEN DIA_25 WHEN @VP_DIA = '25' AND DIA_25 <> '' AND DIA_25 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_25,'/', @VP_INV_NO) ELSE DIA_25 END ), 
																DIA_26	= 	( CASE WHEN @VP_DIA = '26' AND DIA_26 = '' THEN @VP_INV_NO WHEN @VP_DIA = '26' AND DIA_26 <> '' AND DIA_26 LIKE '%' + @VP_INV_NO + '%' THEN DIA_26 WHEN @VP_DIA = '26' AND DIA_26 <> '' AND DIA_26 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_26,'/', @VP_INV_NO) ELSE DIA_26 END ), 
																DIA_27	= 	( CASE WHEN @VP_DIA = '27' AND DIA_27 = '' THEN @VP_INV_NO WHEN @VP_DIA = '27' AND DIA_27 <> '' AND DIA_27 LIKE '%' + @VP_INV_NO + '%' THEN DIA_27 WHEN @VP_DIA = '27' AND DIA_27 <> '' AND DIA_27 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_27,'/', @VP_INV_NO) ELSE DIA_27 END ), 
																DIA_28	= 	( CASE WHEN @VP_DIA = '28' AND DIA_28 = '' THEN @VP_INV_NO WHEN @VP_DIA = '28' AND DIA_28 <> '' AND DIA_28 LIKE '%' + @VP_INV_NO + '%' THEN DIA_28 WHEN @VP_DIA = '28' AND DIA_28 <> '' AND DIA_28 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_28,'/', @VP_INV_NO) ELSE DIA_28 END ),
																DIA_29	= 	( CASE WHEN @VP_DIA = '29' AND DIA_29 = '' THEN @VP_INV_NO WHEN @VP_DIA = '29' AND DIA_29 <> '' AND DIA_29 LIKE '%' + @VP_INV_NO + '%' THEN DIA_29 WHEN @VP_DIA = '29' AND DIA_29 <> '' AND DIA_29 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_29,'/', @VP_INV_NO) ELSE DIA_29 END ), 
																DIA_30	= 	( CASE WHEN @VP_DIA = '30' AND DIA_30 = '' THEN @VP_INV_NO WHEN @VP_DIA = '30' AND DIA_30 <> '' AND DIA_30 LIKE '%' + @VP_INV_NO + '%' THEN DIA_30 WHEN @VP_DIA = '30' AND DIA_30 <> '' AND DIA_30 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_30,'/', @VP_INV_NO) ELSE DIA_30 END ),	
																DIA_31	= 	( CASE WHEN @VP_DIA = '31' AND DIA_31 = '' THEN @VP_INV_NO WHEN @VP_DIA = '31' AND DIA_31 <> '' AND DIA_31 LIKE '%' + @VP_INV_NO + '%' THEN DIA_31 WHEN @VP_DIA = '31' AND DIA_31 <> '' AND DIA_31 NOT LIKE '%' + @VP_INV_NO + '%' THEN CONCAT(DIA_31,'/', @VP_INV_NO) ELSE DIA_31 END )
														WHERE CUS_PART_NO = 'INVOICE'
														AND TYPE = @VP_TYPE				

														IF @VP_INV_NO <> 'N/F'
															BEGIN
																SELECT @VP_TOTAL_INV_NO = SUM(qty_to_ship * unit_price)
																FROM OELINHST_SQL 
																WHERE LTRIM(RTRIM(inv_no)) = @VP_INV_NO
																AND  LTRIM(RTRIM(item_desc_2)) = @VP_TYPE
															
																SET @VP_AMOUNT =  CONVERT(VARCHAR(15),@VP_TOTAL_INV_NO)
															END																			

														-- UPDATE AMOUNT
														UPDATE	@VP_SALIDA_PIEL_MHI_TBL 	
															SET	DIA_1	= 	( CASE WHEN @VP_DIA = '01' AND DIA_1  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '01' AND DIA_1  <> '' AND DIA_1  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_1  WHEN @VP_DIA = '01' AND DIA_1  <> '' AND DIA_1  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_1 ,'/', @VP_AMOUNT) ELSE DIA_1 END ),
																DIA_2	= 	( CASE WHEN @VP_DIA = '02' AND DIA_2  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '02' AND DIA_2  <> '' AND DIA_2  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_2  WHEN @VP_DIA = '02' AND DIA_2  <> '' AND DIA_2  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_2 ,'/', @VP_AMOUNT) ELSE DIA_2 END ), 
																DIA_3	= 	( CASE WHEN @VP_DIA = '03' AND DIA_3  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '03' AND DIA_3  <> '' AND DIA_3  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_3  WHEN @VP_DIA = '03' AND DIA_3  <> '' AND DIA_3  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_3 ,'/', @VP_AMOUNT) ELSE DIA_3 END ),
																DIA_4	= 	( CASE WHEN @VP_DIA = '04' AND DIA_4  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '04' AND DIA_4  <> '' AND DIA_4  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_4  WHEN @VP_DIA = '04' AND DIA_4  <> '' AND DIA_4  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_4 ,'/', @VP_AMOUNT) ELSE DIA_4 END ),
																DIA_5	= 	( CASE WHEN @VP_DIA = '05' AND DIA_5  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '05' AND DIA_5  <> '' AND DIA_5  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_5  WHEN @VP_DIA = '05' AND DIA_5  <> '' AND DIA_5  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_5 ,'/', @VP_AMOUNT) ELSE DIA_5 END ),
																DIA_6	= 	( CASE WHEN @VP_DIA = '06' AND DIA_6  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '06' AND DIA_6  <> '' AND DIA_6  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_6  WHEN @VP_DIA = '06' AND DIA_6  <> '' AND DIA_6  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_6 ,'/', @VP_AMOUNT) ELSE DIA_6 END ),
																DIA_7	= 	( CASE WHEN @VP_DIA = '07' AND DIA_7  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '07' AND DIA_7  <> '' AND DIA_7  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_7  WHEN @VP_DIA = '07' AND DIA_7  <> '' AND DIA_7  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_7 ,'/', @VP_AMOUNT) ELSE DIA_7 END ),
																DIA_8	= 	( CASE WHEN @VP_DIA = '08' AND DIA_8  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '08' AND DIA_8  <> '' AND DIA_8  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_8  WHEN @VP_DIA = '08' AND DIA_8  <> '' AND DIA_8  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_8 ,'/', @VP_AMOUNT) ELSE DIA_8 END ),
																DIA_9	= 	( CASE WHEN @VP_DIA = '09' AND DIA_9  = '' THEN @VP_AMOUNT WHEN @VP_DIA = '09' AND DIA_9  <> '' AND DIA_9  LIKE '%' + @VP_AMOUNT + '%' THEN DIA_9  WHEN @VP_DIA = '09' AND DIA_9  <> '' AND DIA_9  NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_9 ,'/', @VP_AMOUNT) ELSE DIA_9 END ),
																DIA_10	= 	( CASE WHEN @VP_DIA = '10' AND DIA_10 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '10' AND DIA_10 <> '' AND DIA_10 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_10 WHEN @VP_DIA = '10' AND DIA_10 <> '' AND DIA_10 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_10,'/', @VP_AMOUNT) ELSE DIA_10 END ),	
																DIA_11	= 	( CASE WHEN @VP_DIA = '11' AND DIA_11 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '11' AND DIA_11 <> '' AND DIA_11 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_11 WHEN @VP_DIA = '11' AND DIA_11 <> '' AND DIA_11 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_11,'/', @VP_AMOUNT) ELSE DIA_11 END ),	 
																DIA_12	= 	( CASE WHEN @VP_DIA = '12' AND DIA_12 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '12' AND DIA_12 <> '' AND DIA_12 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_12 WHEN @VP_DIA = '12' AND DIA_12 <> '' AND DIA_12 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_12,'/', @VP_AMOUNT) ELSE DIA_12 END ),	 
																DIA_13	= 	( CASE WHEN @VP_DIA = '13' AND DIA_13 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '13' AND DIA_13 <> '' AND DIA_13 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_13 WHEN @VP_DIA = '13' AND DIA_13 <> '' AND DIA_13 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_13,'/', @VP_AMOUNT) ELSE DIA_13 END ),	 
																DIA_14	= 	( CASE WHEN @VP_DIA = '14' AND DIA_14 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '14' AND DIA_14 <> '' AND DIA_14 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_14 WHEN @VP_DIA = '14' AND DIA_14 <> '' AND DIA_14 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_14,'/', @VP_AMOUNT) ELSE DIA_14 END ),	 
																DIA_15	= 	( CASE WHEN @VP_DIA = '15' AND DIA_15 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '15' AND DIA_15 <> '' AND DIA_15 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_15 WHEN @VP_DIA = '15' AND DIA_15 <> '' AND DIA_15 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_15,'/', @VP_AMOUNT) ELSE DIA_15 END ),	 
																DIA_16	= 	( CASE WHEN @VP_DIA = '16' AND DIA_16 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '16' AND DIA_16 <> '' AND DIA_16 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_16 WHEN @VP_DIA = '16' AND DIA_16 <> '' AND DIA_16 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_16,'/', @VP_AMOUNT) ELSE DIA_16 END ),	 
																DIA_17	= 	( CASE WHEN @VP_DIA = '17' AND DIA_17 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '17' AND DIA_17 <> '' AND DIA_17 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_17 WHEN @VP_DIA = '17' AND DIA_17 <> '' AND DIA_17 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_17,'/', @VP_AMOUNT) ELSE DIA_17 END ),	 
																DIA_18	= 	( CASE WHEN @VP_DIA = '18' AND DIA_18 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '18' AND DIA_18 <> '' AND DIA_18 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_18 WHEN @VP_DIA = '18' AND DIA_18 <> '' AND DIA_18 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_18,'/', @VP_AMOUNT) ELSE DIA_18 END ),	 
																DIA_19	= 	( CASE WHEN @VP_DIA = '19' AND DIA_19 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '19' AND DIA_19 <> '' AND DIA_19 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_19 WHEN @VP_DIA = '19' AND DIA_19 <> '' AND DIA_19 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_19,'/', @VP_AMOUNT) ELSE DIA_19 END ),	 
																DIA_20	= 	( CASE WHEN @VP_DIA = '20' AND DIA_20 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '20' AND DIA_20 <> '' AND DIA_20 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_20 WHEN @VP_DIA = '20' AND DIA_20 <> '' AND DIA_20 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_20,'/', @VP_AMOUNT) ELSE DIA_20 END ),
																DIA_21	= 	( CASE WHEN @VP_DIA = '21' AND DIA_21 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '21' AND DIA_21 <> '' AND DIA_21 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_21 WHEN @VP_DIA = '21' AND DIA_21 <> '' AND DIA_21 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_21,'/', @VP_AMOUNT) ELSE DIA_21 END ), 
																DIA_22	= 	( CASE WHEN @VP_DIA = '22' AND DIA_22 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '22' AND DIA_22 <> '' AND DIA_22 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_22 WHEN @VP_DIA = '22' AND DIA_22 <> '' AND DIA_22 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_22,'/', @VP_AMOUNT) ELSE DIA_22 END ), 
																DIA_23	= 	( CASE WHEN @VP_DIA = '23' AND DIA_23 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '23' AND DIA_23 <> '' AND DIA_23 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_23 WHEN @VP_DIA = '23' AND DIA_23 <> '' AND DIA_23 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_23,'/', @VP_AMOUNT) ELSE DIA_23 END ), 
																DIA_24	= 	( CASE WHEN @VP_DIA = '24' AND DIA_24 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '24' AND DIA_24 <> '' AND DIA_24 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_24 WHEN @VP_DIA = '24' AND DIA_24 <> '' AND DIA_24 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_24,'/', @VP_AMOUNT) ELSE DIA_24 END ), 
																DIA_25	= 	( CASE WHEN @VP_DIA = '25' AND DIA_25 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '25' AND DIA_25 <> '' AND DIA_25 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_25 WHEN @VP_DIA = '25' AND DIA_25 <> '' AND DIA_25 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_25,'/', @VP_AMOUNT) ELSE DIA_25 END ), 
																DIA_26	= 	( CASE WHEN @VP_DIA = '26' AND DIA_26 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '26' AND DIA_26 <> '' AND DIA_26 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_26 WHEN @VP_DIA = '26' AND DIA_26 <> '' AND DIA_26 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_26,'/', @VP_AMOUNT) ELSE DIA_26 END ), 
																DIA_27	= 	( CASE WHEN @VP_DIA = '27' AND DIA_27 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '27' AND DIA_27 <> '' AND DIA_27 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_27 WHEN @VP_DIA = '27' AND DIA_27 <> '' AND DIA_27 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_27,'/', @VP_AMOUNT) ELSE DIA_27 END ), 
																DIA_28	= 	( CASE WHEN @VP_DIA = '28' AND DIA_28 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '28' AND DIA_28 <> '' AND DIA_28 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_28 WHEN @VP_DIA = '28' AND DIA_28 <> '' AND DIA_28 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_28,'/', @VP_AMOUNT) ELSE DIA_28 END ),
																DIA_29	= 	( CASE WHEN @VP_DIA = '29' AND DIA_29 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '29' AND DIA_29 <> '' AND DIA_29 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_29 WHEN @VP_DIA = '29' AND DIA_29 <> '' AND DIA_29 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_29,'/', @VP_AMOUNT) ELSE DIA_29 END ), 
																DIA_30	= 	( CASE WHEN @VP_DIA = '30' AND DIA_30 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '30' AND DIA_30 <> '' AND DIA_30 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_30 WHEN @VP_DIA = '30' AND DIA_30 <> '' AND DIA_30 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_30,'/', @VP_AMOUNT) ELSE DIA_30 END ),	
																DIA_31	= 	( CASE WHEN @VP_DIA = '31' AND DIA_31 = '' THEN @VP_AMOUNT WHEN @VP_DIA = '31' AND DIA_31 <> '' AND DIA_31 LIKE '%' + @VP_AMOUNT + '%' THEN DIA_31 WHEN @VP_DIA = '31' AND DIA_31 <> '' AND DIA_31 NOT LIKE '%' + @VP_AMOUNT + '%' THEN CONCAT(DIA_31,'/', @VP_AMOUNT) ELSE DIA_31 END )
														WHERE CUS_PART_NO = 'AMOUNT'	
														AND TYPE = @VP_TYPE	
														
														-- INSERT QTY
														INSERT INTO @VP_SALIDA_PIEL_MHI_TBL (PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO,	
																			 DIA_1, DIA_2, DIA_3, DIA_4, DIA_5, DIA_6, DIA_7, DIA_8, DIA_9, DIA_10,		
																			 DIA_11, DIA_12, DIA_13, DIA_14, DIA_15, DIA_16, DIA_17, DIA_18, DIA_19, DIA_20,	
																			 DIA_21, DIA_22, DIA_23, DIA_24, DIA_25, DIA_26, DIA_27, DIA_28	,DIA_29, DIA_30,	
																			 DIA_31, ACUMULADO, PRECIO	)
																	VALUES(
																			@VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO,
																			( CASE WHEN @VP_DIA = '01'THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '02'THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '03'THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '04'THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '05'THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '06'THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '07'THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '08'THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '09'THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '10' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '11' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '12' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '13' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '14' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '15' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '16' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '17' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '18' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '19' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '20' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '21' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '22' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '23' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '24' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '25' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '26' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '27' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '28' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '29' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '30' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA = '31' THEN @VP_QTY ELSE '' END ), 
																			'', ''
																			)	
													END
											END
										ELSE
											BEGIN
												-- INSERT DATE
												INSERT INTO @VP_SALIDA_PIEL_MHI_TBL (PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO,	
																					 DIA_1, DIA_2, DIA_3, DIA_4, DIA_5, DIA_6, DIA_7, DIA_8, DIA_9, DIA_10,		
																					 DIA_11, DIA_12, DIA_13, DIA_14, DIA_15, DIA_16, DIA_17, DIA_18, DIA_19, DIA_20,	
																					 DIA_21, DIA_22, DIA_23, DIA_24, DIA_25, DIA_26, DIA_27, DIA_28	,DIA_29, DIA_30,	
																					 DIA_31, ACUMULADO, PRECIO	)
																			VALUES(
																					'', @VP_TYPE, '', 'DATE',
																					@VP_DIA_1, @VP_DIA_2, @VP_DIA_3, @VP_DIA_4, @VP_DIA_5, @VP_DIA_6, @VP_DIA_7, @VP_DIA_8, @VP_DIA_9, @VP_DIA_10,
																					@VP_DIA_11, @VP_DIA_12, @VP_DIA_13, @VP_DIA_14, @VP_DIA_15, @VP_DIA_16, @VP_DIA_17, @VP_DIA_18, @VP_DIA_19, @VP_DIA_20,
																					@VP_DIA_21, @VP_DIA_22, @VP_DIA_23, @VP_DIA_24, @VP_DIA_25, @VP_DIA_26, @VP_DIA_27, @VP_DIA_28, @VP_DIA_29, @VP_DIA_30,
																					@VP_DIA_31, '', ''
																					)	
												
												-- INSERT PACKING
												INSERT INTO @VP_SALIDA_PIEL_MHI_TBL (PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO,	
																					 DIA_1, DIA_2, DIA_3, DIA_4, DIA_5, DIA_6, DIA_7, DIA_8, DIA_9, DIA_10,		
																					 DIA_11, DIA_12, DIA_13, DIA_14, DIA_15, DIA_16, DIA_17, DIA_18, DIA_19, DIA_20,	
																					 DIA_21, DIA_22, DIA_23, DIA_24, DIA_25, DIA_26, DIA_27, DIA_28	,DIA_29, DIA_30,	
																					 DIA_31, ACUMULADO, PRECIO	)
																			VALUES(
																					'', @VP_TYPE, '', 'PACKING',
																					( CASE WHEN @VP_DIA_1 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_2 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_3 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_4 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_5 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_6 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_7 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_8 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_9 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_10 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_11 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_12 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_13 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_14 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_15 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_16 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_17 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_18 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_19 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_20 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_21 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_22 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_23 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_24 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_25 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_26 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_27 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_28 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_29 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_30 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_31 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																					'', ''
																					)	
												
												-- INSERT INVOICE
												INSERT INTO @VP_SALIDA_PIEL_MHI_TBL (PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO,	
																					 DIA_1, DIA_2, DIA_3, DIA_4, DIA_5, DIA_6, DIA_7, DIA_8, DIA_9, DIA_10,		
																					 DIA_11, DIA_12, DIA_13, DIA_14, DIA_15, DIA_16, DIA_17, DIA_18, DIA_19, DIA_20,	
																					 DIA_21, DIA_22, DIA_23, DIA_24, DIA_25, DIA_26, DIA_27, DIA_28	,DIA_29, DIA_30,	
																					 DIA_31, ACUMULADO, PRECIO	)
																			VALUES(
																					'', @VP_TYPE, '', 'INVOICE',
																					( CASE WHEN @VP_DIA_1 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_2 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_3 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_4 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_5 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_6 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_7 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_8 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_9 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_10 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_11 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_12 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_13 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_14 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_15 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_16 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_17 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_18 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_19 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_20 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_21 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_22 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_23 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_24 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_25 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_26 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_27 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_28 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_29 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_30 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					( CASE WHEN @VP_DIA_31 <> '' THEN @VP_INV_NO ELSE '' END ), 
																					'', ''
																					)	
												
												
												IF @VP_INV_NO <> 'N/F'
													BEGIN
														SELECT @VP_TOTAL_INV_NO = SUM(qty_to_ship * unit_price)
														FROM OELINHST_SQL 
														WHERE LTRIM(RTRIM(inv_no)) = @VP_INV_NO
														AND  LTRIM(RTRIM(item_desc_2)) = @VP_TYPE

														SET @VP_AMOUNT =  CONVERT(VARCHAR(15),@VP_TOTAL_INV_NO)
													END																			

												-- INSERT AMOUNT
												INSERT INTO @VP_SALIDA_PIEL_MHI_TBL (PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO,	
																					 DIA_1, DIA_2, DIA_3, DIA_4, DIA_5, DIA_6, DIA_7, DIA_8, DIA_9, DIA_10,		
																					 DIA_11, DIA_12, DIA_13, DIA_14, DIA_15, DIA_16, DIA_17, DIA_18, DIA_19, DIA_20,	
																					 DIA_21, DIA_22, DIA_23, DIA_24, DIA_25, DIA_26, DIA_27, DIA_28	,DIA_29, DIA_30,	
																					 DIA_31, ACUMULADO, PRECIO	)
																			VALUES(
																					'', @VP_TYPE, '', 'AMOUNT',
																					( CASE WHEN @VP_DIA_1 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_2 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_3 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_4 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_5 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_6 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_7 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_8 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_9 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_10 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_11 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_12 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_13 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_14 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_15 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_16 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_17 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_18 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_19 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_20 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_21 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_22 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_23 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_24 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_25 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_26 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_27 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_28 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_29 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_30 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					( CASE WHEN @VP_DIA_31 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																					'', ''
																					)	
												
												-- INSERT QTY
												INSERT INTO @VP_SALIDA_PIEL_MHI_TBL (PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO,	
																					 DIA_1, DIA_2, DIA_3, DIA_4, DIA_5, DIA_6, DIA_7, DIA_8, DIA_9, DIA_10,		
																					 DIA_11, DIA_12, DIA_13, DIA_14, DIA_15, DIA_16, DIA_17, DIA_18, DIA_19, DIA_20,	
																					 DIA_21, DIA_22, DIA_23, DIA_24, DIA_25, DIA_26, DIA_27, DIA_28	,DIA_29, DIA_30,	
																					 DIA_31, ACUMULADO, PRECIO	)
																			VALUES(
																					@VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO,
																					( CASE WHEN @VP_DIA_1 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_2 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_3 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_4 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_5 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_6 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_7 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_8 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_9 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_10 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_11 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_12 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_13 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_14 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_15 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_16 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_17 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_18 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_19 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_20 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_21 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_22 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_23 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_24 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_25 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_26 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_27 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_28 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_29 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_30 <> '' THEN @VP_QTY ELSE '' END ), 
																					( CASE WHEN @VP_DIA_31 <> '' THEN @VP_QTY ELSE '' END ), 
																					'', ''
																					)	
											END
									END
								ELSE
									BEGIN
										-- INSERT DATE
										INSERT INTO @VP_SALIDA_PIEL_MHI_TBL (PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO,	
																			 DIA_1, DIA_2, DIA_3, DIA_4, DIA_5, DIA_6, DIA_7, DIA_8, DIA_9, DIA_10,		
																			 DIA_11, DIA_12, DIA_13, DIA_14, DIA_15, DIA_16, DIA_17, DIA_18, DIA_19, DIA_20,	
																			 DIA_21, DIA_22, DIA_23, DIA_24, DIA_25, DIA_26, DIA_27, DIA_28	,DIA_29, DIA_30,	
																			 DIA_31, ACUMULADO, PRECIO	)
																	VALUES(
																			'', @VP_TYPE, '', 'DATE',
																			@VP_DIA_1, @VP_DIA_2, @VP_DIA_3, @VP_DIA_4, @VP_DIA_5, @VP_DIA_6, @VP_DIA_7, @VP_DIA_8, @VP_DIA_9, @VP_DIA_10,
																			@VP_DIA_11, @VP_DIA_12, @VP_DIA_13, @VP_DIA_14, @VP_DIA_15, @VP_DIA_16, @VP_DIA_17, @VP_DIA_18, @VP_DIA_19, @VP_DIA_20,
																			@VP_DIA_21, @VP_DIA_22, @VP_DIA_23, @VP_DIA_24, @VP_DIA_25, @VP_DIA_26, @VP_DIA_27, @VP_DIA_28, @VP_DIA_29, @VP_DIA_30,
																			@VP_DIA_31, '', ''
																			)	
										
										-- INSERT PACKING
										INSERT INTO @VP_SALIDA_PIEL_MHI_TBL (PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO,	
																			 DIA_1, DIA_2, DIA_3, DIA_4, DIA_5, DIA_6, DIA_7, DIA_8, DIA_9, DIA_10,		
																			 DIA_11, DIA_12, DIA_13, DIA_14, DIA_15, DIA_16, DIA_17, DIA_18, DIA_19, DIA_20,	
																			 DIA_21, DIA_22, DIA_23, DIA_24, DIA_25, DIA_26, DIA_27, DIA_28	,DIA_29, DIA_30,	
																			 DIA_31, ACUMULADO, PRECIO	)
																	VALUES(
																			'', @VP_TYPE, '', 'PACKING',
																			( CASE WHEN @VP_DIA_1 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_2 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_3 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_4 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_5 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_6 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_7 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_8 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_9 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_10 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_11 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_12 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_13 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_14 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_15 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_16 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_17 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_18 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_19 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_20 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_21 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_22 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_23 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_24 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_25 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_26 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_27 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_28 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_29 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_30 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_31 <> '' THEN @VP_PACKING_NO ELSE '' END ), 
																			'', ''
																			)	
										
										-- INSERT INVOICE
										INSERT INTO @VP_SALIDA_PIEL_MHI_TBL (PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO,	
																			 DIA_1, DIA_2, DIA_3, DIA_4, DIA_5, DIA_6, DIA_7, DIA_8, DIA_9, DIA_10,		
																			 DIA_11, DIA_12, DIA_13, DIA_14, DIA_15, DIA_16, DIA_17, DIA_18, DIA_19, DIA_20,	
																			 DIA_21, DIA_22, DIA_23, DIA_24, DIA_25, DIA_26, DIA_27, DIA_28	,DIA_29, DIA_30,	
																			 DIA_31, ACUMULADO, PRECIO	)
																	VALUES(
																			'', @VP_TYPE, '', 'INVOICE',
																			( CASE WHEN @VP_DIA_1 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_2 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_3 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_4 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_5 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_6 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_7 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_8 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_9 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_10 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_11 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_12 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_13 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_14 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_15 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_16 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_17 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_18 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_19 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_20 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_21 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_22 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_23 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_24 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_25 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_26 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_27 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_28 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_29 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_30 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			( CASE WHEN @VP_DIA_31 <> '' THEN @VP_INV_NO ELSE '' END ), 
																			'', ''
																			)	
										
										
										IF @VP_INV_NO <> 'N/F'
											BEGIN
												SELECT @VP_TOTAL_INV_NO = SUM(qty_to_ship * unit_price)
												FROM OELINHST_SQL 
												WHERE LTRIM(RTRIM(inv_no)) = @VP_INV_NO
												AND  LTRIM(RTRIM(item_desc_2)) = @VP_TYPE

												SET @VP_AMOUNT =  CONVERT(VARCHAR(15),@VP_TOTAL_INV_NO)
											END																			

										-- INSERT AMOUNT
										INSERT INTO @VP_SALIDA_PIEL_MHI_TBL (PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO,	
																			 DIA_1, DIA_2, DIA_3, DIA_4, DIA_5, DIA_6, DIA_7, DIA_8, DIA_9, DIA_10,		
																			 DIA_11, DIA_12, DIA_13, DIA_14, DIA_15, DIA_16, DIA_17, DIA_18, DIA_19, DIA_20,	
																			 DIA_21, DIA_22, DIA_23, DIA_24, DIA_25, DIA_26, DIA_27, DIA_28	,DIA_29, DIA_30,	
																			 DIA_31, ACUMULADO, PRECIO	)
																	VALUES(
																			'', @VP_TYPE, '', 'AMOUNT',
																			( CASE WHEN @VP_DIA_1 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_2 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_3 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_4 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_5 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_6 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_7 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_8 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_9 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_10 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_11 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_12 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_13 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_14 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_15 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_16 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_17 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_18 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_19 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_20 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_21 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_22 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_23 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_24 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_25 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_26 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_27 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_28 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_29 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_30 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			( CASE WHEN @VP_DIA_31 <> '' THEN @VP_AMOUNT ELSE '' END ), 
																			'', ''
																			)	
										
										-- INSERT QTY
										INSERT INTO @VP_SALIDA_PIEL_MHI_TBL (PROD_CAT_DESC, TYPE, PART_NO, CUS_PART_NO,	
																			 DIA_1, DIA_2, DIA_3, DIA_4, DIA_5, DIA_6, DIA_7, DIA_8, DIA_9, DIA_10,		
																			 DIA_11, DIA_12, DIA_13, DIA_14, DIA_15, DIA_16, DIA_17, DIA_18, DIA_19, DIA_20,	
																			 DIA_21, DIA_22, DIA_23, DIA_24, DIA_25, DIA_26, DIA_27, DIA_28	,DIA_29, DIA_30,	
																			 DIA_31, ACUMULADO, PRECIO	)
																	VALUES(
																			@VP_PROD_CAT_DESC, @VP_TYPE, @VP_PART_NO, @VP_CUS_PART_NO,
																			( CASE WHEN @VP_DIA_1 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_2 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_3 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_4 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_5 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_6 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_7 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_8 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_9 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_10 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_11 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_12 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_13 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_14 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_15 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_16 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_17 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_18 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_19 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_20 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_21 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_22 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_23 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_24 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_25 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_26 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_27 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_28 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_29 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_30 <> '' THEN @VP_QTY ELSE '' END ), 
																			( CASE WHEN @VP_DIA_31 <> '' THEN @VP_QTY ELSE '' END ), 
																			'', ''
																			)	
									END
								SET @VP_DIA = ''
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
		SELECT	*
		--CDATE,			
		--		PROD_CAT_DESC,	
		--		TYPE,			
		--		PART_NO,		 
		--		CUS_PART_NO,	
		--		PRICE,
		--		QTY,
		--		INV_NO,				
		--		PACKING_NO		
		FROM @VP_SALIDA_PIEL_MHI_TBL AS SALIDA
		--ORDER BY CUS_PART_NO ASC
	-- ////////////////////////////////////////////////
	-- ////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
