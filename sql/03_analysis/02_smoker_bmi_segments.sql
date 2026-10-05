-- Step 3: Claims by smoking status and the BMI 30 (obesity) threshold.
-- Run from the project root inside the DuckDB shell:
--     .read sql/03_analysis/02_smoker_bmi_segments.sql

-- Smokers only: does BMI 30 separate the two peaks in the claim distribution?
SELECT
    bmi >= 30 AS bmi_30_plus,
    COUNT(*) AS n,
    ROUND(MEDIAN(claim)) AS median_claim,
    ROUND(MIN(claim)) AS min_claim,
    ROUND(MAX(claim)) AS max_claim,
    SUM(CASE WHEN claim > 30000 THEN 1 ELSE 0 END) AS n_over_30k
FROM insurance_cleaned
WHERE smoker
GROUP BY bmi_30_plus
ORDER BY bmi_30_plus;

-- Everyone: median claim for each smoker x BMI 30 combination (interaction check)
SELECT
    smoker,
    bmi >= 30 AS bmi_30_plus,
    COUNT(*) AS n,
    ROUND(MEDIAN(claim)) AS median_claim
FROM insurance_cleaned
GROUP BY smoker, bmi_30_plus
ORDER BY smoker, bmi_30_plus;
