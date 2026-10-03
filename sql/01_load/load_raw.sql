-- Step 1: Load the raw CSV into DuckDB as the table `insurance`.
-- Run from the project root inside the DuckDB shell:
--     .read sql/01_load/load_raw.sql

-- Write your CREATE OR REPLACE TABLE statement below:

CREATE OR REPLACE TABLE insurance AS SELECT * FROM read_csv_auto('data/raw/insurance.csv');

