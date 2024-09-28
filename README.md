# Data-Analytics-project


**Electric Vehicles Sales Analysis**

This repository contains SQL queries used to analyze electric vehicle sales data, including sales by state, maker, and penetration rates. Below are the detailed SQL queries along with explanations for each use case.

**Table of Contents
List of Electric Vehicle Sales by State
List of Electric Vehicle Sales by Maker
Joining State, Maker, and Date Tables
Calculating Penetration Rates
Top and Bottom 3 Makers
State Comparison for Penetration Rates
Projected Sales for 2030**

**1. List of Electric Vehicle Sales by State**
   SELECT * 
FROM electric_vehicles_sales.dbo.electric_vehicle_sales_by_state;

This query retrieves all records from the electric_vehicle_sales_by_state table.




**2. List of Electric Vehicle Sales by Maker**

   SELECT * 
FROM electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker;


**3. Joining State, Maker, and Date Tables**

   SELECT * 
FROM electric_vehicles_sales.dbo.electric_vehicle_sales_by_state AS sta
FULL OUTER JOIN electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker AS mak
    ON sta.vehicle_category = mak.vehicle_category
    AND sta.date = mak.date
JOIN electric_vehicles_sales.dbo.dim_date AS dii
    ON dii.date = sta.date
ORDER BY mak.electric_vehicles_sold, quarter;

This query joins three tables (electric_vehicle_sales_by_state, electric_vehicle_sales_by_maker, and dim_date) using FULL OUTER JOIN and JOIN. It returns the results sorted by the number of electric vehicles sold and quarter.

**4. Calculating Penetration Rates**
SELECT dii.date, fiscal_year, quarter, state, maker, mak.vehicle_category, 
       total_electric_vehicles_sold, total_vehicles_sold,
       (total_electric_vehicles_sold / total_vehicles_sold) * 100 AS penetration_rate
FROM electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker AS mak
FULL OUTER JOIN electric_vehicles_sales.dbo.electric_vehicle_sales_by_state AS sta
    ON sta.vehicle_category = mak.vehicle_category
    AND sta.date = mak.date
JOIN electric_vehicles_sales.dbo.dim_date AS dii
    ON dii.date = sta.date
ORDER BY mak.electric_vehicles_sold, quarter, date;
This query calculates the penetration rate of electric vehicles as a percentage of total vehicle sales.

**5. Top and Bottom 3 Makers**
Top 3 Makers for Fiscal Year 2023
SELECT TOP 3 maker, mak.vehicle_category, fiscal_year
FROM electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker AS mak
JOIN electric_vehicles_sales.dbo.dim_date AS dii
    ON dii.date = mak.date
WHERE vehicle_category = '2-wheelers' AND fiscal_year = '2023'
ORDER BY fiscal_year DESC;

**Bottom 3 Makers for Fiscal Year 2023**
SELECT TOP 3 maker, mak.vehicle_category, fiscal_year
FROM electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker AS mak
JOIN electric_vehicles_sales.dbo.dim_date AS dii
    ON dii.date = mak.date
WHERE vehicle_category = '2-wheelers' AND fiscal_year = '2023'
ORDER BY fiscal_year ASC;

These queries list the top 3 and bottom 3 makers for 2-wheelers in fiscal year 2023

**6. State Comparison for Penetration Rates**
   SELECT dii.date, fiscal_year, state, total_electric_vehicles_sold, penetration_rate
FROM electric_vehicles_sales.dbo.electric_vehicle_sales_by_state AS sta
JOIN electric_vehicles_sales.dbo.dim_date AS dii
    ON dii.date = sta.date
WHERE fiscal_year = '2024' AND state IN ('Delhi', 'Karnataka');

This query compares electric vehicle sales and penetration rates between Delhi and Karnataka for fiscal year 2024.

**7. Projected Sales for 2030**
   WITH SalesUnits AS (
    SELECT state,
           SUM(CASE WHEN fiscal_year = 2022 THEN total_vehicles_sold ELSE 0 END) AS units_2022,
           SUM(CASE WHEN fiscal_year = 2024 THEN total_vehicles_sold ELSE 0 END) AS units_2024
    FROM electric_vehicles_sales.dbo.electric_vehicle_sales_by_state AS sta
    JOIN electric_vehicles_sales.dbo.dim_date AS dii
        ON dii.date = sta.date
    WHERE fiscal_year IN (2022, 2024)
    GROUP BY state
), CAL_CAGR AS (
    SELECT state,
           CASE
               WHEN units_2022 > 0 THEN POWER((units_2024 * 1.0) / units_2022, 1.0 / 2) - 1
               ELSE NULL
           END AS cagr
    FROM SalesUnits
)
SELECT TOP 10 state, cagr, units_2024 * POWER((1 + cagr), 6) AS projected_sales_2030
FROM CAL_CAGR
ORDER BY cagr DESC;

This query projects the electric vehicle sales for the top 10 states by penetration rate for the year 2030 based on the Compound Annual Growth Rate (CAGR).













