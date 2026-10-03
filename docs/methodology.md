# Methodology

This document defines the 7 steps of the project. Each step lists its **objective**, **inputs**, **tasks**, **outputs**, **key questions**, and **skills practiced**.

**Business question:** *Which personal and health characteristics are associated with higher health insurance claim amounts, and how accurately can we estimate an individual's claim amount from them?*

**Target variable:** `claim`, the insurance claim amount (continuous). This makes it a **regression** problem.

The steps are ordered, but real projects iterate. If a later step shows a problem in an earlier one, go back, fix it, and record the change in `docs/project_log.md`.

---

## Step 1: Business Understanding and Data Setup

- **Objective:** Define the problem precisely and load the data reproducibly.
- **Inputs:** `data/raw/insurance.csv` (downloaded by `src/data/download_data.py`).
- **Tasks:**
  - Write the problem statement. The audience is an insurer's pricing/underwriting team. What would they do with a claim estimate, and with an understanding of what drives claims?
  - Decide what "good enough" accuracy means. How large an error (in dollars) would still be useful?
  - Load the CSV into a DuckDB database as a raw table (`sql/01_load/`), without modifying it.
  - Record the data's provenance and its limitations. The origin is undocumented, so we can't assume the data is real.
- **Outputs:** Problem statement in the README; load script; project log entry.
- **Key questions:** Who would use this model, and for what decision? Which variables would be legal or ethical to use in real insurance pricing?
- **Skills practiced:** Problem framing, reproducible data loading.

## Step 2: Data Profiling and Quality Assessment (SQL)

- **Objective:** Understand exactly what is in the data and find problems before analyzing it.
- **Inputs:** Raw table in DuckDB.
- **Tasks (write each as a SQL query in `sql/02_profiling/`):**
  - Row count; is `Id` unique?
  - Missing values per column.
  - Numeric columns: min, max, mean, median, and percentiles. Are any values impossible or suspicious?
  - Categorical columns: the distinct values and their counts. Are spellings and capitalization consistent?
  - Duplicate rows (ignoring `Id`).
  - Write down a handling rule for each issue found (fix, drop, impute, keep) with a justification.
- **Outputs:** Profiling SQL files; `notebooks/01_data_profiling.ipynb` (runs the SQL and shows the results); a filled-in `docs/data_dictionary.md`; a short data-quality summary in `reports/findings/`.
- **Key questions:** What does one row represent? If values are missing, are they missing randomly, or more often for certain groups? Could dropping rows bias the results?
- **Skills practiced:** SQL aggregation, `GROUP BY`, `CASE WHEN`, percentiles, data-quality thinking.

## Step 3: Exploratory Data Analysis

- **Objective:** Understand how `claim` behaves and how it relates to each variable, then turn the patterns into hypotheses.
- **Inputs:** Cleaned data (quality rules from Step 2 applied).
- **Tasks:**
  - The distribution of `claim`: shape, skewness, outliers. Would a log transformation help?
  - Relationship of `claim` with each variable (scatter plots for numeric variables, box plots for categorical ones).
  - Relationships between predictors (correlations); possible interactions (does the effect of one variable depend on another?).
  - Segment summaries in SQL (`sql/03_analysis/`), e.g., average and median claim by group.
  - Write a hypothesis list for Step 4, kept separate from conclusions.
- **Outputs:** `notebooks/02_eda.ipynb`; figures in `reports/figures/`; hypothesis list.
- **Key questions:** Which variables appear to matter most? Are the patterns linear? Are any groups too small to trust?
- **Skills practiced:** pandas, matplotlib/seaborn, SQL summaries, hypothesis generation.

## Step 4: Statistical Analysis

- **Objective:** Test the EDA hypotheses rigorously and quantify each effect with uncertainty.
- **Inputs:** Hypotheses from Step 3; cleaned data.
- **Tasks:**
  - **Group comparisons:** Welch's t-test or Mann–Whitney for two groups; ANOVA or Kruskal–Wallis for more than two. Choose based on the distributions, and report effect sizes and confidence intervals, not only p-values.
  - **Multiple linear regression** (statsmodels): estimate each variable's effect while holding the others constant.
  - **Regression diagnostics:** residual plots, heteroscedasticity, normality of residuals, multicollinearity (VIF). Try a log-transformed target if the diagnostics call for it, and learn how that changes the interpretation of the coefficients.
  - **Interaction terms** for the interactions suggested in Step 3.
  - Explain clearly why these results show **association, not causation**.
- **Outputs:** `notebooks/03_statistical_analysis.ipynb`; regression tables with interpretation.
- **Key questions:** Which effects remain significant after controlling for the other variables? Are the regression assumptions reasonably met? What does a coefficient mean in plain dollars?
- **Skills practiced:** Hypothesis testing, linear regression, diagnostics, transformations, statsmodels.

## Step 5: Predictive Modeling and Interpretation

- **Objective:** Build and honestly evaluate models that predict `claim`, and explain what drives their predictions.
- **Inputs:** Cleaned data.
- **Tasks:**
  - **Train/test split** with a fixed random seed. The test set is held out until the very end.
  - **Preprocessing in a scikit-learn pipeline** (imputation, encoding, scaling), fit on training data only to avoid leakage.
  - **Baseline:** always predict the training mean (or median). Every model must beat this.
  - **Models:** linear regression, regularized regression (Ridge/Lasso), random forest, gradient boosting.
  - **Evaluation:**
    - 5-fold cross-validation on the training set
    - metrics: MAE (average error in dollars), RMSE, R²
    - final, single evaluation on the test set
  - **Error analysis:** for which groups does the model make its biggest errors?
  - **Interpretation:** linear coefficients, permutation importance, partial dependence plots. Do these agree with Step 4?
  - **Fairness discussion:** should `gender` or `region` be used to price insurance? Compare model performance with and without them.
- **Outputs:** `notebooks/04_modeling.ipynb`; reusable code in `src/models/`; a model comparison table.
- **Key questions:** How much better than the baseline is the best model, in dollars? Is a complex model worth it compared with a simple, explainable one? Where does the model fail?
- **Skills practiced:** scikit-learn pipelines, cross-validation, regression metrics, regularization, tree-based models, interpretability.

## Step 6: Tableau Dashboard

- **Objective:** Communicate the key findings to a non-technical audience.
- **Inputs:** Cleaned data; results from Steps 3–5.
- **Tasks:**
  - Export a tidy file for Tableau (SQL in `sql/03_analysis/`).
  - Build a one-page dashboard: KPIs (number of people, average and median claim), claim by key drivers, segment comparisons, and a short "what this means" panel.
  - Publish to Tableau Public.
- **Outputs:** Workbook in `tableau/`; screenshot in `reports/figures/`; public link.
- **Key questions:** Can a manager find the main takeaway within 10 seconds? Does any chart overstate certainty?
- **Skills practiced:** Dashboard design, data storytelling, Tableau.

## Step 7: Recommendations and Final Documentation

- **Objective:** Turn the results into clear recommendations and present the project professionally.
- **Inputs:** All results.
- **Tasks:**
  - Write 3–5 recommendations linked to specific evidence, each stating whether the evidence shows association or causation.
  - Finalize the README: question, data, approach, key results (real ones only), visuals, how to reproduce.
  - Write a "Limitations" section covering dataset size, undocumented provenance, association vs. causation, and fairness considerations.
  - Confirm the project runs end to end from a fresh environment; lock exact package versions.
- **Outputs:** Recommendations in `reports/findings/`; polished README; `requirements-lock.txt`.
- **Key questions:** Could a stranger reproduce the project from the README alone? Is every claim backed by something in the repo?
- **Skills practiced:** Business communication, technical writing, reproducibility.
