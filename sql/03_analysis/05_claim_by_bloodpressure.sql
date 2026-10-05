-- Step 3: Claims by blood pressure band, smoking status and BMI 30.
-- Run from the project root inside the DuckDB shell:
--     .read sql/03_analysis/05_claim_by_bloodpressure.sql
-- Bands follow the visible breaks in the scatter plot (most non-smokers stop at 100).

-- Everyone: median claim by smoking status and blood pressure band
SELECT
    smoker,
    CASE
        WHEN bloodpressure <= 100 THEN '80-100'
        WHEN bloodpressure <= 110 THEN '101-110'
        ELSE '111-140'
    END AS bp_band,
    COUNT(*) AS n,
    ROUND(MEDIAN(claim)) AS median_claim,
    ROUND(MIN(claim)) AS min_claim,
    ROUND(MAX(claim)) AS max_claim
FROM insurance_cleaned
GROUP BY smoker, bp_band
ORDER BY smoker, MIN(bloodpressure);

-- Smokers only: is the blood pressure pattern explained by BMI 30?
SELECT
    CASE
        WHEN bloodpressure <= 100 THEN '80-100'
        WHEN bloodpressure <= 110 THEN '101-110'
        ELSE '111-140'
    END AS bp_band,
    bmi >= 30 AS bmi_30_plus,
    COUNT(*) AS n,
    ROUND(MEDIAN(claim)) AS median_claim
FROM insurance_cleaned
WHERE smoker
GROUP BY bp_band, bmi_30_plus
ORDER BY MIN(bloodpressure), bmi_30_plus;
