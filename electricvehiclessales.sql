



	SELECT *
	FROM
		electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta


			SELECT *
	FROM
				electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak


					SELECT *
	FROM
					electric_vehicles_sales.dbo.dim_date dii



-------------------------JOIN THE THREE TABLES TOGETHER-----------------------------------------------

	SELECT *
	FROM
		electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
	FULL OUTER JOIN
		electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak

	ON sta.vehicle_category = mak.vehicle_category
	AND sta.date = mak.date
	JOIN
			electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = sta.date
	ORDER BY MAK.electric_vehicles_sold, quarter;






-----------------------ADDITION OF ELECTRIC VEHICLES IN MAKERS AND STATE-----------------------------


	SELECT dii.date, fiscal_year, quarter, state, maker, mak.vehicle_category , 
	--(Convert(int, sta.electric_vehicles_sold) + Convert(int,mak.electric_vehicles_sold)) AS total_electric_vehicles_sold,
	total_vehicles_sold, total_electric_vehicles_sold
	FROM 
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
	FULL OUTER JOIN
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
	ON sta.vehicle_category = mak.vehicle_category
	AND sta.date = mak.date
	JOIN
			electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = sta.date
	ORDER BY MAK.electric_vehicles_sold, quarter
	SELECT *
	FROM electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta;



----Altered the table with total elecric vehiclesand updaed it------------------ 

	ALTER TABLE electric_vehicles_sales.dbo.electric_vehicle_sales_by_state 
	ADD total_electric_vehicles_sold int

	UPDATE electric_vehicles_sales.dbo.electric_vehicle_sales_by_state 
	SET total_electric_vehicles_sold = (Convert(int, sta.electric_vehicles_sold) + Convert(int,mak.electric_vehicles_sold)) 
	FROM 
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
	FULL OUTER JOIN
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
	ON sta.vehicle_category = mak.vehicle_category
	AND sta.date = mak.date;

-------------------------------------------------------------------------------



	----------------CALCULATION OF PENETRATION RATE--------------------------------


	SELECT dii.date, fiscal_year, quarter, state, maker, mak.vehicle_category , total_electric_vehicles_sold,
	total_vehicles_sold,
(total_electric_vehicles_sold / total_vehicles_sold) * 100 AS penetration_rate
	FROM 
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
	FULL OUTER JOIN
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
	ON sta.vehicle_category = mak.vehicle_category
	AND sta.date = mak.date
	JOIN
			electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = sta.date
	ORDER BY MAK.electric_vehicles_sold, quarter,date;


	--------------ADDING OF PENETRATION RATE COLUMN TO THE TABLE---------------------------

		ALTER TABLE electric_vehicles_sales.dbo.electric_vehicle_sales_by_state 
	ADD penetration_rate int

	UPDATE electric_vehicles_sales.dbo.electric_vehicle_sales_by_state 
	SET  penetration_rate = (total_electric_vehicles_sold / total_vehicles_sold) * 100
		FROM 
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
	FULL OUTER JOIN
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
	ON sta.vehicle_category = mak.vehicle_category
	AND sta.date = mak.date
	JOIN
			electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = sta.date;

	----------------------------------------------------------------------------
		



		--List the top 3 and bottom 3 makers for the fiscal years 2023 in 
		--TOP 3 iterms of the number of 2-wheelers sold.
		
	SELECT top 3 maker, mak.vehicle_category, fiscal_year
	FROM 
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
	FULL OUTER JOIN
			electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = mak.date
				where  vehicle_category = '2-wheelers' and fiscal_year = '2023'
				ORDER BY maker,vehicle_category,fiscal_year desc;
	
	--BOTTOM 3
		SELECT top 3 maker, mak.vehicle_category, fiscal_year
	FROM 
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
	FULL OUTER JOIN
			electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = mak.date
				where  vehicle_category = '2-wheelers' and fiscal_year = '2023'
				ORDER BY maker,vehicle_category,fiscal_year asc;



   ------List the top 3 and bottom 3 makers for the fiscal years 2024 in terms of the number of 2-wheelers sold.

		SELECT top 3 maker, mak.vehicle_category, fiscal_year
	FROM 
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
	FULL OUTER JOIN
			electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = mak.date
				where  vehicle_category = '2-wheelers' and fiscal_year = '2024'
					ORDER BY maker,vehicle_category,fiscal_year asc;

					
					
	--Bottom 3

					
		SELECT top 3 maker, mak.vehicle_category, fiscal_year
	FROM 
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
	FULL OUTER JOIN
			electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = mak.date
				where  vehicle_category = '2-wheelers' and fiscal_year = '2024'
					ORDER BY maker,vehicle_category,fiscal_year desc;




--. Identify the top 5 states with the highest penetration rate in 2-wheeler and 4-wheeler EV sales in FY 2024.

		SELECT top 5 state, fiscal_year, sta.vehicle_category , penetration_rate
	FROM 
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
	FULL OUTER JOIN
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
	ON sta.vehicle_category = mak.vehicle_category
	AND sta.date = mak.date
	JOIN
			electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = sta.date
		
	where  sta.vehicle_category = '2-wheelers'and fiscal_year = '2024'
	ORDER BY state, penetration_rate,  sta.vehicle_category asc;

-------------------a different approach-----------------------------------

	WITH TOP_5_STATE AS (
		SELECT
		state, fiscal_year, sta.vehicle_category , sta.penetration_rate,

		(CASE WHEN sta.vehicle_category = '2-wheelers' AND fiscal_year = '2024'  THEN  sta.penetration_rate ELSE 0 END) AS top_2_wheeer,
		(CASE WHEN sta.vehicle_category = '4-wheelers' AND fiscal_year = '2024' THEN sta.penetration_rate ELSE 0 END) AS top_4_wheeer

		FROM electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
	FULL OUTER JOIN
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
	ON sta.vehicle_category = mak.vehicle_category
	AND sta.date = mak.date
	JOIN
			electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = sta.date
		
	)
	SELECT 
		top 5
		fiscal_year,
		----penetration_rate
		state,
		top_2_wheeer,
		top_4_wheeer

	FROM TOP_5_STATE;




--List of states with increase and decline penetration  in EV sales from 2022 to 2024?


	WITH FY_2022 AS (
    SELECT 
		
        state, 
        fiscal_year, penetration_rate
    FROM 
        electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
    FULL OUTER JOIN
        electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
        ON sta.vehicle_category = mak.vehicle_category
        AND sta.date = mak.date
    JOIN
        electric_vehicles_sales.dbo.dim_date dii
        ON dii.date = sta.date
    WHERE 
        fiscal_year = 2022
), FY_2024 AS (
    SELECT 
        state, 
        fiscal_year,penetration_rate
    FROM 
        electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
    FULL OUTER JOIN
        electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
        ON sta.vehicle_category = mak.vehicle_category
        AND sta.date = mak.date
    JOIN
        electric_vehicles_sales.dbo.dim_date dii
        ON dii.date = sta.date
    WHERE 
        fiscal_year = 2024
)

SELECT 
	
    COALESCE(FY_2022.state, FY_2024.state) AS STATE,
    FY_2022.penetration_rate AS FY_2022_PENETRATION_RATE,
    FY_2024.penetration_rate AS FY_2024_PENETRATION_RATE,
    CASE 
        WHEN (FY_2024.penetration_rate - FY_2022.penetration_rate) < 0 
        THEN 'DECLINING_RATE' 
        ELSE 'INCREASE_RATE' 
    END AS CHANGE_RATE
FROM 
    FY_2022 
FULL OUTER JOIN 
    FY_2024 
    ON FY_2022.state = FY_2024.state;

-----------------------------------------------------------------------------------------------------


	--List the states with negative penetration (decline) in EV sales from 2022 to 2024?
--	Filtering for Decline: The WHERE clause in the final SELECT filters for states where the penetration_rate in 2024 is less than that in 2022, indicating a decline.
--Results: This query will return the list of states, along with their penetration rates for 2022 and 2024, where there has been a decline in EV sales penetration.




	WITH FY_2022 AS (
    SELECT 
        state, 
        fiscal_year, penetration_rate
    FROM 
        electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
    FULL OUTER JOIN
        electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
        ON sta.vehicle_category = mak.vehicle_category
        AND sta.date = mak.date
    JOIN
        electric_vehicles_sales.dbo.dim_date dii
        ON dii.date = sta.date
    WHERE 
        fiscal_year = 2022
), FY_2024 AS (
    SELECT 
        state, 
        fiscal_year, penetration_rate
    FROM 
        electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
    FULL OUTER JOIN
        electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
        ON sta.vehicle_category = mak.vehicle_category
        AND sta.date = mak.date
    JOIN
        electric_vehicles_sales.dbo.dim_date dii
        ON dii.date = sta.date
    WHERE 
        fiscal_year = 2024
)

SELECT 
    COALESCE(FY_2022.state, FY_2024.state) AS STATE,
    FY_2022.penetration_rate AS FY_2022_PENETRATION_RATE,
    FY_2024.penetration_rate AS FY_2024_PENETRATION_RATE,
    --'DECLINING_RATE' AS CHANGE_RATE
	   CASE 
        WHEN (FY_2024.penetration_rate - FY_2022.penetration_rate) < 0 
        THEN 'DECLINING_RATE' 
    END AS CHANGE_RATE
FROM 
    FY_2022 
FULL OUTER JOIN 
    FY_2024 
    ON FY_2022.state = FY_2024.state
WHERE 
    FY_2024.penetration_rate < FY_2022.penetration_rate;




--How do the EV sales and penetration rates in Delhi compare to 
--Karnataka for 2024?


 			SELECT   dii.date, fiscal_year, state, total_electric_vehicles_sold, penetration_rate
	FROM 
	electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
	JOIN
			electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = sta.date
		where fiscal_year = '2024' AND state in ('Delhi', 'Karnataka');




--		List down the compounded annual growth rate (CAGR) in 4-wheeler 
--units for the top 5 makers from 2022 to 2024.



			WITH SalesUnits AS (
    -- Calculate the total units sold for 2022 and 2024 for each maker
    SELECT
		vehicle_category,
        maker,
        SUM(CASE WHEN fiscal_year = 2022 AND mak.vehicle_category = '4-wheelers'  THEN electric_vehicles_sold ELSE 0 END) AS units_2022,
        SUM(CASE WHEN fiscal_year = 2024 AND mak.vehicle_category = '4-wheelers'  THEN electric_vehicles_sold ELSE 0 END) AS units_2024
    FROM 	
		electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak
	JOIN 
		electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = mak.date

    WHERE fiscal_year IN (2022, 2024)
    GROUP BY maker, mak.vehicle_category
),
CAL_CAGR AS (
    -- Calculate the CAGR for each maker
    SELECT
		vehicle_category,
        maker,
        CASE
            WHEN units_2022 > 0 THEN
                POWER((units_2024 * 1.0) / units_2022, 1.0 / 2) - 1
            ELSE
                NULL
        END AS cagr
    FROM SalesUnits
)
-- Fetch top 5 makers based on total units sold in 2024
SELECT 
	TOP 5
	vehicle_category,
	maker, cagr
FROM CAL_CAGR
ORDER BY cagr DESC;




--List down the top 10 states that had the highest compounded annual 
--growth rate (CAGR) from 2022 to 2024 in total vehicles sold



			WITH SalesUnits AS (
    SELECT
        state,
        SUM(CASE WHEN fiscal_year = 2022  THEN total_vehicles_sold ELSE 0 END) AS units_2022,
        SUM(CASE WHEN fiscal_year = 2024   THEN total_vehicles_sold ELSE 0 END) AS units_2024
    FROM 	
			electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta

	JOIN 
		electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = sta.date

    WHERE fiscal_year IN (2022, 2024)
    GROUP BY state
),
  
CAL_CAGR AS (

    SELECT
        state,
        CASE
            WHEN units_2022 > 0 THEN
                POWER((units_2024 * 1.0) / units_2022, 1.0 / 2) - 1
            ELSE
                NULL
        END AS cagr
    FROM SalesUnits
)

SELECT 
	TOP 10
	state, cagr
FROM CAL_CAGR
ORDER BY cagr DESC;




--What are the peak and low season months for EV sales based on the 
--data from 2022 to 2024?



-- Peak month(s)
SELECT 
	--TOP 5
    MONTH(dii.date) AS month, 
    YEAR(dii.date) AS year, 
    total_electric_vehicles_sold AS total_sales
FROM 
    			electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
		JOIN 
				electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = sta.date
WHERE 
    YEAR(dii.date) BETWEEN 2022 AND 2024
GROUP BY 
    YEAR(dii.date), MONTH(dii.date), total_electric_vehicles_sold
ORDER BY 
    total_sales DESC,month DESC, year DESC

-- Low month(s)
SELECT 
    MONTH(date) AS month, 
    YEAR(date) AS year, 
    total_electric_vehicles_sold AS total_sales
FROM 
        			electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta

WHERE 
    YEAR(date) BETWEEN 2022 AND 2024

ORDER BY 
	  total_sales ASC,month ASC, year ASC;



--	What is the projected number of EV sales (including 2-wheelers and 4-
--wheelers) for the top 10 states by penetration rate in 2030, based on the 
--compounded annual growth rate (CAGR) from previous years?








			WITH SalesUnits AS (
    SELECT
        state,
        SUM(CASE WHEN fiscal_year = 2022  THEN total_vehicles_sold ELSE 0 END) AS units_2022,
        SUM(CASE WHEN fiscal_year = 2024   THEN total_vehicles_sold ELSE 0 END) AS units_2024
	
	--SUM(CASE WHEN fiscal_year = 2024 THEN total_electric_vehicles_sold ELSE 0 END) AS sales_in_2024
    FROM 	
			electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
	JOIN 
		electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = sta.date

    WHERE fiscal_year IN (2022 , 2024)
    GROUP BY state
),
    -- Calculate the CAGR for each state
CAL_CAGR AS (

    SELECT
        state,
        CASE
            WHEN units_2022 > 0 THEN
                POWER((units_2024 * 1.0) / units_2022, 1.0 / 2) - 1
            ELSE
                NULL
        END AS cagr
				
    FROM SalesUnits
)
-- Fetch top 10 state based on total units sold in 2024
SELECT 
	TOP 10
	su.state, cagr, units_2024 * POWER((1 + cagr), 7) AS projected_sales_2030

FROM CAL_CAGR cc
JOin SalesUnits su
ON su.state = cc.state
ORDER BY cagr DESC;







			WITH SalesUnits AS (
    SELECT
		--sta.vehicle_category,
        state,
        SUM(CASE WHEN fiscal_year = 2022  THEN      penetration_rate ELSE 0 END) AS units_2022,
        SUM(CASE WHEN fiscal_year = 2024   THEN 	penetration_rate ELSE 0 END) AS units_2024
	
	--SUM(CASE WHEN fiscal_year = 2024 THEN total_electric_vehicles_sold ELSE 0 END) AS sales_in_2024
    FROM 	
		electric_vehicles_sales.dbo.dim_date dii
			
	JOIN 
		electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
		
			ON dii.date = sta.date

    WHERE fiscal_year IN (2022 , 2024)
    GROUP BY state
),
    -- Calculate the CAGR for each state
CAL_CAGR AS (

    SELECT
        state,
        CASE
            WHEN units_2022 > 0 THEN
                POWER((units_2024 * 1.0) / units_2022, 1.0 / 2) - 1
            ELSE
                NULL
        END AS cagr
				
    FROM SalesUnits
)
-- Fetch top 5 state based on total units sold in 2024
SELECT 
	TOP 10
	su.state,cagr, units_2024 * POWER((1 + cagr), 6) AS projected_sales_2030

FROM CAL_CAGR cc
JOin SalesUnits su
ON su.state = cc.state
ORDER BY cagr DESC;








--Estimate the revenue growth rate of 4-wheeler and 2-wheelers 
--EVs in India for 2022 vs 2024 and 2023 vs 2024, assuming an average 
--unit price. H
---- 2 wheel - 85,000 and 4-wheel - 1500,000


WITH revenue AS (
  SELECT 
	sta.state,
    dii.fiscal_year, 
    sta.vehicle_category, 
    CASE 
      WHEN vehicle_category = '2-wheeler' THEN total_electric_vehicles_sold * 85000 -- assumed average price
      WHEN vehicle_category = '4-wheeler' THEN total_electric_vehicles_sold * 1500000 -- assumed average price
    END AS total_revenue
  FROM 
    		electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta 
  JOIN 
			electric_vehicles_sales.dbo.dim_date dii
	ON dii.date = sta.date


)
SELECT 
	r1.state,
  r1.vehicle_category,
  r1.fiscal_year AS year_from,
  r2.fiscal_year AS year_to,
  ((r2.total_revenue - r1.total_revenue) / r1.total_revenue) * 100 AS growth_rate
FROM 
  revenue r1
JOIN 
  revenue r2 
  ON r1.vehicle_category = r2.vehicle_category AND r1.fiscal_year < r2.fiscal_year
WHERE 
  (r1.fiscal_year = 2022 AND r2.fiscal_year = 2024) 
  OR (r1.fiscal_year = 2023 AND r2.fiscal_year = 2024)
ORDER BY 
  r1.vehicle_category, r1.fiscal_year;

		





		
WITH revenue AS (
  SELECT 
	sta.state,
    dii.fiscal_year, 
    sta.vehicle_category, 
    (CASE WHEN vehicle_category = '2-wheeler' THEN total_electric_vehicles_sold * 85000 END) AS wheeler_2_total_revenue,   
     (CASE  WHEN vehicle_category = '4-wheeler' THEN total_electric_vehicles_sold * 1500000 END) AS wheeler_4_total_revenue    
   
  FROM 
    		electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta 
  JOIN 
			electric_vehicles_sales.dbo.dim_date dii
	ON dii.date = sta.date


)
SELECT 
	r1.state,
  r1.vehicle_category,
  r1.fiscal_year AS year_from,
  r2.fiscal_year AS year_to,
  ((r2.wheeler_4_total_revenue - r1.wheeler_2_total_revenue) / r1.wheeler_2_total_revenue) * 100 AS growth_rate
FROM 
  revenue r1
JOIN 
  revenue r2 
  ON r1.vehicle_category = r2.vehicle_category AND r1.fiscal_year < r2.fiscal_year
WHERE 
  (r1.fiscal_year = 2022 AND r2.fiscal_year = 2024) 
  OR (r1.fiscal_year = 2023 AND r2.fiscal_year = 2024)
ORDER BY 
  r1.vehicle_category, r1.fiscal_year;

		






		CREATE A VIEW MAKERSSATE AS 
	
	SELECT  sta.date, maker, state, mak.vehicle_category, total_electric_vehicles_sold, total_vehicles_sold, penetration_rate,
	FROM
		electric_vehicles_sales.dbo.electric_vehicle_sales_by_state sta
	FULL OUTER JOIN
		electric_vehicles_sales.dbo.electric_vehicle_sales_by_maker mak

	ON sta.vehicle_category = mak.vehicle_category
	AND sta.date = mak.date
	JOIN
			electric_vehicles_sales.dbo.dim_date dii
			ON dii.date = sta.date
	ORDER BY MAK.electric_vehicles_sold, quarter;
