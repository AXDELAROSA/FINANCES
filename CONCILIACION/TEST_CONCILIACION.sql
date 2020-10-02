
USE DATA_02
			
			
SELECT * FROM IMITMIDX_SQL WHERE LTRIM(RTRIM(item_no)) LIKE 'F___DX9'

select * from HIDESHDR_SQL   
 --inner join HIDESLIN_SQL on  HIDESLIN_SQL.FILENO = HIDESHDR_SQL.FILENO
 WHERE INVOICE <> '000000'
 --TDATE = '20200912' AND TYPE = 'DX9 NAPPA'

 select top 100 * from u_part_no 

 select top 1000 * from pf_sc_view order by cdate2 desc


 SELECT TOP 1000 * --@VP_N_PACKING = COUNT(ID)
			FROM	pf_schst 
			WHERE	TYPE = 'e' 
			--AND		packing_no IS NOT NULL
			AND		CONVERT(DATE, CDATE) = CONVERT(DATE,GETDATE())


 SELECT	DISTINCT LTRIM(RTRIM(pf_schst.cus_part_no)) AS CUS_PART_NO
 FROM pf_schst 
 INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
 WHERE TYPE='e' 
 AND CDATE >= '20200701'
 AND CDATE <= '20200731'
 AND	(	packing_no IS NOT NULL
 			OR inv_no IS NOT NULL )
 AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = '2015 WK KL'
 ORDER BY	LTRIM(RTRIM(cus_part_no)) ASc

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

 SELECT top 1000 * FROM imcatfil_sql where prod_cat in ('PWZ','PWG')

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

SELECT TOP 1000 cube_width FROM IMITMIDX_SQL WHERE LTRIM(RTRIM(item_no)) LIKE 'PMWKLFFCPRDX9'

select * from OELINHST_SQL where inv_no='551614' and cus_item_no = '172675P'

SELECT top 10 Item_No, Comp_Item_No, Qty_Per_Par, Mfg_Uom, Loc, Scrap_Qty  FROM BMPRDSTR_SQL 


SELECT top 10 * FROM IMITMIDX_SQL

SELECT	packing_no
 FROM pf_schst 
 WHERE TYPE='e' 
 AND CDATE >= '20201001'
 AND CDATE <= '20201031'
GROUP BY PACKING_NO
HAVING COUNT(packing_no) > 2 

