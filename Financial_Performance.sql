Select count(*) from bank;

-- Yearly Trend of Operating Income in Millions
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%m/%d/%Y')) AS Year,
    ROUND(SUM(Operating_Income) / 1000000, 2) AS Total_Operating_Income_Million
FROM
    bank
GROUP BY Year
ORDER BY Year;

-- Quarter with the Highest Average Expenses
SELECT 
    CONCAT('Q', QUARTER(STR_TO_DATE(Date, '%m/%d/%Y'))) AS Quarter, 
    ROUND(AVG(Expenses), 2) AS Avg_Expenses
FROM bank
GROUP BY Quarter
ORDER BY Avg_Expenses DESC
LIMIT 1;


-- 3. YoY Growth in Operating Income (in Millions)
WITH YearlyIncome AS (
    SELECT 
        EXTRACT(YEAR FROM STR_TO_DATE(Date, '%m/%d/%Y')) AS Year, 
        ROUND(SUM(Operating_Income) / 1000000, 2) AS Total_Operating_Income_Million
    FROM bank
    GROUP BY Year
),
YoYGrowth AS (
    SELECT 
        Year, 
        Total_Operating_Income_Million, 
        LAG(Total_Operating_Income_Million) OVER (ORDER BY Year) AS Prev_Year_Income,
        ROUND(((Total_Operating_Income_Million - 
                LAG(Total_Operating_Income_Million) OVER (ORDER BY Year)) / 
                LAG(Total_Operating_Income_Million) OVER (ORDER BY Year)) * 100, 2) AS YoY_Growth_Percent
    FROM YearlyIncome
)
SELECT * 
FROM YoYGrowth;



-- 4. Debt-to-Equity Ratio Trend by Year
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%m/%d/%Y')) AS Year, 
    ROUND(AVG(Debt_to_Equity), 2) AS Avg_Debt_to_Equity
FROM bank
GROUP BY Year
ORDER BY Year;




-- 5. Top Month with the Highest Profit Margin

SELECT 
    EXTRACT(MONTH FROM STR_TO_DATE(Date, '%m/%d/%Y')) AS Month, 
    ROUND(AVG(Profit_Margin), 2) AS Avg_Profit_Margin
FROM bank
GROUP BY Month
ORDER BY Avg_Profit_Margin DESC
LIMIT 1;



-- 6. Correlation Between Revenue and Net Income

SELECT 
    ROUND(SUM((Revenue - (SELECT AVG(Revenue) FROM bank)) * (Net_Income - (SELECT AVG(Net_Income) FROM bank))) / 
          (SQRT(SUM(POW(Revenue - (SELECT AVG(Revenue) FROM bank), 2))) * 
           SQRT(SUM(POW(Net_Income - (SELECT AVG(Net_Income) FROM bank), 2)))), 2) AS Revenue_NetIncome_Correlation
FROM bank;





-- 7. Percentage of Revenue Spent on Interest Expense Yearly

SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%m/%d/%Y')) AS Year, 
    ROUND((SUM(Interest_Expense) / SUM(Revenue)) * 100, 2) AS Interest_Percentage
FROM bank
GROUP BY Year
ORDER BY Year;




-- 8. Top 5 Dates with the Highest Cash Flow
SELECT 
    STR_TO_DATE(Date, '%m/%d/%Y') AS Date, 
    Cash_Flow
FROM bank
ORDER BY Cash_Flow DESC
LIMIT 5;






-- 9. ROA (Return on Assets) Trend Over Time
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%m/%d/%Y')) AS Year, 
    ROUND(AVG(ROA), 2) AS Avg_ROA
FROM bank
GROUP BY Year
ORDER BY Year;





-- 10. Year with the Highest Dividend Payout
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%m/%d/%Y')) AS Year, 
    ROUND(SUM(Dividend_Payout), 2) AS Total_Dividend_Payout
FROM bank
GROUP BY Year
ORDER BY Total_Dividend_Payout DESC
LIMIT 1;




