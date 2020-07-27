-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			HEADER_PURCHASE_ORDER
-- // OPERATION:		SP'S
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200206
-- ////////////////////////////////////////////////////////////// 

USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_HEADER_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_HEADER_PURCHASE_ORDER]
GO
-- EXECUTE [dbo].[PG_LI_HEADER_PURCHASE_ORDER] 0,144,'',-1,-1,-1,null,null
-- EXECUTE [dbo].[PG_LI_HEADER_PURCHASE_ORDER] 0,139, '' , -1 , -1 , -1 , '2020-06-08' , '2020-07-10'
CREATE PROCEDURE [dbo].[PG_LI_HEADER_PURCHASE_ORDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_BUSCAR						VARCHAR(200),
	@PP_K_STATUS_PURCHASE_ORDER		INT,
	@PP_K_VENDOR					INT,
	@PP_K_CURRENCY					INT,
	@PP_F_INIT						DATE,
	@PP_F_FINISH					DATE
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1		
	DECLARE @VP_K_APPROVED_BY		INT
	DECLARE @VP_LI_N_REGISTROS		INT =5000
	-- ///////////////////////////////////////////
	-- =========================================		
	DECLARE @VP_K_FOLIO				INT
	EXECUTE [BD_GENERAL].DBO.[PG_RN_OBTENER_ID_X_REFERENCIA]			
								@PP_BUSCAR,	@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
-- =========================================		
	IF @VP_MENSAJE=''
	BEGIN
			SELECT	TOP (1)
			--SE OBTIENE LA K_GERENTE PARA LISTAR LAS ORDENES DEL MISMO DEPARTAMENTO.
			@VP_K_APPROVED_BY=
				(	CASE
						WHEN	EN_NUM_DEPT IN (1)			THEN	(7945)			-- RH					
						WHEN	EN_NUM_DEPT IN (2,5,6,11)	THEN	(22)			-- PRODUCCION
						WHEN	EN_NUM_DEPT IN (3)			THEN	(4475)			-- MATERIALES
						WHEN	EN_NUM_DEPT IN (4)			THEN	(1299)			-- CALIDAD
						WHEN	EN_NUM_DEPT IN (7,12)		THEN	(181)			-- PROYECTOS / SISTEMAS
						WHEN	EN_NUM_DEPT IN (8)			THEN	(67)			-- FINANZAS
						WHEN	EN_NUM_DEPT IN (9)			THEN	(52)
				END )
				FROM    BD_GENERAL.DBO.USUARIO_PEARL
				LEFT JOIN HOWE.DBO.VISTA_GAFETES ON EN_NUM_EMP=K_EMPLEADO_PEARL
				WHERE	L_BORRADO=0
				AND		USUARIO_PEARL.K_USUARIO_PEARL=@PP_K_USUARIO_ACCION

			IF @PP_K_USUARIO_ACCION=139
			BEGIN
				SET @VP_K_APPROVED_BY = -1
			END
	END
	-- =========================================		
	IF @VP_MENSAJE=''
	BEGIN
		--SET @VP_LI_N_REGISTROS = 0		
	SELECT		TOP (@VP_LI_N_REGISTROS)
				CONVERT(INTEGER,(TAX_RATE*100)) AS TAX,
				F_DATE_PURCHASE_ORDER AS [DATE],
				F_REQUIRED_PURCHASE_ORDER AS [REQUIRED],
				S_STATUS_PURCHASE_ORDER	, D_STATUS_PURCHASE_ORDER,
				D_VENDOR,
				S_PLACED_BY	, D_PLACED_BY,
				S_TERMS		, D_TERMS	 ,				
				S_CURRENCY	, D_CURRENCY,
				D_DELIVERY_PURCHASE_ORDER AS D_DELIVERY_TO,
				HEADER_PURCHASE_ORDER.*
				-- =============================	
	FROM		HEADER_PURCHASE_ORDER
	INNER JOIN 	STATUS_PURCHASE_ORDER	ON STATUS_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER=HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER
	INNER JOIN 	VENDOR					ON VENDOR.K_VENDOR=HEADER_PURCHASE_ORDER.K_VENDOR
	INNER JOIN 	PLACED_BY				ON PLACED_BY.K_PLACED_BY=HEADER_PURCHASE_ORDER.K_PLACED_BY
	INNER JOIN	DELIVERY_PURCHASE_ORDER ON DELIVERY_PURCHASE_ORDER.K_DELIVERY_PURCHASE_ORDER=HEADER_PURCHASE_ORDER.K_DELIVERY_TO
	INNER JOIN 	BD_GENERAL.DBO.TERMS	ON TERMS.K_TERMS=HEADER_PURCHASE_ORDER.K_TERMS
	INNER JOIN 	BD_GENERAL.DBO.CURRENCY	ON CURRENCY.K_CURRENCY=HEADER_PURCHASE_ORDER.K_CURRENCY
				-- =============================
	WHERE		(	HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=@VP_K_FOLIO
				OR	HEADER_PURCHASE_ORDER.ISSUED_BY_PURCHASE_ORDER			LIKE '%'+@PP_BUSCAR+'%'
				OR	HEADER_PURCHASE_ORDER.CONFIRMING_ORDER_WITH				LIKE '%'+@PP_BUSCAR+'%' 
--				OR	HEADER_PURCHASE_ORDER.DELIVERY_TO						LIKE '%'+@PP_BUSCAR+'%'
				OR	HEADER_PURCHASE_ORDER.C_PURCHASE_ORDER					LIKE '%'+@PP_BUSCAR+'%' )
				-- =============================
	AND			( @PP_F_INIT IS NULL		OR	@PP_F_INIT<=F_DATE_PURCHASE_ORDER)
	AND			( @PP_F_FINISH IS NULL		OR	@PP_F_FINISH>=F_DATE_PURCHASE_ORDER)
				-- =============================
	AND			( @PP_K_STATUS_PURCHASE_ORDER	=-1		OR	HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER=@PP_K_STATUS_PURCHASE_ORDER )
	AND			( @PP_K_VENDOR =-1			OR	HEADER_PURCHASE_ORDER.K_VENDOR=@PP_K_VENDOR )
	AND			( @PP_K_CURRENCY =-1		OR	HEADER_PURCHASE_ORDER.K_CURRENCY=@PP_K_CURRENCY )
	AND			( @VP_K_APPROVED_BY =-1		OR	HEADER_PURCHASE_ORDER.K_APPROVED_BY=@VP_K_APPROVED_BY )
				-- =============================
	AND			HEADER_PURCHASE_ORDER.L_BORRADO<>1
	ORDER BY	K_STATUS_PURCHASE_ORDER, F_DATE_PURCHASE_ORDER	DESC
	END
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //	LISTADO PARA VERIFICAR LAS PO QUE SE DEBEN AUTORIZAR		--		LISTADO PARA GERENTES
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_APPROVE_MANAGER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_APPROVE_MANAGER]
GO
--		 EXECUTE [dbo].[PG_LI_APPROVE_MANAGER] 0,57,1		-- FABIOLA
--		 EXECUTE [dbo].[PG_LI_APPROVE_MANAGER] 0,47,1		-- MIKE
--		 EXECUTE [dbo].[PG_LI_APPROVE_MANAGER] 0,139,1		-- AX
--		 EXECUTE [dbo].[PG_LI_APPROVE_MANAGER] 0,60,1		-- LIC. ADRIANA
CREATE PROCEDURE [dbo].[PG_LI_APPROVE_MANAGER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_PO_FINANCES				INT
	-- ===========================
	--@PP_BUSCAR					VARCHAR(200),
	--@PP_K_STATUS_PURCHASE_ORDER	INT,
	--@PP_K_VENDOR					INT,
	--@PP_K_CURRENCY				INT,
	--@PP_F_INIT					DATE,
	--@PP_F_FINISH					DATE
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_LI_N_REGISTROS		INT =5000
	-- ///////////////////////////////////////////	
	IF @PP_K_USUARIO_ACCION NOT IN(60)
	BEGIN
		SET @PP_L_PO_FINANCES=0
	END
	-- ///////////////////////////////////////////	
	IF @VP_MENSAJE=''
	BEGIN
		IF @PP_L_PO_FINANCES=0
		BEGIN
			SELECT		TOP (@VP_LI_N_REGISTROS)
						CONVERT(INTEGER,(TAX_RATE*100)) AS TAX,
						F_DATE_PURCHASE_ORDER AS [DATE],
						F_REQUIRED_PURCHASE_ORDER AS [REQUIRED],
						S_STATUS_PURCHASE_ORDER	, D_STATUS_PURCHASE_ORDER,
						D_VENDOR,
						S_PLACED_BY	, D_PLACED_BY,
						S_TERMS		, D_TERMS	 ,				
						S_CURRENCY	, D_CURRENCY,
						D_DELIVERY_PURCHASE_ORDER AS D_DELIVERY_TO,
						HEADER_PURCHASE_ORDER.*
						-- =============================	
			FROM		HEADER_PURCHASE_ORDER
			INNER JOIN 	STATUS_PURCHASE_ORDER	ON STATUS_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER=HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER
			INNER JOIN 	VENDOR					ON VENDOR.K_VENDOR=HEADER_PURCHASE_ORDER.K_VENDOR
			INNER JOIN 	PLACED_BY				ON PLACED_BY.K_PLACED_BY=HEADER_PURCHASE_ORDER.K_PLACED_BY
			INNER JOIN	DELIVERY_PURCHASE_ORDER ON DELIVERY_PURCHASE_ORDER.K_DELIVERY_PURCHASE_ORDER=HEADER_PURCHASE_ORDER.K_DELIVERY_TO
			INNER JOIN 	BD_GENERAL.DBO.TERMS	ON TERMS.K_TERMS=HEADER_PURCHASE_ORDER.K_TERMS
			INNER JOIN 	BD_GENERAL.DBO.CURRENCY	ON CURRENCY.K_CURRENCY=HEADER_PURCHASE_ORDER.K_CURRENCY
			INNER JOIN	BD_GENERAL.dbo.USUARIO_PEARL	ON HEADER_PURCHASE_ORDER.K_APPROVED_BY=USUARIO_PEARL.K_EMPLEADO_PEARL
						-- =============================
			WHERE		USUARIO_PEARL.K_USUARIO_PEARL=@PP_K_USUARIO_ACCION
						-- =============================
			AND			( HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER	=	2 )
						-- =============================
			AND			HEADER_PURCHASE_ORDER.L_BORRADO<>1
			ORDER BY	K_STATUS_PURCHASE_ORDER, F_DATE_PURCHASE_ORDER	DESC
		END
		ELSE IF @PP_L_PO_FINANCES=1
		BEGIN
			SELECT		TOP (@VP_LI_N_REGISTROS)
						CONVERT(INTEGER,(TAX_RATE*100)) AS TAX,
						F_DATE_PURCHASE_ORDER AS [DATE],
						F_REQUIRED_PURCHASE_ORDER AS [REQUIRED],
						S_STATUS_PURCHASE_ORDER	, D_STATUS_PURCHASE_ORDER,
						D_VENDOR,
						S_PLACED_BY	, D_PLACED_BY,
						S_TERMS		, D_TERMS	 ,				
						S_CURRENCY	, D_CURRENCY,
						D_DELIVERY_PURCHASE_ORDER AS D_DELIVERY_TO,
						HEADER_PURCHASE_ORDER.*
						-- =============================	
			FROM		HEADER_PURCHASE_ORDER
			INNER JOIN 	STATUS_PURCHASE_ORDER	ON STATUS_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER=HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER
			INNER JOIN 	VENDOR					ON VENDOR.K_VENDOR=HEADER_PURCHASE_ORDER.K_VENDOR
			INNER JOIN 	PLACED_BY				ON PLACED_BY.K_PLACED_BY=HEADER_PURCHASE_ORDER.K_PLACED_BY
			INNER JOIN	DELIVERY_PURCHASE_ORDER ON DELIVERY_PURCHASE_ORDER.K_DELIVERY_PURCHASE_ORDER=HEADER_PURCHASE_ORDER.K_DELIVERY_TO
			INNER JOIN 	BD_GENERAL.DBO.TERMS	ON TERMS.K_TERMS=HEADER_PURCHASE_ORDER.K_TERMS
			INNER JOIN 	BD_GENERAL.DBO.CURRENCY	ON CURRENCY.K_CURRENCY=HEADER_PURCHASE_ORDER.K_CURRENCY
			INNER JOIN	BD_GENERAL.dbo.USUARIO_PEARL	ON HEADER_PURCHASE_ORDER.K_APPROVED_BY=USUARIO_PEARL.K_EMPLEADO_PEARL
						-- =============================
			--WHERE		USUARIO_PEARL.K_USUARIO_PEARL=@PP_K_USUARIO_ACCION
						-- =============================
			WHERE		HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER	IN	(2,7)
						-- =============================
			AND			HEADER_PURCHASE_ORDER.L_BORRADO<>1
			ORDER BY	K_STATUS_PURCHASE_ORDER, F_DATE_PURCHASE_ORDER	DESC			
		END
	END
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //	LISTADO PARA VERIFICAR LAS PO QUE SE DEBEN AUTORIZAR		--		LISTADO PARA FINANZAS
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_APPROVE_FINANCES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_APPROVE_FINANCES]
GO
--		 EXECUTE [dbo].[PG_LI_APPROVE_FINANCES] 0,57		4		-- FABIOLA
--		 EXECUTE [dbo].[PG_LI_APPROVE_FINANCES] 0,47		2		-- MIKE
--		 EXECUTE [dbo].[PG_LI_APPROVE_FINANCES] 0,139		2		-- AX
--		 EXECUTE [dbo].[PG_LI_APPROVE_FINANCES] 0,60		2		-- LIC. ADRIANA
CREATE PROCEDURE [dbo].[PG_LI_APPROVE_FINANCES]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT--,
	-- ===========================
	--@PP_BUSCAR						VARCHAR(200),
	--@PP_K_STATUS_PURCHASE_ORDER		INT,
	--@PP_K_VENDOR					INT,
	--@PP_K_CURRENCY					INT,
	--@PP_F_INIT						DATE,
	--@PP_F_FINISH					DATE
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_LI_N_REGISTROS		INT =5000
	-- ///////////////////////////////////////////	
	IF @VP_MENSAJE=''
	BEGIN
	SELECT		TOP (@VP_LI_N_REGISTROS)
				CONVERT(INTEGER,(TAX_RATE*100)) AS TAX,
				F_DATE_PURCHASE_ORDER AS [DATE],
				F_REQUIRED_PURCHASE_ORDER AS [REQUIRED],
				S_STATUS_PURCHASE_ORDER	, D_STATUS_PURCHASE_ORDER,
				D_VENDOR,
				S_PLACED_BY	, D_PLACED_BY,
				S_TERMS		, D_TERMS	 ,				
				S_CURRENCY	, D_CURRENCY,
				D_DELIVERY_PURCHASE_ORDER AS D_DELIVERY_TO,
				HEADER_PURCHASE_ORDER.*
				-- =============================	
	FROM		HEADER_PURCHASE_ORDER
	INNER JOIN 	STATUS_PURCHASE_ORDER	ON STATUS_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER=HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER
	INNER JOIN 	VENDOR					ON VENDOR.K_VENDOR=HEADER_PURCHASE_ORDER.K_VENDOR
	INNER JOIN 	PLACED_BY				ON PLACED_BY.K_PLACED_BY=HEADER_PURCHASE_ORDER.K_PLACED_BY
	INNER JOIN	DELIVERY_PURCHASE_ORDER ON DELIVERY_PURCHASE_ORDER.K_DELIVERY_PURCHASE_ORDER=HEADER_PURCHASE_ORDER.K_DELIVERY_TO
	INNER JOIN 	BD_GENERAL.DBO.TERMS	ON TERMS.K_TERMS=HEADER_PURCHASE_ORDER.K_TERMS
	INNER JOIN 	BD_GENERAL.DBO.CURRENCY	ON CURRENCY.K_CURRENCY=HEADER_PURCHASE_ORDER.K_CURRENCY
--	INNER JOIN	BD_GENERAL.dbo.USUARIO_PEARL	ON HEADER_PURCHASE_ORDER.K_APPROVED_BY=USUARIO_PEARL.K_EMPLEADO_PEARL
				-- =============================
	--WHERE		HEADER_PURCHASE_ORDER.K_APPROVED_BY=@PP_K_USUARIO_ACCION
	WHERE		@PP_K_USUARIO_ACCION IN (57,139)
				-- =============================
	AND			HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER	IN	(4,6,7,9) 
				-- =============================
	AND			HEADER_PURCHASE_ORDER.L_BORRADO<>1
	ORDER BY	K_STATUS_PURCHASE_ORDER, F_DATE_PURCHASE_ORDER	DESC
	END
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_HEADER_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_HEADER_PURCHASE_ORDER]
GO
-- EXECUTE [dbo].[PG_SK_HEADER_PURCHASE_ORDER] 0,139,1		
-- EXECUTE [dbo].[PG_SK_HEADER_PURCHASE_ORDER] 0,139,8008
-- EXECUTE [dbo].[PG_SK_DETAILS_PURCHASE_ORDER] 0,139,1
CREATE PROCEDURE [dbo].[PG_SK_HEADER_PURCHASE_ORDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		INT
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''	
	-- ///////////////////////////////////////////			
	SELECT		TOP (1)
				S_STATUS_PURCHASE_ORDER	, D_STATUS_PURCHASE_ORDER,
				D_VENDOR,
				S_PLACED_BY	, D_PLACED_BY,
				S_TERMS		, D_TERMS	 , C_TERMS	 ,
				S_CURRENCY	, D_CURRENCY,	
				D_DELIVERY_PURCHASE_ORDER	AS D_DELIVERY_TO,
				C_DELIVERY_PURCHASE_ORDER	AS C_DELIVERY_TO,
				S_DELIVERY_PURCHASE_ORDER	AS S_DELIVERY_TO,
				CONVERT(INTEGER,TAX_RATE*100) AS TAX_RATE_PER,
				-- ===========================	-- ===========================
				CONVERT(VARCHAR, CAST(SUBTOTAL_PURCHASE_ORDER AS MONEY), 1)	AS SUBTOTAL_PURCHASE_ORDER,
				CONVERT(VARCHAR, CAST(IVA_PURCHASE_ORDER AS MONEY), 1)		AS IVA_PURCHASE_ORDER,
				CONVERT(VARCHAR, CAST(TOTAL_PURCHASE_ORDER AS MONEY), 1)	AS TOTAL_PURCHASE_ORDER,
				-- ===========================	-- ===========================
				-- ===========================	-- ===========================
				-- ===========================	-- ===========================
				---- PARA INSERTAR LOS NOMBRES DE LAS AUTORIZACIONES/APROBACIONES Y QUIEN GENERA.
				CONCAT(EP_NOMBRE,' ',EP_APELLIDO_PATERNO) AS APPROVED,
				---- PARA OBTENER LA RUTA DEL ARCHIVO DE LA FIRMA DIGITAL DEL GERENTE
				CONCAT(C_FIRMAS,D_FIRMAS,S_FIRMAS)	AS RUTA_FIRMA,
				-- ===========================	-- ===========================
				-- ===========================	-- ===========================
				-- ===========================	-- ===========================
				--(CASE	
				--	WHEN CAST(F_REQUIRED_PURCHASE_ORDER AS DATE)=CAST(F_DATE_PURCHASE_ORDER AS DATE) THEN	'ASAP'
				--	ELSE	F_REQUIRED_PURCHASE_ORDER 
				--END	) AS ASAP,
				HEADER_PURCHASE_ORDER.*
				-- =============================	
	FROM		HEADER_PURCHASE_ORDER,		STATUS_PURCHASE_ORDER, 
				VENDOR,						PLACED_BY,
				BD_GENERAL.DBO.TERMS,		BD_GENERAL.DBO.CURRENCY,
				DELIVERY_PURCHASE_ORDER,
				-- =============================
				-- =============================
				HOWE.DBO.VISTA_GAFETES,				-- PARA OBTENER EL NOMBRE DE LA PERSONA QUE AUTORIZARÁ LA PO
				BD_GENERAL.DBO.FIRMAS
				-- =============================
				-- =============================
	WHERE		HEADER_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER=STATUS_PURCHASE_ORDER.K_STATUS_PURCHASE_ORDER
	AND			HEADER_PURCHASE_ORDER.K_VENDOR=VENDOR.K_VENDOR
	AND			HEADER_PURCHASE_ORDER.K_PLACED_BY=PLACED_BY.K_PLACED_BY
	AND			HEADER_PURCHASE_ORDER.K_TERMS=TERMS.K_TERMS
	AND			HEADER_PURCHASE_ORDER.K_DELIVERY_TO=DELIVERY_PURCHASE_ORDER.K_DELIVERY_PURCHASE_ORDER
	AND			HEADER_PURCHASE_ORDER.K_CURRENCY=CURRENCY.K_CURRENCY
				-- =============================
				-- =============================
	AND			EN_NUM_EMP=HEADER_PURCHASE_ORDER.K_APPROVED_BY
	AND			HEADER_PURCHASE_ORDER.K_APPROVED_BY=FIRMAS.K_FIRMAS
				-- =============================
				-- =============================
	AND			HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
	AND			HEADER_PURCHASE_ORDER.L_BORRADO<>1		
	-- ////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_DETAILS_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_DETAILS_PURCHASE_ORDER]
GO
-- EXECUTE [dbo].[PG_SK_DETAILS_PURCHASE_ORDER] 0,139,8008
CREATE PROCEDURE [dbo].[PG_SK_DETAILS_PURCHASE_ORDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		INT
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''	
	-- ///////////////////////////////////////////
	SELECT		TOP (5000)
				S_CURRENCY,
				ITEM.K_CURRENCY,
				PART_NUMBER_ITEM_VENDOR,
				D_ITEM,
				DETAILS_PURCHASE_ORDER.QUANTITY_ORDER AS QUANTITY,
				PRICE_ITEM,
				TOTAL_PRICE as TOTAL_ITEM,
				DETAILS_PURCHASE_ORDER.*
	FROM		DETAILS_PURCHASE_ORDER
	INNER JOIN	ITEM		ON	DETAILS_PURCHASE_ORDER.K_ITEM=ITEM.K_ITEM
	INNER JOIN	BD_GENERAL.DBO.CURRENCY	ON	ITEM.K_CURRENCY=CURRENCY.K_CURRENCY
	WHERE		DETAILS_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
	-- ////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////
--EN_NUM_DEPT		DP_DESC_DEPTO					--EN_NUM_DEPT		DP_DESC_DEPTO
	--1				DEPTO 1    (ADMINISTRACION)			--2				DEPTO 2 (PRODUCCION)
	--3				DEPTO 3 (MATERIALES)				--4				DEPTO 4  (CONTROL DE CALIDAD)
	--5				INGENIERIA-MANTENIMIENTO			--6				PRODUCCION
	--7				SISTEMAS							--8				FINANZAS
	--9				GERENCIA							--10			NO EXISTE EL 10
	--11			PERFORACION							--12			INGENIERIA DE PROYECTOS	
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_ISSUED]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_ISSUED]
GO
-- EXECUTE [dbo].[PG_SK_ISSUED] 0,139,139
-- EXECUTE [dbo].[PG_SK_ISSUED] 0,139,145
-- EXECUTE [dbo].[PG_SK_ISSUED] 0,139,42
CREATE PROCEDURE [dbo].[PG_SK_ISSUED]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_USUARIO				INT
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''	
	-- ///////////////////////////////////////////			
	SELECT	TOP (1)
			USUARIO_PEARL.K_USUARIO_PEARL AS K_USUARIO_ALTA,
			CONCAT(EP_NOMBRE,' ',EP_APELLIDO_PATERNO) AS ISSUED,
			(	CASE
					WHEN	EN_NUM_DEPT IN (1)			THEN	(SELECT CONCAT(EP_NOMBRE,' ',EP_APELLIDO_PATERNO) FROM	HOWE.DBO.VISTA_GAFETES WHERE EN_NUM_DEPT=1 AND 	EN_SUPERVISOR='GERENTES' AND EN_NUM_EMP=7945)	-- RH					
					WHEN	EN_NUM_DEPT IN (2,5,6,11)	THEN	(SELECT CONCAT(EP_NOMBRE,' ',EP_APELLIDO_PATERNO) FROM	HOWE.DBO.VISTA_GAFETES WHERE EN_NUM_DEPT=6 AND 	EN_SUPERVISOR='GERENTES')						-- PRODUCCION
					WHEN	EN_NUM_DEPT IN (3)			THEN	(SELECT CONCAT(EP_NOMBRE,' ',EP_APELLIDO_PATERNO) FROM	HOWE.DBO.VISTA_GAFETES WHERE EN_NUM_DEPT=3 AND 	EN_SUPERVISOR='GERENTES')						-- MATERIALES
					WHEN	EN_NUM_DEPT IN (4)			THEN	(SELECT CONCAT(EP_NOMBRE,' ',EP_APELLIDO_PATERNO) FROM	HOWE.DBO.VISTA_GAFETES WHERE EN_NUM_DEPT=4 AND 	EN_SUPERVISOR='GERENTES')						-- CALIDAD
					WHEN	EN_NUM_DEPT IN (7,12)		THEN	(SELECT CONCAT(EP_NOMBRE,' ',EP_APELLIDO_PATERNO) FROM	HOWE.DBO.VISTA_GAFETES WHERE EN_NUM_DEPT=12 AND EN_SUPERVISOR='GERENTES')					-- PROYECTOS / SISTEMAS
					WHEN	EN_NUM_DEPT IN (8)			THEN	(SELECT CONCAT(EP_NOMBRE,' ',EP_APELLIDO_PATERNO) FROM	HOWE.DBO.VISTA_GAFETES WHERE EN_NUM_DEPT=8 AND 	EN_SUPERVISOR='GERENTES')						-- FINANZAS
					WHEN	EN_NUM_DEPT IN (9)			THEN	'JORGE HOLGUIN'
					ELSE	'X'
			END )		APPROVED,
				--SE OBTIENE LA K_DEL GERENTE PARA OBTENER LA IMAGEN EN EL REPORTE DE LA PO
			(	CASE
					WHEN	EN_NUM_DEPT IN (1)			THEN	(7945)			-- RH					
					WHEN	EN_NUM_DEPT IN (2,5,6,11)	THEN	(22)			-- PRODUCCION
					WHEN	EN_NUM_DEPT IN (3)			THEN	(4475)			-- MATERIALES
					WHEN	EN_NUM_DEPT IN (4)			THEN	(1299)			-- CALIDAD
					WHEN	EN_NUM_DEPT IN (7,12)		THEN	(181)			-- PROYECTOS / SISTEMAS
					WHEN	EN_NUM_DEPT IN (8)			THEN	(67)			-- FINANZAS
					WHEN	EN_NUM_DEPT IN (9)			THEN	'JORGE HOLGUIN'
					ELSE	'X'
			END )		K_APPROVED,
			'JORGE HOLGUIN' AS AUTHORIZED
	FROM    BD_GENERAL.DBO.USUARIO_PEARL
	LEFT JOIN HOWE.DBO.VISTA_GAFETES ON EN_NUM_EMP=K_EMPLEADO_PEARL
	WHERE	L_BORRADO=0
	AND		USUARIO_PEARL.K_USUARIO_PEARL=@PP_K_USUARIO
	ORDER BY APELLIDO_PATERNO ASC
	-- ////////////////////////////////////////////////////////////////////
GO

	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_IN_HEADER_PURCHASE_ORDER]	0, 139,  'TEST' , 
--			'2020/07/07' , '2020/07/07' , 'ALEJANDRO DE LA ROSA' , 'ALEJANDRO DE LA ROSA' , 
--			0 , '1' , 'RAFAEL FIERRO' , 1 , 0 , 1 , 8 , 2938.00 , 235.04 , 3173.04 , 
--			'24/27/26/25/28/30/29' , '2/4/6/6/6/4/2' , 
--			'45.00/27.00/130.00/78.00/22.00/30.00/620.00' , 
--			'90.00/108.00/780.00/468.00/132.00/120.00/1240.00' 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_HEADER_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_HEADER_PURCHASE_ORDER]
GO

CREATE PROCEDURE [dbo].[PG_IN_HEADER_PURCHASE_ORDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_C_PURCHASE_ORDER					[VARCHAR](255),
	-- ============================
	@PP_F_DATE_PURCHASE_ORDER				[DATE],
	@PP_F_REQUIRED_PURCHASE_ORDER			[DATE],
	-- ============================
	@PP_ISSUED_BY_PURCHASE_ORDER			[VARCHAR] (150),
	@PP_REQUIRED_PURCHASE_ORDER				[VARCHAR] (150),
	@PP_K_PLACED_BY							[INT],
	@PP_K_APPROVED_BY						[INT],
	-- ============================
	@PP_K_DELIVERY_TO						[INT],
	@PP_CONFIRMING_ORDER_WITH				[VARCHAR] (150),
	@PP_K_VENDOR							[INT],
	-- ============================
	@PP_K_TERMS								[INT],
	@PP_K_CURRENCY							[INT],
	@PP_TAX_RATE							[DECIMAL] (10,4),
	-- ============================
	@PP_SUBTOTAL_PURCHASE_ORDER				[DECIMAL] (10,4),
	@PP_IVA_PURCHASE_ORDER					[DECIMAL] (10,4),
	@PP_TOTAL_PURCHASE_ORDER				[DECIMAL] (10,4),
	-----=====================================================
	@PP_ITEM_ARRAY							NVARCHAR(MAX),
	@PP_QUANTITY_ARRAY						NVARCHAR(MAX),
	@PP_PRICE_ARRAY							NVARCHAR(MAX),
	@PP_TOTAL_ARRAY							NVARCHAR(MAX),
	-----=====================================================
	@PP_TOTAL_ITEMS							[INT]
AS			
DECLARE @VP_MENSAJE				VARCHAR(500) = ''
DECLARE @VP_K_HEADER_PURCHASE_ORDER			INT = 0;		
DECLARE @VP_K_PO			INT = 0;		
BEGIN TRANSACTION 
BEGIN TRY
-- /////////////////////////////////////////////////////////////////////
		EXECUTE [BD_GENERAL].dbo.[PG_SK_CATALOGO_K_MAX_GET]		@PP_K_SISTEMA_EXE, 'COMPRAS',
																'HEADER_PURCHASE_ORDER', 'K_HEADER_PURCHASE_ORDER',
																@OU_K_TABLA_DISPONIBLE = @VP_K_HEADER_PURCHASE_ORDER	OUTPUT
	-- /////////////////////////////////////////////////////////////////////
	--SET @VP_K_PO = @VP_K_HEADER_PURCHASE_ORDER + 8006	-- VALOR PARA PRUEBAS, SE ESTABLECE PARA NO INICIAR LAS PO EN 1
	-- //////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
	BEGIN		
	--============================================================================
	--======================================INSERTAR EL HEADER_PURCHASE_ORDER
	--============================================================================
		INSERT INTO HEADER_PURCHASE_ORDER
			(	[K_HEADER_PURCHASE_ORDER],	[C_PURCHASE_ORDER],
				-- ============================
				[K_STATUS_PURCHASE_ORDER],				
				-- ============================
				[F_DATE_PURCHASE_ORDER],	[F_REQUIRED_PURCHASE_ORDER],			
				-- ============================
				[ISSUED_BY_PURCHASE_ORDER],	[REQUIRED_PURCHASE_ORDER],				
				[K_PLACED_BY],				[K_APPROVED_BY],
				-- ============================
				[K_DELIVERY_TO],			[CONFIRMING_ORDER_WITH],				
				[K_VENDOR],
				-- ============================
				[K_TERMS],					[K_CURRENCY],							
				[TAX_RATE],					--[ADDITIONAL_TAXES_PURCHASE_ORDER],		
				--[ADDITIONAL_DISCOUNTS_PURCHASE_ORDER],	
				--[PREPAID_PURCHASE_ORDER],				
				-- ============================
				[TOTAL_ITEMS],
				[SUBTOTAL_PURCHASE_ORDER],	
				[IVA_PURCHASE_ORDER],
				[TOTAL_PURCHASE_ORDER],				
				-- ============================
				--[K_ACCOUNT_PURCHASE_ORDER],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_HEADER_PURCHASE_ORDER, 
				--@VP_K_PO,		-- VALOR PARA PRUEBAS, SE ESTABLECE PARA NO INICIAR LAS PO EN 1
				@PP_C_PURCHASE_ORDER, 
				-- ============================
				1, --@PP_K_STATUS_PURCHASE_ORDER,				
				-- ============================
				@PP_F_DATE_PURCHASE_ORDER,		@PP_F_REQUIRED_PURCHASE_ORDER,
				-- ============================
				@PP_ISSUED_BY_PURCHASE_ORDER,	@PP_REQUIRED_PURCHASE_ORDER,				
				@PP_K_PLACED_BY,				@PP_K_APPROVED_BY,
				-- ============================
				@PP_K_DELIVERY_TO,				@PP_CONFIRMING_ORDER_WITH,				
				@PP_K_VENDOR,
				-- ============================
				@PP_K_TERMS,					@PP_K_CURRENCY,							
				(@PP_TAX_RATE/100),					--0, --@PP_ADDITIONAL_TAXES_PURCHASE_ORDER,		
				--0, --@PP_ADDITIONAL_DISCOUNTS_PURCHASE_ORDER,	
				--0, --@PP_PREPAID_PURCHASE_ORDER,				
				-- ============================
				@PP_TOTAL_ITEMS,
				@PP_SUBTOTAL_PURCHASE_ORDER,	
				@PP_IVA_PURCHASE_ORDER,
				@PP_TOTAL_PURCHASE_ORDER,				
				-- ============================
				--0, --@PP_K_ACCOUNT_PURCHASE_ORDER,
				-- ============================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )

			IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='The HEADER_PURCHASE_ORDER was not inserted. [HEADER_PURCHASE_ORDER#'+CONVERT(VARCHAR(10),@VP_K_HEADER_PURCHASE_ORDER)+']'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END				
	END

	IF @VP_MENSAJE=''
	BEGIN
		EXECUTE		[dbo].[PG_IN_DETAILS_PURCHASE_ORDER]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															-----=====================================================
															@VP_K_HEADER_PURCHASE_ORDER,
															--@VP_K_PO,		-- VALOR PARA PRUEBAS, SE ESTABLECE PARA NO INICIAR LAS PO EN 1
															@PP_ITEM_ARRAY,		@PP_QUANTITY_ARRAY,
															@PP_PRICE_ARRAY,	@PP_TOTAL_ARRAY
	END
-- /////////////////////////////////////////////////////////////////////
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	/* Ocurrió un error, deshacemos los cambios*/ 
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH	
	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		SET		@VP_MENSAJE = 'Not is possible [Insert] at [HEADER_PURCHASE_ORDER]: ' + @VP_MENSAJE 
	END
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_HEADER_PURCHASE_ORDER AS CLAVE
	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // PARA INSERTAR LOS DETALLES DE LA ORDEN DE COMPRA
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_DETAILS_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_DETAILS_PURCHASE_ORDER]
GO

CREATE PROCEDURE [dbo].[PG_IN_DETAILS_PURCHASE_ORDER]
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-----=====================================================
	@PP_K_HEADER_PURCHASE_ORDER				INT,
	@PP_ITEM_ARRAY							NVARCHAR(MAX),
	@PP_QUANTITY_ARRAY						NVARCHAR(MAX),
	@PP_PRICE_ARRAY							NVARCHAR(MAX),
	@PP_TOTAL_ARRAY							NVARCHAR(MAX)
	-----=====================================================
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	-----=====================================================				
	DECLARE @VP_K_DETAIL_PO	INT = 1
	
	DECLARE @VP_POSICION_ITEM	INT
	DECLARE @VP_POSICION_QTY	INT
	DECLARE @VP_POSICION_PRICE	INT 
	DECLARE @VP_POSICION_TOTAL	INT
	DECLARE @VP_VALOR_ITEM		VARCHAR(500)
	DECLARE @VP_VALOR_QTY		VARCHAR(500)
	DECLARE @VP_VALOR_PRICE		VARCHAR(500)
	DECLARE @VP_VALOR_TOTAL		VARCHAR(500)
	--Colocamos un separador al final de los parametros para que funcione bien nuestro codigo
	SET	@PP_ITEM_ARRAY		= @PP_ITEM_ARRAY		+ '/'
	SET	@PP_QUANTITY_ARRAY	= @PP_QUANTITY_ARRAY	+ '/'
	SET	@PP_PRICE_ARRAY		= @PP_PRICE_ARRAY		+ '/'
	SET	@PP_TOTAL_ARRAY		= @PP_TOTAL_ARRAY		+ '/'
	
	--Hacemos un bucle que se repite mientras haya separadores, patindex busca un patron en una cadena y nos devuelve su posicion
	WHILE patindex('%/%' , @PP_ITEM_ARRAY) <> 0
		BEGIN
			SELECT @VP_POSICION_ITEM	=	patindex('%/%' , @PP_ITEM_ARRAY		)
			SELECT @VP_POSICION_QTY		=	patindex('%/%' , @PP_QUANTITY_ARRAY	)
			SELECT @VP_POSICION_PRICE	=	patindex('%/%' , @PP_PRICE_ARRAY	)
			SELECT @VP_POSICION_TOTAL	=	patindex('%/%' , @PP_TOTAL_ARRAY	)

			--Buscamos la posicion de la primera y obtenemos los caracteres hasta esa posicion
			SELECT @VP_VALOR_ITEM		= LEFT(@PP_ITEM_ARRAY		, @VP_POSICION_ITEM		- 1)
			SELECT @VP_VALOR_QTY		= LEFT(@PP_QUANTITY_ARRAY	, @VP_POSICION_QTY		- 1)
			SELECT @VP_VALOR_PRICE		= LEFT(@PP_PRICE_ARRAY		, @VP_POSICION_PRICE	- 1)
			SELECT @VP_VALOR_TOTAL		= LEFT(@PP_TOTAL_ARRAY		, @VP_POSICION_TOTAL	- 1)
		
					INSERT INTO DETAILS_PURCHASE_ORDER
						(
						[K_HEADER_PURCHASE_ORDER]		,
						[K_DETAILS_PURCHASE_ORDER]		,
						-- ============================	,
						[K_ITEM],			[QUANTITY_ORDER],
						-- ============================
						[UNIT_PRICE],		[TOTAL_PRICE]
						)
					VALUES
						(
						@PP_K_HEADER_PURCHASE_ORDER,
						@VP_K_DETAIL_PO,
						@VP_VALOR_ITEM,		@VP_VALOR_QTY,	
						@VP_VALOR_PRICE,	@VP_VALOR_TOTAL
						)																		
													
			IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='The DETAIL_PURCHASE_ORDER was not inserted. [DETAIL#'+CONVERT(VARCHAR(10),@VP_VALOR_ITEM)+']'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END	

			--Reemplazamos lo procesado con nada con la funcion stuff
			SELECT @PP_ITEM_ARRAY		= STUFF(@PP_ITEM_ARRAY		, 1, @VP_POSICION_ITEM , '')
			SELECT @PP_QUANTITY_ARRAY	= STUFF(@PP_QUANTITY_ARRAY	, 1, @VP_POSICION_QTY  , '')
			SELECT @PP_PRICE_ARRAY		= STUFF(@PP_PRICE_ARRAY		, 1, @VP_POSICION_PRICE, '')
			SELECT @PP_TOTAL_ARRAY		= STUFF(@PP_TOTAL_ARRAY		, 1, @VP_POSICION_TOTAL, '')

			SET @VP_K_DETAIL_PO += 1
		END
	-- ////////////////////////////////////////////////////////////////
	-- ///////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_UP_HEADER_PURCHASE_ORDER] 0, 139,												
--				379,												
--				'TEST HEADER_PURCHASE_ORDER 3' , '' , 
--				'TEST200220IT' , 'TEST200201IT@TEST.HEADER_PURCHASE_ORDER' , '6660000000' , 30 , 
--				1,0,
--				1,
--				'CALLE HEADER_PURCHASE_ORDER' , 'COLONIA HEADER_PURCHASE_ORDER' , 'COMMENTS' , 
--				'CIUDAD HEADER_PURCHASE_ORDER', 'ESTADO HEADER_PURCHASE_ORDER' , '32000' , '123' , '-A',
--				1, 
--				'NOMBRE 1' , 'APELLIDO 1' , '' , '' , '' , 
--				'' , '' ,'' ,''														
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_HEADER_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_HEADER_PURCHASE_ORDER]
GO

CREATE PROCEDURE [dbo].[PG_UP_HEADER_PURCHASE_ORDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		[INT],
	@PP_C_PURCHASE_ORDER			[VARCHAR](255),
	-- ============================
	@PP_F_DATE_PURCHASE_ORDER		[DATE],
	@PP_F_REQUIRED_PURCHASE_ORDER	[DATE],
	-- ============================
	@PP_ISSUED_BY_PURCHASE_ORDER	[VARCHAR] (150),
	@PP_REQUIRED_PURCHASE_ORDER		[VARCHAR] (150),
	@PP_K_PLACED_BY					[INT],
	@PP_K_APPROVED_BY				[INT],
	-- ============================
	@PP_K_DELIVERY_TO				[INT],
	@PP_CONFIRMING_ORDER_WITH		[VARCHAR] (150),
	@PP_K_VENDOR					[INT],
	-- ============================
	@PP_K_TERMS						[INT],
	@PP_K_CURRENCY					[INT],
	@PP_TAX_RATE					[DECIMAL] (10,4),
	-- ============================
	@PP_SUBTOTAL_PURCHASE_ORDER		[DECIMAL] (10,4),
	@PP_IVA_PURCHASE_ORDER			[DECIMAL] (10,4),
	@PP_TOTAL_PURCHASE_ORDER		[DECIMAL] (10,4),
	-----=====================================================
	@PP_ITEM_ARRAY					NVARCHAR(MAX),
	@PP_QUANTITY_ARRAY				NVARCHAR(MAX),
	@PP_PRICE_ARRAY					NVARCHAR(MAX),
	@PP_TOTAL_ARRAY					NVARCHAR(MAX),
	-----=====================================================
	@PP_TOTAL_ITEMS					[INT]
AS			
DECLARE @VP_MENSAJE				VARCHAR(300) = ''
BEGIN TRANSACTION 
BEGIN TRY
	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
	BEGIN
		EXECUTE [dbo].[PG_RN_PURCHASE_ORDER_UPDATE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_HEADER_PURCHASE_ORDER, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	END
	-- /////////////////////////////////////////////////////////////////////
--	IF @VP_MENSAJE=''
--		EXECUTE [dbo].[PG_RN_HEADER_PURCHASE_ORDER_UNIQUE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
--																@PP_K_HEADER_PURCHASE_ORDER,@PP_D_HEADER_PURCHASE_ORDER, 
--																@PP_RFC_HEADER_PURCHASE_ORDER,
--																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE=''
	BEGIN
		UPDATE	HEADER_PURCHASE_ORDER
		SET		
				[K_HEADER_PURCHASE_ORDER]		= @PP_K_HEADER_PURCHASE_ORDER,				
				[C_PURCHASE_ORDER]				= @PP_C_PURCHASE_ORDER,					
				-- ============================	= -- ============================
				[F_DATE_PURCHASE_ORDER]			= @PP_F_DATE_PURCHASE_ORDER,				
				[F_REQUIRED_PURCHASE_ORDER]		= @PP_F_REQUIRED_PURCHASE_ORDER,		
				-- ============================	= -- ============================		
				[ISSUED_BY_PURCHASE_ORDER]		= @PP_ISSUED_BY_PURCHASE_ORDER,			
				[REQUIRED_PURCHASE_ORDER]		= @PP_REQUIRED_PURCHASE_ORDER,				
				[K_PLACED_BY]					= @PP_K_PLACED_BY,
				[K_APPROVED_BY]					= @PP_K_APPROVED_BY,
				-- ============================	= -- ============================		
				[K_DELIVERY_TO]					= @PP_K_DELIVERY_TO,						
				[CONFIRMING_ORDER_WITH]			= @PP_CONFIRMING_ORDER_WITH,				
				[K_VENDOR]						= @PP_K_VENDOR,							
				-- ============================	= -- ============================		
				[K_TERMS]						= @PP_K_TERMS,								
				[K_CURRENCY]					= @PP_K_CURRENCY,							
				[TAX_RATE]						= (@PP_TAX_RATE/100),							
				-- ============================	= -- ============================		
				[TOTAL_ITEMS]					= @PP_TOTAL_ITEMS,							
				[SUBTOTAL_PURCHASE_ORDER]		= @PP_SUBTOTAL_PURCHASE_ORDER,				
				[IVA_PURCHASE_ORDER]			= @PP_IVA_PURCHASE_ORDER,					
				[TOTAL_PURCHASE_ORDER]			= @PP_TOTAL_PURCHASE_ORDER,				
				-- ============================	= -- ============================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION
		WHERE	[K_HEADER_PURCHASE_ORDER]=@PP_K_HEADER_PURCHASE_ORDER
		IF @@ROWCOUNT = 0
			BEGIN
				SET @VP_MENSAJE='The HEADER_PURCHASE_ORDER was not updated. [HEADER_PURCHASE_ORDER#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
				RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
			END
	END
		
	IF @VP_MENSAJE=''
	BEGIN
		DELETE 
		FROM	DETAILS_PURCHASE_ORDER
		WHERE	[K_HEADER_PURCHASE_ORDER]=@PP_K_HEADER_PURCHASE_ORDER
	END

	IF @VP_MENSAJE=''
	BEGIN
		EXECUTE		[dbo].[PG_IN_DETAILS_PURCHASE_ORDER]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															-----=====================================================
															@PP_K_HEADER_PURCHASE_ORDER,
															@PP_ITEM_ARRAY,		@PP_QUANTITY_ARRAY,
															@PP_PRICE_ARRAY,	@PP_TOTAL_ARRAY
	END
-- /////////////////////////////////////////////////////////////////////
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH	
	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		SET		@VP_MENSAJE = 'Not is possible [Update] at [HEADER_PURCHASE_ORDER]: ' + @VP_MENSAJE 
	END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_HEADER_PURCHASE_ORDER AS CLAVE
	-- //////////////////////////////////////////////////////////////	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////
--	EXECUTE [dbo].[PG_DL_HEADER_PURCHASE_ORDER] 0,139,380,2,2
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_HEADER_PURCHASE_ORDER]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_HEADER_PURCHASE_ORDER]
GO
CREATE PROCEDURE [dbo].[PG_DL_HEADER_PURCHASE_ORDER]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		INT
AS
DECLARE @VP_MENSAJE				VARCHAR(300) = ''
BEGIN TRANSACTION 
BEGIN TRY
--/////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
	BEGIN
		EXECUTE [dbo].[PG_RN_PURCHASE_ORDER_DELETE]		@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_HEADER_PURCHASE_ORDER, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	END
	--////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
	BEGIN		
		UPDATE	HEADER_PURCHASE_ORDER
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
		IF @@ROWCOUNT = 0
			BEGIN
				SET @VP_MENSAJE='The HEADER_PURCHASE_ORDER was not updated. [HEADER_PURCHASE_ORDER#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
			END
	END
-- /////////////////////////////////////////////////////////////////////
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH	

	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		SET		@VP_MENSAJE = 'Not is possible [Update] at [HEADER_PURCHASE_ORDER]: ' + @VP_MENSAJE 
	END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_HEADER_PURCHASE_ORDER AS CLAVE
	-- //////////////////////////////////////////////////////////////
	
	-- //////////////////////////////////////////////////////////////	
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////

-- // A PARTIR DE AQUÍ VAN LOS SP PARA LA REVISIÓN DE STATUS DE LAS PO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////

-- //////////////////////////////////////////////////////////////
-- //	STORED PROCEDURE ---> REVIEW_ESTATUS		
-- //	CONSULTA LOS PERMISOS PARA SABER SI PUEDE ABRIR O 
-- //	EJECUTAR CIERTA ACCIÓN EN LA FORMA
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_PERMISOS_PO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_PERMISOS_PO]
GO
--		 EXECUTE [dbo].[PG_SK_PERMISOS_PO] 0,145,6002
CREATE PROCEDURE [dbo].[PG_SK_PERMISOS_PO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_GRUPO_APROBADOR			INT
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''	
	-- ///////////////////////////////////////////		
	SELECT		TOP (1)
				COUNT(K_USUARIO)	AS MENSAJE
				-- =============================	
	FROM		BD_GENERAL.DBO.GRUPO_APROBADOR
				-- =============================
	WHERE		K_USUARIO=@PP_K_USUARIO_ACCION
	AND			K_TIPO_GRUPO_APROBADOR=@PP_K_GRUPO_APROBADOR
	AND			K_ESTATUS_GRUPO_APROBADOR=1
	-- ////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- //	STORED PROCEDURE ---> VERIFICAR ESTATUS A REVISAR
-- //	CONSULTA EN BASE AL USUARIO A QUE PO PODRÁ CAMBIAR EL ESTATUS
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_VERIFICAR_ESTATUS_PO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_VERIFICAR_ESTATUS_PO]
GO
--		 EXECUTE [dbo].[PG_SK_VERIFICAR_ESTATUS_PO] 0,62
--		 EXECUTE [dbo].[PG_SK_VERIFICAR_ESTATUS_PO] 0,139
--		 EXECUTE [dbo].[PG_SK_VERIFICAR_ESTATUS_PO] 0,145
CREATE PROCEDURE [dbo].[PG_SK_VERIFICAR_ESTATUS_PO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_PO_FINANCES				INT
	-- ===========================
--	@OU_K_ESTATUS					INT		OUTPUT
AS
	DECLARE @VP_K_ESTATUS_A_REVISAR			INT=0
	DECLARE @VP_SP_EJECUTAR					VARCHAR(150)=''
	-- ///////////////////////////////////////////		
	--	(	CASE
	--														EMPLEADO			USUARIO
	--			WHEN	EN_NUM_DEPT IN (1)			THEN	(7945)			--	62		RH					
	--			WHEN	EN_NUM_DEPT IN (2,5,6,11)	THEN	(22)			--	44		PRODUCCION
	--			WHEN	EN_NUM_DEPT IN (3)			THEN	(4475)			--	56		MATERIALES
	--			WHEN	EN_NUM_DEPT IN (4)			THEN	(1299)			--	47		CALIDAD
	--			WHEN	EN_NUM_DEPT IN (7,12)		THEN	(181)			--	42		PROYECTOS / SISTEMAS
	--			WHEN	EN_NUM_DEPT IN (8)			THEN	(67)			--	60		FINANZAS
	--			WHEN	EN_NUM_DEPT IN (9)			THEN	(52)			--	43		GERENTE PLANTA
	--	END )
	IF @PP_K_USUARIO_ACCION IN (62,44,56,47,42,60,43)
		BEGIN
			--SET @VP_K_ESTATUS_A_REVISAR = 2
			--SET @VP_SP_EJECUTAR			= 'PG_LI_APPROVE_MANAGER'

			EXECUTE	[dbo].[PG_LI_APPROVE_MANAGER]	@PP_K_SISTEMA_EXE,	@PP_K_USUARIO_ACCION, @PP_L_PO_FINANCES
		END
														--	EMPLEADO	USUARIO		NOMBRE
	ELSE IF @PP_K_USUARIO_ACCION IN (57,139)			--	7658		57			FABIOLA
		BEGIN
			--SET @VP_K_ESTATUS_A_REVISAR = 4
			--SET @VP_SP_EJECUTAR			= 'PG_LI_APPROVE_FINANCES'
			
			EXECUTE	[dbo].[PG_LI_APPROVE_FINANCES]	@PP_K_SISTEMA_EXE,	@PP_K_USUARIO_ACCION
		END
	--ELSE
	--	BEGIN
	--			SET @VP_K_ESTATUS_A_REVISAR = 0
	--	END

	--SET @OU_K_ESTATUS=@VP_K_ESTATUS_A_REVISAR
	--SELECT	@VP_SP_EJECUTAR, @VP_K_ESTATUS_A_REVISAR
	-- ////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> REVIEW_ESTATUS
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_COMENTARIOS_LOG_PO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_COMENTARIOS_LOG_PO]
GO
-- EXECUTE [dbo].[PG_SK_COMENTARIOS_LOG_PO] 0,139,3
-- EXECUTE [dbo].[PG_SK_COMENTARIOS_LOG_PO] 0,139,5
CREATE PROCEDURE [dbo].[PG_SK_COMENTARIOS_LOG_PO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		INT
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''	
	-- ///////////////////////////////////////////			
	SELECT		TOP (1)
				isnull(PO_COMENTARIO_LOG.K_HEADER_PURCHASE_ORDER,'') AS K_HEADER_PURCHASE_ORDER,
				isnull(C_PO_COMENTARIO_LOG,'') AS COMENTARIO
				-- =============================	
	FROM		HEADER_PURCHASE_ORDER,
				PO_COMENTARIO_LOG
				-- =============================
	WHERE		PO_COMENTARIO_LOG.K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
	AND			PO_COMENTARIO_LOG.K_USUARIO=@PP_K_USUARIO_ACCION
	AND			HEADER_PURCHASE_ORDER.L_BORRADO<>1		
	-- ////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // PARA INSERTAR LOS COMENTARIOS EN EL LOG DE COMENTARIOS DE LA PO
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_COMENTARIOS_LOG_PO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_COMENTARIOS_LOG_PO]
GO
CREATE PROCEDURE [dbo].[PG_IN_COMENTARIOS_LOG_PO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		[INT],
	@PP_C_PO_COMENTARIO_LOG			[VARCHAR](255)
AS			
DECLARE @VP_MENSAJE				VARCHAR(500) = ''
DECLARE @VP_K_HEADER_PURCHASE_ORDER			INT = 0;		
DECLARE @VP_K_PO			INT = 0;		
BEGIN TRANSACTION 
BEGIN TRY
-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
	BEGIN		
		INSERT	INTO PO_COMENTARIO_LOG 
		(	[K_HEADER_PURCHASE_ORDER]
			,[C_PO_COMENTARIO_LOG]
			,[K_USUARIO]
			,[F_COMENTARIO]				)
		VALUES	
		(	@PP_K_HEADER_PURCHASE_ORDER,
			@PP_C_PO_COMENTARIO_LOG,
			@PP_K_USUARIO_ACCION,
			GETDATE()					)

			IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='The COMMENT was not inserted. [HEADER_PURCHASE_ORDER#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END				
	END
-- /////////////////////////////////////////////////////////////////////
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	/* Ocurrió un error, deshacemos los cambios*/ 
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH	
	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		SET		@VP_MENSAJE = 'Not is possible [Insert] at [COMMENT_HEADER_PURCHASE_ORDER]: ' + @VP_MENSAJE 
	END
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_HEADER_PURCHASE_ORDER AS CLAVE
	-- //////////////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / PO
-- // PARA ACTUALIZAR EL ESTATUS DE LA PO DESDE LA PANTALLA DE USUARIO QUE LA GENERA
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ESTATUS_PO_SEND_REVIEW]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_ESTATUS_PO_SEND_REVIEW]
GO
--		 EXECUTE [dbo].[PG_UP_ESTATUS_PO_SEND_REVIEW]	0,129,  6
CREATE PROCEDURE [dbo].[PG_UP_ESTATUS_PO_SEND_REVIEW]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		[INT]
AS
DECLARE @VP_MENSAJE			VARCHAR(500)=''
DECLARE @VP_ESTATUS_PO		INT
-- /////////////////////////////////////////////////////////////////////
BEGIN TRANSACTION 
BEGIN TRY
	IF @VP_MENSAJE=''
	BEGIN
		SELECT	@VP_ESTATUS_PO=K_STATUS_PURCHASE_ORDER
		FROM	HEADER_PURCHASE_ORDER
		WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
		AND		L_BORRADO<>1

		IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='[PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+'] NOT FOUND'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END			
	END

	IF @VP_MENSAJE=''
	BEGIN
		IF	@VP_ESTATUS_PO NOT IN (1,3,5,8)
		BEGIN
			SET @VP_MENSAJE='[PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+'] IN REVIEW'
		END
		ELSE IF @VP_ESTATUS_PO IN (1,3,5,8)
		BEGIN
			SET	@VP_ESTATUS_PO = 2
			GOTO UPDATE_PO
		END
	END

	IF @VP_MENSAJE=''
	BEGIN
UPDATE_PO:
		UPDATE HEADER_PURCHASE_ORDER
		SET
				K_STATUS_PURCHASE_ORDER=@VP_ESTATUS_PO
		WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER

		IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='[PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+'] Not UPDATE'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END		
	END
-- /////////////////////////////////////////////////////////////////////
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	/* Ocurrió un error, deshacemos los cambios*/ 
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH
-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		SET		@VP_MENSAJE = 'Not is possible [UPDATE] at [STATUS_PO]: ' + @VP_MENSAJE 
	END
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_HEADER_PURCHASE_ORDER AS CLAVE
	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / PO
-- // PARA ACTUALIZAR EL ESTATUS DE LA PO POR PARTE DE GERENCIA Y FINANZAS(ESTO ANTES DE QUE SE ENVÍE A IMPRIMIR)
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ESTATUS_PO_MANAGER_DPTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_ESTATUS_PO_MANAGER_DPTO]
GO
--		 EXECUTE [dbo].[PG_UP_ESTATUS_PO_MANAGER_DPTO]	0,129,  4,1
CREATE PROCEDURE [dbo].[PG_UP_ESTATUS_PO_MANAGER_DPTO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_PO_ARRAY					[NVARCHAR](MAX),
	@PP_K_PO_APROBADA				[INT]
AS
DECLARE @VP_MENSAJE			VARCHAR(500)=''

DECLARE @VP_POSICION_PO		INT
DECLARE @VP_VALOR_PO		VARCHAR(500)

DECLARE @VP_ESTATUS_PO		INT
-- /////////////////////////////////////////////////////////////////////
BEGIN TRANSACTION 
BEGIN TRY
	IF @VP_MENSAJE=''
	--Colocamos un separador al final de los parametros para que funcione bien nuestro codigo
	SET	@PP_PO_ARRAY		= @PP_PO_ARRAY		+ '/'

		--Hacemos un bucle que se repite mientras haya separadores, patindex busca un patron en una cadena y nos devuelve su posicion
	WHILE patindex('%/%' , @PP_PO_ARRAY) <> 0
		BEGIN
			SELECT @VP_POSICION_PO	=	patindex('%/%' , @PP_PO_ARRAY		)

			--Buscamos la posicion de la primera y obtenemos los caracteres hasta esa posicion
			SELECT @VP_VALOR_PO		= LEFT(@PP_PO_ARRAY		, @VP_POSICION_PO		- 1)
			
			-- PRIMERO SE VERIFICA QUE TENGA VALOR LA PO. Y QUE SE ENCUENTRE ACTIVA EN LAS PO
			IF @VP_VALOR_PO<>''
			BEGIN
				SELECT	@VP_ESTATUS_PO=K_STATUS_PURCHASE_ORDER
				FROM	HEADER_PURCHASE_ORDER
				WHERE	K_HEADER_PURCHASE_ORDER=@VP_VALOR_PO
				AND		K_STATUS_PURCHASE_ORDER IN (2,4,7)
				AND		L_BORRADO<>1

				IF @@ROWCOUNT = 0
						BEGIN
							--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
							SET @VP_MENSAJE='[PO#'+CONVERT(VARCHAR(10),@VP_VALOR_PO)+'] CANNOT UPDATE'
							RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
						END			
			END

			--SE IDENTIFICA EL ESTATUS EN EL QUE SE ENCUENTRA Y SE PROCEDE A ACTUALIZAR.
			IF @VP_MENSAJE=''
			BEGIN
				IF @VP_ESTATUS_PO IN (2,4,7)
				BEGIN
					DECLARE @VP_SIGUIENTE_STATUS INT=1
					SET @VP_SIGUIENTE_STATUS += @VP_ESTATUS_PO + @PP_K_PO_APROBADA
			
					UPDATE HEADER_PURCHASE_ORDER
					SET
							K_STATUS_PURCHASE_ORDER=@VP_SIGUIENTE_STATUS
					WHERE	K_HEADER_PURCHASE_ORDER=@VP_VALOR_PO
					AND		L_BORRADO<>1

						IF @@ROWCOUNT = 0
						BEGIN
							--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
							SET @VP_MENSAJE='[PO#'+CONVERT(VARCHAR(10),@VP_VALOR_PO)+'] Not UPDATE'
							RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
						END													
				END
			END
			--Reemplazamos lo procesado con nada con la funcion stuff
			SELECT @PP_PO_ARRAY		= STUFF(@PP_PO_ARRAY		, 1, @VP_POSICION_PO , '')
		END
	-- ////////////////////////////////////////////////////////////////
	-- ///////////////////////////////////////////////////////////////
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	/* Ocurrió un error, deshacemos los cambios*/ 
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH
-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		SET		@VP_MENSAJE = 'Not is possible [UPDATE] at [STATUS_PO]: ' + @VP_MENSAJE 
	END
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_VALOR_PO AS CLAVE
	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / PO
-- // PARA ACTUALIZAR EL ESTATUS DE LA PO DESDE LA PANTALL DE USUARIO QUE LA GENERA
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ESTATUS_PO_SEND_PRINT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_ESTATUS_PO_SEND_PRINT]
GO
--		 EXECUTE [dbo].[PG_UP_ESTATUS_PO_SEND_PRINT]	0,129,  6
CREATE PROCEDURE [dbo].[PG_UP_ESTATUS_PO_SEND_PRINT]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		[INT]
AS
DECLARE @VP_MENSAJE			VARCHAR(500)=''
DECLARE @VP_ESTATUS_PO		INT
-- /////////////////////////////////////////////////////////////////////
BEGIN TRANSACTION 
BEGIN TRY
	IF @VP_MENSAJE=''
	BEGIN
		SELECT	@VP_ESTATUS_PO=K_STATUS_PURCHASE_ORDER
		FROM	HEADER_PURCHASE_ORDER
		WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
--		AND		K_STATUS_PURCHASE_ORDER IN (6,7)
		AND		L_BORRADO<>1

		IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='[PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+'] NOT AVAILABLE'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END			
	END

	IF @VP_MENSAJE=''
	BEGIN
		IF	@VP_ESTATUS_PO NOT IN (6,7)
		BEGIN
			SET @VP_MENSAJE='[PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+'] NOT AVAILABLE FOR PRINT'
		END
		ELSE
		BEGIN
			IF @VP_ESTATUS_PO=6
			BEGIN
				SET	@VP_ESTATUS_PO += 1
			END
			GOTO UPDATE_PO
		END
	END

	IF @VP_MENSAJE=''
	BEGIN
UPDATE_PO:
		UPDATE HEADER_PURCHASE_ORDER
		SET
				K_STATUS_PURCHASE_ORDER=@VP_ESTATUS_PO
		WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER

		IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='[PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+'] Not UPDATE'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END		
	END
-- /////////////////////////////////////////////////////////////////////
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	/* Ocurrió un error, deshacemos los cambios*/ 
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH
-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		SET		@VP_MENSAJE = 'Not is possible [UPDATE] at [STATUS_PO]: ' + @VP_MENSAJE 
	END
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_HEADER_PURCHASE_ORDER AS CLAVE
	-- //////////////////////////////////////////////////////////////
GO

---- //////////////////////////////////////////////////////////////
---- // STORED PROCEDURE ---> UPDATE / PO
---- // PARA ACTUALIZAR EL ESTATUS DE LA PO CUANDO EL GERENTE DE PLANTA HA CONFIRMADO EL ESTATUS
---- //////////////////////////////////////////////////////////////
--IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ESTATUS_PO_MANAGER_GRAL]') AND type in (N'P', N'PC'))
--	DROP PROCEDURE [dbo].[PG_UP_ESTATUS_PO_MANAGER_GRAL]
--GO
----		 EXECUTE [dbo].[PG_UP_ESTATUS_PO_MANAGER_GRAL]	0,129,  4,1
--CREATE PROCEDURE [dbo].[PG_UP_ESTATUS_PO_MANAGER_GRAL]
--	@PP_K_SISTEMA_EXE				INT,
--	@PP_K_USUARIO_ACCION			INT,
--	-- ===========================
--	@PP_PO_ARRAY					[NVARCHAR](MAX),
--	@PP_K_PO_APROBADA				[INT]
--AS
--DECLARE @VP_MENSAJE			VARCHAR(500)=''

--DECLARE @VP_POSICION_PO		INT
--DECLARE @VP_VALOR_PO		VARCHAR(500)

--DECLARE @VP_ESTATUS_PO		INT
---- /////////////////////////////////////////////////////////////////////
--BEGIN TRANSACTION 
--BEGIN TRY
--	IF @VP_MENSAJE=''
--	--Colocamos un separador al final de los parametros para que funcione bien nuestro codigo
--	SET	@PP_PO_ARRAY		= @PP_PO_ARRAY		+ '/'

--		--Hacemos un bucle que se repite mientras haya separadores, patindex busca un patron en una cadena y nos devuelve su posicion
--	WHILE patindex('%/%' , @PP_PO_ARRAY) <> 0
--		BEGIN
--			SELECT @VP_POSICION_PO	=	patindex('%/%' , @PP_PO_ARRAY		)

--			--Buscamos la posicion de la primera y obtenemos los caracteres hasta esa posicion
--			SELECT @VP_VALOR_PO		= LEFT(@PP_PO_ARRAY		, @VP_POSICION_PO		- 1)
			
--			-- PRIMERO SE VERIFICA QUE TENGA VALOR LA PO. Y QUE SE ENCUENTRE ACTIVA EN LAS PO
--			IF @VP_VALOR_PO<>''
--			BEGIN
--				SELECT	@VP_ESTATUS_PO=K_STATUS_PURCHASE_ORDER
--				FROM	HEADER_PURCHASE_ORDER
--				WHERE	K_HEADER_PURCHASE_ORDER=@VP_VALOR_PO
--				AND		K_STATUS_PURCHASE_ORDER IN (7)
--				AND		L_BORRADO<>1

--				IF @@ROWCOUNT = 0
--						BEGIN
--							--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
--							SET @VP_MENSAJE='[PO#'+CONVERT(VARCHAR(10),@VP_VALOR_PO)+'] CANNOT UPDATE'
--							RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
--						END			
--			END

--			--SE IDENTIFICA EL ESTATUS EN EL QUE SE ENCUENTRA Y SE PROCEDE A ACTUALIZAR.
--			IF @VP_MENSAJE=''
--			BEGIN
--				IF @VP_ESTATUS_PO IN (7)
--				BEGIN
--					DECLARE @VP_SIGUIENTE_STATUS INT=1
--					SET @VP_SIGUIENTE_STATUS += @VP_ESTATUS_PO + @PP_K_PO_APROBADA
			
--					UPDATE HEADER_PURCHASE_ORDER
--					SET
--							K_STATUS_PURCHASE_ORDER=@VP_SIGUIENTE_STATUS
--					WHERE	K_HEADER_PURCHASE_ORDER=@VP_VALOR_PO
--					AND		L_BORRADO<>1

--						IF @@ROWCOUNT = 0
--						BEGIN
--							--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
--							SET @VP_MENSAJE='[PO#'+CONVERT(VARCHAR(10),@VP_VALOR_PO)+'] Not UPDATE'
--							RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
--						END													
--				END
--			END
--			--Reemplazamos lo procesado con nada con la funcion stuff
--			SELECT @PP_PO_ARRAY		= STUFF(@PP_PO_ARRAY		, 1, @VP_POSICION_PO , '')
--		END
--	-- ////////////////////////////////////////////////////////////////
--	-- ///////////////////////////////////////////////////////////////
--COMMIT TRANSACTION 
--END TRY

--BEGIN CATCH
--	/* Ocurrió un error, deshacemos los cambios*/ 
--	ROLLBACK TRANSACTION
--	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
--	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
--	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
--END CATCH
---- /////////////////////////////////////////////////////////////////////	
--	IF @VP_MENSAJE<>''
--	BEGIN
--		SET		@VP_MENSAJE = 'Not is possible [UPDATE] at [STATUS_PO]: ' + @VP_MENSAJE 
--	END
--	SELECT	@VP_MENSAJE AS MENSAJE, @VP_VALOR_PO AS CLAVE
--	-- //////////////////////////////////////////////////////////////
--GO
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////



--	dianan		Facturas1
--	adrianai	12345
--	dulcec		Password1
--	irise		12345
--	marios		12345

--	omard		12340
--	miguelc		Dalica9905

--	SELECT K_USUARIO_PEARL, D_USUARIO_PEARL, PASSWORD_USUARIO_PEARL,K_USUARIO_DEPARTAMENTO,K_EMPLEADO_PEARL FROM BD_GENERAL.DBO.USUARIO_PEARL

--	select * from STATUS_PURCHASE_ORDER