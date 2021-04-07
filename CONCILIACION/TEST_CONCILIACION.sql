
USE DATA_02PRUEBAS
		
SELECT * FROM IMITMIDX_SQL WHERE ITEM_NO = 'FCNPDX9'

-- TRUNCATE TABLE  MERMA_LOTE_COMPRADO

SELECT * FROM MERMA_LOTE_COMPRADO WHERE LOT_CRUST = 'K3413'

SELECT * from HIDESHDR_SQL 
WHERE PLOT = '402181' --PCOLOR = 'FNPJSA5'
 ORDER BY ID DESC 


SELECT * from HIDESHDR_SQL      
 inner join HIDESLIN_SQL on  HIDESLIN_SQL.FILENO = HIDESHDR_SQL.FILENO
 WHERE PCOLOR = 'FNPJSA5'
 AND TAREA = '8155.10'

 SELECT DISTINCT colour FROM COLORES_ACTIVOS

select top 100 * from u_part_no 

SELECT * --NP_CLIENTE, COUNT(N_EMB) AS 'CANTIDAD' 
from pf_sc_view
 WHERE  TYPE = 'e' 
 --AND  LTRIM(RTRIM(COLOR)) = 'NRUDX9'
--AND cdate2 = '20200701'
AND PACKING_NO = 'RU1201-1'
--AND n_emb = '3'
--GROUP BY NP_CLIENTE

SELECT * --TOP 1 @VP_PRECIO_CUS_PART_NO = prc_or_disc_1 
FROM OEPRCFIL_SQL WHERE LTRIM(RTRIM(filler_0001)) LIKE '%'+ 'PRUQFCLNRULK5' +'%' 
ORDER BY END_DT DESC

select * from OELINHST_SQL where  inv_no IN (553899)

 select  *  FROM pf_schst WHERE  TYPE = 'e' AND INV_NO IN ('553896')  ORDER BY cus_part_no

 select  *  FROM pf_schst 
 WHERE  TYPE = 'e' 
 AND cus_part_no IN (select cus_item_no from OELINHST_SQL where  inv_no IN (553899))
AND cdate2 = '20201213'
and packing_no is null
and inv_no is null
ORDER BY cus_part_no

	SELECT *
	FROM	IMITMIDX_SQL 
	--WHERE	LTRIM(RTRIM(ITEM_DESC_1))  = 'CAPRI TX7'
	WHERE	LTRIM(RTRIM(ITEM_DESC_1))  IN ('CAPRI TX7', 'NAPPA WT5')
	ORDER BY LTRIM(RTRIM(ITEM_DESC_1)) 

SELECT TOP 1000 * FROM IMITMIDX_SQL WHERE prod_cat = 'PWG' LTRIM(RTRIM(item_no)) = 'FCNPDX9'

SELECT * FROM COLORES_ACTIVOS

SELECT TOP 1000 * FROM cccusitm_sql WHERE LTRIM(RTRIM(cus_item_no)) = '174255A                       '

select inv_no,tot_sls_amt from OEHDRHST_SQL where inv_no='553533'

SELECT TOP 1 * FROM OEPRCFIL_SQL WHERE LTRIM(RTRIM(filler_0001)) LIKE '%PLWDRB4CNPDX9%' ORDER BY END_DT DESC

select SUM(qty_to_ship * unit_price)
from OELINHST_SQL 
where inv_no='551835'
AND item_desc_2 = 'CHRYSLER NAPPA HL1'

select * from OEHDRHST_SQL where  inv_no IN (553897) 

 SELECT top 1000 * FROM imcatfil_sql --where prod_cat in ('PWZ','PWG')
 WHERE  L_BORRADO = 0 --AND FILLER_0001 IS NOT NULL 
 --AND PROD_CAT_DESC LIKE '%ARM%'
 ORDER BY PROD_CAT
 
SELECT * FROM PROD_RPT_SQL ORDER BY PROD_CAT

 select  *  FROM pf_schst 
 WHERE  TYPE = 'e' 
 AND cus_part_no in ('184135A'                      
,'184137A'                       
,'184139A'                       
,'184141A'                       
,'184143A'                       
,'184145A'                       
,'184147A'                       
,'184149A' )                       
AND cdate2 = '20201213'
ORDER BY cus_part_no


 Select * from OEHDRHST_SQL where  inv_no IN (553897) 
 select * from OELINHST_SQL where inv_no='553897' --and cus_item_no = '172675P'

  select * from oeordlin_sql where ord_no = '00318962' AND item_no = 'PMWCJBRCPRDX9'

SELECT  * FROM IMITMIDX_SQL WHERE LTRIM(RTRIM(item_no)) = 'PMWGLBRCNPDX9'

select TOP 10 * from OELINHST_SQL where /*inv_no='551614' and */ cus_item_no = '174369A'

SELECT top 10  * /* Item_No, Comp_Item_No, Qty_Per_Par, Mfg_Uom, Loc, Scrap_Qty */ FROM BMPRDSTR_SQL 

SELECT   cube_width FROM IMITMIDX_SQL WHERE LTRIM(RTRIM(item_no)) = 'PMWKLBRCPRDX9'			


 SELECT top 1000 * FROM imcatfil_sql  where prod_cat_desc = 'WK GLDL' --'2015 WK KL'
 and   L_BORRADO = 0 
 ORDER BY PROD_CAT

SELECT	--DISTINCT  /*LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)),*/ LTRIM(RTRIM(item_desc_1)) --, LTRIM(RTRIM(pf_schst.cus_part_no)) AS CUS_PART_NO
			TOP 1 packing_no
					FROM pf_schst 
					INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(item_no)) = CONCAT('F', SUBSTRING(part_no, (LEN(LTRIM(RTRIM(part_no))) - 5), 6))
					AND SUBSTRING(LTRIM(RTRIM(item_no)),1,1) = 'F'
					WHERE TYPE = 'e' -- ENBARCADO
					AND		CDATE >=  '2020/08/01'
					AND		CDATE <= '2020/08/30'
					AND	(	packing_no IS NOT NULL
								OR inv_no IS NOT NULL )
					--and pf_schst.prod_cat = 'PWG'
					AND LTRIM(RTRIM(item_desc_1)) = 'CHRYSLER NAPPA DX9'
					AND inv_no = '551860'

 SELECT	CONVERT(DATE, CDATE) CDATE, 
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
							--LEFT JOIN  ON OEHDRHST_SQL.INV_NO = pf_schst.INV_NO
							WHERE TYPE = 'e' -- ENBARCADO
							AND		CDATE >=  '2020/11/01'
							AND		CDATE <= '2020/11/30'
							AND	(	pf_schst.packing_no IS NOT NULL
										OR pf_schst.inv_no IS NOT NULL )
							--AND LTRIM(RTRIM(pf_schst.cus_part_no)) = '174255A'
							--AND LTRIM(RTRIM(item_desc_1)) = 'CAPRI BLACK DX9'
							--AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = '2015 WK KL'
							GROUP BY	CDATE, LTRIM(RTRIM(part_no)), LTRIM(RTRIM(cus_part_no)), 
										LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)),  LTRIM(RTRIM(packing_no)), 
										LTRIM(RTRIM(inv_no)), LTRIM(RTRIM(item_desc_1))
							ORDER BY	LTRIM(RTRIM(item_desc_1)), LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)), 
										CDATE, LTRIM(RTRIM(packing_no)), LTRIM(RTRIM(inv_no))  ,
										LTRIM(RTRIM(part_no)), LTRIM(RTRIM(cus_part_no)) ASC