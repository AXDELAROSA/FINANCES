
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

 SELECT TOP 10 * 
 FROM pf_schst 
 WHERE TYPE='e' and n_emb='1' and cdate2='20200924'
 
SELECT TOP 100 * FROM IMITMIDX_SQL WHERE LTRIM(RTRIM(item_no)) LIKE 'F___DX9'

 SELECT  CDATE, pf_schst.prod_cat, item_desc_1 as [TYPE], pf_schst.part_no, pf_schst.cus_part_no , SUM(qty) 'QTY Kits', packing_no ,inv_no AS INVOICE
 FROM pf_schst 
 INNER JOIN IMITMIDX_SQL ON LTRIM(RTRIM(item_no)) = CONCAT('F', SUBSTRING(part_no, (LEN(LTRIM(RTRIM(part_no))) - 5), 6))
 WHERE TYPE='e' and n_emb='1' 
 AND CDATE >= '20200915' AND CDATE<= '20200916'
 GROUP BY  CDATE, item_desc_1, pf_schst.prod_cat, part_no, cus_part_no, packing_no, inv_no
 ORDER BY CDATE, item_desc_1, packing_no ASC

 select *   FROM pf_schst where inv_no = '551725'

select inv_no,tot_sls_amt from OEHDRHST_SQL where inv_no='551725'

SELECT * FROM imcatfil_sql where prod_cat = 'PWL'

select item_no,cus_item_no,item_desc_1,qty_to_ship,unit_price from OELINHST_SQL where inv_no='551725'

select top 100 filler_0001,prc_or_disc_1 from OEPRCFIL_SQL

 SELECT SUBSTRING('PMWCFCLCPRDX9', (LEN(LTRIM(RTRIM('PMWCFCLCPRDX9'))) - 5), 6)









