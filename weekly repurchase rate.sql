/****** Script for SelectTopNRows command from SSMS  ******/
--grouping the table in week numbers and retunig repurchase and nonrepurchasing ids
with cte AS 
(SELECT [Customer ID],
      DATEPART(WEEK,[Created Date]) AS week,
	  CASE WHEN APPROX_COUNT_DISTINCT([Order Number]) > 1 THEN 'repurchaser' ELSE 'Non Repurcaser' END AS repurchase    
  FROM [ecommerce_project].[dbo].[sales]
 GROUP BY [Customer ID], DATEPART(WEEK,[Created Date])),

 --a cte from the previous query to count repurchasing ids grouped by week number
 repurchasers_cte AS ( SELECT week,  APPROX_COUNT_DISTINCT([Customer ID]) AS Repurchasers_Number
  FROM cte 
  WHERE repurchase ='repurchaser'
  GROUP BY week )

  --joining the first query and the second query, counting repuchased ids and both repurchasing and non-reourchasing ids as total purchasers, deriving the repurchase rate grouped by week number
  SELECT r.week, Repurchasers_Number, APPROX_COUNT_DISTINCT(c.[Customer ID]) AS total_purchasers, FORMAT((Repurchasers_Number*1.00/ COUNT(c.[Customer ID]*1.00)),'0.00%') AS weekly_repurchase_rate
  FROM repurchasers_cte AS r
  LEFT JOIN cte AS c
  ON r.week =  c.week
  GROUP BY r.week, Repurchasers_Number
  ORDER BY r.week;

  
