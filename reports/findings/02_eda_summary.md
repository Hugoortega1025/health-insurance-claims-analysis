# Exploratory Data Analysis Summary (Step 3)

Dataset: `insurance_cleaned`, 1,332 policyholders (the raw 1,340 rows minus 8 with missing values; see `01_data_quality_summary.md`).
Notebook: `notebooks/02_eda.ipynb`. Queries: `sql/03_analysis/` and `sql/02_profiling/06_age_range_by_gender.sql`. Every number below comes from running them.

These are descriptive patterns, not tested conclusions. They show association, not cause, and they describe this dataset only. Its origin is undocumented and several patterns suggest it may be synthetic. Claim units are unknown, so amounts are shown as plain numbers.

## What was found

### 1. Claims are right-skewed

| Statistic | Value |
|---|---|
| Median | 9,413 |
| Mean | 13,325 |
| Middle 50% | 4,760 to 16,781 |
| Share over 30,000 | 12.2% |
| Skewness (raw / log) | 1.51 / -0.07 |

Medians are used as the typical value throughout. On the log scale the tail disappears, but the shape still has several peaks, so a log transformation is not automatically the right choice for modeling.

### 2. Smoking is the largest single difference

| | n | Median claim | Middle 50% |
|---|---|---|---|
| Non-smokers | 1,058 | 7,365 | 4,034 to 11,365 |
| Smokers | 274 | 34,456 | 20,826 to 41,019 |

Smokers' median claim is about 4 to 5 times that of non-smokers, and their claims form two distinct peaks (around 20,000 and 40,000).

### 3. Smoking and BMI interact

| Median claim | BMI under 30 | BMI 30 or more | Change at BMI 30 |
|---|---|---|---|
| Non-smokers | 6,770 (n=501) | 8,117 (n=557) | +1,347 |
| Smokers | 20,167 (n=129) | 40,904 (n=145) | +20,737 |

BMI separates the two groups of smokers: 144 of 145 smokers with a BMI of 30 or more claim over 30,000, compared with 8 of 129 below 30. For non-smokers, BMI makes little difference. The relationship between BMI and claims depends on smoking status, so a model needs a smoking-by-BMI term.

### 4. Blood pressure overlaps with smoking and BMI

| Blood pressure | Non-smokers: n | Median | Smokers: n | Median |
|---|---|---|---|---|
| 80 to 100 | 942 | 6,625 | 132 | 23,323 |
| 101 to 110 | 105 | 11,743 | 64 | 25,520 |
| 111 to 140 | 11 | 28,288 | 78 | 39,667 |

Its correlation with claims is 0.53, but it is also correlated with smoking (0.42). Among smokers, 68 of the 78 people above 110 also have a BMI of 30 or more, and with BMI held fixed the blood-pressure pattern mostly disappears. Among non-smokers, claims do rise with blood pressure, but the top band has only 11 people.

### 5. The northeast has higher claims

Its median is 13,130, compared with 7,403 to 9,123 in the other regions. It has the most smokers (29.0%), but it stays highest among non-smokers (11,045 compared with 6,184 to 7,479) and has the lowest share with a BMI of 30 or more (46.3%).

### 6. Little visible relationship

- Age: correlation -0.03, and no pattern among smokers.
- Gender: medians of 9,439 (men) and 9,413 (women). Men's wider spread matches their higher smoking rate (23.7% compared with 17.4%).
- Diabetic status: medians of 9,620 and 9,302.
- Children: medians move between about 8,500 and 11,000 with no trend. The 4- and 5-children groups have only 25 and 18 people.

## Data-quality observations

- Men are aged 18 to 50 and women 25 to 60, with no overlap at either end. Gender and age are therefore confounded.
- Three patterns are unusually clean for real data: the jump in claims at a BMI of 30, the edge at a blood pressure of 100 (89% of non-smokers are at or below it), and the gender-specific age ranges. Together with the 47.9% diabetes rate found in Step 2, they suggest the data may be synthetic.

## Hypotheses for Step 4

1. Smoking is associated with higher claims and is the strongest single factor.
2. The association between a BMI of 30 or more and claims is much larger for smokers than for non-smokers (interaction).
3. Blood pressure adds little once smoking and BMI are in the model, except possibly among non-smokers.
4. The northeast is associated with higher claims after controlling for smoking, BMI and age.
5. Age shows little association with claims.
6. Gender, diabetic status and number of children show little association once other variables are controlled for.

## Modeling notes

- Compare models on raw and log claims using residual diagnostics.
- Test a BMI-30 indicator interacted with smoking, rather than BMI as a straight line only.
- Interpret gender only in a model that also includes age.
- Consider grouping 3 or more children.
- Never use `Id` as a predictor, because the file is sorted by claim.
