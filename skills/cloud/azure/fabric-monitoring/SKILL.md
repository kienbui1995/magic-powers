---
name: fabric-monitoring
description: Use when monitoring Microsoft Fabric capacity usage, pipeline run failures, notebook performance, semantic model refresh errors, or managing Fabric capacity with the Capacity Metrics app. Covers DP-700 monitoring and optimization domain.
---

# Fabric Monitoring

## When to Use
- Investigating pipeline, notebook, or dataflow run failures in Microsoft Fabric
- Monitoring Fabric capacity unit (CU) consumption and identifying throttling
- Checking semantic model refresh history and diagnosing refresh failures
- Analyzing Spark job performance in notebooks
- Setting up alerts for pipeline failures or capacity overuse
- Preparing for Microsoft Fabric Data Engineer Associate (DP-700) exam

## Core Jobs

### 1. Monitoring Hub
- **Monitoring Hub** = central view of all Fabric activity runs in a workspace
- Access: Fabric workspace left nav → "Monitoring Hub"
- Covers: Pipeline runs, Notebook runs, Dataflow Gen2 refreshes, Semantic model refreshes, Spark jobs
- Columns: Item name, type, status (Succeeded/Failed/In Progress), start time, duration
- Click any run → **Activity run details**: per-activity status, input/output, error message
- Filter by: status (failed only), item type, date range, user

### 2. Capacity Metrics App
- **Capacity Metrics app** = installed from AppSource; monitors CU usage for Fabric capacity
- Key metrics:
  - **CU %** — percentage of capacity consumed; >100% triggers throttling
  - **Throttling** — operations queued or rejected when capacity is consistently exceeded
  - **Smoothing** — Fabric spreads burst CU usage over a 10-minute rolling window to avoid instant throttling
- Use Capacity Metrics app to:
  - Identify which workloads consume the most CUs (Spark, SQL, Pipelines, Dataflows)
  - Find throttling incidents and their timing
  - Plan capacity scaling (upgrade SKU if consistently >80% utilization)
- Smoothing example: a 30-second Spark job consuming 100 CUs spreads impact over 10 minutes

### 3. Semantic Model Refresh Monitoring
- Access: Workspace → Semantic Model → Settings → Refresh history
- Refresh history shows: scheduled/on-demand refreshes, status, duration, error details
- Common refresh failures:
  - Source connectivity (credentials expired, firewall block)
  - Timeout (large model exceeding refresh timeout)
  - Memory limit (model too large for capacity SKU)
- Schedule refresh: configure in Semantic Model settings; requires gateway for on-premises sources

### 4. Alerts and Notifications
- **Pipeline failure alerts**: configure on pipeline run failure → send email or Teams notification
  - Use Failure path in Pipeline + Email/Teams activity
  - Or: Azure Monitor alert on Fabric pipeline failure metric
- **Capacity alerts**: in Capacity Metrics app, set threshold alerts for CU overuse
- **Semantic model refresh failure**: configure email notification in dataset settings → send failure email
- **Reflex alerts**: for Eventstream data — trigger actions when real-time data meets conditions

### 5. Spark Monitoring in Notebooks
- Each notebook cell shows execution duration after run
- **Spark job monitoring**: click "Spark jobs" in notebook toolbar → opens Spark monitoring UI
- Spark UI includes:
  - **DAG visualization** — shows stages and task dependencies
  - **Stage/task metrics** — input bytes, shuffle bytes, task duration
  - **Executor logs** — stderr/stdout for debugging failures
- Common Spark performance issues:
  - Data skew: one partition much larger than others (use salting or repartition)
  - Excessive shuffle: joins on non-partitioned columns (partition by join key)
  - Small files: many tiny Delta files slow reads (use `OPTIMIZE` command on Delta table)

### 6. Admin Portal Monitoring
- **Admin portal** → accessible to Fabric/Power BI tenant admins
- Key monitoring tools:
  - **Usage metrics** — who is using which items (reports, datasets); consumption trends
  - **Audit logs** — user activity log (create, delete, share, export); integrates with Microsoft Purview
  - **Tenant settings** — enable/disable features across tenant (e.g., allow external users, allow export)
  - **Capacity settings** — manage Fabric capacity SKUs; assign workspaces to capacities

## Key Concepts
- **Monitoring Hub** — workspace-level view of all activity runs; primary debugging tool for failed pipelines/notebooks
- **CU (Capacity Unit)** — unit of Fabric compute resource; SKU determines how many CUs available
- **Throttling** — operations slowed or rejected when capacity CU limit exceeded
- **Smoothing** — 10-minute rolling window; Fabric spreads burst usage to reduce throttling frequency
- **Capacity Metrics app** — AppSource app for CU usage analysis; identify heavy workloads and plan scaling
- **Spark UI** — detailed DAG and task metrics for Spark Notebook jobs
- **Audit logs** — tenant-level activity log; 90-day retention; export to Log Analytics for longer retention

## Checklist
- [ ] Monitoring Hub checked first when investigating pipeline/notebook failures?
- [ ] Capacity Metrics app installed and reviewed for CU utilization trends?
- [ ] Pipeline failure notifications configured (email/Teams on failure path)?
- [ ] Semantic model refresh failure email notifications enabled?
- [ ] Spark UI reviewed for data skew or shuffle issues in slow notebooks?
- [ ] OPTIMIZE command scheduled for Delta tables with many small files?
- [ ] Admin portal audit logs reviewed for unexpected data access or sharing?

## Output Format
- 🔴 **Critical** — capacity consistently >100% CU without scaling plan (throttling affects all workloads)
- 🔴 **Critical** — no failure notification on critical pipelines (failures go undetected)
- 🟡 **Warning** — Spark notebook slow due to data skew or excessive shuffle (check Spark UI stage metrics)
- 🟡 **Warning** — Delta table has many small files (run `OPTIMIZE` to compact; improves query performance)
- 🟢 **Suggestion** — install Capacity Metrics app and set CU threshold alert at 80% before throttling occurs

## Exam Tips
- **Monitoring Hub = primary place to check pipeline/notebook/dataflow run status** — not in workspace item list; dedicated monitoring view
- **CU throttling = capacity exceeded** — use Capacity Metrics app (from AppSource) to identify heavy workloads and throttling incidents
- **Smoothing = Fabric spreads burst usage over 10-minute rolling window** — a short Spark job's CU burst is amortized; reduces but does not eliminate throttling risk
- **Notebook Spark monitoring** — each cell shows duration; click "Spark jobs" link for DAG and task-level metrics (stage input/output bytes, shuffle)
- **Pipeline failure → check Activity Run details in Monitoring Hub** — shows per-activity input, output, and error message; most specific failure info
- **Admin portal Usage Metrics** — tracks who uses which items (reports, datasets); useful for capacity planning and identifying unused items
