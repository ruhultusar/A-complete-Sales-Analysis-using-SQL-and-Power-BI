/** Clean DimDate Table **/
SELECT 
  [DateKey], 
  [FullDateAlternateKey] AS Date, 
  [EnglishDayNameOfWeek] AS Day, 
  [WeekNumberOfYear] AS WeekNo, 
  [EnglishMonthName] AS Month, 
  LEFT(EnglishMonthName, 3) AS MonthShort, 
  [MonthNumberOfYear] AS MonthNo, 
  [CalendarQuarter] AS Quarter, 
  [CalendarYear] AS Year 
FROM 
  DimDate
WHERE 
  CalendarYear >= 2020;
-- as they want analysis for current year and for some info last 2 year.

/** Cleaning and Enriching DimCustomer Table **/
SELECT 
  c.CustomerKey AS 'Customer Key', 
  c.FirstName AS 'First Name', 
  c.LastName AS 'Last Name', 
  c.FirstName + ' ' + c.LastName AS 'Full Name', 
  CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gneder, -- Altering column value
  c.DateFirstPurchase AS 'Date First Purchase', 
  g.City AS 'Customer City' 
FROM 
  DimCustomer AS c 
  Left Join DimGeography AS g -- Left join to detect customer location
  ON c.GeographyKey = g.GeographyKey 
ORDER BY 
  c.CustomerKey ASC;


/** Cleaning and Enriching DimProduct Table **/
SELECT 
  p.ProductKey, 
  p.ProductAlternateKey AS ProductItemKey, 
  p.EnglishProductName AS 'Product Name', 
  pc.EnglishProductCategoryName AS 'Product Category', 
  ps.EnglishProductSubcategoryName AS 'Product Sub Category', 
  p.Color AS 'Product Color', 
  p.Size AS 'Product Size', 
  p.ProductLine AS 'Product Line', 
  p.ModelName AS 'Product Model Name', 
  p.EnglishDescription AS 'Product Description', 
  ISNULL (p.Status, 'Outdated') AS '[Product Status' 
FROM 
  DimProduct AS p 
  LEFT JOIN DimProductSubcategory as ps -- join 1st table 
  ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey 
  LEFT JOIN DimProductCategory as pc -- Join 3rd table 
  ON ps.ProductCategoryKey = pc.ProductCategoryKey 
ORDER BY 
  p.ProductKey ASC;

/** Cleaning FACT_InternetSales Table **/
SELECT 
  ProductKey, 
  OrderDateKey, 
  DueDate, 
  ShipDateKey, 
  CustomerKey, 
  SalesOrderNumber, 
  SalesAmount 
FROM 
  FactInternetSales 
WHERE 
  LEFT (OrderDateKey, 4) >= YEAR(GETDATE())-2 -- Ensures we always only bring two years of date from extraction.
ORDER BY 
  OrderDateKey ASC;
