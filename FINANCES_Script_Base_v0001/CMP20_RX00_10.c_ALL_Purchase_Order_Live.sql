-- ///////////////////////////////////////////////////////////////////
-- //	PARA REALIZAR LA MODIFICACIÓN DE PO CON ID TEMPORAL. 
-- //	SE REALIZA:
-- //	* ELIMINAR LLAVE PRIMARIA DE [HEADER_PURCHASE_ORDER]
-- //	* AGREGA TABLA DE ID´S TEMPORALES PARA PO
-- //	* AGREGA TABLA DE PO QUE QUEDARÁ COMO LIVE


-- ///////////////////////////////////////////////////////////////////

/*
-- ///////////////////////////////////////////////////////////////////
-- //			DROP PARA LAS PRIMAREY KEYS
-- ///////////////////////////////////////////////////////////////////
ALTER TABLE [dbo].[DETAILS_PURCHASE_ORDER] 
	DROP CONSTRAINT [FK_HEADER_PURCHASE_ORDER_01]
GO

ALTER TABLE [dbo].[DETAILS_BLANKET_PURCHASE_ORDER]
	DROP CONSTRAINT [FK_HEADER_PURCHASE_ORDER_10] 
GO

ALTER TABLE [dbo].[HEADER_PURCHASE_ORDER]
	DROP CONSTRAINT [PK_HEADER_PURCHASE_ORDER]
GO

ALTER TABLE [dbo].[HEADER_PURCHASE_ORDER] 
	DROP	[FK_STATUS_PURCHASE_ORDER_01] 
GO
*/

-- ///////////////////////////////////////////////////////////////////
-- //	TABLA TEMPORAL PARA RELACIONAR LA PO CON UN ID PROVISIONAL
-- //	ESTA TABLA CONTENDRÁ EL ID QUE SERÁ EL DISPONIBLE PARA ASIGNAR
-- //					PURCHASE_ORDER_TEMP
-- ///////////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEADER_PURCHASE_ORDER_TEMP]') AND type in (N'U'))
	DROP TABLE [dbo].[HEADER_PURCHASE_ORDER_TEMP]
GO
CREATE TABLE [dbo].[HEADER_PURCHASE_ORDER_TEMP] (
	[K_HEADER_PURCHASE_ORDER_TEMP]			[INT] IDENTITY (1,1)	NOT NULL,
--	[K_PO_TEMPORAL]							[VARCHAR](50) NOT NULL,
	[K_PO_TEMPORAL]							[INT] NOT NULL,
	[L_EN_USO]								[INT] DEFAULT 0				-- SI EL REGISTRO SE ENCUENTRA EN 0 SE PODRÁ USAR.
)	ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////
-- //	PARA AGREGAR LOS ID PROVISIONALES DE LA TABLA
-- //				CI - HEADER_PURCHASE_ORDER_TEMP
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_HEADER_PURCHASE_ORDER_TEMP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_HEADER_PURCHASE_ORDER_TEMP]
GO
CREATE PROCEDURE [dbo].[PG_CI_HEADER_PURCHASE_ORDER_TEMP]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT
	-- ===========================
--	@PP_K_PO_TEMPORAL				VARCHAR (50)
AS				
	DECLARE @VP_CONTADOR INT=1
	-- ===========================
	
	WHILE @VP_CONTADOR<1001
		BEGIN

			INSERT INTO HEADER_PURCHASE_ORDER_TEMP
					(	[K_PO_TEMPORAL]		)
			VALUES	
					--(	'T'+@PP_K_PO_TEMPORAL	)
					(	@VP_CONTADOR	)
		
			SET @VP_CONTADOR=@VP_CONTADOR+1
		END
GO

	EXECUTE [dbo].[PG_CI_HEADER_PURCHASE_ORDER_TEMP] 0,139
GO


/*
PARA BUSCAR EL ID DISPONIBLE PARA ASIGNAR DE MANERA PROVISIONAL

SELECT TOP (1) K_PO_TEMPORAL
FROM	HEADER_PURCHASE_ORDER_TEMP
WHERE	L_EN_USO=0
ORDER BY [K_HEADER_PURCHASE_ORDER_TEMP]

*/


-- ///////////////////////////////////////////////////////////////////
-- //	AQUÍ SE GUARDARAN LAS PO QUE YA FUERON IMPRESAS 
-- //	Y ESTAN EN ESPERA DE FIRMA POR PARTE DE GERENCIA DE PLANTA.
-- //					PURCHASE_ORDER_LIVE
-- ///////////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEADER_PURCHASE_ORDER_LIVE]') AND type in (N'U'))
	DROP TABLE [dbo].[HEADER_PURCHASE_ORDER_LIVE]
GO

CREATE TABLE [dbo].[HEADER_PURCHASE_ORDER_LIVE] (
	[K_HEADER_PURCHASE_ORDER]				[INT] NOT NULL,			
	[C_PURCHASE_ORDER]						[VARCHAR](255) NOT NULL DEFAULT '',
	-- ============================
	[K_APPROVED_BY]							[INT] NOT NULL,
	[K_BLANKET]								[INT] NOT NULL DEFAULT 1,		-- #1 PO-REGULAR(UN SOLO EVENTO)	/	#2	PO-BLANKET(ORDEN ABIERTA)
	[K_CURRENCY]							[INT] NOT NULL,
	[K_DELIVERY_TO]							[INT] NOT NULL,
	[K_PLACED_BY]							[INT] NOT NULL,
	[K_STATUS_PURCHASE_ORDER]				[INT] NOT NULL,
	[K_TERMS]								[INT] NOT NULL,
	[K_VENDOR]								[INT] NOT NULL,	
	-- ============================
	[F_DATE_PURCHASE_ORDER]					[DATE] NOT NULL,
	[F_REQUIRED_PURCHASE_ORDER]				[DATE] NOT NULL,
	-- ============================
	[F_PROMISE_PURCHASE_ORDER]				[DATE] NULL,
	[F_RECEIVED_PURCHASE_ORDER]				[DATE] NULL,
	-- ============================
	[ISSUED_BY_PURCHASE_ORDER]				[VARCHAR] (150) NOT NULL,
	[REQUIRED_PURCHASE_ORDER]				[VARCHAR] (150) NOT NULL,
	[CONFIRMING_ORDER_WITH]					[VARCHAR] (150) NOT NULL,
	-- ============================
	[TAX_RATE]								[DECIMAL] (10,4) NOT NULL,
	-- ============================
	[TOTAL_ITEMS]							[INT] NOT NULL,
	[SUBTOTAL_PURCHASE_ORDER]				[DECIMAL] (10,4) NOT NULL,
	[IVA_PURCHASE_ORDER]					[DECIMAL] (10,4) NOT NULL,
	[TOTAL_PURCHASE_ORDER]					[DECIMAL] (10,4) NOT NULL,
	-- ============================
	[D_DELIVERY_TO]							[VARCHAR] (250) NOT NULL,
	[EXCHANGE_RATE]							[DECIMAL] (10,4) NOT NULL DEFAULT 0,
	[ADDITIONAL_TAXES_PURCHASE_ORDER]		[DECIMAL] (10,4) NOT NULL DEFAULT 0,
	[ADDITIONAL_DISCOUNTS_PURCHASE_ORDER]	[DECIMAL] (10,4) NOT NULL DEFAULT 0,
	[PREPAID_PURCHASE_ORDER]				[DECIMAL] (10,4) NOT NULL DEFAULT 0,
	[K_ACCOUNT_PURCHASE_ORDER]				[VARCHAR] (17) NOT NULL DEFAULT 0,
	-- ============================
	[L_IS_BLANKET]							[INT] NOT NULL DEFAULT 0,
	[C_INFO_QUOTATION]						[VARCHAR](500) NOT NULL DEFAULT '',
	[TERMS_HEADER]							[VARCHAR](500) NOT NULL DEFAULT ''
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[HEADER_PURCHASE_ORDER_LIVE] 
	ADD		[K_USUARIO_ALTA]			[INT] NOT NULL,
			[F_ALTA]					[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]			[INT] NOT NULL,
			[F_CAMBIO]					[DATETIME] NOT NULL,
			[L_BORRADO]					[INT] NOT NULL,
			[K_USUARIO_BAJA]			[INT] NULL,
			[F_BAJA]					[DATETIME] NULL;
GO	

-- //////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////
--	SE LLENA LA TABLA CON LA MISMA INFORMACIÓN DE LA TABLA ORIGINAL.
--	PARA MANTENER LOS DATOS QUE YA HAN SIDO GUARDADOS.
	INSERT INTO HEADER_PURCHASE_ORDER_LIVE
			(	[K_HEADER_PURCHASE_ORDER],	[C_PURCHASE_ORDER],
				-- ============================
				[K_STATUS_PURCHASE_ORDER],				
				-- ============================
				[F_DATE_PURCHASE_ORDER],	[F_REQUIRED_PURCHASE_ORDER],			
				-- ============================
				[ISSUED_BY_PURCHASE_ORDER],	[REQUIRED_PURCHASE_ORDER],				
				[K_PLACED_BY],				[K_APPROVED_BY],
				-- ============================
				[K_DELIVERY_TO],			[D_DELIVERY_TO],
				[CONFIRMING_ORDER_WITH],	[K_VENDOR],
				-- ============================
				[K_TERMS],					[K_CURRENCY],							
				[TAX_RATE],								
				-- ============================
				[TOTAL_ITEMS],
				[SUBTOTAL_PURCHASE_ORDER],	[ADDITIONAL_DISCOUNTS_PURCHASE_ORDER],
				[IVA_PURCHASE_ORDER],		[ADDITIONAL_TAXES_PURCHASE_ORDER],
				[TOTAL_PURCHASE_ORDER],				
				-- ============================
				[L_IS_BLANKET],				[C_INFO_QUOTATION],
				[TERMS_HEADER],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
	SELECT
				[K_HEADER_PURCHASE_ORDER],	[C_PURCHASE_ORDER],
				-- ============================
				[K_STATUS_PURCHASE_ORDER],				
				-- ============================
				[F_DATE_PURCHASE_ORDER],	[F_REQUIRED_PURCHASE_ORDER],			
				-- ============================
				[ISSUED_BY_PURCHASE_ORDER],	[REQUIRED_PURCHASE_ORDER],				
				[K_PLACED_BY],				[K_APPROVED_BY],
				-- ============================
				[K_DELIVERY_TO],			[D_DELIVERY_TO],
				[CONFIRMING_ORDER_WITH],	[K_VENDOR],
				-- ============================
				[K_TERMS],					[K_CURRENCY],							
				[TAX_RATE],								
				-- ============================
				[TOTAL_ITEMS],
				[SUBTOTAL_PURCHASE_ORDER],	[ADDITIONAL_DISCOUNTS_PURCHASE_ORDER],
				[IVA_PURCHASE_ORDER],		[ADDITIONAL_TAXES_PURCHASE_ORDER],
				[TOTAL_PURCHASE_ORDER],				
				-- ============================
				[L_IS_BLANKET],				[C_INFO_QUOTATION],
				[TERMS_HEADER],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]
	FROM		[HEADER_PURCHASE_ORDER]
	WHERE		[K_STATUS_PURCHASE_ORDER]>=9