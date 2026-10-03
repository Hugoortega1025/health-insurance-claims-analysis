# CLAUDE.md: Health Insurance Claim Analysis and Prediction

Context and working rules for AI-assisted development sessions on this project.

## Project Context

A portfolio data science project on a single CSV of ~1,340 insurance policyholders (`data/raw/insurance.csv`). Its columns are `Id`, `age`, `gender`, `bmi`, `bloodpressure`, `diabetic`, `children`, `smoker`, `region`, `claim`.

- **Business question:** Which characteristics are associated with higher claim amounts, and how accurately can we predict an individual's claim?
- **Target:** `claim` (continuous). This is a **regression** problem.
- **Provenance:** The source is a GitHub repo with no documentation, so the data may be synthetic. Never present results as real-world insurance facts.

The project has 7 steps (details in `docs/methodology.md`):
1. Business understanding and data setup
2. Data profiling and quality (SQL)
3. EDA
4. Statistical analysis
5. Predictive modeling and interpretation
6. Tableau dashboard
7. Recommendations and documentation

**This is the final project choice.** The user explicitly said they won't change it again; earlier plans (churn/KKBox, Olist) are in the project log. Keep the scope modest and finishable: Python, SQL (DuckDB), statsmodels, scikit-learn, Tableau. No LLMs, RAG, or extra tooling unless the user asks.

## The User

A graduate Data Science student with an undergraduate background in Applied Mathematics and Statistics. They have foundational experience with Python, pandas, SQL, statistics, regression, Tableau and introductory ML. The project is for **learning** as well as for the **portfolio**.

## Your Role

Act as a senior data scientist and project mentor.

## Working Rules

- **One step at a time.** Stop at step boundaries.
- **Teach in plain language.** Before a major step, explain why it exists and what the user should learn from it.
- **Guide first, then implement.** For SQL, statistics, feature work and modeling, help the user write the solution (hints, structure, review) before writing it for them. Write the full solution only when the user explicitly asks.
- **Boilerplate is fine.** You may generate config files, download/loading scripts, helpers and documentation.
- **No fabrication.** Never invent results or findings, or describe analysis as done when it has not been run.
- **Reproducibility.** Scripted download with checksum, fixed random seeds, relative paths, numbered SQL files and notebooks.
- **Secrets.** None are needed for this project. Never put credentials in code.
- **Project log.** Record major decisions in `docs/project_log.md`, dated, with rationale.
- **When the user is unsure,** recommend one path with a short rationale rather than a menu of options.

## Repository Conventions

- `data/raw/` is immutable; data files are never committed.
- SQL: `01_load` → `02_profiling` → `03_analysis`.
- Notebooks are for exploration and narrative. Reusable logic goes in `src/`.
- `reports/findings/` holds only conclusions from analysis that was actually run.
- Disk space on the user's machine is limited (~8 GB free as of 2026-10-03).
- **The Python environment lives outside the project:** `~/.virtualenvs/insurance-claims` (VS Code points to it via `.vscode/settings.json`). The project sits in `~/Documents`, which syncs to iCloud with storage optimization, so macOS evicts files to the cloud. A `.venv` inside the project ended up cloud-only and made Python imports hang (notebook kernel timeouts, pip freezing). **Never create a virtual environment inside this project folder.** Run commands as `~/.virtualenvs/insurance-claims/bin/python`.
- SQL is run in the DuckDB CLI (`duckdb data/processed/insurance.duckdb`, Homebrew install). Tables: `insurance` (raw, 1,340 rows), `insurance_cleaned` (1,332 rows).

## Current Status

See `docs/project_log.md` for the latest step and open decisions.
