-- Step 3: Claim distribution by number of children (supports the box plot).
-- Run from the project root inside the DuckDB shell:
--     .read sql/03_analysis/04_claim_by_children.sql

-- Group size matters here: small groups give unreliable medians
SELECT
    children,
    COUNT(*) AS n,
    ROUND(MEDIAN(claim)) AS median_claim,
    ROUND(QUANTILE_CONT(claim, 0.25)) AS q1,
    ROUND(QUANTILE_CONT(claim, 0.75)) AS q3,
    ROUND(100 * AVG(smoker::INT), 1) AS smoker_pct
FROM insurance_cleaned
GROUP BY children
ORDER BY children;
