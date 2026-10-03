-- Identify missing values in the insurance dataset & pct of missing values per column
SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN age IS NULL THEN 1 END) AS missing_age,
    ROUND(COUNT(CASE WHEN age IS NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS pct_missing_age,
    COUNT(CASE WHEN gender IS NULL THEN 1 END) AS missing_gender,
    ROUND(COUNT(CASE WHEN gender IS NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS pct_missing_gender,
    COUNT(CASE WHEN bmi IS NULL THEN 1 END) AS missing_bmi,
    ROUND(COUNT(CASE WHEN bmi IS NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS pct_missing_bmi,
    COUNT(CASE WHEN bloodpressure IS NULL THEN 1 END) AS missing_bloodpressure,
    COUNT(CASE WHEN diabetic IS NULL THEN 1 END) AS missing_diabetic,
    ROUND(COUNT(CASE WHEN diabetic IS NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS pct_missing_diabetic,
    COUNT(CASE WHEN children IS NULL THEN 1 END) AS missing_children,
    ROUND(COUNT(CASE WHEN children IS NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS pct_missing_children,
    COUNT(CASE WHEN smoker IS NULL THEN 1 END) AS missing_smoker,
    ROUND(COUNT(CASE WHEN smoker IS NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS pct_missing_smoker,
    COUNT(CASE WHEN region IS NULL THEN 1 END) AS missing_region,
    ROUND(COUNT(CASE WHEN region IS NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS pct_missing_region,
    COUNT(CASE WHEN claim IS NULL THEN 1 END) AS missing_claims,
    ROUND(COUNT(CASE WHEN claim IS NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS pct_missing_claims
FROM insurance;