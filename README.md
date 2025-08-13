# Hospital Readmission Analysis

**Last updated:** 2025-08-13

## Overview
This project examines hospital readmission rates across age groups and explores their relationship with chronic condition prevalence.
It demonstrates a compact workflow using Python for data prep/EDA and a simple dashboard for stakeholder communication.

## Dataset
Synthetic dataset representing 10,000+ discharge records with:
- Age Group
- Readmission (Yes/No)
- Chronic Condition indicator (% prevalence by cohort)

## Methods
1. Data wrangling in Python (pandas).
2. EDA: readmission rate by age cohort.
3. Correlation check between chronic condition prevalence and readmission rate.
4. Visualization to communicate insights to non-technical stakeholders.

## Key Results (example)
- Readmission rates rise with age, peaking in the 76+ cohort.
- Chronic condition prevalence correlates with higher readmission risk.
- Recommended focus: targeted post-discharge follow-up (60+) and chronic condition management programs.

## Files
- `notebook.ipynb` – Reproducible Python workflow to generate summary stats and the dashboard.
- `dashboard.png` – Visual of readmission vs chronic condition trends by age.
- `workflow.pdf` – High-level process map from raw data to decisions.

## How to Run
1. Clone this folder from your GitHub repo.
2. Open `notebook.ipynb` in Jupyter or VS Code.
3. Run all cells to regenerate charts and summary statistics.
4. Replace the synthetic dataset with de-identified real data to adapt the analysis.

> **Compliance:** Do not include PHI/PII. Ensure HIPAA-compliant handling of any real data.