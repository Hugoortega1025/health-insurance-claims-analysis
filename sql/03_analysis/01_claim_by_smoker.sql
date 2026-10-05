-- Step 3: Claim distribution by smoking status (supports the smoker box plot).
-- Run from the project root inside the DuckDB shell:
--     .read sql/03_analysis/01_claim_by_smoker.sql

-- Median, quartiles, IQR, range, and box-plot outliers (beyond 1.5 x IQR) per group
WITH stats AS (
    SELECT
        smoker,
        COUNT(*) AS n,
        AVG(claim) AS mean_claim,
        MEDIAN(claim) AS median_claim,
        QUANTILE_CONT(claim, 0.25) AS q1,
        QUANTILE_CONT(claim, 0.75) AS q3,
        MIN(claim) AS min_claim,
        MAX(claim) AS max_claim
    FROM insurance_cleaned
    GROUP BY smoker
)
SELECT
    s.smoker,
    s.n,
    ROUND(s.mean_claim) AS mean_claim,
    ROUND(s.median_claim) AS median_claim,
    ROUND(s.q1) AS q1,
    ROUND(s.q3) AS q3,
    ROUND(s.q3 - s.q1) AS iqr,
    ROUND(s.min_claim) AS min_claim,
    ROUND(s.max_claim) AS max_claim,
    (
        SELECT COUNT(*)
        FROM insurance_cleaned c
        WHERE c.smoker = s.smoker
          AND (c.claim > s.q3 + 1.5 * (s.q3 - s.q1)
               OR c.claim < s.q1 - 1.5 * (s.q3 - s.q1))
    ) AS n_outliers
FROM stats s
ORDER BY s.smoker;
