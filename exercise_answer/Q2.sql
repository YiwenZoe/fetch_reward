-- Q2
-- Second question: Write a query that directly answers a predetermined question from a business stakeholder

-- Write a SQL query against your new structured relational data model that answers one of the following bullet points below of your choosing. Commit it to the git repository along with the rest of the exercise.

-- Note: When creating your data model be mindful of the other requests being made by the business stakeholder. If you can capture more than one bullet point in your model while keeping it clean, efficient, and performant, that benefits you as well as your team.

-- What are the top 5 brands by receipts scanned for most recent month?
-- Tables needed: receipts, brands
-- Columns needed: 
-- receipts: receipt_id, barcode, quantity, dateScanned
-- brands: barcode, brand_name
-- DATEADD(SECOND, START_DATE/1000 ,'1970/1/1')


WITH re AS 
(SELECT
receipt_id,
barcode,
quantityPurchased,
DATEADD(SECOND, dateScanned/1000 ,'1970/1/1') AS scanned_date,
YEAR(DATEADD(SECOND, dateScanned/1000 ,'1970/1/1')) AS scanned_year,
MONTH(DATEADD(SECOND, dateScanned/1000 ,'1970/1/1')) AS scanned_month
FROM receipts)
,

most_recent_date AS 
(SELECT
MAX(YEAR(scanned_date)) AS most_recent_year,
MAX(MONTH(scanned_date)) AS most_recent_month
FROM receipts)
,

most_recent_re AS 
(SELECT
receipt_id,
barcode,
quantityPurchased
FROM re INNER JOIN most_recent_date
ON re.scanned_year = most_recent_date.most_recent_year
AND re.scanned_month = most_recent_date.most_recent_month)

SELECT
brand_name AS top_5_brands
FROM
(SELECT
brands.brand_name,
SUM(most_recent_re.quantityPurchased) AS total_items
FROM
most_recent_re LEFT JOIN brands
ON most_recent_re.barcode = brands.barcode
GROUP BY brands.brand_name) AS base
ORDER BY total_items DESC
LIMIT 5
;


-- How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
-- When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
-- When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
-- Which brand has the most spend among users who were created within the past 6 months?
-- Which brand has the most transactions among users who were created within the past 6 months?