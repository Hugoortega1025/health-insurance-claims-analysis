-- Get basic statistics for the numeric columns in the `insurance` table.

-- Average values
SELECT
    ROUND(AVG(age), 2) AS avg_age,
    ROUND(AVG(bmi), 2) AS avg_bmi,
    ROUND(AVG(bloodpressure), 2) AS avg_bloodpressure,
    ROUND(AVG(children), 2) AS avg_children,
    ROUND(AVG(claim), 2) AS avg_claim
FROM insurance;

-- Minimum and maximum values
SELECT
    MIN(age) AS min_age,
    MAX(age) AS max_age,
    MIN(bmi) AS min_bmi,
    MAX(bmi) AS max_bmi,
    MIN(bloodpressure) AS min_bloodpressure,
    MAX(bloodpressure) AS max_bloodpressure,
    MIN(children) AS min_children,
    MAX(children) AS max_children,
    MIN(claim) AS min_claim,
    MAX(claim) AS max_claim

FROM insurance;

-- Median values
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY age) AS median_age,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY bmi) AS median_bmi,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY bloodpressure) AS median_bloodpressure,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY children) AS median_children,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY claim) AS median_claim
FROM insurance;

-- Standard deviation values
SELECT
    ROUND(STDDEV(age), 2) AS stddev_age,
    ROUND(STDDEV(bmi), 2) AS stddev_bmi,
    ROUND(STDDEV(bloodpressure), 2) AS stddev_bloodpressure,
    ROUND(STDDEV(children), 2) AS stddev_children,
    ROUND(STDDEV(claim), 2) AS stddev_claim
FROM insurance;