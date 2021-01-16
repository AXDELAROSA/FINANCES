
USE DATA_02Pruebas

 SELECT * FROM ccjobhdr_sql WHERE JOBNO IN ('21414')	

 SELECT top 10 * FROM SERIALCAM_SQL WHERE  SERIAL IN ( '21683002')

 SELECT * FROM QCLIBERA_SQL WHERE SERIAL IN ('22023007')

 SELECT	* FROM	ccjoblin_sql WHERE	LTRIM(RTRIM(jobno)) + RIGHT('000'+ LTRIM(RTRIM(ser_no)),3)  IN ('21611009')

 -- 21823007
 SELECT * FROM INVENTARIO_EMBARQUE WHERE   SERIAL_1 IN ('22023007')

 SELECT * FROM INVENTARIO_EMBARQUE WHERE PACKING_NO = 'YFR0114-1'

 SELECT	* FROM	ccjoblin_sql WHERE	LTRIM(RTRIM(jobno))  = '21758'

 SELECT * FROM [FACTURA_COBRADA]

 --SELECT	TOP 100 * FROM	ccjoblin_sql WHERE JOBNO = '06332'

 SELECT TOP 1000 * FROM IMCATFIL_SQL WHERE prod_cat IN ('wc1', 'w7s')

 --UPDATE IMCATFIL_SQL 
 --SET filler_0001 = 'FAU'
 --WHERE prod_cat IN ('FW2')

 --SELECT * FROM cccusitm_sql WHERE item_no = 'PMWARQBWLCPT3'
   
  SELECT * FROM [MODELO_SIN_HOJA_EMPAQUE]
    
  SELECT * FROM ESTATUS_INVENTARIO_EMBARQUE
  
  -- MATERIAL PENDIENTE DE INGRESO A EMBARQUES
  --SELECT * FROM INVENTARIO_EMBARQUE WHERE   SERIAL_1 IN ('21868008', '21919006')

  SELECT * FROM INVENTARIO_EMBARQUE_LOG WHERE K_ESTATUS_INVENTARIO_EMBARQUE = 2 --AND PACKING_NO <> 'WOO1222-1'
  -- 6386,6618,6620,6621,6638
 
 SELECT TOP 1000 * FROM IMCATFIL_SQL WHERE prod_cat IN ('FW2')

    select * from PF_SCHST 
	where type = 'E'
	--AND INV_NO = 554337
  --AND cdate2 = 20210105
  --AND packing_no IN ( 'WK0105-9', 'WK0106-10' )
  --and cus_part_no  LIKE '1841%'
   --and cus_part_no  = '174255A'
  --and prod_cat = 'PWU'
  AND  serial1 = 'S21823007'
   ORDER BY SERIAL1

 --CLIENTES
 SELECT * FROM arcusfil_sql where cus_no LIKE 'YAN%'
 -- user_def_fld_2 = TRACKING 
 -- user_def_fld_4 = L/C

 SELECT * FROM OEORDHDR_SQL  where ord_no = '00318898'
 
 SELECT UPPER('Carretera Mena- Cd. Industrial Xico')
	
	--UPDATE OEORDHDR_SQL
	--	SET bill_to_name =	 'Yanfeng Mexico',
	--		bill_to_addr_1 = 'PO BOX 7148',
	--		bill_to_addr_2 = '48376 Novi MI',
	--		bill_to_addr_3 = 'UNITED STATES',
	--		bill_to_country = '',

	--		ship_to_name =   'Yanfeng Mexico',
	--		ship_to_addr_1 = 'PO BOX 7148',
	--		ship_to_addr_2 = '48376 Novi MI',
	--		ship_to_addr_3 = 'UNITED STATES',
	--		ship_to_country = ''
	--WHERE ord_no = '00318898'
		
	SELECT	TOP 1000 * FROM OEHDRHST_SQL 
	WHERE LTRIM(RTRIM(cus_no)) = 'YANG02' 
	ORDER BY A4GLIdentity DESC

	
	--UPDATE OEHDRHST_SQL
	--		SET  bill_to_name =	 'Yanfeng Mexico',
	--		bill_to_addr_1 = 'PO BOX 7148',
	--		bill_to_addr_2 = '48376 Novi MI',
	--		bill_to_addr_3 = 'UNITED STATES',
	--		bill_to_country = '',

	--		ship_to_name =   'Yanfeng Mexico',
	--		ship_to_addr_1 = 'PO BOX 7148',
	--		ship_to_addr_2 = '48376 Novi MI',
	--		ship_to_addr_3 = 'UNITED STATES',
	--		ship_to_country = ''
	--WHERE INV_NO = 554262
	

	SELECT * FROM OEHDRHST_SQL WHERE INV_NO IN ( 554291, 554289)
	 
	select * from OELINHST_SQL where inv_no IN ( 554291, 554289)

	SELECT * --TOP 1 PRC_OR_DISC_1
					FROM	OEPRCFIL_SQL 
					WHERE	--LTRIM(RTRIM(filler_0001)) LIKE '%' + 'PLMFCLHYPAWA6' 
					--AND		
					LTRIM(RTRIM(filler_0001)) LIKE 'YANG02' + '%'
					ORDER BY A4GLIdentity DESC

-- //////////////////////////////////////////////////////////////		
 -- ORDEN DE FACTURACION/VENTA POR CLIENTE 'IRVI02' -- PO P4026                    
 -- 00318824

 SELECT * FROM OEORDHDR_SQL  where ord_no = '00318898'
 
 -- DETALLADO DE LOS REQUERIMIENTOS DE LA ORDEN DE FACTURACION
  select * from oeordlin_sql where ord_no = '00318898' AND cus_item_no = '200034B' -- AND request_dt = 20201221
  AND item_no IN (
					SELECT DISTINCT ITEM_NO FROM INVENTARIO_EMBARQUE WHERE   PACKING_NO = 'JL1204-1' --AND item_no = 'PJLSFBLMCKTX7'
				)
	
	--UPDATE  oeordlin_sql 
	--SET UNIT_PRICE = 6.300000
	--where ord_no = '00319016' AND cus_item_no = '200034B' -- AND request_dt = 20201221

 -- FACTURAS GENERADAS
 --INVOICE
	

  Select * from OEHDRHST_SQL where  inv_no = '554210' --ORD_NO = '00318798' 
  ORDER BY inv_no DESC 

   -- DETALLADO DE FACTURAS GENERADAS
  --DETALLE INVOICE
 select * from OELINHST_SQL where inv_no = '554210' --ORD_NO = '00318798' order by line_seq_no

-- //////////////////////////////////////////////////////////////	
 -- ORDEN DE VENTA POR CLIENTE 'MAGN03'
 SELECT TOP 100 * FROM OEORDHDR_SQL  where cus_no = 'MAGN03' ORDER BY ORD_NO DESC
 
   -- NUMEROS DE PARTE REQUERIDOS EN ORDEN DE VENT
 select *  from oeordlin_sql where ord_no = '00318898' AND  QTY_TO_SHIP <> 0
 AND item_no IN (
					SELECT DISTINCT ITEM_NO FROM INVENTARIO_EMBARQUE WHERE  PACKING_NO = 'WK1204-1'
				)
	
SELECT TOP 1000 * FROM IMITMIDX_SQL WHERE LTRIM(RTRIM(item_no)) IN ('PRURB60NRULK5    ' )

SELECT   * FROM INVENTARIO_EMBARQUE WHERE  PACKING_NO = 'WPI1204-1' ORDER BY CUS_PART_NO

 -- SE OBTIENE LA AORDEN DE FACTURACION INVOICE Y SE INCREMENTA 1 DESPUES DE OBTENERLA
 select str_inv_no from ARCTLFIL_SQL

 SELECT * FROM OEORDHDR_SQL  where ord_no = '00318798'

 --INVOICE
  Select * from OEHDRHST_SQL where  inv_no = '554102' --ORD_NO = '00318798' 
  ORDER BY inv_no DESC 

  --DETALLE INVOICE
 select * from OELINHST_SQL where inv_no = '553086' --ORD_NO = '00318798' order by line_seq_no

 SELECT TOP 1  LTRIM(RTRIM(jnl_cd))
				FROM	OELINHST_SQL 
				ORDER BY A4GLIdentity DESC

 -- precio de kits
 select top 1  * from OEPRCFIL_SQL where filler_0001 like '%PMWKLBLCPRDX9' and filler_0001 like 'MAGN03%'
 order by A4GLIdentity desc

 select top 100 * from cccusitm_sql where item_no = 'PMWEQBLWLPAX7'

 select top 1 * from ccitmidx_sql where item_no = 'PMWEQBLWLPAX7' order by versionno desc


 -- SE GRABAN LOS ITEM QUE PERTENECEN AL NUMERO DE PARTE U 
  SELECT TOP 100 * FROM IMORDHST_SQL ORDER BY A4GLIdentity DESC

  SELECT TOP 100 * FROM AROPNFIL_SQL ORDER BY DOC_DT DESC

 select TOP 10 * from invsel_sql  ORDER BY inv_date DESC

 select TOP 10 * from invcre_sql  ORDER BY inv_date DESC
 
-- SE OBTIENE EL PROD_CAT
SELECT TOP 1000 * FROM IMITMIDX_SQL WHERE LTRIM(RTRIM(item_no)) IN ('FNRULK5' )

SELECT TOP 100 * FROM ccitmidx_sql WHERE MODELNO = 'U3P'

SELECT TOP 1000 * FROM IMCATFIL_SQL WHERE prod_cat IN ('PWG')

SELECT * FROM ccjobtrx_sql WHERE 	LTRIM(RTRIM(jobno)) IN ( '17432', '17093' )

select * from u_part_no where u_part_no = 'UWD2TFBCNPJRR'
    
	select * from PF_SCHST 
	where type = 'E'
	AND INV_NO = 554307
	AND cdate2 = 20210110
	--AND packing_no IN ( 'WK0108-6' )
	and cus_part_no  in (select cus_item_no from OELINHST_SQL where inv_no IN ( 554307))
	ORDER BY cus_part_no

	select cus_part_no , sum(qty) from PF_SCHST 
	where type = 'E'
  AND cdate2 = 20210110
   and cus_part_no  in (select cus_item_no from OELINHST_SQL where inv_no IN ( 554307))
  group by cus_part_no
   ORDER BY cus_part_no
   
   select * from OELINHST_SQL where inv_no IN ( 554307) order by cus_item_no

	SELECT * FROM OEHDRHST_SQL WHERE INV_NO IN ( 554307)	 

	--UPDATE OELINHST_SQL
	--SET ITEM_DESC_2 = 'CHRYSLER NAPPA WA3'
	-- where inv_no IN ( 554296)

	select * from OEORDLIN_SQL where ord_no = 00319013
	
	SELECT  * FROM OELINHST_SQL WHERE inv_no = 554325 AND  LTRIM(RTRIM(item_desc_2)) = 'JRR RADAR RED / DX9 BLACK'

	/*
	 SELECT	 CONVERT(DATE,F_INVENTARIO_EMBARQUE) CDATE, 
							LTRIM(RTRIM(INVENTARIO_EMBARQUE.D_PROD_CAT)) AS PROD_CAT_DESC, 
							LTRIM(RTRIM(item_desc_1)) AS TYPE, 
							LTRIM(RTRIM(INVENTARIO_EMBARQUE.ITEM_NO)) AS PART_NO, 
							LTRIM(RTRIM(INVENTARIO_EMBARQUE.CUS_PART_NO)) AS CUS_PART_NO, 
							SUM(qty) AS QTY, 
							CASE WHEN ISNULL(LTRIM(RTRIM(INVENTARIO_EMBARQUE.INVOICE_NO)), '') = '' THEN ISNULL(LTRIM(RTRIM(INVENTARIO_EMBARQUE.PACKING_NO)), '')
								ELSE ISNULL(LTRIM(RTRIM(INVENTARIO_EMBARQUE.INVOICE_NO)), '') END AS PACKING_NO ,
							ISNULL(LTRIM(RTRIM(INVENTARIO_EMBARQUE.INVOICE_NO)), 'N/F') AS INV_NO
					FROM INVENTARIO_EMBARQUE 
					INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(IMITMIDX_SQL.item_no)) = LTRIM(RTRIM(COLOR))
					AND SUBSTRING(LTRIM(RTRIM(IMITMIDX_SQL.item_no)), 1,1) = 'F'
					WHERE	CONVERT(DATE,F_INVENTARIO_EMBARQUE) >=  '2020/12/22'
					AND CONVERT(DATE,F_INVENTARIO_EMBARQUE) <=  '2020/12/22'	
					AND K_ESTATUS_INVENTARIO_EMBARQUE IN (3,4)
					AND LTRIM(RTRIM(INVENTARIO_EMBARQUE.CUS_PART_NO)) = '365624'
					AND LTRIM(RTRIM(item_desc_1)) = 'CHRYSLER NAPPA RU LK5'
					AND LTRIM(RTRIM(INVENTARIO_EMBARQUE.D_PROD_CAT)) = 'RU PINNACLE'
					GROUP BY	CONVERT(DATE,F_INVENTARIO_EMBARQUE), LTRIM(RTRIM(INVENTARIO_EMBARQUE.ITEM_NO)), LTRIM(RTRIM(INVENTARIO_EMBARQUE.CUS_PART_NO)), 
								LTRIM(RTRIM(INVENTARIO_EMBARQUE.D_PROD_CAT)),  LTRIM(RTRIM(INVENTARIO_EMBARQUE.PACKING_NO)), 
								LTRIM(RTRIM(INVENTARIO_EMBARQUE.INVOICE_NO)), LTRIM(RTRIM(item_desc_1))
					ORDER BY	LTRIM(RTRIM(item_desc_1)), LTRIM(RTRIM(INVENTARIO_EMBARQUE.D_PROD_CAT)), 
								CONVERT(DATE,F_INVENTARIO_EMBARQUE), LTRIM(RTRIM(INVENTARIO_EMBARQUE.PACKING_NO)), LTRIM(RTRIM(INVENTARIO_EMBARQUE.INVOICE_NO)),
								LTRIM(RTRIM(INVENTARIO_EMBARQUE.ITEM_NO)), LTRIM(RTRIM(INVENTARIO_EMBARQUE.CUS_PART_NO)) ASC


    SELECT	CONVERT(DATE, CDATE2) CDATE, 
							LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) AS PROD_CAT_DESC, 
							LTRIM(RTRIM(item_desc_1)) AS TYPE, 
							LTRIM(RTRIM(pf_schst.part_no)) AS PART_NO, 
							LTRIM(RTRIM(pf_schst.cus_part_no)) AS CUS_PART_NO, 
							SUM(qty) AS QTY, 
							--ISNULL(LTRIM(RTRIM(packing_no)), '') AS PACKING_NO,
							CASE WHEN ISNULL(LTRIM(RTRIM(inv_no)), '') = '' THEN ISNULL(LTRIM(RTRIM(packing_no)), '')
								ELSE ISNULL(LTRIM(RTRIM(inv_no)), '') END AS PACKING_NO ,
							ISNULL(LTRIM(RTRIM(inv_no)), 'N/F') AS INV_NO
					FROM pf_schst 
					INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(item_no)) = CONCAT('F', SUBSTRING(part_no, (LEN(LTRIM(RTRIM(part_no))) - 5), 6))
					AND SUBSTRING(LTRIM(RTRIM(item_no)), 1,1) = 'F'
					INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
					AND LTRIM(RTRIM(PROD_CAT_DESC)) <> 'DO NOT DELETE'
					AND LTRIM(RTRIM(PROD_CAT_DESC)) <> 'OBSOLETE'
					WHERE TYPE = 'e' -- ENBARCADO
					AND CDATE >=  '2021/01/01'
					AND CDATE <=  '2021/01/13'	
					AND	(	packing_no IS NOT NULL
								OR inv_no IS NOT NULL )
					AND LTRIM(RTRIM(pf_schst.cus_part_no)) = '365624'
					AND LTRIM(RTRIM(item_desc_1)) = 'CHRYS'
					AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) =  'RU PINNACLE'
					GROUP BY	CDATE2, LTRIM(RTRIM(part_no)), LTRIM(RTRIM(cus_part_no)), 
								LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)),  LTRIM(RTRIM(packing_no)), 
								LTRIM(RTRIM(inv_no)), LTRIM(RTRIM(item_desc_1))
					ORDER BY	LTRIM(RTRIM(item_desc_1)), LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)), 
								CDATE2, LTRIM(RTRIM(packing_no)), LTRIM(RTRIM(inv_no)),
								LTRIM(RTRIM(part_no)), LTRIM(RTRIM(cus_part_no)) ASC
	*/
