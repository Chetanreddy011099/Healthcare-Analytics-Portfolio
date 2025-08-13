-- ========== EHR Workflow Optimization – Example SQL ==========
-- Notes: Adapt table/column names to your environment. 
-- Assume a wide encounters table for simplicity. For production, split into event tables.

-- 1) Basic cycle times per encounter
SELECT
  encounter_id,
  patient_id,
  provider_id,
  EXTRACT(EPOCH FROM (triage_start_ts - arrival_ts))/60.0              AS mins_arrival_to_triage,
  EXTRACT(EPOCH FROM (provider_note_start_ts - triage_start_ts))/60.0  AS mins_triage_to_provider,
  EXTRACT(EPOCH FROM (provider_note_signed_ts - provider_note_start_ts))/60.0 AS mins_provider_to_signoff,
  EXTRACT(EPOCH FROM (discharge_ts - provider_note_signed_ts))/60.0    AS mins_signoff_to_discharge
FROM encounters
WHERE arrival_ts IS NOT NULL;

-- 2) Summary stats to spot bottlenecks (by location or provider)
WITH cycle AS (
  SELECT
    location_id,
    provider_id,
    EXTRACT(EPOCH FROM (triage_start_ts - arrival_ts))/60.0              AS a2t,
    EXTRACT(EPOCH FROM (provider_note_start_ts - triage_start_ts))/60.0  AS t2p,
    EXTRACT(EPOCH FROM (provider_note_signed_ts - provider_note_start_ts))/60.0 AS p2s,
    EXTRACT(EPOCH FROM (discharge_ts - provider_note_signed_ts))/60.0    AS s2d
  FROM encounters
  WHERE arrival_ts IS NOT NULL
)
SELECT
  location_id,
  provider_id,
  COUNT(*)                                  AS encounters,
  ROUND(AVG(a2t)::numeric, 2)               AS avg_mins_arrival_to_triage,
  ROUND(AVG(t2p)::numeric, 2)               AS avg_mins_triage_to_provider,
  ROUND(AVG(p2s)::numeric, 2)               AS avg_mins_provider_to_signoff,
  ROUND(AVG(s2d)::numeric, 2)               AS avg_mins_signoff_to_discharge,
  ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY p2s)::numeric, 2) AS p90_mins_provider_to_signoff
FROM cycle
GROUP BY 1,2
ORDER BY avg_mins_provider_to_signoff DESC;

-- 3) Documentation completion & signature timeliness
SELECT
  DATE_TRUNC('week', arrival_ts) AS week,
  AVG(CASE WHEN documentation_complete_flag = 1 THEN 1 ELSE 0 END) * 100.0 AS pct_docs_complete,
  AVG(CASE WHEN provider_note_signed_ts <= arrival_ts + INTERVAL '24 hours' THEN 1 ELSE 0 END) * 100.0 AS pct_signed_24h
FROM encounters
GROUP BY 1
ORDER BY 1;

-- 4) Error/bounce rate (rework proxy)
SELECT
  location_id,
  AVG(errors_count)                         AS avg_errors_per_encounter,
  SUM(CASE WHEN errors_count > 0 THEN 1 ELSE 0 END)::float / COUNT(*) * 100 AS pct_encounters_with_errors
FROM encounters
GROUP BY 1
ORDER BY pct_encounters_with_errors DESC;

-- 5) SLA compliance view
SELECT
  encounter_id,
  CASE WHEN provider_note_signed_ts <= arrival_ts + INTERVAL '24 hours' THEN 'ON_TIME' ELSE 'LATE' END AS signoff_sla_status,
  CASE WHEN documentation_complete_flag = 1 THEN 'COMPLETE' ELSE 'INCOMPLETE' END                     AS doc_status
FROM encounters;
