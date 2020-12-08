-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	[DATA_02Pruebas]
-- // MODULO:			FINANZAS
-- // OPERACION:		LIBERACION / STORED PROCEDURES
-- //////////////////////////////////////////////////////////////
-- // Autor:			FEG
-- // Fecha creación:	16/11/2020
-- ////////////////////////////////////////////////////////////// 

USE [DATA_02PRUEBAS]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////

-- EXECUTE [PG_CB_ESTATUS_INVENTARIO_EMBARQUE] 001,144, 0
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_COLOR_X_PROGRAMA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_COLOR_X_PROGRAMA]
GO

/*'2015 WK KL' --
	EXEC	[dbo].[PG_CB_COLOR_X_PROGRAMA] 0,0,	 '2020/08/01' , '2020/08/30' , '2015 WK KL'  --'2020/08/01', '2020/08/30', 'WK GLDL'
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

	INSERT INTO @VP_TA_CATALOGO 
	SELECT	DISTINCT  LTRIM(RTRIM(item_desc_1))
	FROM pf_schst 
	INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(item_no)) = CONCAT('F', SUBSTRING(part_no, (LEN(LTRIM(RTRIM(part_no))) - 5), 6))
	AND SUBSTRING(LTRIM(RTRIM(item_no)),1,1) = 'F'
	WHERE TYPE = 'e' -- ENBARCADO
	AND		CDATE >= @PP_F_INICIO
	AND		CDATE <= @PP_F_FIN
	AND	(	packing_no IS NOT NULL
				OR inv_no IS NOT NULL )
	AND LTRIM(RTRIM(pf_schst.prod_cat)) = @VP_PROD_CAT

	-- ///////////////////////////////////////////////////
	SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
				TA_D_CATALOGO	AS D_COMBOBOX 
		FROM	@VP_TA_CATALOGO
		ORDER BY  TA_D_CATALOGO 

	-- ==========================================
		
	-- ////////////////////////////////////////////////////
GO

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////