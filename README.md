# EHR Workflow Optimization

**Last updated:** 2025-08-13

## Overview
This project maps and analyzes end-to-end EHR workflows (registration → triage → provider encounter → discharge/coding) 
to identify bottlenecks, reduce data-entry time, and improve documentation quality. It includes a reference workflow diagram,
starter SQL for cycle-time and compliance analytics, and guidance for operational KPIs.

## Objectives
- Reduce average documentation time per encounter
- Improve completion and signature rates (provider & nurse)
- Decrease missing/invalid fields that cause downstream denials
- Standardize handoffs and reduce rework

## Approach
1. **Process Mapping**: Visualize the current state workflow and identify redundant steps.
2. **Data Instrumentation**: Define event timestamps and IDs needed for analytics.
3. **Cycle-Time Analysis**: Measure time between critical steps (e.g., arrival → triage, triage → provider note start, provider note start → sign-off).
4. **Quality & Compliance**: Track documentation completion, coding accuracy, and encounter lock/sign-off timeliness.
5. **Continuous Improvement**: Iterate on quick wins and monitor KPIs via dashboard.

## Files
- `SQL_queries.sql` – Example SQL for cycle time, completion rates, and bottleneck analysis.
- `workflow_diagram.png` – High-level current state EHR workflow for outpatient encounters.
- *(Optional add later)* `dashboard.twbx` – KPI dashboard (Tableau) for operational monitoring.

## Data Model (Example)
Minimum fields for event tables:

- `encounter_id`, `patient_id`, `location_id`, `provider_id`

- `arrival_ts`, `triage_start_ts`, `provider_note_start_ts`, `provider_note_signed_ts`, `discharge_ts`

- `documentation_complete_flag`, `coding_status`, `lock_status`, `errors_count`

## KPIs
- Cycle time (arrival→triage, triage→provider, provider→sign-off, sign-off→discharge)
- % provider notes signed within 24 hours
- % encounters with complete documentation and zero blocking errors
- Average clicks/fields completed per encounter (if available)

## How to Use
1. Review `workflow_diagram.png` to align on the current state.
2. Adapt `SQL_queries.sql` to your schema (EHR data warehouse or extracts).
3. Build a simple dashboard for the KPIs above (Power BI/Tableau).
4. Pilot changes with one clinic and compare KPIs pre/post change.

> **Compliance:** Use de-identified data only and follow HIPAA & org policies.