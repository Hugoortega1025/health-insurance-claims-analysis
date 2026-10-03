# Data Quality Summary (Step 2)

**Dataset:** `data/raw/insurance.csv`: 1,340 rows, 10 columns, one row per policyholder.
**Source:** https://github.com/Onurbltc/InsuranceData (provenance undocumented).
**Queries:** `sql/02_profiling/`. Every result below comes from running those queries.

## Checks performed

| Check | Query | Result |
|-------|-------|--------|
| Row count and key uniqueness | `01_row_count_and_keys.sql` | 1,340 rows; `Id` is unique |
| Missing values | `02_missing_values.sql` | `age`: 5 missing (Ids 3–7); `region`: 3 missing (Ids 14–16); all other columns complete |
| Row order | `03_sort_order.sql` | Ordered by `Id`, only 2 rows have a lower claim than the row before them, so the file is almost entirely sorted by `claim` |
| Numeric ranges | `04_statistics.sql` | No impossible values (details below) |
| Whole-number ages | ad hoc query | 0 rows with a fractional `age` |
| Categorical values | `05_categorical_values.sql` | Consistent spelling in every category; no unexpected values |

## Numeric summary (all 1,340 rows, before cleaning)

| Column | Min | Max | Mean | Median | SD |
|--------|-----|-----|------|--------|----|
| `age` | 18 | 60 | 38.08 | 38 | 11.10 |
| `bmi` | 16.0 | 53.1 | 30.67 | 30.4 | 6.11 |
| `bloodpressure` | 80 | 140 | 94.16 | 92 | 11.43 |
| `children` | 0 | 5 | 1.09 | 1 | 1.21 |
| `claim` | 1,121.87 | 63,770.43 | 13,252.75 | 9,369.62 | 12,109.61 |

## Categorical summary

| Column | Values |
|--------|--------|
| `gender` | male 678 (50.6%), female 662 (49.4%) |
| `region` | southeast 443 (33.1%), northwest 349 (26.0%), southwest 314 (23.4%), northeast 231 (17.2%), missing 3 |
| `smoker` | no 1,066 (79.6%), yes 274 (20.4%) |
| `diabetic` | no 698 (52.1%), yes 642 (47.9%) |

## Issues and decisions

| Issue | Decision | Rationale |
|-------|----------|-----------|
| 8 rows (0.6%) missing `age` or `region` | **Dropped** in `insurance_cleaned` (1,332 rows). The raw table is unchanged. | Very small share; dropping is simpler and more defensible than inventing values |
| File is nearly sorted by `claim` | No change to the data. **Shuffle before the train/test split** in Step 5 | An ordered split would train on low claims and test on high ones |
| `Id` follows the claim ordering | **Never use `Id` as a model feature** | It would leak the target |

## Observations for later steps

- **`claim` is right-skewed.** The mean is ~3,900 above the median and the SD is close to the mean, so a minority of large claims pulls the average up. Report medians as "typical" values, and consider a log transformation in Step 4.
- **The missing values are not completely random.** All 8 incomplete rows are low-claim, male, non-smokers with 0 children, in two blocks of consecutive Ids. Because only 0.6% of rows are affected, the effect of dropping them should be negligible, but this is reported as a limitation.

## Limitations

- **Undocumented provenance.** Diabetes prevalence (47.9%) is far above the real-world adult rate (roughly 1 in 10), which suggests the data is synthetic or not representative. Findings describe this dataset, not real-world insurance.
- **`bloodpressure` is a single value** of unknown type (systolic or diastolic) and unit, which limits its interpretation.
- **Units of `claim` are unknown** (currency and time period).
