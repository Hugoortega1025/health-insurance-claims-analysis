-- Get value counts for categorical columns in the `insurance` table.
-- Gender
SELECT
    gender,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM insurance
GROUP BY gender
ORDER BY count DESC;

-- Region
SELECT
    region,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM insurance
GROUP BY region
ORDER BY count DESC;

-- Smoker
SELECT
    smoker,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM insurance
GROUP BY smoker
ORDER BY count DESC;


-- Diabetic
SELECT
    diabetic,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM insurance
GROUP BY diabetic
ORDER BY count DESC;
