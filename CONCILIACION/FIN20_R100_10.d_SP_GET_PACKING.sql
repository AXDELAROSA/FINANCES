-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	[DATA_02Pruebas]
-- // MODULO:			FINANZAS CONCILIACION
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			FEG
-- // Fecha creaci�n:	23/SEP/2020
-- //////////////////////////////////////////////////////////////  

USE [DATA_02]
GO

-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / 
-- //////////////////////////////////////////////////////////////


--USE [DATA_02]

--IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_GET_PACKING_NO_EMBARQUE_TEST]') AND type in (N'P', N'PC'))
--	DROP PROCEDURE [dbo].[PG_GET_PACKING_NO_EMBARQUE_TEST]
--GO
---- EXECUTE   [dbo].[PG_GET_PACKING_NO_EMBARQUE] 0,0, 'CHRYSLER RU AL' 
--CREATE PROCEDURE [dbo].[PG_GET_PACKING_NO_EMBARQUE]
--	@PP_K_SISTEMA_EXE			INT,
--	@PP_K_USUARIO_ACCION		INT,
--	-- ===========================
--	@PP_PROGRAMA_DESCRIPCION	VARCHAR(150)
--AS
--	-- ///////////////////////////////////////////
--	DECLARE @VP_PROGRAMA	VARCHAR(150) = ''
--	DECLARE @VP_RESULTADO	VARCHAR(250) = ''
	
--	SELECT @VP_PROGRAMA = LTRIM(RTRIM(filler_0001)) 
--	FROM imcatfil_sql WHERE
--	LTRIM(RTRIM(prod_cat_desc)) = @PP_PROGRAMA_DESCRIPCION
	
--	IF @VP_PROGRAMA IS NULL
--		SET @VP_PROGRAMA = ''
--	-- =========================================

--	IF @VP_PROGRAMA <> ''
--		BEGIN
--			DECLARE @VP_N_PACKING			INT = 0
--			DECLARE @VP_PACKING_NO_ACTUAL	VARCHAR(50) = ''
--			DECLARE @VP_DATE				DATE = GETDATE()

--			SELECT @VP_N_PACKING = COUNT(ID)
--			FROM	pf_schst 
--			WHERE	TYPE = 'e' 
--			AND		packing_no IS NOT NULL
--			AND		CONVERT(DATE, CDATE) = @VP_DATE

--			IF @VP_N_PACKING IS NULL
--				SET @VP_N_PACKING = 0

--			IF @VP_N_PACKING > 0
--				BEGIN
--					SELECT TOP 1 @VP_PACKING_NO_ACTUAL = LTRIM(RTRIM(PACKING_NO))
--					FROM	pf_schst 
--					WHERE	TYPE = 'e' 
--					AND		packing_no IS NOT NULL
--					AND	CONVERT(DATE, CDATE) = @VP_DATE
--					ORDER BY CONVERT(INT,SUBSTRING(packing_no,CHARINDEX('-', packing_no) + 1, 10)) DESC

--					DECLARE @VP_DELIMITADOR VARCHAR(5) = '-'
--					DECLARE @VP_CONSECUTIVO_ACTUAL VARCHAR(50) = ''
--					DECLARE @VP_POSICION_GUION INT = 0
--					DECLARE @VP_CONSECUTIVO_NUEVO INT = 0

--					SET @VP_POSICION_GUION = CHARINDEX(@VP_DELIMITADOR, @VP_PACKING_NO_ACTUAL)
	
--					SET @VP_CONSECUTIVO_ACTUAL = SUBSTRING(@VP_PACKING_NO_ACTUAL, @VP_POSICION_GUION + 1, 5)

--					SET @VP_CONSECUTIVO_NUEVO = CONVERT(INT, @VP_CONSECUTIVO_ACTUAL) + 1
					
--					SET @VP_RESULTADO = CONCAT(@VP_PROGRAMA, FORMAT(GETDATE(),'MMdd'), '-', @VP_CONSECUTIVO_NUEVO )
--				END
--			ELSE
--				BEGIN
--					SET @VP_RESULTADO = CONCAT(@VP_PROGRAMA, FORMAT(GETDATE(),'MMdd'), '-', '1' )
--				END

--		END

--	-- ///////////////////////////////////////////
--	SELECT @VP_RESULTADO AS PACKING_NO
--	-- ///////////////////////////////////////////

      
--	-- ////////////////////////////////////////////////////////////////////
--GO



--	USE [DATA_02]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_GET_PACKING_NO_EMBARQUE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_GET_PACKING_NO_EMBARQUE]
GO

-- 'CHRYSLER RU AL' 
-- '2015 WK KL'     
-- '2019 JEEP JT'
-- 'WPI WD'         
-- 'YANGFENG'      
-- 'RU PINNACLE DL'

-- EXECUTE   [dbo].[PG_GET_PACKING_NO_EMBARQUE] 0,0,  'ARMREST'
CREATE PROCEDURE [dbo].[PG_GET_PACKING_NO_EMBARQUE]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_PROGRAMA_DESCRIPCION	VARCHAR(150)
AS
	-- ///////////////////////////////////////////
	DECLARE @VP_PROGRAMA	VARCHAR(150) = ''
	DECLARE @VP_RESULTADO	VARCHAR(250) = ''
	
	IF @PP_PROGRAMA_DESCRIPCION = 'ARMREST'
		BEGIN
			SET @VP_PROGRAMA = 'WK'
		END
	ELSE
		BEGIN
			SELECT @VP_PROGRAMA = LTRIM(RTRIM(filler_0001)) 
			FROM imcatfil_sql WHERE
			LTRIM(RTRIM(prod_cat_desc)) = @PP_PROGRAMA_DESCRIPCION
		END

	IF @VP_PROGRAMA IS NULL
		SET @VP_PROGRAMA = ''
	-- =========================================

	IF @VP_PROGRAMA <> ''
		BEGIN
			DECLARE @VP_N_PACKING			INT = 0
			DECLARE @VP_PACKING_NO_ACTUAL	VARCHAR(50) = ''
			DECLARE @VP_DATE				DATE = GETDATE()

			SELECT @VP_N_PACKING = COUNT(ID)
			FROM	pf_schst 
			WHERE	TYPE = 'e' 
			AND		packing_no IS NOT NULL
			AND		CONVERT(DATE, CDATE) = @VP_DATE

			IF @VP_N_PACKING IS NULL
				SET @VP_N_PACKING = 0

			IF @VP_N_PACKING > 0
				BEGIN
					DECLARE @VP_N_PACKING_X_PROGRAMA INT = 0
					SELECT @VP_N_PACKING_X_PROGRAMA = COUNT(PACKING_NO)
					FROM	pf_schst 
					WHERE	TYPE = 'e' 
					AND		packing_no IS NOT NULL
					AND		CONVERT(DATE, CDATE) = @VP_DATE
					AND		LTRIM(RTRIM(packing_no)) LIKE CONCAT(@VP_PROGRAMA, '%')

					IF @VP_N_PACKING_X_PROGRAMA IS NULL
						SET @VP_N_PACKING_X_PROGRAMA = 0

					IF @VP_N_PACKING_X_PROGRAMA > 0
						BEGIN
							SELECT TOP 1 @VP_PACKING_NO_ACTUAL = LTRIM(RTRIM(PACKING_NO))
							FROM	pf_schst 
							WHERE	TYPE = 'e' 
							AND		packing_no IS NOT NULL
							AND	CONVERT(DATE, CDATE) = @VP_DATE
							AND		LTRIM(RTRIM(packing_no)) LIKE CONCAT(@VP_PROGRAMA, '%')
							ORDER BY CONVERT(INT,SUBSTRING(packing_no,CHARINDEX('-', packing_no) + 1, 10)) DESC

							DECLARE @VP_DELIMITADOR VARCHAR(5) = '-'
							DECLARE @VP_CONSECUTIVO_ACTUAL VARCHAR(50) = ''
							DECLARE @VP_POSICION_GUION INT = 0
							DECLARE @VP_CONSECUTIVO_NUEVO INT = 0

							SET @VP_POSICION_GUION = CHARINDEX(@VP_DELIMITADOR, @VP_PACKING_NO_ACTUAL)
	
							SET @VP_CONSECUTIVO_ACTUAL = SUBSTRING(@VP_PACKING_NO_ACTUAL, @VP_POSICION_GUION + 1, 5)

							SET @VP_CONSECUTIVO_NUEVO = CONVERT(INT, @VP_CONSECUTIVO_ACTUAL) + 1
							
							SET @VP_RESULTADO = CONCAT(@VP_PROGRAMA, FORMAT(GETDATE(),'MMdd'), '-', @VP_CONSECUTIVO_NUEVO )
							--SET @VP_RESULTADO = CONCAT(@VP_PROGRAMA, '1007', '-', @VP_CONSECUTIVO_NUEVO )

						END
					ELSE
						BEGIN
							SET @VP_RESULTADO = CONCAT(@VP_PROGRAMA, FORMAT(GETDATE(),'MMdd'), '-', '1' )
						END
				END
			ELSE
				BEGIN
					SET @VP_RESULTADO = CONCAT(@VP_PROGRAMA, FORMAT(GETDATE(),'MMdd'), '-', '1' )
				END
		END

	-- ///////////////////////////////////////////
	SELECT @VP_RESULTADO AS PACKING_NO
	-- ///////////////////////////////////////////

      
	-- ////////////////////////////////////////////////////////////////////
GO

-- USE [DATA_02]

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_QTY_PACKING_X_PART_NO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_QTY_PACKING_X_PART_NO]
GO
-- EXECUTE   [dbo].[PG_SK_QTY_PACKING_X_PART_NO] 0,0, 'ARMREST', 'CNPLT5', '20201020', 1
CREATE PROCEDURE [dbo].[PG_SK_QTY_PACKING_X_PART_NO]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_PROGRAMA_DESCRIPCION	VARCHAR(150),
	@PP_COLOR					VARCHAR(50),
	@PP_DATE					VARCHAR(50),
	@PP_N_EMBARQUE				INT
AS
	-- ///////////////////////////////////////////
	DECLARE @DESGLOSE_CANTIDAD_CAJAS_X_NP_CLIENTE_TBL AS TABLE(
			PROG		VARCHAR(100),
			NP_CLIENTE	VARCHAR(100),
			COLOR		VARCHAR(100),
			TYPE		VARCHAR(100),
			CDATE2		VARCHAR(100),
			N_EMB		INT
			)

	INSERT INTO @DESGLOSE_CANTIDAD_CAJAS_X_NP_CLIENTE_TBL
	SELECT	(CASE	WHEN LTRIM(RTRIM(PROG)) = '2017 WD ML' AND NP_CLIENTE = '188251A' 
						THEN 'ARMREST'
					-- ===========================
					WHEN LTRIM(RTRIM(PROG)) = 'WK GLDL'	AND ( NP_CLIENTE = '187959A' OR NP_CLIENTE = '173632P' OR NP_CLIENTE = '173530P' 
																OR NP_CLIENTE = '173632Q' OR NP_CLIENTE = '173530Q' OR NP_CLIENTE = '187959B' 
																OR NP_CLIENTE = '185572B' OR NP_CLIENTE = '188251A' OR NP_CLIENTE = '189003A' )
						THEN 'ARMREST'
					-- ===========================
					WHEN LTRIM(RTRIM(PROG)) = 'D258 TAURUS SHO' AND ( NP_CLIENTE = 'PC258ST13DSB5B8AA' OR NP_CLIENTE = 'PC258ST13PSB5B8AA' OR NP_CLIENTE = 'PC258ST13DSC5B8AA' OR NP_CLIENTE = 'PC258ST13PSC5B8AA' ) 
					THEN 'TAURUS SHO SUEDE'
					-- ===========================
					ELSE PROG END) AS PROG,
					-- ===========================
			LTRIM(RTRIM(NP_CLIENTE)) AS NP_CLIENTE, 
			COLOR,
			TYPE,
			CDATE2,
			N_EMB
	FROM	pf_sc_view 
	WHERE	LTRIM(RTRIM(COLOR)) = @PP_COLOR
	AND LTRIM(RTRIM(TYPE)) = 'e' 
	AND LTRIM(RTRIM(cdate2)) = @PP_DATE
	AND n_emb = @PP_N_EMBARQUE


	SELECT	LTRIM(RTRIM(NP_CLIENTE)) AS NP_CLIENTE, 
			COUNT(N_EMB) AS 'CANTIDAD' 
	FROM	@DESGLOSE_CANTIDAD_CAJAS_X_NP_CLIENTE_TBL 
	WHERE	LTRIM(RTRIM(PROG)) = @PP_PROGRAMA_DESCRIPCION
	AND LTRIM(RTRIM(COLOR)) = @PP_COLOR
	AND LTRIM(RTRIM(TYPE)) = 'e' 
	AND LTRIM(RTRIM(cdate2)) = @PP_DATE
	AND n_emb = @PP_N_EMBARQUE
	GROUP BY NP_CLIENTE

	-- ///////////////////////////////////////////

      
	-- ////////////////////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
