# Data Dictionary

> **Status:** Column names are listed from the file header. The descriptions are **assumptions to verify**: the source has no documentation. The "Observed" columns are filled in during Step 2 from actual profiling results, never from guesses.

## `insurance` (raw)

- **Source:** https://github.com/Onurbltc/InsuranceData, `insurance.csv` (downloaded 2026-10-01)
- **SHA-256:** `2e35f2fddde9824c3e0978a0ed2a0fc0a357386ffe2f5218399b820b6018b86e`
- **Provenance:** Undocumented (possibly synthetic)
- **Grain:** One row per policyholder
- **Primary key:** `Id`. Verified unique: `COUNT(*) = COUNT(DISTINCT Id)` (`sql/02_profiling/01_row_count_and_keys.sql`)
- **Row count (observed):** 1,340

| Field | Type (observed) | Assumed meaning (verify) | Range / values (observed) | % Missing (observed) | Notes |
|-------|-----------------|--------------------------|---------------------------|----------------------|-------|
| `Id` | BIGINT | Row identifier | | 0% | Unique |
| `age` | DOUBLE | Age in years | 18–60; mean 38.08, median 38 | 0.37% (5) | Stored as decimal, but all values are whole numbers (0 rows where `age <> FLOOR(age)`); missing in Ids 3–7 |
| `gender` | VARCHAR | Gender | male 678 (50.6%), female 662 (49.4%) | 0% | Consistent lowercase values |
| `bmi` | DOUBLE | Body mass index | 16.0–53.1; mean 30.67, median 30.4 | 0% | Extreme but plausible at both ends |
| `bloodpressure` | BIGINT | Blood pressure (type and unit unknown) | 80–140; mean 94.16, median 92 | 0% | Single value. Unclear whether systolic or diastolic (limitation) |
| `diabetic` | BOOLEAN | Diabetes status | true 642 (47.9%), false 698 (52.1%) | 0% | Raw values Yes/No; DuckDB auto-converted to boolean. Prevalence far above the real-world adult rate (~1 in 10), suggesting synthetic or non-representative data |
| `children` | BIGINT | Number of dependent children | 0–5; mean 1.09, median 1 | 0% | |
| `smoker` | BOOLEAN | Smoker status | true 274 (20.4%), false 1,066 (79.6%) | 0% | Raw values Yes/No; DuckDB auto-converted to boolean |
| `region` | VARCHAR | US region | southeast 443, northwest 349, southwest 314, northeast 231 | 0.22% (3) | 4 consistent lowercase values; missing in Ids 14–16 |
| `claim` | DOUBLE | Claim amount (currency/period unknown) | 1,121.87–63,770.43; mean 13,252.75, median 9,369.62, SD 12,109.61 | 0% | **Target.** Mean ≫ median → right-skewed |

Missing values: `sql/02_profiling/02_missing_values.sql`. Category counts: `sql/02_profiling/05_categorical_values.sql`. Ranges: `sql/02_profiling/04_statistics.sql` (computed on all 1,340 rows, before dropping incomplete ones). Types: `PRAGMA table_info(insurance)`.

## Derived fields

| Field | Definition | Source fields | Created in |
|-------|------------|---------------|------------|
| | | | |
