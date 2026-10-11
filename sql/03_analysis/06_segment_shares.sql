-- Step 6: Share of members and share of claim costs for each smoking x BMI 30+ group.
-- Run from the project root inside the DuckDB shell:
--     .read sql/03_analysis/06_segment_shares.sql

SELECT
    smoker,
    bmi >= 30 AS bmi_30_plus,
    COUNT(*) AS members,
    ROUND(SUM(claim), 0) AS total_claim_amount,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_members,
   ROUND(100.0 * SUM(claim) / SUM(SUM(claim)) OVER (), 1) AS pct_of_claim_amount
FROM insurance_cleaned
GROUP BY smoker, bmi_30_plus
ORDER BY smoker, bmi_30_plus;
