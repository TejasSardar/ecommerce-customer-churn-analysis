-- E-Commerce Customer Churn Analysis - SQL Queries
-- Database: churn_db

-- 1. Basic Aggregation: Overall Churn Rate
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS total_churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS overall_churn_rate
FROM customers;

-- 2. Grouping: Churn Rate by Contract Type
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM customers
GROUP BY Contract
ORDER BY churn_rate DESC;

-- 3. Advanced Function: CTE & Window Function (RANK)
WITH RankedCharges AS (
    SELECT 
        customerID,
        Contract,
        MonthlyCharges,
        Churn,
        RANK() OVER (PARTITION BY Contract ORDER BY MonthlyCharges DESC) AS charge_rank
    FROM customers
)
SELECT 
    customerID,
    Contract,
    MonthlyCharges,
    Churn,
    charge_rank
FROM RankedCharges
WHERE charge_rank <= 5;