-- Step 2 (found during Step 3 EDA): Age range by gender and smoking status.
-- Run from the project root inside the DuckDB shell:
--     .read sql/02_profiling/06_age_range_by_gender.sql

-- Men and women cover different age ranges (men 18-50, women 25-60)
SELECT
    smoker,
    gender,
    COUNT(*) AS n,
    MIN(age) AS min_age,
    MAX(age) AS max_age
FROM insurance_cleaned
GROUP BY smoker, gender
ORDER BY smoker, gender;
