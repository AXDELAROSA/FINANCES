-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			TEMP_DETAILS_PURCHASE_ORDER
-- // OPERATION:		TABLA
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200225
-- ////////////////////////////////////////////////////////////// 

USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////

-- SELECT * FROM [TEMP_DETAILS_PURCHASE_ORDER]

-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TEMP_DETAILS_PURCHASE_ORDER]') AND type in (N'U'))
	DROP TABLE [dbo].[TEMP_DETAILS_PURCHASE_ORDER]
GO

-- ////////////////////////////////////////////////////////////////
-- //					TEMP_DETAILS_PURCHASE_ORDER				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[TEMP_DETAILS_PURCHASE_ORDER] (
	[K_HEADER_PURCHASE_ORDER]				[INT] NOT NULL,
--	[K_DETAILS_PURCHASE_ORDER]				[INT] NOT NULL,					-- SE UTILIZA HASTA QUE SE INSERTAN LOS REGISTROS EN LA TABLA DE DETALLES.
	-- ============================
	[K_ITEM]								[INT] NOT NULL,
	[QUANTITY_ORDER]						[DECIMAL] (10,4) NOT NULL,
	[K_UNIT_OF_ITEM]						[INT] NOT NULL,
	[PART_NUMBER_ITEM_VENDOR]				[VARCHAR](250)	NOT NULL DEFAULT '0',
	[PART_NUMBER_ITEM_PEARL]				[VARCHAR](250)	NOT NULL DEFAULT '0',
	-- ============================
	[UNIT_PRICE]							[DECIMAL] (10,4) NOT NULL,
	[TOTAL_PRICE]							[DECIMAL] (10,4) NOT NULL,
	-- ============================
--	[QUANTITY_RECEIVED]						[DECIMAL] (10,4) NOT NULL,		-- NO SE RECIBE EN LA TEMPORAL, SE USA HASTA RECIBIR EL MATERIAL
--	[QUANTITY_REJECTED]						[DECIMAL] (10,4) NOT NULL		-- NO SE RECIBE EN LA TEMPORAL, SE USA HASTA RECIBIR EL MATERIAL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
