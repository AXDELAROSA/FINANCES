-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	[DATA_02Pruebas]
-- // MODULO:			FINANZAS CONCILIACION
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			FEG
-- // Fecha creación:	01/FEB/2021
-- //////////////////////////////////////////////////////////////  

USE [DATA_02]
GO

-- //////////////////////////////////////////////////////////////

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_REPORTE_VENTA_TOTAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_REPORTE_VENTA_TOTAL]
GO

/* 
	--	EXEC	[dbo].[PG_PR_REPORTE_VENTA_TOTAL] 0,0,  '2021/02/01' , '2021/02/06' , 'YANG03', 'FYCPAX7' 
	--	EXEC	[dbo].[PG_PR_REPORTE_VENTA_TOTAL] 0,0,  '2021/02/01' , '2021/02/06' , 'YANG03', 'FYPATX7' 
*/
CREATE PROCEDURE [dbo].[PG_PR_REPORTE_VENTA_TOTAL]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_F_INICIO					DATE,
	@PP_F_FIN						DATE,
	@PP_CLIENTE						VARCHAR(50),
	@PP_COLOR						VARCHAR(150)
	-- ===========================
AS
	
	-- //////////////SE CONVIERTA LA FECHA AENTERO/////////////////////////////
	DECLARE @VP_F_INICIO_INT INT = [dbo].[CONVERT_DATE_TO_INT](@PP_F_INICIO, 'yyyyMMdd')
	DECLARE @VP_F_FIN_INT INT = [dbo].[CONVERT_DATE_TO_INT](@PP_F_FIN, 'yyyyMMdd')

	-- //////////////SE OBTIENE EL CODIGO DEL COLOR DE LA DESCRIPCION/////////////////////////////
	DECLARE @PP_D_COLOR VARCHAR(50) = ''
	SELECT  TOP 1 @PP_D_COLOR = LTRIM(RTRIM(ITEM_DESC_1)) 
	FROM	IMITMIDX_SQL 
	WHERE	LTRIM(RTRIM(ITEM_NO)) = @PP_COLOR

	-- //////////////SE CREA TABLA TEMPORAL PARA INGRESAR TOTALES/////////////////////////////
	CREATE TABLE #MATERIAL_VENDIDO(
			ID				INT	IDENTITY(1,1),
			EMBOSSING				VARCHAR(50) DEFAULT '',
			LAMINATION				VARCHAR(50) DEFAULT '',
			PERFORATION				VARCHAR(50) DEFAULT '',
			QUILTING				VARCHAR(50) DEFAULT '',
			RECUT					VARCHAR(50) DEFAULT '',
			SKIVING					VARCHAR(50) DEFAULT '',
			CUTTING_COST			VARCHAR(50) DEFAULT '',
			TOTAL_PRICE_PER_PIECE	VARCHAR(50) DEFAULT '',
			TOTAL_PRICE_COMPLETED	VARCHAR(50) DEFAULT '',
			--------------------------------------
			COLOR					VARCHAR(50) DEFAULT '',
			--D_COLOR					VARCHAR(150) DEFAULT '',
			PART_NO					VARCHAR(150) DEFAULT '',
			CUS_PART_NO				VARCHAR(150) DEFAULT '',
			NET_AREA				VARCHAR(150) DEFAULT '',
			GROSS					VARCHAR(150) DEFAULT '',
			FECHA_INVOICE			VARCHAR(150) DEFAULT '',
			PACKING					VARCHAR(150) DEFAULT '',
			QTY						VARCHAR(150) DEFAULT '',
			MOUNT					VARCHAR(150) DEFAULT '',
			PRECIO					VARCHAR(150) DEFAULT '',
			ACUMULADO_QTY			VARCHAR(150) DEFAULT '',
			ACUMULADO_MOUNT			VARCHAR(150) DEFAULT '',
			CUTTING_MOUNT			VARCHAR(150) DEFAULT '',
			INVOICE					VARCHAR(150) DEFAULT ''
		)
		SET NOCOUNT ON

	INSERT INTO #MATERIAL_VENDIDO
	SELECT	'', '', '', '',	'',	'',	'','', '',	
			@PP_COLOR		AS COLOR,
			--@PP_D_COLOR		AS D_COLOR,
			LTRIM(RTRIM(ITEM_NO)) AS ITEM_NO, 
			LTRIM(RTRIM(cus_item_no)) CUS_PART_NO,
			-- ===========================
			'          ',
			'          ',
			-- ===========================
			[dbo].[CONVERT_INT_TO_DATE](BILLED_DT),
			-- ===========================
			( SELECT TOP 1 user_def_fld_5 
				FROM OEHDRHST_SQL 
				WHERE OEHDRHST_SQL.INV_NO = OELINHST_SQL.INV_NO) AS PACKING_NO,	
			-- ===========================
			SUM(CONVERT(INT,qty_to_ship)) AS QTY_TO_SIHP,
			SUM(sls_amt) AS TOTAL,
			CONVERT(DECIMAL(13,6), unit_price) AS PRICE,
			'',
			'',
			'',
			inv_no
	FROM OELINHST_SQL 
	WHERE BILLED_DT >= @VP_F_INICIO_INT
	AND BILLED_DT <= @VP_F_FIN_INT	
	AND LTRIM(RTRIM(CUS_NO)) = @PP_CLIENTE
	AND CONCAT('F', RIGHT(LTRIM(RTRIM(ITEM_NO)),6)) = @PP_COLOR
	GROUP BY 
			CONCAT('F', RIGHT(LTRIM(RTRIM(ITEM_NO)),6)),
			BILLED_DT, inv_no, LTRIM(RTRIM(ITEM_NO)), LTRIM(RTRIM(cus_item_no)), unit_price
	ORDER BY billed_dt, inv_no --, PROD_CAT
	SET NOCOUNT ON

	DECLARE @VP_N_MATERIAL_SALIDA INT = 0
	SELECT @VP_N_MATERIAL_SALIDA = COUNT(ID) 
	FROM #MATERIAL_VENDIDO

	IF @VP_N_MATERIAL_SALIDA IS NULL
		SET @VP_N_MATERIAL_SALIDA = 0
	
	IF @VP_N_MATERIAL_SALIDA > 0
		BEGIN
			-- ////////////////////SE OBTIENEN LOS DATOS DE LAS FACTURAS DINAMICAMENTE QUE SE CONVERTIRAN EN LAS COLUMNAS DE LA TABLA//////////////////////////	
			DECLARE @VP_COLUMNA AS NVARCHAR(MAX), @VP_QUERY AS NVARCHAR(MAX) = ''
			
			SELECT @VP_COLUMNA = STUFF((	SELECT ',' + QUOTENAME(INVOICE) 
											FROM #MATERIAL_VENDIDO 
											GROUP BY  FECHA_INVOICE, INVOICE
											ORDER BY FECHA_INVOICE, INVOICE
								FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') ,1,1,'' ) 	
			
			-- ////////////////////SE CREA LA TABLA TEMPORAL FECHA_INVOICE CON LAS COLUMNAS DINAMICAMENTE//////////////////////////
			SET @VP_QUERY = N'SELECT ''          ''  EMBOSSING, ''          ''  LAMINATION, ''          ''  PERFORATION, ''          ''  QUILTING, ''          ''  RECUT, ''          ''  SKIVING, ''          ''  CUTTING_COST, ''          ''  TOTAL_PRICE_PER_PIECE, ''          ''  TOTAL_PRICE_COMPLETED, ''''  COLOR,  ''''  PART_NO, ''INVOICE DATE''  CUS_PART_NO, '''' NET_AREA, '''' GROSS, '''' PRECIO, '''' ACUMULADO_QTY, '''' ACUMULADO_MOUNT, '''' CUTTING_MOUNT, ' + @VP_COLUMNA + N' INTO [tempdb].[dbo].[FECHA_INVOICE]  FROM ( SELECT  FECHA_INVOICE, INVOICE FROM #MATERIAL_VENDIDO GROUP BY FECHA_INVOICE, INVOICE ) x pivot ( MAX(FECHA_INVOICE) for INVOICE in (' + @VP_COLUMNA + N') ) p ' 
			EXEC sp_executesql @VP_QUERY;	

			SET @VP_QUERY = ''
			SET @VP_QUERY = N'SELECT ''          ''  EMBOSSING, ''          ''  LAMINATION, ''          ''  PERFORATION, ''          ''  QUILTING, ''          ''  RECUT, ''          ''  SKIVING, ''          ''  CUTTING_COST, ''          ''  TOTAL_PRICE_PER_PIECE, ''          ''  TOTAL_PRICE_COMPLETED, ''''  COLOR,  '''+ @PP_D_COLOR +'''  PART_NO, ''PACKING #''  CUS_PART_NO, '''' NET_AREA, '''' GROSS, '''' PRECIO, '''' ACUMULADO_QTY, '''' ACUMULADO_MOUNT, '''' CUTTING_MOUNT, ' + @VP_COLUMNA + N' INTO [tempdb].[dbo].[PACKING_INVOICE]  FROM ( SELECT  PACKING, INVOICE FROM #MATERIAL_VENDIDO GROUP BY PACKING, INVOICE ) x pivot ( MAX(PACKING) for INVOICE in (' + @VP_COLUMNA + N') ) p ' 
			EXEC sp_executesql @VP_QUERY;	

			SET @VP_QUERY = ''
			SET @VP_QUERY = N'SELECT ''          ''  EMBOSSING, ''          ''  LAMINATION, ''          ''  PERFORATION, ''          ''  QUILTING, ''          ''  RECUT, ''          ''  SKIVING, ''          ''  CUTTING_COST, ''          ''  TOTAL_PRICE_PER_PIECE, ''          ''  TOTAL_PRICE_COMPLETED, ''''  COLOR,  ''''  PART_NO, ''INVOICE #''  CUS_PART_NO, '''' NET_AREA, '''' GROSS, '''' PRECIO, '''' ACUMULADO_QTY, '''' ACUMULADO_MOUNT, '''' CUTTING_MOUNT, ' + @VP_COLUMNA + N' INTO [tempdb].[dbo].[FACTURAS]  FROM ( SELECT  INVOICE FROM #MATERIAL_VENDIDO GROUP BY  INVOICE ) x pivot ( MAX(INVOICE) for INVOICE in (' + @VP_COLUMNA + N') ) p ' 
			EXEC sp_executesql @VP_QUERY;	

			SET @VP_QUERY = ''
			SET @VP_QUERY = N'SELECT ''          ''  EMBOSSING, ''          ''  LAMINATION, ''          ''  PERFORATION, ''          ''  QUILTING, ''          ''  RECUT, ''          ''  SKIVING, ''          ''  CUTTING_COST, ''          ''  TOTAL_PRICE_PER_PIECE, ''          ''  TOTAL_PRICE_COMPLETED, ''''  COLOR, ''''  PART_NO, ''TOTAL USD $''  CUS_PART_NO, '''' NET_AREA, '''' GROSS, '''' PRECIO, '''' ACUMULADO_QTY, '''' ACUMULADO_MOUNT, '''' CUTTING_MOUNT, ' + @VP_COLUMNA + N' INTO [tempdb].[dbo].[TOTAL_INVOICE]  FROM ( SELECT  SUM(CONVERT(DECIMAL(13,2), MOUNT)) AS TOTAL_INVOICE, INVOICE FROM #MATERIAL_VENDIDO GROUP BY INVOICE ) x pivot ( MAX(TOTAL_INVOICE) for INVOICE in (' + @VP_COLUMNA + N') ) p ' 
			EXEC sp_executesql @VP_QUERY;	

			SET @VP_QUERY = ''
			SET @VP_QUERY = N'SELECT ''          ''  EMBOSSING, ''          ''  LAMINATION, ''          ''  PERFORATION, ''          ''  QUILTING, ''          ''  RECUT, ''          ''  SKIVING, ''          ''  CUTTING_COST, ''          ''  TOTAL_PRICE_PER_PIECE, ''          ''  TOTAL_PRICE_COMPLETED, COLOR, PART_NO, CUS_PART_NO, NET_AREA, GROSS, PRECIO, ''          '' ACUMULADO_QTY,  ''          '' ACUMULADO_MOUNT, ''          '' CUTTING_MOUNT, ' + @VP_COLUMNA + N' INTO [tempdb].[dbo].[QTY_SHIP]  FROM ( SELECT COLOR, PART_NO, CUS_PART_NO, NET_AREA, GROSS, PRECIO, ACUMULADO_QTY, ACUMULADO_MOUNT, QTY, INVOICE FROM #MATERIAL_VENDIDO ) x pivot ( MAX(QTY) for INVOICE in (' + @VP_COLUMNA + N') ) p ' 
			EXEC sp_executesql @VP_QUERY;	

			-- ///////SE CREA TABLA TEMPORAL [TOTALES] CON DATOS DE TABLA TEMPORAL [QTY_KIT]/////////////////////////////////////////
			SELECT * INTO [tempdb].[dbo].[VENTA_TOTAL] FROM [tempdb].[dbo].[QTY_SHIP]
			SET NOCOUNT ON
			  
			-- ///////SE BORRAN LOS DATOS DE TABLA TEMPORAL [TOTALES]/////////////////////////////////////////
			DELETE [tempdb].[dbo].[VENTA_TOTAL]
			SET NOCOUNT ON

			-- ///////SE COPIAN LOS DATOS DE TABLA TEMPORAL [FECHA] A [TOTALES]/////////////////////////////////////////
			INSERT INTO [tempdb].[dbo].[VENTA_TOTAL]
			SELECT * FROM [tempdb].[dbo].[FECHA_INVOICE]
			SET NOCOUNT ON

			-- ///////SE COPIAN LOS DATOS DE TABLA TEMPORAL [PACKING] A [TOTALES]/////////////////////////////////////////
			INSERT INTO [tempdb].[dbo].[VENTA_TOTAL]
			SELECT * FROM [tempdb].[dbo].[PACKING_INVOICE] 
			SET NOCOUNT ON

			-- ///////SE COPIAN LOS DATOS DE TABLA TEMPORAL [INVOICE] A [TOTALES]/////////////////////////////////////////
			INSERT INTO [tempdb].[dbo].[VENTA_TOTAL]
			SELECT * FROM [tempdb].[dbo].[FACTURAS] 
			SET NOCOUNT ON

			-- ///////SE COPIAN LOS DATOS DE TABLA TEMPORAL [AMOUNT] A [TOTALES]/////////////////////////////////////////
			INSERT INTO [tempdb].[dbo].[VENTA_TOTAL]
			SELECT * FROM [tempdb].[dbo].[TOTAL_INVOICE] 
			SET NOCOUNT ON

			-- ///////SE COPIAN LOS DATOS DE TABLA TEMPORAL [QTY_KIT] A [TOTALES]/////////////////////////////////////////
			INSERT INTO [tempdb].[dbo].[VENTA_TOTAL]
			SELECT * FROM [tempdb].[dbo].[QTY_SHIP] 
			SET NOCOUNT ON

			-- ///////SE OBTINE EL TOTAL FACTURADO PARA EL COLOR EN LAS FECHAS ESPECIFICADAS/////////////////////////////////////////
			DECLARE @VP_TOTAL_FACTURADO DECIMAL(13,2) = 0
			SELECT @VP_TOTAL_FACTURADO = SUM(CONVERT(DECIMAL(13,2), MOUNT))
			FROM #MATERIAL_VENDIDO
			SET NOCOUNT ON

			-- ///////SE ACTUALIZA EL CAMPO ACUMULADO_MOUNT CON EL TOTAL DE LAS FACTURAS/////////////////////////////////////////
			UPDATE [tempdb].[dbo].[VENTA_TOTAL]
				SET  ACUMULADO_MOUNT = @VP_TOTAL_FACTURADO
			WHERE CUS_PART_NO = 'TOTAL USD $'
			SET NOCOUNT ON

			-- //////////////SE CREA EL CURSOR/////////////////////////////
			DECLARE @VP_ACUMULADO_QTY INT = 0, @VP_ACUMULADO_MOUNT DECIMAL(13,2) = 0, @VP_NET_AREA DECIMAL(13,5) = 0, @VP_TOTAL_PACKING INT = 0;
			DECLARE @VP_CUS_PART_NO VARCHAR(150) = '', @VP_ITEM_NO VARCHAR(150) = '', @VP_PRECIO DECIMAL(13,6)= 0, @VP_CUTTING_MOUNT DECIMAL(13,2) = 0;
			DECLARE @VP_TOTAL_CUTTING_MOUNT DECIMAL(13,2) = 0;

			DECLARE CU_VENTA_TOTAL_X_PART_NO CURSOR 
			FOR SELECT	PART_NO, CUS_PART_NO, PRECIO --, CONVERT(DECIMAL(13,5), NET_AREA) AS NET_AREA
				FROM [tempdb].[dbo].[VENTA_TOTAL] 
				WHERE COLOR <> ''
			-- ===========================

			OPEN CU_VENTA_TOTAL_X_PART_NO
			FETCH NEXT FROM CU_VENTA_TOTAL_X_PART_NO INTO @VP_ITEM_NO, @VP_CUS_PART_NO, @VP_PRECIO --, @VP_NET_AREA
								
			-- ////////////////////SE RECORRE EL CURSOR//////////////////////////	
			WHILE @@FETCH_STATUS = 0
				BEGIN		
					-- ///////SE OBTIENE EL TOTAL DE KITS FACTURADOS POR NUMERO DE PARTE Y PRECIO/////////////////////////////////////////
					SELECT @VP_ACUMULADO_QTY =  SUM(CONVERT(INT, QTY))
					FROM #MATERIAL_VENDIDO
					WHERE CUS_PART_NO = @VP_CUS_PART_NO
					AND PRECIO = @VP_PRECIO
					SET NOCOUNT ON

					SET @VP_ACUMULADO_MOUNT = @VP_ACUMULADO_QTY * @VP_PRECIO

					-- ///////SE OBTIENEN LOS COSTOS DE LOS PROCESOS ESPECIALES POR NUMERO DE PARTE/////////////////////////////////////////
					DECLARE @OU_CUTTING_COST VARCHAR(50), @OU_TOTAL_PRICE_PER_PIECE VARCHAR(50), @OU_TOTAL_EMBOSSING_COST VARCHAR(50);     
					DECLARE @OU_TOTAL_LAMINATION_COST VARCHAR(50), @OU_TOTAL_PERFORATION_COST VARCHAR(50), @OU_TOTAL_QUILTING_COST VARCHAR(50);          
					DECLARE @OU_TOTAL_RECUT_COST VARCHAR(50), @OU_TOTAL_SKIVING_COST VARCHAR(50), @OU_TOTAL_PRICE_COMPLETE VARCHAR(50);   
					DECLARE @OU_TOTAL_NET_AREA VARCHAR(50), @OU_TOTAL_GROSS_AREA VARCHAR(50), @OU_TOTAL_LEATHER_CUTTING VARCHAR(50);

					EXECUTE [COT19_Cotizaciones_V9999_R0].[dbo].[PG_SK_TOTALES_X_COLOR_FINANZAS]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @VP_ITEM_NO, @VP_CUS_PART_NO,
																									@OU_CUTTING_COST			= @OU_CUTTING_COST OUTPUT, 
																									@OU_TOTAL_PRICE_PER_PIECE	= @OU_TOTAL_PRICE_PER_PIECE OUTPUT, 
																									@OU_TOTAL_EMBOSSING_COST	= @OU_TOTAL_EMBOSSING_COST OUTPUT,  
																									@OU_TOTAL_LAMINATION_COST	= @OU_TOTAL_LAMINATION_COST OUTPUT, 
																									@OU_TOTAL_PERFORATION_COST	= @OU_TOTAL_PERFORATION_COST OUTPUT, 
																									@OU_TOTAL_QUILTING_COST		= @OU_TOTAL_QUILTING_COST OUTPUT,   
																									@OU_TOTAL_RECUT_COST		= @OU_TOTAL_RECUT_COST OUTPUT, 
																									@OU_TOTAL_SKIVING_COST		= @OU_TOTAL_SKIVING_COST OUTPUT,
																									@OU_TOTAL_PRICE_COMPLETE	= @OU_TOTAL_PRICE_COMPLETE OUTPUT,
																									@OU_TOTAL_NET_AREA			= @OU_TOTAL_NET_AREA OUTPUT,
																									@OU_TOTAL_GROSS_AREA		= @OU_TOTAL_GROSS_AREA OUTPUT,
																									@OU_TOTAL_LEATHER_CUTTING	= @OU_TOTAL_LEATHER_CUTTING OUTPUT
					-- ///////SE OBTIENE EL MONTO DEL CORTE/////////////////////////////////////////
					SET @VP_CUTTING_MOUNT = 0

					IF @OU_CUTTING_COST <> '-1.00'
						BEGIN
							SET @VP_CUTTING_MOUNT =  @VP_ACUMULADO_QTY * CONVERT(DECIMAL(13,2),@OU_CUTTING_COST)
							SET @VP_TOTAL_CUTTING_MOUNT = @VP_TOTAL_CUTTING_MOUNT + @VP_CUTTING_MOUNT
						END
					-- ///////SE ACTUALIZAN LOS DATOS POR NUMERO DE PARTE Y PRECIO/////////////////////////////////////////
					UPDATE [tempdb].[dbo].[VENTA_TOTAL] 
						SET 
							ACUMULADO_QTY			= CONVERT(VARCHAR(15), @VP_ACUMULADO_QTY),
							ACUMULADO_MOUNT			= CONVERT(VARCHAR(15), @VP_ACUMULADO_MOUNT),
							CUTTING_MOUNT			= CONVERT(VARCHAR(15), @VP_CUTTING_MOUNT),
							----------------------------
							NET_AREA				= @OU_TOTAL_NET_AREA,
							GROSS					= @OU_TOTAL_GROSS_AREA,
							TOTAL_PRICE_COMPLETED	= @OU_TOTAL_PRICE_COMPLETE,
							CUTTING_COST			= @OU_CUTTING_COST,			 
							TOTAL_PRICE_PER_PIECE	= @OU_TOTAL_PRICE_PER_PIECE,
							EMBOSSING				= @OU_TOTAL_EMBOSSING_COST,	
							LAMINATION				= @OU_TOTAL_LAMINATION_COST,	
							PERFORATION				= @OU_TOTAL_PERFORATION_COST,	
							QUILTING				= @OU_TOTAL_QUILTING_COST,		
							RECUT					= @OU_TOTAL_RECUT_COST,		
							SKIVING					= @OU_TOTAL_SKIVING_COST	
					WHERE CUS_PART_NO = @VP_CUS_PART_NO
					AND PRECIO = @VP_PRECIO
					SET NOCOUNT ON

					FETCH NEXT FROM CU_VENTA_TOTAL_X_PART_NO INTO @VP_ITEM_NO, @VP_CUS_PART_NO, @VP_PRECIO --, @VP_NET_AREA		
				END
			
			-- ////////////////////SE CIERRA EL CURSOR//////////////////////////
			CLOSE CU_VENTA_TOTAL_X_PART_NO
			DEALLOCATE CU_VENTA_TOTAL_X_PART_NO
			
			-- ///////SE OBTIENE EL TOTAL DE KITS FACTURADOS/////////////////////////////////////////
			SELECT	@VP_TOTAL_PACKING =  SUM(CONVERT(INT, QTY))
			FROM	#MATERIAL_VENDIDO
			SET NOCOUNT ON

			-- ///////SE ACTUALIZA EL TOTAL DE KITS FACTURADOS/////////////////////////////////////////
			UPDATE [tempdb].[dbo].[VENTA_TOTAL] 
				SET ACUMULADO_QTY = CONVERT(VARCHAR(15), @VP_TOTAL_PACKING),
					CUTTING_MOUNT = CONVERT(VARCHAR(15),@VP_TOTAL_CUTTING_MOUNT),
					CUTTING_COST = @OU_TOTAL_LEATHER_CUTTING
			WHERE CUS_PART_NO = 'TOTAL USD $'
			SET NOCOUNT ON

			-- ///////SE MUESTRA EL RESULTADO PARA EL REPORTE/////////////////////////////////////////
			SELECT * FROM [tempdb].[dbo].[VENTA_TOTAL] ORDER BY COLOR

			-- ///////SE BORRAN LAS TABLAS TEMPORALES UTILIZADAS/////////////////////////////////////////
			DROP TABLE [tempdb].[dbo].[VENTA_TOTAL]
			SET NOCOUNT ON

			DROP TABLE #MATERIAL_VENDIDO
			SET NOCOUNT ON

			DROP TABLE [tempdb].[dbo].[FECHA_INVOICE]
			SET NOCOUNT ON

			DROP TABLE [tempdb].[dbo].[PACKING_INVOICE]
			SET NOCOUNT ON

			DROP TABLE [tempdb].[dbo].FACTURAS
			SET NOCOUNT ON

			DROP TABLE [tempdb].[dbo].TOTAL_INVOICE
			SET NOCOUNT ON

			DROP TABLE [tempdb].[dbo].QTY_SHIP
			SET NOCOUNT ON
		END
	-- ////////////////////////////////////////////////

		--	EXEC	[dbo].[PG_PR_REPORTE_VENTA_TOTAL] 0,0,  '2021/02/01' , '2021/02/06' , 'YANG03', 'FYCPAX7'                                                       
	
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
