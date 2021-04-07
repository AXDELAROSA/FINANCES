-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	[DATA_02Pruebas]
-- // MODULO:			FINANZAS
-- // OPERACION:		LIBERACION / STORED PROCEDURES
-- //////////////////////////////////////////////////////////////
-- // Autor:			FEG
-- // Fecha creación:	16/11/2020
-- ////////////////////////////////////////////////////////////// 

USE [DATA_02]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_COLOR_X_PROGRAMA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_COLOR_X_PROGRAMA]
GO

/*'2015 WK KL' --
	EXEC	[dbo].[PG_CB_COLOR_X_PROGRAMA] 0,0,	 '2021/01/01' , '2021/01/19' , 'WL 75 TL'  --'2020/08/01', '2020/08/30', 'WK GLDL'
*/
CREATE PROCEDURE [dbo].[PG_CB_COLOR_X_PROGRAMA]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO				INT,
	--============================
	@PP_F_INICIO				DATE,
	@PP_F_FIN					DATE,
	@PP_PROGRAMA				VARCHAR(50)
AS

	DECLARE @VP_TA_CATALOGO	AS TABLE
				(	TA_K_CATALOGO		INT IDENTITY(1,1),
					TA_D_CATALOGO		VARCHAR(50))
	
	DECLARE @VP_PROD_CAT VARCHAR(20) = ''
	SELECT TOP 1 @VP_PROD_CAT = prod_cat FROM imcatfil_sql  
	where prod_cat_desc = @PP_PROGRAMA
	AND   L_BORRADO = 0 
	ORDER BY PROD_CAT

	--INSERT INTO @VP_TA_CATALOGO 
	--SELECT	DISTINCT  LTRIM(RTRIM(item_desc_1))
	--FROM pf_schst 
	--INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(item_no)) = CONCAT('F', SUBSTRING(part_no, (LEN(LTRIM(RTRIM(part_no))) - 5), 6))
	--AND SUBSTRING(LTRIM(RTRIM(item_no)),1,1) = 'F'
	--WHERE TYPE = 'e' -- ENBARCADO
	--AND		CDATE >= @PP_F_INICIO
	--AND		CDATE <= @PP_F_FIN
	--AND	(	packing_no IS NOT NULL
	--			OR inv_no IS NOT NULL )
	--AND LTRIM(RTRIM(pf_schst.prod_cat)) = @VP_PROD_CAT

	INSERT INTO @VP_TA_CATALOGO 
	SELECT	DISTINCT  LTRIM(RTRIM(COLOR))
	FROM INVENTARIO_EMBARQUE 
	--INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(IMITMIDX_SQL.item_no)) = COLOR
	--AND SUBSTRING(LTRIM(RTRIM(IMITMIDX_SQL.item_no)),1,1) = 'F'
	WHERE CONVERT(DATE, F_INVENTARIO_EMBARQUE) >= @PP_F_INICIO
	AND		CONVERT(DATE, F_INVENTARIO_EMBARQUE) <= @PP_F_FIN
	AND	(	packing_no IS NOT NULL
				OR INVOICE_NO IS NOT NULL )
	AND LTRIM(RTRIM(INVENTARIO_EMBARQUE.PROD_CAT)) = @VP_PROD_CAT
	--AND LTRIM(RTRIM(item_desc_1)) NOT IN (SELECT TA_D_CATALOGO FROM @VP_TA_CATALOGO)

	-- ///////////////////////////////////////////////////
	SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
				TA_D_CATALOGO	AS D_COMBOBOX 
		FROM	@VP_TA_CATALOGO
		ORDER BY  TA_D_CATALOGO 

	-- ==========================================
		
	-- ////////////////////////////////////////////////////
GO


 -- USE DATA_02
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_COLOR_CON_DESCRIPCION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_COLOR_CON_DESCRIPCION]
GO

/*
	EXEC	[dbo].[PG_CB_COLOR_CON_DESCRIPCION] 0,0,	0
*/
CREATE PROCEDURE [dbo].[PG_CB_COLOR_CON_DESCRIPCION]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO				INT,
	--============================
	@PP_L_CON_TODOS				INT
AS

	DECLARE @VP_TA_CATALOGO	AS TABLE
				(	TA_K_CATALOGO		VARCHAR(10),
					TA_D_CATALOGO		VARCHAR(150) )
	
	IF @PP_L_CON_TODOS = 1
	BEGIN
		INSERT INTO @VP_TA_CATALOGO
			( TA_K_CATALOGO,	TA_D_CATALOGO	)
		VALUES
			( '( TODOS )',				'( TODOS )'		)
	END

	INSERT INTO @VP_TA_CATALOGO
	SELECT	LTRIM(RTRIM(ITEM_NO)), 
			CONCAT('( ', LTRIM(RTRIM(ITEM_NO)), ' ) ', LTRIM(RTRIM(item_desc_1)))
	FROM	IMITMIDX_SQL 
	WHERE	SUBSTRING(LTRIM(RTRIM(ITEM_NO)), 1, 1) = 'F'
	AND LTRIM(RTRIM(ITEM_NO)) IN ( SELECT DISTINCT LTRIM(RTRIM(COLOUR)) FROM COLORES_ACTIVOS)
	ORDER BY ITEM_NO
	
	-- ///////////////////////////////////////////////////
	SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
				TA_D_CATALOGO	AS D_COMBOBOX 
		FROM	@VP_TA_CATALOGO
		--ORDER BY  TA_D_CATALOGO 

	-- ==========================================
		
	-- ////////////////////////////////////////////////////
GO



-- USE DATA_02
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_COLOR_CON_DESCRIPCION_X_CLIENTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_COLOR_CON_DESCRIPCION_X_CLIENTE]
GO

/*
	EXEC	[dbo].[PG_CB_COLOR_CON_DESCRIPCION_X_CLIENTE] 0,0,	0, 'YANG03'
*/
CREATE PROCEDURE [dbo].[PG_CB_COLOR_CON_DESCRIPCION_X_CLIENTE]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO				INT,
	--============================
	@PP_L_CON_TODOS				INT,
	@PP_CLIENTE					VARCHAR(50)
AS

	DECLARE @VP_TA_CATALOGO	AS TABLE
				(	TA_K_CATALOGO		VARCHAR(10),
					TA_D_CATALOGO		VARCHAR(150) )
	
	IF @PP_L_CON_TODOS = 1
	BEGIN
		INSERT INTO @VP_TA_CATALOGO
			( TA_K_CATALOGO,	TA_D_CATALOGO	)
		VALUES
			( '( TODOS )',				'( TODOS )'		)
	END

	INSERT INTO @VP_TA_CATALOGO
	SELECT	LTRIM(RTRIM(ITEM_NO)), 
			CONCAT('( ', LTRIM(RTRIM(ITEM_NO)), ' ) ', LTRIM(RTRIM(item_desc_1)))
	FROM	IMITMIDX_SQL 
	WHERE	SUBSTRING(LTRIM(RTRIM(ITEM_NO)), 1, 1) = 'F'
	AND LTRIM(RTRIM(ITEM_NO)) IN ( SELECT DISTINCT LTRIM(RTRIM(COLOUR)) 
									FROM COLORES_ACTIVOS
									WHERE LTRIM(RTRIM(cus_no)) = @PP_CLIENTE )
	ORDER BY ITEM_NO
	
	-- ///////////////////////////////////////////////////
	SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
				TA_D_CATALOGO	AS D_COMBOBOX 
		FROM	@VP_TA_CATALOGO
		--ORDER BY  TA_D_CATALOGO 

	-- ==========================================
		
	-- ////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
--	USE [DATA_02]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_PROGRAMA_CON_PACKING]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_PROGRAMA_CON_PACKING]
GO

/*'2015 WK KL' --
	EXEC	[dbo].[PG_CB_PROGRAMA_CON_PACKING] 0,0,	1
*/
CREATE PROCEDURE [dbo].[PG_CB_PROGRAMA_CON_PACKING]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO				INT,
	--============================
	@PP_L_CON_TODOS					INT 
AS

	DECLARE @VP_TA_CATALOGO	AS TABLE
				(	TA_K_CATALOGO		INT IDENTITY(1,1),
					TA_D_CATALOGO		VARCHAR(50))
	
	IF @PP_L_CON_TODOS = 0
		BEGIN
			INSERT INTO @VP_TA_CATALOGO 
			SELECT TOP 1000 
					LTRIM(RTRIM(prod_cat_desc))
			FROM IMCATFIL_SQL 
			WHERE L_BORRADO <> 1 
			AND filler_0001 IS NOT NULL 
			ORDER BY filler_0001, prod_cat 
		END

	IF @PP_L_CON_TODOS = 1 -- SE USA EN FORMA FO_PACKING
		BEGIN
			INSERT INTO @VP_TA_CATALOGO 
			SELECT '( TODOS )'

			INSERT INTO @VP_TA_CATALOGO 
			SELECT 'ARMREST'

			INSERT INTO @VP_TA_CATALOGO 
			SELECT TOP 1000 
					LTRIM(RTRIM(prod_cat_desc))
			FROM IMCATFIL_SQL 
			WHERE L_BORRADO <> 1 
			AND filler_0001 IS NOT NULL 
			ORDER BY filler_0001, prod_cat 
		END

	-- ///////////////////////////////////////////////////
	SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
				TA_D_CATALOGO	AS D_COMBOBOX 
		FROM	@VP_TA_CATALOGO
		ORDER BY  TA_K_CATALOGO 

	-- ==========================================
		
	-- ////////////////////////////////////////////////////
GO

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////