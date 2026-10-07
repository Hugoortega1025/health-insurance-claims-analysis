# Project Log

A dated record of major decisions, methodology changes, and their rationale. Newest entries at the bottom.

Entry template:

```
## YYYY-MM-DD: <Title>
**Phase:** <n. name>
**Decision / Change:**
**Rationale:**
**Alternatives considered:**
**Consequences / follow-ups:**
```

---

## 2026-10-01: Project initialization

**Phase:** 1. Business understanding → 2. Data acquisition

**Decision / Change:**
- Created the repository structure (`data/`, `sql/`, `notebooks/`, `src/`, `tableau/`, `reports/`, `docs/`).
- Wrote the initial README, CLAUDE.md, methodology document (21 phases), data dictionary template, `.gitignore`, `.env.example`, and `requirements.txt`.
- Created placeholder notebooks containing only a title and purpose. No analysis yet.

**Rationale:**
- A consistent structure keeps raw, intermediate, and processed data separate. It also separates exploration (notebooks) from reusable code (`src/`) and SQL by layer, which makes the pipeline reproducible.
- Writing the methodology before seeing the data guards against shaping the questions to fit whatever results appear.

**Tentative choices (to be confirmed later):**
- **DuckDB** as the local SQL engine. It is file-based, needs no server, reads CSV/Parquet directly, and its SQL dialect is standard enough to carry over to other warehouses. To be confirmed in Phase 5.
- LLM and embedding providers are **not yet chosen** (Phase 14 / 17). `.env.example` uses provider-neutral placeholders.

**Notes:**
- Phase 1 (business understanding) is captured only at a high level in the README. Before modeling, a precise **churn definition** (e.g., non-renewal within N days of expiry) and the **prediction window** must be written down. These depend on what fields the chosen data contains.
- The project is not yet a git repository. Run `git init` before the first commit.

**Open decision (blocking Phase 3):**
- Choose the data-source strategy (see the Phase 2 assessment).

---

## 2026-10-01: Data-source decision

**Phase:** 2. Data acquisition

**Decision / Change:**
- **Structured core: KKBox Churn Prediction Challenge (WSDM 2018, Kaggle).** This is real, anonymized data from a Taiwanese music-streaming subscription service. We take a disk-limited subset:
  - `members_v3`: customer attributes
  - `transactions` + `transactions_v2`: full billing and subscription history
  - `train_v2`: churn labels
  - `user_logs_v2`: one month of daily listening activity
  - The full `user_logs` file (~30 GB uncompressed) is **excluded**.
- **Text source: Customer Support on Twitter (Kaggle, ThoughtVector)**, filtered to conversations with Spotify's support account (@SpotifyCares). These are real customer complaints from the same industry (music-streaming subscriptions). Only the filtered subset is kept.
- **Linkage: deferred to Phase 16.** The text and the KKBox customers are different people, and they will not be joined. Phases 14, 15, 17 and 18 run on the real text alone. The question of whether to build a clearly labeled simulated linkage for objective 5 will be decided when we reach Phase 16.
- **Storage:** Each file is downloaded, extracted, converted to Parquet, and the archive and CSV are then deleted, one file at a time. The Parquet copy is treated as the immutable raw layer. Row counts and source file names are recorded at conversion time.

**Rationale:**
- KKBox is one of the few public churn datasets with **timestamped, multi-table** subscription data. That makes it possible to practice point-in-time features, leakage prevention and realistic SQL. IBM Telco is a single snapshot with no dates, and IBM describes the company in it as fictional.
- Using real text from the same industry keeps every text-based finding grounded in real customer language while staying small on disk.
- Deferring the linkage decision avoids committing to synthetic data before it is needed.

**Alternatives considered:**
- IBM Telco: rejected as the primary source (snapshot, fictional, overused). It stays the fallback if KKBox data can't be downloaded.
- CFPB complaints: real, but from financial services, which doesn't match the domain.
- Dropping text and RAG entirely: rejected. They are core project objectives, and a filtered subset fits the disk budget.
- Fully simulated data: rejected because it can't support real-world findings.

**Constraints:**
- About 11 GB of free disk space at decision time. Target footprint for the final raw layer: ~2 GB or less.
- KKBox is a Kaggle *competition* dataset. Downloading it requires accepting the competition rules, and the data may not be redistributed. The Twitter dataset's license must also be checked before publishing any derived data. Raw data is never committed to git (enforced in `.gitignore`).

**Consequences / follow-ups:**
- Because `user_logs_v2` covers only one month, usage features will be short-window. The prediction cutoff design in Phase 5/7 must account for this.
- Text findings describe music-streaming customers in general (Spotify support), **not** KKBox churners. All reporting must state this.

---

## 2026-10-01: Change of direction: smaller scope, Olist dataset

**Phase:** Re-scoping (before any data was downloaded)

**Decision / Change:**
- **Supersedes the data-source decision above.** KKBox and the Spotify support tweets are dropped. Nothing had been downloaded.
- New dataset: **Olist Brazilian E-Commerce** (Kaggle `olistbr/brazilian-ecommerce`). It is real, anonymized marketplace data with ~100k orders (2016–2018) in 9 linked tables, about 120 MB.
- New business question: *What drives negative customer reviews, and can we flag orders likely to receive one at the moment of delivery?*
- Draft definitions (to be confirmed in Step 1):
  - Target: bad review = score 1–2.
  - Prediction point: delivery to the customer.
- Methodology reduced from 21 phases to **8 steps** (see `docs/methodology.md`).
- **Removed from scope:** LLM extraction, RAG, embeddings, review-text NLP. Review text may be mentioned as future work.
- Repository changes:
  - removed `src/llm/` and `notebooks/05_nlp_llm.ipynb`;
  - renumbered the notebook headers to the new steps;
  - removed `py7zr` from requirements;
  - simplified `.env.example`.

**Rationale:**
- The user prefers a smaller, finishable project that clearly shows core skills (SQL, Python, statistics, ML, Tableau) over an ambitious one. A clean, complete project has more portfolio value than a half-finished large one.
- Olist's 9 linked tables make the SQL work substantive. Its small size fits the user's limited disk space.
- KKBox was estimated at ~70–90 hours even without the text components. Its download was uncertain, and its anonymized codes (e.g., "city 13") limit business storytelling. Olist is estimated at ~40–60 hours.

**Alternatives considered:**
- KKBox without text (real churn, but more effort and risk).
- UCI Online Retail II (mostly one table, so lighter SQL).
- IBM Telco (no dates, fictional, overused).

**Consequences / follow-ups:**
- Olist is a well-known Kaggle dataset, so the project has to stand out through a clear question, careful SQL, honest statistics and a model that only uses information available at prediction time.
- The project is no longer about subscription churn. A bad review serves as the measure of customer dissatisfaction.
- A/B testing (e.g., the Cookie Cats dataset) could become a separate small project later.

---

## 2026-10-01: Final project choice: health insurance claim prediction

**Phase:** Re-scoping (final)

**Decision / Change:**
- **Supersedes both earlier data decisions** (KKBox and Olist). Olist was never downloaded.
- The user chose the project: **predicting health insurance claim amounts** from a single CSV.
  - Source: https://github.com/Onurbltc/InsuranceData (`insurance.csv`)
  - Columns: `Id`, `age`, `gender`, `bmi`, `bloodpressure`, `diabetic`, `children`, `smoker`, `region`, `claim`
- Target: `claim` (continuous), so this is a regression problem.
- The methodology is now **7 steps** (see `docs/methodology.md`).
- Repository changes:
  - SQL folders: `01_load`, `02_profiling`, `03_analysis`
  - removed `data/interim/`, `src/features/` and `src/llm/`
  - removed `notebooks/05_nlp_llm.ipynb`
  - removed the Kaggle dependency; no secrets are needed
- Data downloaded with `src/data/download_data.py`:
  - file: 66 KB, 1,341 lines including the header
  - SHA-256 `2e35f2fddde9824c3e0978a0ed2a0fc0a357386ffe2f5218399b820b6018b86e`

**Rationale:**
- It is the user's choice, and the user stated it is final.
- The scope is small and finishable. It still covers SQL, EDA, statistical inference (regression with diagnostics), ML (regularization, tree models, cross-validation), interpretation and Tableau.

**Known limitations (to address openly in the README):**
- **Provenance is undocumented.** The GitHub repo has no README or source attribution, and the data may be synthetic. Results describe this dataset only.
- The dataset is small (~1,340 rows), so estimates will carry real uncertainty, and complex models may not beat simple ones.
- Insurance-pricing datasets like this one are common in portfolios. The project should stand out through rigorous statistics, honest evaluation, and a fairness discussion (e.g., whether `gender`/`region` should be used in pricing).

**Consequences / follow-ups:**
- Step 1 still needs: a written problem statement, an acceptable-error threshold, and the DuckDB load script.
- Optional: rename the project folder from `customer-intelligence-ai` to match the new topic.

---

## 2026-10-01: Problem statement and success criterion

**Phase:** Step 1. Business understanding

**Decision / Change:**
- Problem statement written from the user's own framing and added to the README. The user is a pricing team, which estimates each person's likely claim so that higher-risk people pay a higher premium and the insurer doesn't lose money.
- **Success criterion:** MAE (mean absolute error, in dollars) clearly lower than a naive baseline that predicts the training-set average claim for everyone. A specific numeric threshold is **deferred until after Step 2**, when the claim distribution is known. Choosing it now would be a guess.

**Rationale:**
- There is no universal industry standard for acceptable prediction error. Comparing against a naive baseline is the standard, defensible way to judge whether a model adds value.

**Note for Step 5 (fairness):**
- Under the US Affordable Care Act, individual-market health premiums may vary only by age, tobacco use, location and family size, not by health status. Several variables in this dataset (BMI, blood pressure, diabetes) could therefore not legally be used for pricing in that market. This framing should be used in the fairness discussion.

---

## 2026-10-01: Tooling: run SQL in the DuckDB command-line shell

**Phase:** Step 1 → Step 2

**Problem:** Jupyter notebooks won't start on the user's machine. Both VS Code ("timeout waiting for the ports to get used") and `jupyter lab` fail. Diagnostics showed that:
- the kernel process itself starts normally;
- localhost connections work;
- DuckDB works from plain Python.

The root cause is still unknown.

**Decision / Change:**
- **Keep SQL and DuckDB** (they work). Steps 1–2 use the **DuckDB command-line shell** (`brew install duckdb`, v1.5.5). SQL is saved in numbered `.sql` files and run with `.read`. No notebooks are needed for the SQL steps.
- **Excel was considered and rejected** as the main tool. It can't show SQL/Python skills, and it isn't practical for regression diagnostics or ML.
- Notebooks are needed again from Step 3 (charts, statistics, ML). Before then, either fix local Jupyter or use **Google Colab** as a fallback (browser-based, no local install).

---

## 2026-10-02: Missing values: drop the 8 incomplete rows

**Phase:** Step 2. Data profiling and quality

**Findings** (`sql/02_profiling/02_missing_values.sql`):
- `age` is missing in 5 rows (Ids 3–7) and `region` in 3 rows (Ids 14–16). No other column has missing values.
- In total, 8 of 1,340 rows (0.6%) are incomplete.
- **The missingness is not completely random.** The 8 rows form two blocks of consecutive Ids, all with low claims (~1,136–1,256), and all are male, non-smoker, with 0 children. This looks like a localized data-entry issue, but it is concentrated in one part of the claim distribution.

**Decision:** Drop the 8 rows (complete-case analysis). The drop is applied in a cleaned table, never to the raw file.

**Rationale:**
- 0.6% of rows is very small. The dataset contains many other low-claim rows with similar profiles, so excluding these 8 should have a negligible effect.
- Dropping is simpler and easier to justify than imputation, which would invent `age`/`region` values.

**Alternatives considered:** Median/mode imputation, rejected for the reasons above. It could be reconsidered inside the Step 5 modeling pipeline.

**Limitation to report:** The missingness is clustered among low-claim rows, so it is not fully random. This will be stated in the README's data-quality section.

---

## 2026-10-02: Row order: the file is nearly sorted by claim

**Phase:** Step 2. Data profiling and quality

**Finding** (`sql/02_profiling/03_sort_order.sql`): Ordered by `Id`, only **2 rows** have a lower claim than the row before them, so the file is almost entirely sorted by `claim` in ascending order. `Id` therefore carries information about the target.

**Consequences:**
- **Step 5:** shuffle the rows (random split with a fixed seed) before creating train/test sets. An ordered split would train on low claims and test on high ones.
- **Step 5:** never use `Id` as a model feature. Because of the sort order it would leak the target.

---

## 2026-10-02: Step 2 complete

**Phase:** Step 2. Data profiling and quality

**Summary:**
- Profiling is complete; see `reports/findings/01_data_quality_summary.md`.
- The cleaned table `insurance_cleaned` (1,332 rows) is built by `sql/01_load/02_clean_data.sql`. The row count matched the expected 1,340 − 8.

**Other observations:**
- `age` values are all whole numbers.
- Category spellings are consistent.
- No numeric values are impossible.
- `bloodpressure` type is ambiguous.
- Diabetes prevalence (47.9%) suggests synthetic or non-representative data.
- `claim` is right-skewed (mean 13,252.75 vs. median 9,369.62).

**Success criterion update:** The numeric MAE threshold, previously deferred "until after Step 2", will be set in **Step 5**. There, the baseline MAE is computed on the training set and the model must clearly beat it. Claims vary widely (SD ≈ 12,100), so the threshold should be judged relative to that baseline, not as a fixed dollar amount chosen in advance.

---

## 2026-10-03: Root cause of notebook failures: iCloud evicted the virtual environment

**Phase:** Tooling (before Step 3)

**Problem:** Notebook kernels timed out in VS Code and JupyterLab, and `pip` froze.

**Root cause:** The project lives in `~/Documents`, which syncs to iCloud Drive with storage optimization. With the disk ~95% full, macOS had evicted **31,441 of 31,454 files** in the project's `.venv` to iCloud, leaving placeholder ("dataless") files. Every Python import had to download files on demand, which stalled kernel startup past VS Code's timeout and hung pip. Diagnosis: `python -X faulthandler` showed pip blocked while reading a module file, and `ls -lO` showed the `dataless` flag.

**Decision / Change:**
- Rebuilt the virtual environment outside iCloud at `~/.virtualenvs/insurance-claims` (781 MB).
- Removed the old `.venv`.
- Added `.vscode/settings.json` (gitignored) pointing VS Code to the new interpreter.
- Verified: a kernel starts in ~1.2 s and runs code.

**Supersedes:** The earlier plan to use Google Colab as a fallback. Local notebooks work again, so Steps 3–5 use the notebooks in `notebooks/`.

**Follow-up for the user:**
- Free disk space (~8 GB left).
- Consider moving the project out of `~/Documents`, or excluding it from iCloud, so that project files aren't evicted either.

---

## 2026-10-03: Version control and GitHub backup

**Phase:** Tooling

**Decision / Change:**
- Initialized Git (branch `main`).
- Pushed to a **private** GitHub repository: https://github.com/Hugoortega1025/health-insurance-claims-analysis
- Data files, the DuckDB database, `.vscode/` and caches are excluded by `.gitignore`. Data is reproducible via `src/data/download_data.py` and the SQL files.

**Rationale:**
- The user is moving to a new MacBook, and iCloud had been unreliable for this project. GitHub provides a dependable backup and full history, and it is where the portfolio will be shown.
- Private until the project is polished. Switching to public later preserves the history.

**New-machine setup:** clone into a folder outside `~/Documents` (e.g., `~/Projects`) to avoid iCloud eviction. Then recreate the environment and rebuild the database from the SQL files.

---

## 2026-10-04: Environment rebuilt on the new MacBook

**Phase:** Tooling (Step 3 in progress)

**Decision / Change:**
- The project stays in `~/Documents` for now (the user's choice). The virtual environment stays outside it, at `~/.virtualenvs/insurance-claims` (795 MB), so that iCloud can't evict it. `.vscode/settings.json` was recreated to point VS Code to it.
- Python **3.14.8** (python.org installer) replaces 3.13. All packages in `requirements.txt` installed without problems (e.g., pandas 3.0.6, scikit-learn 1.9.1, statsmodels 0.15.0, duckdb 1.5.6).
- Ran the installer's `Install Certificates.command` to fix the `CERTIFICATE_VERIFY_FAILED` error when downloading data.
- DuckDB CLI **1.5.6** installed with the official script (`curl https://install.duckdb.org | sh`) at `~/.duckdb/cli/latest/`, and added to PATH in `~/.zshrc`. Homebrew is not installed.
- Re-downloaded the data. The SHA-256 matches the 2026-10-01 value (`2e35f2fd…b86e`), so it is the identical file. The rebuilt database has 1,340 raw rows and 1,332 cleaned rows, matching Step 2.
- `notebooks/02_eda.ipynb` runs end to end (about 5 s).
- README Setup section updated to match (environment outside the project, database rebuild commands); status banner corrected.

**Rationale:**
- The official DuckDB installer needs no admin rights and takes ~50 MB, versus a full Homebrew install. Reusing the system Python avoids an extra download.

**Notes:**
- `requirements-lock.txt` is still deferred to Step 7, as planned.

---

## 2026-10-04: Data-quality finding: men and women cover different age ranges

**Phase:** Step 3. EDA (found while plotting smokers by gender and age)

**Finding** (`insurance_cleaned`, checked in DuckDB): in the whole dataset, men are aged **18–50** and women **25–60**. There are no men over 50 and no women under 25. The pattern holds for smokers and non-smokers alike.

**Consequences:**
- **Provenance:** further evidence that the data is synthetic or not representative, alongside the 47.9% diabetes prevalence. To be added to the README limitations.
- **Step 4:** `gender` and `age` are confounded. Any raw difference in claims between men and women may partly reflect age, so gender effects must be read from a multiple regression that holds age constant, not from a two-group comparison alone.
- **Step 5:** the fairness comparison with and without `gender` is less clean, because gender partly stands in for age.

**Decision:** No change to the data. This is a property of the dataset, not an error to fix.

---

## 2026-10-05: Step 3 complete

**Phase:** Step 3. EDA

**Summary:** See `reports/findings/02_eda_summary.md`. Main patterns:
- Smoking is the largest single difference: median claim 34,456 for smokers vs. 7,365 for non-smokers.
- Smoking and BMI interact. Smokers' claims form two peaks, separated by a BMI of 30. For smokers, a BMI of 30 or more adds about 20,700 to the median claim; for non-smokers, about 1,300.
- Blood pressure (r = 0.53 with claim) largely overlaps with smoking and, among smokers, with BMI.
- The northeast has higher claims, even among non-smokers.
- Age, gender, diabetic status and children show little visible relationship with claims.
- Six hypotheses and modeling notes for Step 4 are listed in the findings file and in the notebook.

**Decisions:**
- Medians are the typical value in all comparisons, because claims are right-skewed (skewness 1.51).
- Raw vs. log claims is **not** decided yet. Log claims have skewness near zero but several peaks, so Step 4 decides with residual diagnostics.
- A BMI-30 indicator interacted with smoking will be tested in Step 4, because BMI acts like a step for smokers rather than a straight line.
- Every number in the notebook's tables comes from a saved query: `sql/03_analysis/01`–`05`, plus `sql/02_profiling/06_age_range_by_gender.sql`.

**Corrections made during the step:**
- The first claim-distribution insight said "most claims fall between 8,000 and 13,000". The actual middle half is 4,760 to 16,781.
- A first reading suggested that blood pressure's link with claim held within each smoking group. Splitting smokers by BMI showed that among smokers it is mostly a BMI effect.
- The first age-by-gender chart showed an apparent spike of women aged 60. It was a binning artifact (ages 59 and 60 were drawn in one bar), fixed by plotting one bar per whole age.

**Notebook rewrite:**
- `notebooks/02_eda.ipynb` was restructured into nine sections that follow the order of the exploration.
- Markdown is written in the moment: what was seen at each point, with open questions. The overall summary at the top is labeled as written afterwards.
- No bold text. The tone mixes technical and plain language for GitHub readers.

---

## 2026-10-07: Step 4 complete

**Phase:** Step 4. Statistical analysis

**Summary:** See `reports/findings/03_statistical_analysis_summary.md`.
- Hypotheses 1, 2, 4 and 5 are supported, hypothesis 3 is not, and hypothesis 6 is partly supported (children is significant once smoking is held constant).

**Decisions:**
- **Final model: Model 2**, OLS on claim in dollars with a smoking × BMI 30+ interaction. R² 0.792; it removes Model 1's residual bands and heteroscedasticity (Breusch-Pagan p = 0.185).
- **Log(claim) rejected.** It fixes the residual skew but brings back heteroscedasticity and adds a systematic slope among smokers. Effects in this data appear to add up in dollars rather than multiply.
- **Gamma GLMs tried** because gamma is the industry standard for claim amounts.
  - The log link rejected, for the same reasons as the log model.
  - The identity link gives the same conclusions as Model 2, but its variance assumption fits this data worse. It is reported as a robustness check.
- **Robust standard errors (HC3)** used as a check; no conclusion changed.
- **Variables were not dropped for non-significance.** They were chosen before fitting; dropping them would overstate the remaining results, and age is needed to interpret gender.
- **Separate group tests (t-tests, ANOVA) skipped.** The methodology lists them, but the regression answers the same questions while holding other variables constant. Running both would duplicate results.

**Notebook conventions adopted:**
- Every number quoted in the markdown is printed by a cell in the notebook.
- Code stays at the user's own level (plain statsmodels calls, short comments).
- Markdown is written in the moment, with no bold and light jargon.

**For Step 5:** Model 2's formula is the linear baseline to compare against Ridge/Lasso, random forest and gradient boosting. One question to answer: can tree models find the smoking × BMI interaction without being told about it?
