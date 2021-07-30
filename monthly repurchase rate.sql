/****** Script for SelectTopNRows command from SSMS  ******/
--grouping the table in months and retunig repurchase and nonrepurchasing ids
with cte AS 
(SELECT [Customer ID],
      DATEPART(MONTH,[Created Date]) AS month,
	  CASE WHEN COUNT([Order Number]) > 1 THEN 'repurchaser' ELSE 'Non Repurcaser' END AS repurchase    
  FROM [ecommerce_project].[dbo].[sales]
 GROUP BY [Customer ID], DATEPART(MONTH,[Created Date])),

 --a cte from the previous query to count repurchasing ids grouped by month
 repurchasers_cte AS ( SELECT month, COUNT([Customer ID]) AS Repurchasers_Number
  FROM cte 
  WHERE repurchase ='repurchaser'
  GROUP BY month )

  --joining the first query and the second query, counting repuchased ids and both repurchasing and non-reourchasing ids as total purchasers, deriving the repurchase rate grouped by month
  SELECT r.month, Repurchasers_Number, COUNT(c.[Customer ID]) AS total_purchasers, FORMAT((Repurchasers_Number*1.00/ COUNT(c.[Customer ID]*1.00)),'0.00%') AS monthly_repurchase_rate
  FROM repurchasers_cte AS r
  LEFT JOIN cte AS c
  ON r.month=  c.month
  GROUP BY r.month, Repurchasers_Number
  ORDER BY r.month;

  
