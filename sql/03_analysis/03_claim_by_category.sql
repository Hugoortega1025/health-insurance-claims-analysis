-- Step 3: Claim distribution by gender, region and diabetic status (supports the box plots).
-- Run from the project root inside the DuckDB shell:
--     .read sql/03_analysis/03_claim_by_category.sql
-- smoker_pct is included because smoking is the strongest pattern so far:
-- a group with more smokers will show higher claims for that reason alone.

-- One row per category value: size, quartiles, IQR, and share of smokers
WITH long AS (
    SELECT 'gender' AS variable, gender AS value, claim, smoker, bmi FROM insurance_cleaned
    UNION ALL
    SELECT 'region', region, claim, smoker, bmi FROM insurance_cleaned
    UNION ALL
    SELECT 'diabetic', CAST(diabetic AS VARCHAR), claim, smoker, bmi FROM insurance_cleaned
)
SELECT
    variable,
    value,
    COUNT(*) AS n,
    ROUND(MEDIAN(claim)) AS median_claim,
    ROUND(QUANTILE_CONT(claim, 0.25)) AS q1,
    ROUND(QUANTILE_CONT(claim, 0.75)) AS q3,
    ROUND(QUANTILE_CONT(claim, 0.75) - QUANTILE_CONT(claim, 0.25)) AS iqr,
    ROUND(100 * AVG(smoker::INT), 1) AS smoker_pct,
    ROUND(100 * AVG((bmi >= 30)::INT), 1) AS bmi_30_plus_pct
FROM long
GROUP BY variable, value
ORDER BY variable, median_claim DESC;

-- Same medians within non-smokers only, to remove the effect of smoking
SELECT 'gender' AS variable, gender AS value, COUNT(*) AS n, ROUND(MEDIAN(claim)) AS median_claim
FROM insurance_cleaned WHERE NOT smoker GROUP BY gender
UNION ALL
SELECT 'region', region, COUNT(*), ROUND(MEDIAN(claim))
FROM insurance_cleaned WHERE NOT smoker GROUP BY region
UNION ALL
SELECT 'diabetic', CAST(diabetic AS VARCHAR), COUNT(*), ROUND(MEDIAN(claim))
FROM insurance_cleaned WHERE NOT smoker GROUP BY diabetic
ORDER BY variable, median_claim DESC;
