-- Cleaning and transforming the raw data for analysis

CREATE OR REPLACE TABLE insurance_cleaned AS 
SELECT * 
FROM insurance
WHERE age IS NOT NULL AND region IS NOT NULL; 


