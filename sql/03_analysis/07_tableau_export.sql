-- Step 6: Export one row per member, with readable labels, for Tableau.
-- Run from the project root inside the DuckDB shell:
--     .read sql/03_analysis/07_tableau_export.sql

COPY (
    SELECT
        Id,
        age,
        gender,
        region,
        children,
        bmi,
        bloodpressure,
        claim AS claim_amount,
        CASE WHEN smoker THEN 'Smoker' ELSE 'Non-smoker' END AS smoking_status,
        CASE WHEN bmi >=30 THEN 'BMI 30+' ELSE 'BMI under 30' END AS bmi_group,
        CASE WHEN diabetic THEN 'Diabetic' ELSE 'Not diabetic' END AS diabetic_status
    FROM insurance_cleaned
) TO 'data/processed/tableau_members.csv' (HEADER);
