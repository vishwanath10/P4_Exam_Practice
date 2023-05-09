use AdventureWorks2019
GO

select DISTINCT CONCAT(DATEPART(YEAR, OrderDate),'Q', DATEPART(Quarter,OrderDate)) as YearQuarter 
from Sales.SalesOrderHeader
ORDER BY YearQuarter


SELECT TOP (1000000) ROW_NUMBER() OVER(ORDER BY (SELECT 1)) as Number 
INTO dbo.NumberSet
FROM   sys.all_objects AS A CROSS JOIN sys.all_objects AS B
							CROSS JOIN sys.all_objects AS C
							CROSS JOIN sys.all_objects AS D
ORDER BY Number

WITH YearSet AS
(
SELECT DISTINCT YEAR(DATEADD(YEAR,Number,'2010-01-01 00:00:00.000')) as [Year]
FROM  dbo.NumberSet
WHERE Number < 5
),
YearQuarterSet  AS
(
SELECT CONCAT([Year],'Q',[Number]) as [YearQuarter]
FROM   dbo.NumberSet CROSS JOIN YearSet
WHERE Number < 5
)
,SalesData AS 
(
SELECT YearQuarter, City, TotalAmount 
FROM 
(
SELECT CONCAT(DATEPART(YEAR, OrderDate),'Q', DATEPART(Quarter,OrderDate)) as YearQuarter, ADR.City,  SUM(SOH.SubTotal + TaxAmt) as TotalAmount
,ROW_NUMBER() OVER(PARTITION BY CONCAT(DATEPART(YEAR, OrderDate),'Q', DATEPART(Quarter,OrderDate)) ORDER BY SUM(SOH.SubTotal + TaxAmt) DESC) as RowNum
FROM   Sales.SalesOrderHeader as SOH INNER JOIN Person.Address as ADR ON SOH.BillToAddressID = ADR.AddressID
GROUP BY CONCAT(DATEPART(YEAR, OrderDate),'Q', DATEPART(Quarter,OrderDate)),  ADR.City
) as DT
WHERE DT.RowNum <= 10

)	   
SELECT  Q.YearQuarter, S.City, S.TotalAmount
INTO ##SalesYearQuarterData
FROM YearQuarterSet as Q LEFT JOIN SalesData as S ON Q.YearQuarter = S.YearQuarter
ORDER BY Q.YearQuarter 

SELECT * FROM ##SalesYearQuarterData

DECLARE @Sql as NVARCHAR(MAX) = ''
       ,@ColList as NVARCHAR(MAX) = (
	   SELECT STRING_AGG(QUOTENAME(YearQuarter),',')
	   FROM
	   (SELECT  DISTINCT YearQuarter  
	   FROM ##SalesYearQuarterData) as DT
	   )


SELECT City, [2011Q1], [2011Q2], [2011Q3], [2011Q4] 
FROM 
(
SELECT YearQuarter, City, TotalAmount
FROM   ##SalesYearQuarterData
) as SrcData
PIVOT 
(
SUM(TotalAmount)
FOR   YearQuarter IN ([2011Q1], [2011Q2], [2011Q3], [2011Q4] )
) AS Pvt


