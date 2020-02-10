-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PROVEEDOR / CXP
-- // OPERACION:		LIBERACION / CARGA_INICIAL
-- //////////////////////////////////////////////////////////////
-- // Autor:			Alex de la Rosa
-- // Fecha creación:	24/SEP/2018
-- //////////////////////////////////////////////////////////////  

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////





-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROVEEDOR]') AND type in (N'U'))
	DELETE	FROM [dbo].[PROVEEDOR]
GO



-- //////////////////////////////////////////////////////////////
-- //				CI - PROVEEDOR
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PROVEEDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PROVEEDOR]
GO


CREATE PROCEDURE [dbo].[PG_CI_PROVEEDOR]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_PROVEEDOR						INT,
	@PP_D_PROVEEDOR						VARCHAR(100),
	@PP_C_PROVEEDOR						VARCHAR(255),
	@PP_S_PROVEEDOR						VARCHAR(10),
	@PP_O_PROVEEDOR						INT,
	-- ============================
	@PP_RAZON_SOCIAL					VARCHAR(100),
	@PP_RFC_PROVEEDOR					VARCHAR(13),
	@PP_CURP							VARCHAR(100),
	@PP_CORREO							VARCHAR(100),
	@PP_TELEFONO						VARCHAR(100),
	-- ============================
	@PP_FISCAL_CALLE					VARCHAR(100),
	@PP_FISCAL_NUMERO_EXTERIOR			VARCHAR(100),
	@PP_FISCAL_NUMERO_INTERIOR			VARCHAR(100),
	@PP_FISCAL_COLONIA					VARCHAR(100),
	@PP_FISCAL_POBLACION				VARCHAR(100),
	@PP_FISCAL_CP						VARCHAR(100),
	@PP_FISCAL_MUNICIPIO				VARCHAR(100),
	@PP_FISCAL_K_ESTADO					INT,
	-- ===========================
	@PP_OFICINA_CALLE					VARCHAR(100),
	@PP_OFICINA_NUMERO_EXTERIOR			VARCHAR(100),
	@PP_OFICINA_NUMERO_INTERIOR			VARCHAR(100),
	@PP_OFICINA_COLONIA					VARCHAR(100),
	@PP_OFICINA_POBLACION				VARCHAR(100),
	@PP_OFICINA_CP						VARCHAR(100),
	@PP_OFICINA_MUNICIPIO				VARCHAR(100),
	@PP_OFICINA_K_ESTADO				INT,
	-- ===========================
	@PP_K_ESTATUS_PROVEEDOR				INT,
	@PP_K_CATEGORIA_PROVEEDOR			INT,
	-- ============================
	@PP_CONTACTO_VENTA					VARCHAR(100),
	@PP_CONTACTO_VENTA_TELEFONO			VARCHAR(100),
	@PP_CONTACTO_VENTA_CORREO			VARCHAR(100),
	-- ============================
	@PP_CONTACTO_PAGO					VARCHAR(100),
	@PP_CONTACTO_PAGO_TELEFONO			VARCHAR(100),
	@PP_CONTACTO_PAGO_CORREO			VARCHAR(100)
AS				
	-- ===========================

	INSERT INTO PROVEEDOR
			(	[K_PROVEEDOR], [D_PROVEEDOR], 
				[C_PROVEEDOR], [S_PROVEEDOR], 
				[O_PROVEEDOR],
				-- ===========================
				[RAZON_SOCIAL],	[RFC_PROVEEDOR], 
				[CURP],	[CORREO], [TELEFONO], 
				[N_DIAS_CREDITO],
				-- ===========================
				[FISCAL_CALLE], [FISCAL_NUMERO_EXTERIOR], [FISCAL_NUMERO_INTERIOR], 
				[FISCAL_COLONIA], [FISCAL_POBLACION],
				[FISCAL_CP],[FISCAL_MUNICIPIO], [FISCAL_K_ESTADO],
				-- ===========================
				[OFICINA_CALLE], [OFICINA_NUMERO_EXTERIOR], [OFICINA_NUMERO_INTERIOR], 
				[OFICINA_COLONIA], [OFICINA_POBLACION],
				[OFICINA_CP],[OFICINA_MUNICIPIO], [OFICINA_K_ESTADO],
				-- ===========================
				[K_ESTATUS_PROVEEDOR],[K_CATEGORIA_PROVEEDOR],
				-- ===========================
				[CONTACTO_VENTA],[CONTACTO_VENTA_TELEFONO],[CONTACTO_VENTA_CORREO],
				-- ===========================
				[CONTACTO_PAGO],[CONTACTO_PAGO_TELEFONO],[CONTACTO_PAGO_CORREO],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@PP_K_PROVEEDOR, @PP_D_PROVEEDOR, 
				@PP_C_PROVEEDOR, @PP_S_PROVEEDOR,
				@PP_O_PROVEEDOR,
				-- ===========================
				@PP_RAZON_SOCIAL, @PP_RFC_PROVEEDOR, 
				@PP_CURP, @PP_CORREO, @PP_TELEFONO,
				30,
				-- ===========================
				@PP_FISCAL_CALLE, @PP_FISCAL_NUMERO_EXTERIOR, @PP_FISCAL_NUMERO_INTERIOR,
				@PP_FISCAL_COLONIA, @PP_FISCAL_POBLACION,
				@PP_FISCAL_CP, @PP_FISCAL_MUNICIPIO, @PP_FISCAL_K_ESTADO, 
				-- ===========================
				@PP_OFICINA_CALLE, @PP_OFICINA_NUMERO_EXTERIOR, @PP_OFICINA_NUMERO_INTERIOR,
				@PP_OFICINA_COLONIA, @PP_OFICINA_POBLACION,
				@PP_OFICINA_CP, @PP_OFICINA_MUNICIPIO, @PP_OFICINA_K_ESTADO, 
				-- ===========================
				@PP_K_ESTATUS_PROVEEDOR, @PP_K_CATEGORIA_PROVEEDOR,
				-- ============================
				@PP_CONTACTO_VENTA, @PP_CONTACTO_VENTA_TELEFONO,
				@PP_CONTACTO_VENTA_CORREO,
				-- ============================
				@PP_CONTACTO_PAGO, @PP_CONTACTO_PAGO_TELEFONO,
				@PP_CONTACTO_PAGO_CORREO,		
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )
GO


-- ==========================================================

-- ==========================================================

-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_PROVEEDOR] 0, 0, 0, 0, '( SIN PROVEEDOR )' , 'N/A' , '' , 10001 , '( SIN PROVEEDOR )' , '' , '' , 'uberfacturas@digitalsolutions.mx' , '' , 'INSURGENTES SUR' , '1898' , '12' , 'FLORIDA' , 'ALVARO OBREGON' , '01020' , 'CIUDAD DE MEXICO' , 105 , 'INSURGENTES SUR' , '1898' , '12' , 'FLORIDA' , 'ALVARO OBREGON' , '01020' , 'CIUDAD DE MEXICO' , 105 , '2' , '11', '' , '' , '' , '' , '' , ''

EXECUTE [dbo].[PG_CI_PROVEEDOR] 0, 0, 0, 1, 'DIGITAL SOLUTIONS AMERICAS S DE RL DE CV' , 'UBER' , '' , 10001 , 'DIGITAL SOLUTIONS AMERICAS S DE RL DE CV' , 'DSA130408AM2' , '' , 'uberfacturas@digitalsolutions.mx' , '' , 'INSURGENTES SUR' , '1898' , '12' , 'FLORIDA' , 'ALVARO OBREGON' , '01020' , 'CIUDAD DE MEXICO' , 105 , 'INSURGENTES SUR' , '1898' , '12' , 'FLORIDA' , 'ALVARO OBREGON' , '01020' , 'CIUDAD DE MEXICO' , 105 , '2' , '11', '' , '' , '' , '' , '' , ''
EXECUTE [dbo].[PG_CI_PROVEEDOR] 0, 0, 0, 2, 'IMPULSORA PLAZA CELAYA SA DE CV' , 'CITYEXPREES PLUS' , '' , 10002 , 'IMPULSORA PLAZA CELAYA SA DE CV' , 'IPC060309D42' , '' , '' , '' , 'SAN LUCAS TEPETLACALCO' , 'S/N' , '' , 'SAN LUCAS TEPETLACALCO' , 'ESTADO DE MEXICO' , '54055' , 'ESTADO DE MEXICO' , 106 , 'JUAN SALVADOR AGRAZ' , '69' , '12' , 'SANTA FE CUAJIMALPA' , 'CUAJIMALPA DE MORELOS' , '05348' , 'CUAJIMALPA DE MORELOS' , 106 , '2' , '8', '' , '' , '' , '' , '' , ''
EXECUTE [dbo].[PG_CI_PROVEEDOR] 0, 0, 0, 3, 'AEROVIAS DE MEXICO SA DE CV' , 'AEROMEXICO' , '' , 10003 , 'AEROVIAS DE MEXICO SA DE CV' , 'AME880912I89' , '' , '' , '' , 'PASEO DE LA REFORMA' , '445' , 'A Y B' , 'CUAUHTEMOC' , 'CUAHUTEMOC' , '06500' , 'CUAHUTEMOC' , 105 , 'PASEO DE LA REFORMA' , '445' , 'A Y B' , 'CUAUHTEMOC' , 'CUAHUTEMOC' , '06500' , 'CUAHUTEMOC' , 105 , '2' , '7', '' , '' , '' , '' , '' , ''
EXECUTE [dbo].[PG_CI_PROVEEDOR] 0, 0, 0, 4, 'CADENA COMERCIAL OXXO, S.A. DE C.V.' , 'OXXO' , '' , 10004 , 'CADENA COMERCIAL OXXO, S.A. DE C.V.' , 'CCO8605231N4' , '' , '' , '' , 'EDISON' , '1235' , '' , 'TALLERES' , 'MONTERREY' , '64480' , 'MONTERREY' , 0 , 'OBRERO MUNDIAL' , 'S/N' , '' , 'DEL VALLE CENTRO' , 'CIUDAD DE MEXICO' , '64480' , 'CIUDAD DE MEXICO' , 0 , '2' , '9', '' , '' , '' , '' , '' , ''
EXECUTE [dbo].[PG_CI_PROVEEDOR] 0, 0, 0, 5, 'ABC AEROLÍNEAS S.A. DE C.V' , 'INTERJET' , '' , 10005 , 'ABC AEROLÍNEAS S.A. DE C.V' , 'AAE050309FM0' , '' , '' , '' , 'AV. CAPITAN CARLOS LEON' , 'S/N' , '' , 'ZONA FEDERAL AEROPUERTO INTERNACIONAL CIUDAD DE MÉXICO' , 'VENUSTIANO CARRANZA' , '15620' , 'VENUSTIANO CARRANZA' , 105 , 'AV. CAPITAN CARLOS LEON' , 'S/N' , '' , 'ZONA FEDERAL AEROPUERTO INTERNACIONAL CIUDAD DE MÉXICO' , 'VENUSTIANO CARRANZA' , '15620' , 'VENUSTIANO CARRANZA' , 105 , '2' , '7', '' , '' , '' , '' , '' , ''
EXECUTE [dbo].[PG_CI_PROVEEDOR] 0, 0, 0, 6, 'NUEVA WAL MART DE MÉXICO, S. DE R. L. DE C.V.' , 'WALMART MEXICO Y CENTROAMERICA' , '' , 10006 , 'NUEVA WAL MART DE MÉXICO, S. DE R. L. DE C.V.' , 'NWM9709244W4' , '' , '' , '' , 'NEXTENGO' , '78' , '' , 'SANTA CRUZ ACAYUCAN' , 'AZCAPOTZALCO' , '02770' , 'AZCAPOTZALCO' , 105 , 'AV. RÍO DE LOS REMEDIOS' , '5' , '' , 'EX RANCHO SANTA CRUZ PUEBLO DE SAN JUAN IXHUATEPEC' , 'TLALNEPANTLA DE BAZ' , '54180' , 'TLALNEPANTLA DE BAZ' , 105 , '2' , '11', '' , '' , '' , '' , '' , ''

EXECUTE [dbo].[PG_CI_PROVEEDOR] 0, 0, 0, 1001, 'GAS Y PETROLEO' , 'GAS Y PETROLEO' , '' , 10 , 'COMPAÑIA IMPORTADORA DE GAS Y PETROLEO DEL GOLFO SA DE CV' , 'IGP160201NK5' , '' , '' , '' , 'AV. CAPITAN CARLOS LEON' , 'S/N' , '' , 'ZONA FEDERAL AEROPUERTO INTERNACIONAL CIUDAD DE MÉXICO' , 'VENUSTIANO CARRANZA' , '15620' , 'VENUSTIANO CARRANZA' , 105 , 'AV. CAPITAN CARLOS LEON' , 'S/N' , '' , 'ZONA FEDERAL AEROPUERTO INTERNACIONAL CIUDAD DE MÉXICO' , 'VENUSTIANO CARRANZA' , '15620' , 'VENUSTIANO CARRANZA' , 105 , '2' , '1', '' , '' , '' , '' , '' , ''
EXECUTE [dbo].[PG_CI_PROVEEDOR] 0, 0, 0, 1002, 'TRANSPORTADORA TOMZA' , 'TRANSPORTADORA SILZA' , '' , 10 , 'TRANSPORTADORA SILZA, S.A. DE C.V.' , 'TSI811205GJ6' , '' , '' , '' , 'NEXTENGO' , '78' , '' , 'SANTA CRUZ ACAYUCAN' , 'AZCAPOTZALCO' , '02770' , 'AZCAPOTZALCO' , 105 , 'AV. RÍO DE LOS REMEDIOS' , '5' , '' , 'EX RANCHO SANTA CRUZ PUEBLO DE SAN JUAN IXHUATEPEC' , 'TLALNEPANTLA DE BAZ' , '54180' , 'TLALNEPANTLA DE BAZ' , 105 , '2' , '2', '' , '' , '' , '' , '' , ''



-- ===============================================
SET NOCOUNT OFF
-- ===============================================








-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////



