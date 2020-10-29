
USE DATA_02
		
SELECT * FROM IMITMIDX_SQL WHERE ITEM_NO = 'FCNPDX9'

SELECT DISTINCT LTRIM(RTRIM(TYPE)) from HIDESHDR_SQL

SELECT * from HIDESHDR_SQL      
 --inner join HIDESLIN_SQL on  HIDESLIN_SQL.FILENO = HIDESHDR_SQL.FILENO
 WHERE INVOICE <> '000000'
 --TDATE = '20200912' AND TYPE = 'DX9 NAPPA'

select top 100 * from u_part_no 

SELECT * --NP_CLIENTE, COUNT(N_EMB) AS 'CANTIDAD' 
from pf_sc_view
 WHERE  TYPE = 'e' 
 AND  LTRIM(RTRIM(COLOR)) = 'NRUDX9'
AND cdate2 = '20201026'
AND PACKING_NO = 'RU1027-3'
--AND n_emb = '3'
--GROUP BY NP_CLIENTE

 select *   FROM pf_schst 
 WHERE  TYPE = 'e' 
 --AND  LTRIM(RTRIM(COLOR)) = 'MCKPD2'
AND cdate2 = '20201026'
AND PACKING_NO = 'RU1027-3'
--AND cus_part_no IN ('174954E', '174927D')

SELECT TOP 1000 * FROM IMITMIDX_SQL WHERE LTRIM(RTRIM(item_no)) LIKE 'PMWKLFFCPRDX9'

SELECT TOP 1000 * FROM cccusitm_sql WHERE LTRIM(RTRIM(cus_item_no)) = '174255A                       '

select inv_no,tot_sls_amt from OEHDRHST_SQL where inv_no='551798'

SELECT TOP 100 * FROM OEPRCFIL_SQL 

select SUM(qty_to_ship * unit_price)
from OELINHST_SQL 
where inv_no='551835'
AND item_desc_2 = 'CHRYSLER NAPPA HL1'

select * from OEHDRHST_SQL where  inv_no IN (552545,552566) 

 SELECT top 1000 * FROM imcatfil_sql --where prod_cat in ('PWZ','PWG')
 WHERE  L_BORRADO = 0 --AND FILLER_0001 IS NOT NULL 
 --AND PROD_CAT_DESC LIKE '%ARM%'
 ORDER BY PROD_CAT
 
SELECT * FROM PROD_RPT_SQL ORDER BY PROD_CAT

 Select * from OEHDRHST_SQL where  inv_no IN (552609) 
 select * from OELINHST_SQL where inv_no='552609' --and cus_item_no = '172675P'

SELECT  * FROM IMITMIDX_SQL WHERE LTRIM(RTRIM(item_no)) = 'PMWGARMCNPDX9'

select TOP 10 * from OELINHST_SQL where /*inv_no='551614' and */ cus_item_no = '174369A'

SELECT top 10  * /* Item_No, Comp_Item_No, Qty_Per_Par, Mfg_Uom, Loc, Scrap_Qty */ FROM BMPRDSTR_SQL 

SELECT   cube_width 
								FROM IMITMIDX_SQL 
								WHERE LTRIM(RTRIM(item_no)) = 'PMWKLBRCPRDX9'			

SELECT	COUNT(ID)
		FROM	pf_schst
		INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
		AND LTRIM(RTRIM(PROD_CAT_DESC)) <> 'DO NOT DELETE'
		AND LTRIM(RTRIM(PROD_CAT_DESC)) <> 'OBSOLETE'
		WHERE	TYPE = 'e' -- ENBARCADO
		AND		CDATE >=  '2020/07/01'
		AND		CDATE <= '2020/07/31'
		AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = '2015 WK KL'

SELECT	DISTINCT LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)), LTRIM(RTRIM(item_desc_1)), LTRIM(RTRIM(pf_schst.cus_part_no)) AS CUS_PART_NO
					FROM pf_schst 
					INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
					AND LTRIM(RTRIM(PROD_CAT_DESC)) <> 'DO NOT DELETE'
					AND LTRIM(RTRIM(PROD_CAT_DESC)) <> 'OBSOLETE'
					INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(item_no)) = CONCAT('F', SUBSTRING(part_no, (LEN(LTRIM(RTRIM(part_no))) - 5), 6))
					AND SUBSTRING(LTRIM(RTRIM(item_no)),1,1) = 'F'
					WHERE TYPE = 'e' -- ENBARCADO
					AND		CDATE >=  '2020/07/01'
		AND		CDATE <= '2020/07/31'
					AND	(	packing_no IS NOT NULL
								OR inv_no IS NOT NULL )
					AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = '2015 WK KL'
					ORDER BY	LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)), 
								LTRIM(RTRIM(item_desc_1)),
								LTRIM(RTRIM(pf_schst.cus_part_no)) ASC
