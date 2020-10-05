
USE DATA_02
			
			
SELECT * FROM IMITMIDX_SQL WHERE LTRIM(RTRIM(item_no)) LIKE 'F%'

SELECT DISTINCT LTRIM(RTRIM(TYPE)) from HIDESHDR_SQL

SELECT * from HIDESHDR_SQL      
 --inner join HIDESLIN_SQL on  HIDESLIN_SQL.FILENO = HIDESHDR_SQL.FILENO
 WHERE INVOICE <> '000000'
 --TDATE = '20200912' AND TYPE = 'DX9 NAPPA'

select top 100 * from u_part_no 

SELECT NP_CLIENTE, COUNT(N_EMB) AS 'CANTIDAD' from pf_sc_view WHERE PROG = '2015 WK KL' 
 AND COLOR = 'CPRDX9 '
 AND TYPE = 'e' 
AND cdate2 = '20201003'
AND n_emb = '1'
GROUP BY NP_CLIENTE

 select prog,color,count(*) AS 'COUNT' 
 from pf_sc_view 
 		WHERE	TYPE = 'e' 
			--AND		packing_no IS NOT NULL
			--AND PROG = '2015 WK KL'
			--AND STATUS = 'P'
			AND cdate2 = '20201003'
			--AND COLOR = 'CPRDX9'
			AND n_emb = '1'
		group by PROG,COLOR order by PROG,COLOR

select prog,color,count(*) as count 
from pf_sc_view 
where cdate2='" & Format(DateTimePicker1.Value, "yyyyMMdd") & "' 
and type='e' and n_emb='" & TextBox1.Text & "' group by PROG,COLOR order by PROG,COLOR
			
 SELECT DISTINCT packing_no
			FROM	pf_schst 
			WHERE	TYPE = 'e' 
			AND		packing_no IS NOT NULL
			--AND packing_no LIKE '%1002-1'
			AND		CONVERT(DATE, CDATE2) = '2020-10-03'
			--ORDER BY packing_no DESC
			--ORDER BY SUBSTRING(packing_no, 4, 10) DESC

SELECT SUBSTRING('JLS1002-3',4, 10)

 SELECT TOP 100 *	--DISTINCT LTRIM(RTRIM(pf_schst.cus_part_no)) AS CUS_PART_NO
 FROM pf_sc_view 

 SELECT TOP 100 * 
 FROM pf_schst 
 WHERE /*TYPE='e' AND*/ inv_no = '551590' AND cus_part_no = '174255A'
AND CDATE = '20200706'
 
SELECT TOP 1000 * FROM IMITMIDX_SQL WHERE LTRIM(RTRIM(item_no)) LIKE 'PMWKLFFCPRDX9'

SELECT TOP 1000 * FROM cccusitm_sql WHERE LTRIM(RTRIM(cus_item_no)) = '174255A                       '



 select *   FROM pf_schst where INV_NO IN ('551589')

select inv_no,tot_sls_amt from OEHDRHST_SQL where inv_no='551798'

SELECT TOP 100 * FROM OEPRCFIL_SQL 

select SUM(qty_to_ship * unit_price)
from OELINHST_SQL 
where inv_no='551835'
AND item_desc_2 = 'CHRYSLER NAPPA HL1'

select * from OEHDRHST_SQL where  inv_no IN (552545,552566) 

 SELECT top 1000 * FROM imcatfil_sql --where prod_cat in ('PWZ','PWG')
 WHERE  L_BORRADO = 0 AND FILLER_0001 IS NOT NULL

-- UPDATE imcatfil_sql
--	SET filler_0001 = 'YAN'
--WHERE prod_cat IN ('YFG'
--)


 select *   FROM pf_schst where INV_NO IN (552297) AND packing_no = 'WK0907-2'
 --AND CDATE = '2020-09-06 00:00:00'
 ORDER BY CDATE

 Select * from OEHDRHST_SQL where  inv_no IN (552609) 
 select * from OELINHST_SQL where inv_no='552609' --and cus_item_no = '172675P'

 select *   FROM pf_schst where packing_no IN ( 'WK0907-8','WK0909-4','WK0910-4','WK0915-8','WK0911-5','WK0921-4','WK0907-5')
 AND CDATE = '2020-09-06 00:00:00'
  ORDER BY CDATE

  select *   FROM pf_schst 
  where INV_NO IN (552320,552327,552358,552437,552344,552321,552571)

 --and cus_part_no  = '172675P' and part_no = 'PMWGLBRCNPDX9'

SELECT  * FROM IMITMIDX_SQL WHERE LTRIM(RTRIM(item_no)) = 'PMWGARMCNPDX9'

select TOP 10 * from OELINHST_SQL where /*inv_no='551614' and */ cus_item_no = '174369A'

SELECT top 10  * /* Item_No, Comp_Item_No, Qty_Per_Par, Mfg_Uom, Loc, Scrap_Qty */ FROM BMPRDSTR_SQL 


SELECT top 10 * FROM IMITMIDX_SQL

SELECT	COUNT(ID)
		FROM	pf_schst
		INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
		AND LTRIM(RTRIM(PROD_CAT_DESC)) <> 'DO NOT DELETE'
		AND LTRIM(RTRIM(PROD_CAT_DESC)) <> 'OBSOLETE'
		WHERE	TYPE = 'e' -- ENBARCADO
		AND		CDATE >=  '2010/07/01'
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
					AND		CDATE >=  '2010/07/01'
		AND		CDATE <= '2020/07/31'
					AND	(	packing_no IS NOT NULL
								OR inv_no IS NOT NULL )
					AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = '2015 WK KL'
					ORDER BY	LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)), 
								LTRIM(RTRIM(item_desc_1)),
								LTRIM(RTRIM(pf_schst.cus_part_no)) ASC

SELECT (sum(patternsqm)/sum(hidesqm)) * 100 
						FROM cccuthst_sql INNER JOIN ccjobhst_sql ON cccuthst_sql.jobno = ccjobhst_sql.jobno  
						WHERE ccjobhst_sql.datecompleted between 20201001 AND 20201005 
						AND cccuthst_sql.colour = CONCAT('F', SUBSTRING('PMWGARMCNPDX9', LEN('PMWGARMCNPDX9') -5 ,6 ))


