-- Step 2: Profile the data in the `insurance` table.
-- Run from the project root inside the DuckDB shell:
--     .read sql/02_profiling/01_row_count_and_keys.sql

-- Get the row count of the `insurance` table & Count distinct IDs
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_ids
FROM insurance;

