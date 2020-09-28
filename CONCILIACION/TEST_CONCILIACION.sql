
USE DATA_02
			
			
SELECT * FROM IMITMIDX_SQL WHERE LTRIM(RTRIM(item_no)) LIKE 'F___DX9'

select * from HIDESHDR_SQL   
 --inner join HIDESLIN_SQL on  HIDESLIN_SQL.FILENO = HIDESHDR_SQL.FILENO
 WHERE TDATE = '20200912' AND TYPE = 'DX9 NAPPA'


 select /*TDATE, TYPE, COLOR,*/ SUM(CONVERT(DECIMAL(13,4),THIDES)) AS THIDES,
 SUM(CONVERT(DECIMAL(13,4),TAREA)) AS TOTAL_SQF
 from HIDESHDR_SQL   
 WHERE TDATE = '20200902' --AND LDATE<= '20200903'
 AND TYPE = 'WU9 NAPPA'
 GROUP BY TDATE,TYPE, COLOR
 ORDER BY LDATE,TYPE, COLOR

  select SUM(CONVERT(DECIMAL(13,4),TAREA)) AS TOTAL_SQF 
 from HIDESHDR_SQL   
 WHERE LDATE >= '20200901' AND LDATE<= '20200903'
 --GROUP BY LDATE,TYPE, COLOR
 --ORDER BY LDATE,TYPE, COLOR

 select TYPE, SUBSTRING(CLOT,1,7) AS CLOT, SUM(CONVERT(DECIMAL(13,4),THIDES)) AS TOTAL_SQF , SUM(CONVERT(DECIMAL(13,4),TAREA)) AS TOTAL_SQF 
 from HIDESHDR_SQL   
 WHERE LDATE >= '20200901' AND LDATE<= '20200903'
 GROUP BY TYPE, SUBSTRING(CLOT,1,7) 
 --ORDER BY LDATE,TYPE, COLOR

 SELECT SUBSTRING('33461',1,(LEN('33461') - 1))

--AND	LTRIM(RTRIM(PLOT)) = '401111' 
 --AND LTRIM(RTRIM(HIDE))  IN ('0037')
 --AND PCOLOR = 'FWLCPX7'

SELECT	CONVERT(DATE, CDATE) CDATE, 
						LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) AS PROD_CAT_DESC, 
						LTRIM(RTRIM(item_desc_1)) AS TYPE, 
						LTRIM(RTRIM(pf_schst.part_no)) AS PART_NO, 
						LTRIM(RTRIM(pf_schst.cus_part_no)) AS CUS_PART_NO, 
						SUM(qty) AS QTY, 
						ISNULL(LTRIM(RTRIM(packing_no)), '') AS PACKING_NO,
						ISNULL(LTRIM(RTRIM(inv_no)), 'N/F') AS INV_NO
				FROM pf_schst 
				INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(item_no)) = CONCAT('F', SUBSTRING(part_no, (LEN(LTRIM(RTRIM(part_no))) - 5), 6))
				INNER JOIN imcatfil_sql ON LTRIM(RTRIM(imcatfil_sql.prod_cat)) = LTRIM(RTRIM(pf_schst.prod_cat))
				WHERE TYPE='e' 
				AND CDATE >= '20200901'
				AND CDATE <= '20200928'
				AND	(	packing_no IS NOT NULL
							OR inv_no IS NOT NULL )
				AND LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)) = 'JEEP JT SUMMIT'
				GROUP BY	CDATE, LTRIM(RTRIM(part_no)), LTRIM(RTRIM(cus_part_no)), 
							LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)),  LTRIM(RTRIM(packing_no)), 
							LTRIM(RTRIM(inv_no)), LTRIM(RTRIM(item_desc_1))
				ORDER BY	LTRIM(RTRIM(item_desc_1)), LTRIM(RTRIM(imcatfil_sql.prod_cat_desc)), 
							CDATE, LTRIM(RTRIM(packing_no)), LTRIM(RTRIM(inv_no))  ,
							LTRIM(RTRIM(part_no)), LTRIM(RTRIM(cus_part_no)) ASC

 SELECT TOP 10 * 
 FROM pf_schst 
 WHERE TYPE='e' and n_emb='1' and cdate2='20200924'
 
SELECT TOP 100 * FROM IMITMIDX_SQL WHERE LTRIM(RTRIM(item_no)) LIKE 'F___DX9'

 select *   FROM pf_schst where packing_no = 'WK0715-9'

 SELECT top 1000 * FROM imcatfil_sql where prod_cat = 'WKD'

select inv_no,tot_sls_amt from OEHDRHST_SQL where inv_no='551591'


SELECT TOP 100 * FROM OEPRCFIL_SQL 

select item_no,cus_item_no,item_desc_1,qty_to_ship,unit_price from OELINHST_SQL where inv_no='551822'



 SELECT SUBSTRING('PMWCFCLCPRDX9', (LEN(LTRIM(RTRIM('PMWCFCLCPRDX9'))) - 5), 6)









