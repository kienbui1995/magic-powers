# Plan: Optional Skills Expansion
**Spec:** `docs/superpowers/specs/2026-04-07-optional-skills-expansion-design.md`
**Goal:** Add 67 optional skills across 11 categories, new `/install-skills` command, enhanced `/setup`

## Architecture
- Skills live in `skills/<name>/SKILL.md` (plugin root)
- Users install via `/install-skills` → copied to `.claude/skills/<name>/SKILL.md` (project)
- Auto-loaded by Claude every session once installed

## Tasks

---

### Task 1: Validation Script
**File:** `scripts/validate-skills.sh`

```bash
#!/usr/bin/env bash
# Validates all skill files have required frontmatter and sections
SKILLS_DIR="$(dirname "$0")/../skills"
ERRORS=0

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_file="$skill_dir/SKILL.md"
  name=$(basename "$skill_dir")

  if [ ! -f "$skill_file" ]; then
    echo "MISSING: $name/SKILL.md"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  if ! grep -q "^name:" "$skill_file"; then
    echo "MISSING frontmatter 'name:' in $name"
    ERRORS=$((ERRORS + 1))
  fi

  if ! grep -q "^description:" "$skill_file"; then
    echo "MISSING frontmatter 'description:' in $name"
    ERRORS=$((ERRORS + 1))
  fi

  if ! grep -q "## When to Use" "$skill_file"; then
    echo "MISSING '## When to Use' in $name"
    ERRORS=$((ERRORS + 1))
  fi

  if ! grep -q "## Core Jobs" "$skill_file"; then
    echo "MISSING '## Core Jobs' in $name"
    ERRORS=$((ERRORS + 1))
  fi
done

if [ $ERRORS -eq 0 ]; then
  echo "✅ All skills valid ($(ls -d "$SKILLS_DIR"/*/ | wc -l | tr -d ' ') skills checked)"
else
  echo "❌ $ERRORS error(s) found"
  exit 1
fi
```

**Done when:** Script runs without errors on all existing 43 skills.

---

### Task 2: Phase 1 — Product Skills (6 files)

#### `skills/user-story-writing/SKILL.md`
```markdown
---
name: user-story-writing
description: Use when writing user stories, acceptance criteria, or breaking epics into shippable slices
---

# User Story Writing

## When to Use
When translating requirements or product ideas into structured stories that dev teams can estimate and build.

## Core Jobs

### 1. Write the Story
Format: **As a** [user type], **I want** [action], **so that** [benefit]
- Be specific about the user type — not "user" but "free-tier customer" or "admin"
- The action should be observable behavior, not implementation detail
- The benefit connects to a business or user outcome

### 2. Define Acceptance Criteria
Use Given/When/Then for testable criteria:
- **Given** [starting context]
- **When** [action taken]
- **Then** [expected outcome]
Write 3–6 criteria per story. Each must be independently verifiable.

### 3. Size and Split
- Story should be completable in 1–3 days of dev work
- If larger: split by user type, happy path vs edge cases, or CRUD operation
- Never split by layer (frontend/backend) — that's a task, not a story

### 4. Definition of Done
Include in every story:
- [ ] Acceptance criteria pass
- [ ] Unit tests written
- [ ] Code reviewed
- [ ] Deployed to staging

## Key Outputs
- User story with role/action/benefit
- 3–6 Given/When/Then acceptance criteria
- Story sizing estimate (S/M/L or points)
- DoD checklist

## Anti-Patterns
- Stories written from system perspective ("The system shall...") — rewrite from user perspective
- Acceptance criteria that can't be tested
- Stories too large to complete in a sprint
- No benefit stated — if you can't explain why, don't build it
```

#### `skills/roadmap-planning/SKILL.md`
```markdown
---
name: roadmap-planning
description: Use when building quarterly roadmaps, prioritizing the backlog, or communicating what's coming and why
---

# Roadmap Planning

## When to Use
When deciding what to build over the next quarter, communicating priorities to stakeholders, or aligning the team on direction.

## Core Jobs

### 1. Gather Inputs
- User feedback and support tickets (top pain points)
- Business goals for the quarter (revenue, retention, activation)
- Engineering capacity (subtract 20–30% for incidents/tech debt)
- Stakeholder requests (log them, don't auto-prioritize)

### 2. Prioritize with ICE
Score each initiative:
- **Impact** (1–10): How much does this move the key metric?
- **Confidence** (1–10): How sure are we this will work?
- **Ease** (1–10): How fast/cheap to build?
- ICE Score = (I + C + E) / 3 — rank by score, then apply judgment

### 3. Build the Now/Next/Later Structure
- **Now** (this quarter, committed): Fully scoped, resources assigned
- **Next** (next quarter, directional): Validated problem, not yet scoped
- **Later** (future, aspirational): Interesting ideas, not yet prioritized
- **Not doing** (explicit): Things rejected and why — prevents re-litigation

### 4. Communicate to Stakeholders
- Lead with the "why" (business goal this serves)
- Show the Now/Next/Later view, not a Gantt chart
- Acknowledge what's NOT on the roadmap and why
- Set a review cadence (monthly check-in recommended)

## Key Outputs
- ICE-scored backlog
- Now/Next/Later roadmap (1-pager)
- Stakeholder update (written, async-first)

## Anti-Patterns
- Committing to dates without capacity analysis
- Roadmap as a feature wish list, not a strategy
- Not saying "no" explicitly — ambiguity creates false expectations
- Updating roadmap in isolation without team input
```

#### `skills/stakeholder-communication/SKILL.md`
```markdown
---
name: stakeholder-communication
description: Use when writing exec updates, status reports, or communicating product decisions to non-technical stakeholders
---

# Stakeholder Communication

## When to Use
When you need to inform, align, or get decisions from stakeholders who aren't in the day-to-day work.

## Core Jobs

### 1. Status Updates (Weekly/Bi-weekly)
Structure: BLUF (Bottom Line Up Front)
- **Status**: Green / Yellow / Red + one sentence why
- **This week**: 2–3 bullets of what shipped or progressed
- **Next week**: 2–3 bullets of what's planned
- **Blockers**: What you need from them (be explicit)
Keep it under 200 words. Executives skim.

### 2. Escalations
When to escalate: timeline risk, budget overrun, scope change, or dependency blocked.
Format:
- Situation: what happened
- Impact: what's at risk (timeline / revenue / quality)
- Options: 2–3 choices with trade-offs
- Recommendation: your preferred option with reasoning
- Decision needed by: [date]

### 3. Exec Presentations
- Slide 1: The ask (what decision do you need?)
- Slide 2: Context (why this matters now)
- Slide 3: Options considered
- Slide 4: Recommendation + metrics
- Appendix: Details for questions
Lead with the decision, not the story.

### 4. Product Decision Announcements
When changing direction or cutting scope:
- Acknowledge the change directly
- Explain what data/signals drove it
- State what stays the same
- Give teams time to adjust (avoid surprises)

## Key Outputs
- Weekly status update (BLUF format)
- Escalation memo
- Decision announcement

## Anti-Patterns
- Burying bad news in paragraph 3
- Sending updates without a clear ask
- Using jargon with non-technical stakeholders
- Over-communicating detail, under-communicating impact
```

#### `skills/product-metrics/SKILL.md`
```markdown
---
name: product-metrics
description: Use when defining KPIs, building dashboards, or measuring whether a feature or product is healthy
---

# Product Metrics

## When to Use
When you need to define what "success" means for a product or feature, and build the measurement system to track it.

## Core Jobs

### 1. Define the North Star Metric
One metric that best captures the value users get:
- Must be actionable (team can influence it)
- Must correlate with business outcomes
- Examples: "weekly active users who complete 3+ tasks", "monthly recurring revenue"
Avoid vanity metrics: total signups, page views, app downloads.

### 2. Build the Metric Tree
North Star → Input Metrics → Leading Indicators
- Acquisition: new users, activation rate, channel mix
- Engagement: DAU/MAU, feature adoption, session depth
- Retention: day-7/30/90 retention, churn rate
- Revenue: ARPU, LTV, conversion rate

### 3. Instrument the Feature
Before launch, define:
- What events to track (user action → event name → properties)
- What the baseline is (current state before change)
- What the target is (expected improvement, with confidence level)
- How long to measure (minimum 2 weeks post-launch for significance)

### 4. Interpret Results
- Check statistical significance before declaring success
- Segment results: by cohort, platform, plan tier
- Look for unintended consequences (metric moved, but another degraded)

## Key Outputs
- North Star metric definition
- Input metric tree
- Instrumentation plan (event schema)
- Post-launch measurement report

## Anti-Patterns
- Measuring too many metrics (pick 3–5 that matter)
- Declaring success after 3 days
- Ignoring segment-level data
- No baseline before launching
```

#### `skills/competitive-analysis/SKILL.md`
```markdown
---
name: competitive-analysis
description: Use when researching competitors, positioning features, or preparing for a market entry
---

# Competitive Analysis

## When to Use
When entering a new market, building a new feature, or needing to understand how your product is positioned vs alternatives.

## Core Jobs

### 1. Map the Competitive Landscape
Categories:
- **Direct**: Same problem, same audience (head-to-head)
- **Indirect**: Same problem, different approach
- **Substitute**: Different problem, but steals the same budget/attention

For each competitor:
- Target customer segment
- Core value proposition (in their own words — use their homepage)
- Pricing model
- Key differentiators

### 2. Feature Comparison Matrix
Build a table: Your product vs top 3–5 competitors
Columns: Must-have features, differentiating features, missing features
Mark: ✅ Strong, ⚠️ Weak, ❌ Missing

### 3. Position Your Differentiator
Find the gap: What do users need that nobody does well?
Frame it: "For [audience], [product] is the [category] that [benefit] — unlike [competitor] which [their weakness]."

### 4. Monitor Over Time
- Set up Google Alerts for competitor names
- Follow their changelog/blog/Twitter
- Review quarterly: what changed, what new players appeared?

## Key Outputs
- Competitive landscape map
- Feature comparison matrix
- Positioning statement
- Quarterly update template

## Anti-Patterns
- Copying competitors instead of differentiating
- Only analyzing direct competitors (missing indirect threats)
- Static analysis — competitive landscape changes fast
- Letting competitor features drive your roadmap
```

#### `skills/feedback-synthesis/SKILL.md`
```markdown
---
name: feedback-synthesis
description: Use when processing user interviews, support tickets, NPS comments, or survey responses into actionable insights
---

# Feedback Synthesis

## When to Use
When you have a collection of user feedback (interviews, surveys, tickets, reviews) and need to extract patterns and priorities.

## Core Jobs

### 1. Collect and Tag
Sources: interviews, support tickets, NPS verbatims, app reviews, sales calls, Twitter/Reddit
Tag each piece of feedback with:
- **Theme**: what topic (onboarding, performance, pricing, missing feature)
- **Sentiment**: positive / negative / neutral
- **Frequency**: how many users mention this
- **Severity**: blocking (can't use product) / frustrating / nice-to-have

### 2. Find Patterns
Group by theme, then look for:
- High frequency + high severity = fix now
- High frequency + low severity = backlog
- Low frequency + high severity = investigate (might be a segment)
- Low frequency + low severity = ignore for now

### 3. Write the Insight
Format: "Users [doing X] struggle with [specific pain] because [root cause]. Evidence: [N] mentions across [sources]."
Not: "Users want a better UI." (too vague)
Yes: "New users abandon onboarding at step 3 because the API key setup is unclear. 14 support tickets, 3 interview mentions."

### 4. Prioritize Actions
Map insights to roadmap items. Each insight should connect to:
- A specific user segment
- A measurable outcome if fixed
- An estimated effort (rough)

## Key Outputs
- Tagged feedback database
- Theme frequency/severity matrix
- Top 5 actionable insights (with evidence)
- Roadmap input recommendations

## Anti-Patterns
- Treating loudest feedback as most important (volume ≠ priority)
- Synthesizing without reading primary sources
- Reporting "what users said" without "what it means"
- Skipping the root cause — solving symptoms, not problems
```

---

### Task 3: Phase 1 — Data/ML Skills (9 files)

#### `skills/data-pipeline-design/SKILL.md`
```markdown
---
name: data-pipeline-design
description: Use when designing ETL/ELT pipelines, choosing between streaming vs batch, or architecting data flow between systems
---

# Data Pipeline Design

## When to Use
When building or reviewing data movement between systems — ingestion, transformation, and delivery to consumers.

## Core Jobs

### 1. Choose the Pattern
**Batch (ETL/ELT)**:
- Data moves on schedule (hourly, daily)
- Use when: latency tolerance > 1 hour, source systems can't stream, cost matters
- Tools: Airflow, dbt, Spark, AWS Glue

**Streaming**:
- Data moves continuously (seconds to milliseconds)
- Use when: real-time dashboards, fraud detection, event-driven systems
- Tools: Kafka, Flink, Kinesis, Pub/Sub

**Hybrid**: batch for historical backfill, streaming for current data (Lambda architecture)

### 2. Design the Pipeline Stages
```
Source → Ingest → Validate → Transform → Load → Serve
```
For each stage define:
- What enters, what exits (schema)
- Error handling (dead-letter queue or retry)
- Latency requirement
- Volume (rows/sec at peak)

### 3. Handle Failures
- Idempotent transforms: re-running produces same result
- Checkpointing: resume from last successful point
- Dead-letter queues: capture failed records for inspection
- Alerting: pipeline lag > N minutes → page on-call

### 4. Document the Lineage
- Source → destination for each field
- Transformation logic (not just code — business intent)
- Owner per pipeline segment

## Key Outputs
- Pipeline architecture diagram
- Schema definitions (source and target)
- Failure handling spec
- Lineage documentation

## Anti-Patterns
- No idempotency — reruns create duplicates
- Streaming everything when batch suffices (costs 10x more)
- No data quality checks at ingestion
- Pipelines with no owner
```

#### `skills/data-quality/SKILL.md`
```markdown
---
name: data-quality
description: Use when validating data pipelines, writing data tests, or investigating data anomalies
---

# Data Quality

## When to Use
When ensuring that data flowing through pipelines is accurate, complete, timely, and consistent.

## Core Jobs

### 1. Define Quality Dimensions
- **Completeness**: No unexpected nulls. Key fields populated.
- **Accuracy**: Values match source of truth.
- **Consistency**: Same entity has same value across tables.
- **Timeliness**: Data arrives within SLA window.
- **Uniqueness**: No duplicate records where uniqueness is expected.

### 2. Write Data Tests
Using dbt tests or Great Expectations:
```yaml
# dbt example
models:
  - name: orders
    columns:
      - name: order_id
        tests: [unique, not_null]
      - name: status
        tests:
          - accepted_values:
              values: [pending, shipped, delivered, cancelled]
      - name: amount
        tests:
          - dbt_utils.expression_is_true:
              expression: ">= 0"
```

### 3. Set Up Monitoring
- Row count anomaly detection (±20% from 7-day avg = alert)
- Null rate monitoring per column
- Schema change detection
- Freshness checks (last updated > N hours = alert)

### 4. Investigate Anomalies
When a quality check fails:
1. Is it a pipeline failure or a source data issue?
2. What's the blast radius (which downstream consumers affected)?
3. Quarantine bad data before it propagates
4. Fix + backfill + verify

## Key Outputs
- Data quality test suite
- Quality monitoring dashboard
- Anomaly investigation runbook
- SLA definitions per dataset

## Anti-Patterns
- Testing in dev only, not prod
- Alerts with no owner (alert fatigue)
- Fixing data in place without understanding root cause
- No freshness checks — stale data silently used as current
```

#### `skills/data-modeling/SKILL.md`
```markdown
---
name: data-modeling
description: Use when designing analytics schemas, choosing between star schema and OBT, or modeling entities for a data warehouse
---

# Data Modeling

## When to Use
When designing schemas for analytics workloads — data warehouses, marts, or reporting layers.

## Core Jobs

### 1. Choose the Modeling Approach
**Star Schema** (Kimball):
- Fact tables (events/transactions) + dimension tables (entities)
- Best for: complex reporting, many joins, well-understood domains
- Tools: Snowflake, BigQuery, Redshift

**One Big Table (OBT)**:
- Pre-joined wide table with all dimensions
- Best for: simple BI tools, small teams, fast queries
- Trade-off: storage cost, harder to maintain

**Data Vault**:
- Hubs, Links, Satellites — for auditability and historical tracking
- Best for: regulated industries, complex source systems

### 2. Design Fact Tables
- Grain: what does one row represent? (one order, one page view, one transaction)
- Measures: numeric facts (amount, duration, count)
- Foreign keys: links to dimension tables
- Date key: always include, enables time-series analysis

### 3. Design Dimension Tables
- Slowly Changing Dimensions (SCD): how do you handle changes?
  - Type 1: overwrite (no history)
  - Type 2: new row per change (full history)
  - Type 3: add column (limited history)
- Surrogate keys: integer PKs, not natural keys

### 4. Layer the Models
```
Raw (source copy) → Staging (cleaned) → Intermediate → Marts (business logic)
```
Don't put business logic in raw or staging layers.

## Key Outputs
- ERD / schema diagram
- Fact and dimension table definitions
- SCD strategy per entity
- dbt model layer structure

## Anti-Patterns
- Business logic in the BI tool
- No grain definition on fact tables
- Using natural keys as join keys (breaks on source changes)
- Modeling for current queries only — schema should support future questions
```

#### `skills/ml-experiment-tracking/SKILL.md`
```markdown
---
name: ml-experiment-tracking
description: Use when managing ML experiments, ensuring reproducibility, or comparing model runs
---

# ML Experiment Tracking

## When to Use
When training models and need to compare runs, reproduce results, or share findings with the team.

## Core Jobs

### 1. Track Every Run
Use MLflow, W&B, or DVC. Log per experiment:
- **Parameters**: hyperparameters, data version, preprocessing config
- **Metrics**: loss, accuracy, precision/recall/F1, AUC
- **Artifacts**: model weights, feature importance plots, confusion matrix
- **Environment**: Python version, library versions, hardware

```python
import mlflow

with mlflow.start_run():
    mlflow.log_param("learning_rate", 0.01)
    mlflow.log_param("max_depth", 5)
    mlflow.log_metric("val_accuracy", 0.92)
    mlflow.log_artifact("model.pkl")
```

### 2. Version Your Data
- Pin dataset version alongside each experiment
- Use DVC or S3 versioning
- Never train on "latest" — always a specific version

### 3. Make Experiments Reproducible
- Set random seeds (`torch.manual_seed`, `np.random.seed`)
- Record hardware (GPU model affects float precision)
- Use Docker or conda envs with pinned versions
- Log git commit hash with each run

### 4. Compare and Select
- Don't compare metrics in isolation — look at training curves
- Check for overfitting (train vs val gap)
- Compare on holdout test set only once (before that: val set)
- Document why you chose the winner

## Key Outputs
- Experiment tracking setup (MLflow/W&B config)
- Run comparison report
- Model selection rationale
- Reproducibility checklist

## Anti-Patterns
- Training without logging parameters
- Comparing models trained on different data versions
- Evaluating on test set during model selection (data leakage)
- No seed → can't reproduce results
```

#### `skills/model-evaluation/SKILL.md`
```markdown
---
name: model-evaluation
description: Use when selecting evaluation metrics, detecting bias, or validating model readiness for production
---

# Model Evaluation

## When to Use
When assessing whether a model is good enough to deploy, fairly represents all user groups, and won't degrade in production.

## Core Jobs

### 1. Choose the Right Metrics
Match metric to problem type:
- **Binary classification**: AUC-ROC, F1, precision, recall (choose based on cost of FP vs FN)
- **Multi-class**: macro/weighted F1, confusion matrix
- **Regression**: RMSE, MAE, MAPE (use MAE when outliers shouldn't dominate)
- **Ranking**: NDCG, MRR
- **Generation (LLM)**: BLEU/ROUGE (weak), human eval, LLM-as-judge

Business metric matters more than ML metric — always connect model performance to business outcome.

### 2. Evaluate Across Segments
Don't report only aggregate metrics. Slice by:
- User demographics (age, region, language)
- Data subgroups (product category, request type)
- Time (recent vs older data — look for drift)
- Edge cases (short inputs, rare labels)

### 3. Bias and Fairness Checks
- Equal opportunity: equal TPR across groups?
- Demographic parity: equal positive prediction rates?
- Use tools: Fairlearn, IBM AI Fairness 360

### 4. Pre-Production Validation
- [ ] Performance on holdout test set
- [ ] Performance on recent data (last 30 days)
- [ ] Latency at P50/P95/P99 (meets SLA?)
- [ ] Memory footprint (fits in serving environment?)
- [ ] Slice analysis (no group significantly underperforms)
- [ ] Shadow mode test (run alongside current system)

## Key Outputs
- Evaluation report with chosen metrics and rationale
- Slice analysis (breakdown by key segments)
- Bias/fairness assessment
- Pre-production validation checklist

## Anti-Patterns
- Optimizing for accuracy on imbalanced datasets
- Never slicing results by subgroup
- Declaring a model "ready" without latency testing
- Using test set for model selection (leakage)
```

#### `skills/feature-engineering/SKILL.md`
```markdown
---
name: feature-engineering
description: Use when selecting, transforming, or creating features for ML models
---

# Feature Engineering

## When to Use
When preparing data for model training — selecting which signals to use, how to encode them, and what new features to derive.

## Core Jobs

### 1. Understand the Data
Before engineering:
- Distribution of each feature (histogram, describe())
- Missing value rates
- Correlation with target (mutual information, Pearson)
- Correlation between features (avoid multicollinearity for linear models)

### 2. Handle Raw Features
**Numeric**:
- Scale: StandardScaler (normal dist), MinMaxScaler (bounded), RobustScaler (outliers)
- Transform: log(x+1) for skewed distributions

**Categorical**:
- Low cardinality (< 15 values): one-hot encoding
- High cardinality (> 50 values): target encoding, embedding
- Ordinal: label encode with meaningful order

**Text**:
- TF-IDF for sparse models
- Embeddings (sentence-transformers) for semantic similarity

**Temporal**:
- Extract: hour, day of week, month, is_weekend
- Cyclical: sin/cos encoding for hour/day
- Lag features: value at T-1, T-7, T-30

### 3. Create Derived Features
- Ratios: clicks/impressions, revenue/user
- Differences: current_price - avg_price
- Aggregations: user's avg purchase in last 30 days
- Interaction features: feature_A × feature_B (for linear models)

### 4. Feature Selection
- Remove zero-variance features
- Remove features with > 50% missing
- Use permutation importance or SHAP for post-hoc selection
- Regularization (L1/Lasso) for automatic selection

## Key Outputs
- Feature engineering pipeline (sklearn Pipeline or similar)
- Feature importance report
- Missing value and encoding strategy doc

## Anti-Patterns
- Feature leakage (using future data to predict past)
- Fitting scalers on the full dataset (fit on train only)
- Creating 200 features and not selecting — leads to overfitting
- Forgetting to apply same transformations at inference time
```

#### `skills/mlops-deployment/SKILL.md`
```markdown
---
name: mlops-deployment
description: Use when deploying ML models to production, setting up canary releases, or designing the serving infrastructure
---

# MLOps Deployment

## When to Use
When taking a trained model from experiment to production serving.

## Core Jobs

### 1. Package the Model
- Serialize: pickle (small models), ONNX (cross-framework), TorchScript (PyTorch)
- Container: Docker image with model + inference code + dependencies pinned
- Register: store in model registry (MLflow, W&B, SageMaker) with version + metadata

### 2. Choose Serving Pattern
**Online (real-time)**:
- REST API (FastAPI + uvicorn) or gRPC for low latency
- Batch size 1, P95 latency target < 200ms
- Scale: Kubernetes + HPA or serverless (Lambda, Cloud Run)

**Batch (offline)**:
- Run on schedule, write predictions to DB/S3
- Higher throughput, latency doesn't matter
- Use Spark or Ray for large-scale

**Streaming**:
- Consume from Kafka, predict, publish results
- Use Flink ML or custom consumer

### 3. Canary / Shadow Release
- **Shadow**: new model runs alongside old, predictions logged but not served
- **Canary**: new model serves X% of traffic (start 1%, ramp up)
- Compare: business metrics, not just ML metrics
- Rollback trigger: define threshold before launch

### 4. Inference Optimization
- Quantization: INT8 (4x smaller, ~2x faster, <1% accuracy drop)
- Batching: group requests for throughput
- Caching: cache predictions for identical inputs
- Hardware: GPU for large models, CPU for small/fast

## Key Outputs
- Model serving API (Dockerfile + app code)
- Deployment manifest (k8s YAML or Terraform)
- Canary release plan with rollback criteria
- Latency benchmark report

## Anti-Patterns
- Deploying without a rollback plan
- No shadow mode before production traffic
- Using dev environment pickle files in prod
- No latency SLA defined before deployment
```

#### `skills/model-monitoring/SKILL.md`
```markdown
---
name: model-monitoring
description: Use when setting up drift detection, retraining triggers, or production model health dashboards
---

# Model Monitoring

## When to Use
When a model is live in production and needs ongoing health tracking to catch degradation before users notice.

## Core Jobs

### 1. Monitor Data Drift
Input distribution changes → model becomes unreliable.
- **Univariate drift**: monitor each feature's distribution (KS test, PSI)
- **Multivariate drift**: monitor joint distribution (MMD, PCA shift)
- Tools: Evidently AI, WhyLogs, Alibi Detect
- Threshold: PSI > 0.2 = alert, > 0.25 = investigate retraining

### 2. Monitor Prediction Drift
- Distribution of model outputs changing
- Useful when ground truth is delayed (common in production)
- Alert if output distribution shifts significantly from baseline

### 3. Monitor Ground Truth (when available)
- Compare predictions vs actuals as labels arrive
- Calculate: accuracy, precision, recall (same metrics as eval)
- Set alert thresholds: >10% degradation from baseline = page on-call

### 4. Set Retraining Triggers
Define trigger strategy:
- **Schedule**: retrain weekly/monthly regardless of drift
- **Performance-based**: retrain when accuracy drops below threshold
- **Drift-based**: retrain when PSI > 0.25 on key features
- Combine: schedule + drift detection for critical models

### 5. Dashboard Essentials
- Prediction volume over time
- Feature distributions (current vs baseline)
- Model performance metrics (rolling 7-day)
- Latency P50/P95/P99
- Error rates (failed inferences)

## Key Outputs
- Monitoring pipeline (drift detection + alerting)
- Model health dashboard
- Retraining trigger policy
- Runbook for drift alerts

## Anti-Patterns
- No monitoring after deployment ("set and forget")
- Alerting on every metric — pick 3–5 critical signals
- No ground truth pipeline — can't measure real accuracy
- Retraining without validating the new model first
```

#### `skills/training-pipeline/SKILL.md`
```markdown
---
name: training-pipeline
description: Use when building reproducible ML training workflows, orchestrating training jobs, or versioning training artifacts
---

# Training Pipeline

## When to Use
When building the end-to-end system that takes raw data and produces a validated, registered model — reproducibly.

## Core Jobs

### 1. Define Pipeline Stages
```
Data → Validate → Preprocess → Train → Evaluate → Register
```
Each stage:
- Takes versioned inputs
- Produces versioned outputs
- Is independently re-runnable (idempotent)
- Has pass/fail criteria

### 2. Orchestrate the Pipeline
Tools: Airflow, Prefect, Kubeflow Pipelines, Metaflow, SageMaker Pipelines
- Each step = one container or task
- Pass artifacts between steps via shared storage (S3, GCS)
- Log metadata to experiment tracker at each step

### 3. Version Everything
- Data: DVC or dataset versioning in the registry
- Code: git commit hash logged with each run
- Environment: Docker image tag (pinned, not `latest`)
- Model: versioned in model registry with lineage to data + code

### 4. Automated Evaluation Gate
Before registering, automatically check:
- [ ] Performance > baseline (current prod model)
- [ ] Performance on recent data slice (last 30 days)
- [ ] No data leakage detected (temporal split verified)
- [ ] Latency within SLA
If any check fails: pipeline fails, Slack alert, no model registered.

### 5. CI/CD for ML
- PR → run unit tests on pipeline code
- Merge → trigger training run on subset (smoke test)
- Tag/release → full training run → deploy if gates pass

## Key Outputs
- Pipeline DAG definition
- Evaluation gate configuration
- Model registry entry (with lineage)
- Pipeline monitoring dashboard

## Anti-Patterns
- Manual steps in the pipeline (not reproducible)
- No evaluation gate — any model can go to prod
- `latest` tags on Docker images or data
- No lineage — can't trace a prod model back to its data
```

---

### Task 4: Phase 1 — Platform/SRE Skills (6 files)

#### `skills/slo-sli-design/SKILL.md`
```markdown
---
name: slo-sli-design
description: Use when defining service level objectives, SLIs, or error budgets for reliability engineering
---

# SLO/SLI Design

## When to Use
When establishing reliability targets for a service, creating error budgets, or setting up the measurement framework for SRE practices.

## Core Jobs

### 1. Define SLIs (Service Level Indicators)
SLI = the metric that measures user experience quality.
Good SLIs:
- **Availability**: % of requests that succeed (HTTP 2xx/3xx)
- **Latency**: % of requests faster than threshold (e.g., P95 < 200ms)
- **Error rate**: % of requests that return errors
- **Throughput**: requests per second served
- **Durability**: % of data readable after write

Bad SLIs: CPU usage, memory (these are symptoms, not user experience).

### 2. Set SLOs (Service Level Objectives)
SLO = target for the SLI over a time window.
Examples:
- "99.9% of requests succeed" (availability)
- "P95 latency < 200ms" (latency)
- "99.95% of writes are durable" (durability)

How to set the target:
- Start with what users actually need, not what's technically achievable
- Check historical performance — set target slightly better than current P75
- Different tiers: 99.9% for free, 99.95% for paid, 99.99% for enterprise

### 3. Calculate Error Budget
Error Budget = 1 - SLO
- 99.9% SLO = 0.1% budget = 43.8 minutes/month
- Spend error budget on: deployments, experiments, planned maintenance
- When budget depleted: freeze feature work, focus on reliability

### 4. Create the SLO Dashboard
Track:
- Current SLI value (rolling 30-day window)
- Error budget remaining (%)
- Budget burn rate (are you on track to exhaust it?)
- Alerting: burn rate > 2x normal = page on-call

## Key Outputs
- SLI definitions per service
- SLO targets with rationale
- Error budget calculation
- SLO dashboard (Grafana template)

## Anti-Patterns
- 100% SLO target (unachievable, no room for deployments)
- Using infrastructure metrics (CPU) as SLIs
- SLOs not tied to user experience
- No error budget policy (who decides how to spend it?)
```

#### `skills/capacity-planning/SKILL.md`
```markdown
---
name: capacity-planning
description: Use when projecting infrastructure needs, planning for traffic growth, or making scaling decisions
---

# Capacity Planning

## When to Use
When you need to ensure infrastructure can handle current load, planned growth, or traffic spikes without over-provisioning.

## Core Jobs

### 1. Measure Current Baselines
For each service, measure:
- **Throughput**: requests/sec at P50, P95 traffic
- **Latency**: P50, P95, P99 response time
- **Resource utilization**: CPU%, memory%, disk I/O, network
- **Saturation point**: at what RPS does P99 latency degrade?
- **Headroom**: current utilization vs saturation point

### 2. Model Growth
- Historical traffic growth rate (last 3–6 months)
- Planned initiatives that will change load (new features, marketing campaigns)
- Seasonality (peak hours, days, months)
- Project 3 months and 12 months forward

### 3. Calculate Required Capacity
```
Required instances = (Peak RPS × Avg latency) / (1000ms × CPU cores × target utilization)
```
Target utilization: 60–70% CPU at peak (leave headroom for spikes and rolling deploys)

### 4. Make Scaling Decisions
Options:
- **Vertical scaling**: larger instances (fast, expensive, limits)
- **Horizontal scaling**: more instances (preferred, needs stateless design)
- **Auto-scaling**: HPA on Kubernetes, ASGs on AWS (set based on CPU or custom metric)
- **Caching**: reduce load on DB/API (often 10x more cost-effective than scaling)

### 5. Plan for Spikes
- Load test at 2x expected peak before major launches
- Pre-scale before known events (product launches, marketing campaigns)
- Circuit breakers to shed load gracefully

## Key Outputs
- Current baseline measurements
- 3-month and 12-month capacity projections
- Scaling recommendation with cost estimate
- Load test results

## Anti-Patterns
- Planning based on average load, not peak
- No load testing before major launches
- Scaling CPU-bound services horizontally without profiling
- Over-provisioning permanently for spikes that last hours
```

#### `skills/chaos-engineering/SKILL.md`
```markdown
---
name: chaos-engineering
description: Use when designing resilience tests, planning chaos experiments, or validating failure recovery
---

# Chaos Engineering

## When to Use
When proactively testing system resilience by injecting controlled failures before they happen in production.

## Core Jobs

### 1. Define the Steady State
Before injecting chaos, define what "normal" looks like:
- Key metrics: error rate, latency, throughput, business KPI
- These must remain within bounds during the experiment
- If they leave bounds: experiment failed → learn why

### 2. Hypothesize
"We believe the system can tolerate [failure] because [reason]."
Examples:
- "We believe losing one DB replica won't affect P99 latency because we have read replicas with failover."
- "We believe a 500ms network delay between service A and B won't cause cascading failures because we have timeouts."

### 3. Design the Experiment
- **Scope**: start small (one instance, not all)
- **Blast radius**: what's the worst case if wrong?
- **Duration**: 5–30 minutes (enough to see impact)
- **Rollback**: how do you stop the experiment instantly?
- **Approval**: who needs to know before you run this?

Common experiments:
- Kill random pod/instance
- Inject network latency (50ms, 200ms, 1s)
- Fill disk to 95%
- CPU stress test (one node at 90%)
- DNS failure for dependency
- Terminate DB connection pool

### 4. Run and Observe
- Run during business hours (not 3am — you need to react)
- Watch the steady state metrics in real-time
- Stop immediately if unexpected impact
- Document what happened

### 5. Learn and Improve
- Did hypothesis hold? If yes: expand scope
- If no: fix the gap, don't run same experiment until fixed

## Key Outputs
- Chaos experiment plan (hypothesis + scope + rollback)
- Steady state dashboard
- Experiment results report
- Remediation items

## Anti-Patterns
- Running chaos in production before running in staging
- No rollback plan
- Chaos without observability (can't see what's happening)
- Running multiple experiments simultaneously
```

#### `skills/on-call-runbook/SKILL.md`
```markdown
---
name: on-call-runbook
description: Use when writing runbooks for on-call engineers, documenting incident response steps, or creating operational playbooks
---

# On-Call Runbook Writing

## When to Use
When documenting how to respond to alerts, investigate incidents, or operate a system at 3am with no context.

## Core Jobs

### 1. Runbook Structure
Every runbook should have:
```
# Alert: [Alert Name]

## Severity
[P1/P2/P3] — [impact if this fires]

## Symptoms
- What does the user experience?
- Which metrics are affected?

## Immediate Actions (first 5 minutes)
1. Acknowledge the alert
2. [Specific command to run first]
3. [Decision point: if X, go to section A; if Y, go to section B]

## Investigation Steps
1. Check [dashboard link] — look for [what to look for]
2. Run: `[exact command]`
3. Check logs: `[exact log query]`

## Common Causes and Fixes
### Cause: [specific cause]
Fix: [exact steps]

### Cause: [another cause]
Fix: [exact steps]

## Escalation
If not resolved in 30 minutes, escalate to: [person/team + how]

## Post-Incident
- Create incident ticket in [system]
- Run postmortem if P1/P2
```

### 2. Write for 3am You
- Exact commands, not "check the logs" — provide the grep
- Dashboard links embedded (not "check Grafana")
- Decision trees, not prose
- No jargon that requires context
- Assume nothing — spell out every step

### 3. Test the Runbook
- Have a new team member follow it during a drill
- Time it: can they triage in < 5 minutes?
- Update anywhere they got stuck

### 4. Keep It Current
- Review quarterly or after every P1
- Runbooks that don't get used in incidents are probably outdated
- Link runbooks in the alerting system (PagerDuty, OpsGenie)

## Key Outputs
- Alert-specific runbooks (one per alert)
- Service operational guide
- Escalation matrix

## Anti-Patterns
- Runbooks written for people who already know the system
- Prose instead of numbered steps + commands
- No links to dashboards/logs
- Runbooks that haven't been tested
```

#### `skills/cloud-cost-review/SKILL.md`
```markdown
---
name: cloud-cost-review
description: Use when auditing cloud spend, rightsizing instances, reviewing reserved instance coverage, or finding cost optimization opportunities
---

# Cloud Cost Review

## When to Use
When cloud bills are growing faster than expected, before quarterly planning, or as a regular monthly hygiene practice.

## Core Jobs

### 1. Understand the Bill
Break down by:
- Service (EC2, RDS, S3, data transfer, etc.)
- Team/project (via tags)
- Environment (prod vs dev vs staging)
- Region

Tools: AWS Cost Explorer, GCP Billing, Azure Cost Management

### 2. Find Quick Wins

**Idle Resources** (high impact, easy):
- Instances with CPU < 5% for 14+ days
- Unattached EBS volumes
- Load balancers with no traffic
- Old snapshots (> 90 days)
- Unused Elastic IPs

**Rightsizing** (medium effort):
- Oversized instances: P95 CPU < 30% → downsize one tier
- Tool: AWS Compute Optimizer, GCP Recommender

**Reserved Instances / Savings Plans**:
- Workloads running > 8 months/year → commit for 30–40% savings
- 1-year no-upfront = best flexibility vs savings balance

**Data Transfer**:
- Same-region between services: often free
- Cross-region / egress: expensive — co-locate services
- S3 to EC2 in same region: free

### 3. Tag Everything
Without tags, you can't attribute costs. Enforce:
- `project`, `team`, `environment`, `owner`
- Budget alerts per tag value

### 4. Set Budgets and Alerts
- Monthly budget per service and team
- Alert at 80% and 100% of budget
- Anomaly detection for sudden spikes

## Key Outputs
- Cost breakdown report (service + team + env)
- Top 10 optimization opportunities with estimated savings
- Reserved instance / savings plan recommendation
- Tagging compliance report

## Anti-Patterns
- Reviewing costs quarterly instead of monthly (surprise bills)
- No tagging → can't attribute costs
- Optimizing dev environments instead of prod (wrong ROI)
- Buying reserved instances for workloads that scale down seasonally
```

#### `skills/performance-benchmarking/SKILL.md`
```markdown
---
name: performance-benchmarking
description: Use when establishing performance baselines, comparing before/after changes, or validating performance SLAs
---

# Performance Benchmarking

## When to Use
When you need to measure system performance objectively — before/after a change, or to validate a performance requirement.

## Core Jobs

### 1. Define What to Measure
Pick metrics that matter to users:
- **Latency**: P50, P95, P99 response time (not average)
- **Throughput**: requests per second at target latency
- **Error rate**: % of requests failing under load
- **Resource cost**: CPU/memory per request

Avoid: average latency (hides outliers), total requests (not meaningful without time).

### 2. Design the Benchmark
- **Workload**: representative mix of operations (not just happy path)
- **Concurrency**: test at 1x, 2x, 5x, 10x expected traffic
- **Duration**: at least 5 minutes to reach steady state (longer = better)
- **Warmup**: first 60 seconds discarded (JIT, connection pooling, caches)
- **Isolation**: run on dedicated hardware (not shared with other workloads)

### 3. Run the Benchmark
Tools:
- HTTP: wrk, k6, Locust, Apache Bench (ab)
- Database: pgbench, sysbench
- Custom: write a script that mimics real traffic patterns

```bash
# k6 example
k6 run --vus 100 --duration 5m benchmark.js
```

### 4. Interpret Results
- Check percentile distribution (P99 vs P50 spread — large gap = outliers)
- Look for throughput knee: where does latency start degrading?
- Compare before/after: use same hardware, same data size, same warmup
- Document exact conditions so results are reproducible

## Key Outputs
- Benchmark script (reusable, version controlled)
- Baseline results (before change)
- Comparison report (before vs after)
- Performance regression CI check

## Anti-Patterns
- Benchmarking average latency
- Running benchmarks on shared/noisy hardware
- No warmup period (cold JVM, cold cache)
- Comparing benchmarks run under different conditions
```

---

### Task 5: Phase 1 — Design/UX Skills (4 files)

#### `skills/ux-audit/SKILL.md`
```markdown
---
name: ux-audit
description: Use when conducting a heuristic evaluation of an existing interface, identifying usability problems, or prioritizing UX improvements
---

# UX Audit

## When to Use
When assessing an existing product's user experience before a redesign, after user complaints, or as a quarterly practice.

## Core Jobs

### 1. Heuristic Evaluation (Nielsen's 10)
Evaluate each screen against:
1. Visibility of system status — does the user know what's happening?
2. Match between system and real world — familiar language, not jargon?
3. User control and freedom — easy undo/exit?
4. Consistency and standards — same patterns throughout?
5. Error prevention — does the design prevent mistakes?
6. Recognition over recall — visible options, not memorized commands?
7. Flexibility and efficiency — shortcuts for power users?
8. Aesthetic and minimal design — no irrelevant information?
9. Help users recognize/diagnose/recover from errors — clear error messages?
10. Help and documentation — findable when needed?

Score each: 0 (no problem) to 4 (usability catastrophe)

### 2. User Flow Analysis
Walk through top 3 user flows:
- Map each step from entry to goal completion
- Note where users might get confused or drop off
- Measure click depth: how many clicks to complete key tasks?

### 3. Prioritize Findings
Severity × Frequency:
- Critical (score 3–4 + common flow) → fix before next release
- Major (score 2–3 + occasional flow) → next sprint
- Minor (score 1–2) → backlog

### 4. Write the Report
Per finding:
- Screenshot + annotation
- Heuristic violated
- Severity rating (1–4)
- Recommended fix

## Key Outputs
- Heuristic evaluation scorecard
- User flow breakdown
- Prioritized findings report with screenshots
- Top 5 quick wins

## Anti-Patterns
- Auditing without real users (adds subjective bias)
- Treating all findings as equal priority
- UX audit without connecting to business metrics
- One-time audit with no follow-up measurement
```

#### `skills/design-system-audit/SKILL.md`
```markdown
---
name: design-system-audit
description: Use when reviewing component consistency, design token coverage, or the health of a design system
---

# Design System Audit

## When to Use
When a codebase has grown organically and consistency has degraded, before adopting a design system, or as a quarterly consistency check.

## Core Jobs

### 1. Inventory Components
Catalog what exists:
- UI component inventory: buttons, inputs, modals, cards, tables, navigation
- For each: how many variants exist in code vs in design?
- Duplicates: multiple components solving the same problem?

### 2. Audit Design Tokens
Check token coverage:
- Colors: are hex values hardcoded or using tokens?
- Typography: ad-hoc font sizes or scale?
- Spacing: magic numbers or 8pt grid?
- Shadows, border-radius, z-index: consistent values?

### 3. Check Component Health
Per component:
- Is it documented? (Storybook or equivalent)
- Does it handle accessibility (ARIA labels, keyboard nav)?
- Does it have responsive behavior defined?
- Is it used consistently (or overridden in individual pages)?

### 4. Identify Gaps
- Missing components (teams building one-offs instead)
- Inconsistent naming (Button vs Btn vs CTAButton)
- Design ↔ code drift (design system out of sync with implementation)

### 5. Report and Roadmap
Prioritize:
- Critical: accessibility failures, major inconsistencies in core flows
- High: components with 3+ variants that should be unified
- Medium: missing documentation
- Low: minor visual inconsistencies

## Key Outputs
- Component inventory spreadsheet
- Token coverage report
- Top issues with severity
- Design system improvement roadmap

## Anti-Patterns
- Auditing design without checking implementation (they drift)
- Rebuilding everything at once — incremental improvement is better
- No adoption tracking after publishing the system
- Design system maintained by one person with no contributors
```

#### `skills/user-research/SKILL.md`
```markdown
---
name: user-research
description: Use when planning user interviews, writing discussion guides, running usability tests, or synthesizing research findings
---

# User Research

## When to Use
When you need to understand user needs, validate a concept, or test whether a design works before or after building.

## Core Jobs

### 1. Choose the Research Method
| Method | Use When | Output |
|--------|----------|--------|
| User interviews | Understand problems, motivations, context | Qualitative insights |
| Usability testing | Test if design works | Issues + severity |
| Survey | Quantify attitudes at scale | Stats + verbatims |
| Diary study | Understand longitudinal behavior | Behavioral patterns |
| Card sorting | Information architecture | Navigation structure |

### 2. Write the Discussion Guide (Interviews)
Structure:
- **Intro** (5 min): purpose, permission to record, "no wrong answers"
- **Warm-up** (5 min): their role, context, how they currently solve the problem
- **Core questions** (30 min): open-ended, one topic at a time
- **Concept test** (optional, 10 min): show prototype, ask to think aloud
- **Wrap-up** (5 min): anything else they'd like to share, referrals

Rules:
- Start broad ("tell me about your workflow") before specific
- Never lead: "Do you find it confusing?" → "What do you think of this?"
- Silence is OK — let them fill it

### 3. Run the Session
- Recruit 5–8 participants per segment (enough to see patterns)
- Two people: one facilitates, one takes notes
- Record (with permission)
- Note quotes verbatim, not paraphrases

### 4. Synthesize Findings
- Affinity mapping: group observations by theme
- Write insights: "Users who X tend to Y because Z"
- Don't report "5 users said X" — report what it means

## Key Outputs
- Research plan (goals, methods, recruit criteria)
- Discussion guide / test script
- Synthesis report with actionable insights
- Recommendations linked to design or product decisions

## Anti-Patterns
- Research after building (too late to change)
- Leading questions that confirm existing beliefs
- Recruiting friends/coworkers (not real users)
- Reporting what users said without interpreting what it means
```

#### `skills/design-handoff/SKILL.md`
```markdown
---
name: design-handoff
description: Use when preparing designs for developer implementation, writing specs, or managing the design-to-code workflow
---

# Design Handoff

## When to Use
When designs are ready for implementation and need to be communicated clearly to developers.

## Core Jobs

### 1. Prepare the Design File
Before handing off:
- [ ] All components use design system tokens (no magic numbers)
- [ ] All states covered: default, hover, active, disabled, error, empty, loading
- [ ] Responsive breakpoints annotated (mobile, tablet, desktop)
- [ ] Edge cases shown (long text, empty states, error states)
- [ ] Assets exported and named (SVGs, icons, images)

### 2. Write the Spec
Per component or screen:
- **Spacing**: exact px/rem values for padding, margin, gaps
- **Typography**: font size, weight, line height, letter spacing
- **Colors**: token names (not hex) — "primary-500", not "#3B82F6"
- **Interactions**: hover states, animation timing, transition easing
- **Behavior**: what happens on click/tap, keyboard interaction

### 3. Communicate Edge Cases
Write a short note per complex component:
- What is the max content length? What happens at overflow?
- What if the list is empty?
- What if the image fails to load?

### 4. Stay Available During Implementation
- Answer questions same day (blocking developers = wasted time)
- Review implementation against designs before PR merge
- Document any dev-agreed deviations from spec

## Key Outputs
- Annotated design file (Figma/Sketch link)
- Component spec document
- Edge case documentation
- Exported assets

## Anti-Patterns
- Handing off without covering all states
- Specs that say "matches design" instead of actual values
- No responsive designs for a responsive product
- Disappearing during implementation
```

---

### Task 6: Phase 1 — Team Process Skills (9 files)

#### `skills/sprint-planning/SKILL.md`
```markdown
---
name: sprint-planning
description: Use when facilitating sprint planning, refining the backlog, calculating team capacity, or setting sprint goals
---

# Sprint Planning

## When to Use
At the start of each sprint to align the team on what to build and why.

## When to Use This Skill
Before or during the sprint planning meeting to structure the session, help write the sprint goal, or troubleshoot a dysfunctional planning process.

## Process Checklist

### Pre-Planning (day before)
- [ ] Backlog groomed — top items have acceptance criteria and estimates
- [ ] Previous sprint velocity calculated (avg of last 3 sprints)
- [ ] Team capacity confirmed (who's out? on-call? support rotation?)
- [ ] Product goal for this sprint drafted

### The Planning Meeting (2 hours max for 2-week sprint)

**Part 1: Why (30 min)**
- PO presents sprint goal — the one outcome this sprint delivers
- Team asks clarifying questions
- Goal is agreed (not just "ship features", but "users can complete checkout")

**Part 2: What (60 min)**
- Pull from top of backlog until capacity is reached
- Capacity = velocity × (available dev-days / sprint-days)
- Each story: confirm understanding of acceptance criteria
- If unclear: clarify now or push to next sprint

**Part 3: How (30 min)**
- Break stories into tasks (optional, but recommended for complex stories)
- Identify dependencies between tickets
- Flag risks: what could go wrong?

### Capacity Calculation
```
Available dev-days = (team_size × sprint_days) - PTO - meetings - support_rotation
Capacity = (available_dev_days / sprint_days) × historical_velocity
```

### Sprint Goal Formula
"By the end of this sprint, [user type] will be able to [capability], which enables [business outcome]."

## Key Outputs
- Sprint goal (one sentence)
- Sprint backlog (committed stories)
- Capacity breakdown
- Risk log

## Anti-Patterns
- No sprint goal — just a list of tickets
- Committing to 100% capacity (no buffer for unknowns)
- Adding tickets during the sprint without removing others
- Planning stories that aren't ready (no acceptance criteria)
```

#### `skills/sprint-retrospective/SKILL.md`
```markdown
---
name: sprint-retrospective
description: Use when facilitating sprint retrospectives, choosing retro formats, or driving actionable outcomes from team reflection
---

# Sprint Retrospective

## When to Use
At the end of each sprint to reflect on how the team worked together and improve one thing.

## Process Checklist

### Pre-Retro
- [ ] Previous retro action items reviewed — were they done?
- [ ] Format chosen (see below)
- [ ] Anonymous input collected if team is shy (Miro, EasyRetro)

### The Retro (60–90 min)

**Opening (5 min)**
- One word check-in: "Describe this sprint in one word"
- Review last retro's action items: done / not done / dropped

**Data Collection (20 min)**
- Each person writes sticky notes (2–3 min per column)
- No discussion yet — just write

**Grouping (10 min)**
- Cluster similar stickies together
- Name each cluster

**Discussion (30 min)**
- Vote on top 3 clusters to discuss
- For each: go deeper — why? what happened?
- Facilitator keeps discussion on the topic, not solutions yet

**Actions (15 min)**
- Max 3 action items per retro (less = more done)
- Each action: specific, owner assigned, done-by date
- Add to next sprint backlog or team board

### Formats
- **Start / Stop / Continue**: simple, good for new teams
- **4Ls** (Liked, Learned, Lacked, Longed For): richer reflection
- **Sailboat**: heading toward (goal), wind (helps), anchors (slows), rocks (risks)
- **Mad / Sad / Glad**: emotions-based, good for processing difficult sprints
- **5 Whys on top issue**: deep dive on one systemic problem

## Key Outputs
- 1–3 action items with owners and due dates
- Updated team working agreements (if changed)
- Pattern log (recurring issues across retros)

## Anti-Patterns
- Retro with no action items — just venting
- Same format every sprint (leads to stale thinking)
- Action items with no owner ("the team will...")
- Not reviewing previous action items
```

#### `skills/team-onboarding/SKILL.md`
```markdown
---
name: team-onboarding
description: Use when onboarding a new engineer, setting up their dev environment, introducing the codebase, or planning their first PR
---

# Team Onboarding

## When to Use
When a new engineer joins the team and needs to go from zero to productive contributor.

## Process Checklist

### Week 1: Environment + Context
- [ ] Dev environment set up and working (run the app locally)
- [ ] Access granted: GitHub, Slack, Jira/Linear, AWS console, staging
- [ ] Architecture walkthrough: system diagram + key services explained
- [ ] First PR: a small, well-scoped bug fix or docs improvement (day 3–5)
- [ ] Codebase tour: where is the main logic? what are the key files?
- [ ] Team norms introduced: PR process, review expectations, on-call rotation

### Week 2: First Feature
- [ ] Assigned a small feature from the backlog
- [ ] Pair programming session to unblock any questions
- [ ] Code review walkthrough: how does the team review PRs?
- [ ] Intro to monitoring: how to read dashboards, what to do if an alert fires

### Week 3–4: Independence
- [ ] Owns a medium feature end-to-end
- [ ] Knows who to ask for what
- [ ] Understands the deployment process
- [ ] 30-day check-in: what's unclear? what's frustrating?

### Onboarding Doc Template
```
# [Name]'s Onboarding Guide

## Before Day 1
- Hardware setup: [link]
- Accounts to create: GitHub, Slack, [tool]

## Dev Environment
1. Clone: `git clone ...`
2. Install deps: `make install`
3. Run locally: `make dev`
4. Verify: open http://localhost:3000

## Codebase Map
- Backend: `src/api/` — FastAPI routes
- Frontend: `web/` — Next.js pages
- Infra: `infra/` — Terraform

## Glossary
- [term]: [definition]

## Key People
- Architecture questions → @architect
- Frontend → @ui-lead
- On-call escalation → [runbook link]
```

## Key Outputs
- Onboarding checklist (per new hire)
- Dev environment setup script
- Codebase tour doc
- First PR within week 1

## Anti-Patterns
- Onboarding = "read the docs and ask questions"
- No first PR in week 1 (reduces confidence)
- No 30-day check-in to close feedback loop
- Docs that are outdated (setup fails → immediately demoralizing)
```

#### `skills/adr-writing/SKILL.md`
```markdown
---
name: adr-writing
description: Use when documenting architecture decisions, capturing the context and trade-offs behind technical choices
---

# ADR Writing (Architecture Decision Records)

## When to Use
When making a significant technical decision that will be hard to reverse, affects multiple teams, or needs to be understood by future engineers.

## Core Jobs

### 1. Know When to Write an ADR
Write one when:
- Choosing between 2+ significant technical options
- The decision affects system architecture, not just implementation detail
- Future engineers will wonder "why did they do it this way?"
- The decision is hard to reverse (database choice, API protocol, auth system)

Don't write one for: library patch versions, CSS changes, minor refactoring.

### 2. ADR Template
```markdown
# ADR-[NNN]: [Short Title]

**Date:** YYYY-MM-DD
**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-NNN
**Deciders:** [names or teams]

## Context
[What situation are we in? What forces are at play? What is the problem?]

## Decision
[The decision we made. Use active voice: "We will use X because..."]

## Options Considered

### Option A: [Name]
**Pros:** ...
**Cons:** ...

### Option B: [Name]
**Pros:** ...
**Cons:** ...

## Consequences

**Positive:**
- [What becomes easier or better?]

**Negative:**
- [What becomes harder or worse? What do we give up?]

**Risks:**
- [What could go wrong?]

## References
- [Links to relevant docs, RFCs, benchmarks]
```

### 3. Keep ADRs Immutable
- Never edit an accepted ADR's decision section
- If decision changes: create a new ADR that supersedes it
- Update status of old ADR to "Superseded by ADR-NNN"

### 4. Store and Link
- Keep in `docs/adr/` in the repo (versioned with code)
- Link from CLAUDE.md or README
- Reference in code comments when a non-obvious choice was made

## Key Outputs
- ADR document (in `docs/adr/`)
- Status updated in future ADRs if decision changes

## Anti-Patterns
- ADR written after the decision, without options considered
- Decision section is vague ("we chose Postgres because it's good")
- Editing accepted ADRs instead of superseding
- ADRs stored in Confluence/Notion, not in the repo
```

#### `skills/incident-postmortem/SKILL.md`
```markdown
---
name: incident-postmortem
description: Use when writing a blameless postmortem after an incident, identifying root causes, and building follow-up action items
---

# Incident Postmortem

## When to Use
After any P1/P2 incident, or any incident that surprised the team, caused user impact, or revealed a systemic gap.

## Process Checklist

### Within 24h of Incident Resolution
- [ ] Incident timeline drafted (in chronological order)
- [ ] All participants have reviewed the timeline for accuracy
- [ ] Postmortem meeting scheduled (within 5 business days)

### Postmortem Meeting (60 min)
- [ ] Facilitator is not the incident owner (reduces defensiveness)
- [ ] Rules set: blameless, focus on systems not people
- [ ] Timeline walked through — add missing context
- [ ] 5 Whys applied to root cause(s)
- [ ] Action items drafted with owners

### Postmortem Document
```markdown
# Postmortem: [Incident Title]

**Date:** YYYY-MM-DD
**Severity:** P1/P2
**Duration:** [start] → [end] ([total hours])
**User Impact:** [what users experienced, how many affected]
**Author(s):** [names]

## Summary
[2–3 sentences: what happened, what caused it, how it was resolved]

## Timeline
| Time (UTC) | Event |
|------------|-------|
| 14:00 | Alert fires: error rate > 5% |
| 14:05 | On-call acknowledges, begins investigation |
| 14:22 | Root cause identified: DB connection pool exhausted |
| 14:35 | Mitigation: restarted service, increased pool size |
| 14:40 | Error rate returns to baseline |
| 15:00 | Incident declared resolved |

## Root Cause Analysis (5 Whys)
- Why did users experience errors? → Service returned 500s
- Why? → DB queries timing out
- Why? → Connection pool exhausted
- Why? → Slow query held connections for 30s
- Why? → Missing index on table after migration

**Root Cause:** Missing index on `orders.user_id` after migration, causing full table scans

## What Went Well
- Alert fired within 2 minutes of impact
- On-call had context to diagnose quickly
- Rollback tested — wasn't needed but was ready

## What Went Poorly
- Migration didn't include index (no review checklist)
- No canary deployment caught query degradation
- Runbook for DB connection pool exhaustion was missing

## Action Items
| Item | Owner | Due |
|------|-------|-----|
| Add index to `orders.user_id` | @dbadmin | 2026-04-10 |
| Add migration review checklist | @platform | 2026-04-15 |
| Write DB connection pool runbook | @sre | 2026-04-15 |
| Add query latency alert | @platform | 2026-04-20 |
```

## Key Outputs
- Postmortem document (stored in incident tracking system)
- Action items added to sprint backlog
- Shared with wider team (learning culture)

## Anti-Patterns
- Blaming individuals ("the engineer who deployed...")
- Postmortem that lists symptoms but not root causes
- Action items with no owner or due date
- Not sharing the postmortem — others can't learn from it
```

#### `skills/tech-debt-triage/SKILL.md`
```markdown
---
name: tech-debt-triage
description: Use when prioritizing technical debt, deciding what to fix vs live with, or allocating time for debt reduction
---

# Tech Debt Triage

## When to Use
When technical debt is accumulating and affecting velocity, morale, or reliability, and the team needs a structured approach to address it.

## Core Jobs

### 1. Make Debt Visible
Collect all known debt items:
- Developer gripes in retros
- TODO/FIXME comments in code
- Slow test suites, flaky tests
- Manual processes that should be automated
- Known architectural shortcomings (no abstraction layer, tight coupling)
- Security vulnerabilities below critical threshold

Create a debt register: name, location, rough effort, last touched date.

### 2. Classify Debt
| Type | Example | Treatment |
|------|---------|-----------|
| Critical | Security vuln, data corruption risk | Fix this sprint |
| High | Causes bugs, slows feature dev significantly | Schedule soon |
| Medium | Slows dev, not blocking | Batch with related work |
| Low | Annoyance, cosmetic | Opportunistic (fix when passing by) |

### 3. Prioritize with Business Impact
Score: (Developer pain × Feature velocity impact) / Effort
- High pain + high velocity impact + low effort → fix now
- Low pain + low impact → deprioritize, don't spend cycles on it

### 4. Allocate Time
Options:
- **Explicit allocation**: 20% of sprint capacity reserved for debt
- **Paired with features**: fix debt in the area you're already touching
- **Debt sprints**: occasional full sprints for major rework (use sparingly — context switching hurts)

### 5. Prevent Accumulation
- Definition of done includes: "no new debt added without a ticket"
- Code review: flag debt additions, not just bugs
- Architectural decisions get ADRs so future debt is intentional

## Key Outputs
- Debt register with classification
- Prioritized top 5 debt items this quarter
- Time allocation policy
- Debt-prevention process

## Anti-Patterns
- "We'll fix it later" with no ticket created
- Debt sprints as the only mechanism (too infrequent)
- Prioritizing low-impact cosmetic debt over high-impact architectural debt
- No measurement of whether debt reduction improved velocity
```

#### `skills/knowledge-transfer/SKILL.md`
```markdown
---
name: knowledge-transfer
description: Use when handing off a system, preparing someone to own a codebase, or ensuring knowledge doesn't live in one person's head
---

# Knowledge Transfer

## When to Use
When a team member is leaving, changing roles, or when critical knowledge is concentrated in one person (bus factor = 1).

## Core Jobs

### 1. Identify What Needs Transfer
Map the knowledge:
- Systems owned: what does this person know that nobody else does?
- Undocumented processes: what do they do manually that isn't written down?
- Tribal knowledge: decisions made without ADRs, vendor relationships, historical context
- Access and credentials: what do they control?

### 2. Structured Handoff Sessions
For each area:
- **Walkthrough session**: they show, new owner drives (not watch)
- **Q&A session**: new owner has had 1 week with docs, asks questions
- **Shadow session**: new owner handles it, original provides safety net
- **Solo session**: new owner is on their own, original is available async

### 3. Documentation Artifacts
Produce per system/area:
- Architecture overview (1-pager: what it does, how it works, key components)
- Operational runbook (how to keep it running, common issues)
- Decision log (why it's built this way — the ADRs or equivalent)
- Access inventory (what credentials, where stored, how to rotate)

### 4. Knowledge Transfer Checklist
- [ ] All systems have a named new owner
- [ ] Runbooks written and reviewed by new owner
- [ ] Access transferred (not just shared — actual ownership)
- [ ] 30-day support period agreed (original available for questions)
- [ ] Knowledge gaps identified and addressed before departure

## Key Outputs
- Knowledge map (what → who knows it)
- Handoff documentation per system
- Session recordings (if permitted)
- 30-day support plan

## Anti-Patterns
- Documentation dump without walkthrough sessions
- Assuming new owner will "figure it out"
- Knowledge transfer the week before departure (not enough time)
- Bus factor not tracked — discovering the problem after the person leaves
```

#### `skills/experiment-tracking/SKILL.md`
```markdown
---
name: experiment-tracking
description: Use when designing A/B tests, managing experiment hypotheses, analyzing results, or building an experimentation culture
---

# Experiment Tracking

## When to Use
When validating product decisions with data before full rollout — A/B tests, multivariate tests, or staged rollouts with measurement.

## Core Jobs

### 1. Write the Hypothesis
Format: "We believe [change] will [outcome] for [user segment] because [reason]. We'll know we're right when [metric] changes by [amount] within [timeframe]."

Example: "We believe showing the pricing table earlier will increase trial-to-paid conversion for SMB users because they need to see value/cost before engaging. We'll know when 30-day conversion rate increases by 5% within 4 weeks."

### 2. Design the Experiment
- **Unit of randomization**: user, session, or request?
  - User: consistent experience, required for behavioral tests
  - Session: quick iteration, but user sees both variants
- **Sample size**: calculate minimum detectable effect (MDE)
  - Tools: Evan Miller's A/B sample size calculator
  - Higher traffic → detect smaller effects
- **Duration**: run until significance reached, minimum 2 weeks (capture weekly patterns)
- **Control**: what is the baseline? Is it actually the current production behavior?

### 3. Track the Experiment
Log per experiment:
- Hypothesis, variants, start date, expected end date
- Primary metric, secondary metrics, guardrail metrics
- Team owner, status (running/paused/concluded)

Prevent: running too many experiments simultaneously (interaction effects)

### 4. Analyze Results
- Check statistical significance (p < 0.05) before declaring winner
- Check practical significance (is the effect size meaningful?)
- Look at guardrail metrics (did we improve X but break Y?)
- Segment by key user groups — aggregate results can hide segment-level effects

### 5. Document and Share
- Write up results even for failed experiments (prevents re-running same test)
- Share with wider team — learning compounds

## Key Outputs
- Experiment brief (hypothesis, design, metrics)
- Statistical analysis (significance, effect size)
- Segment breakdown
- Decision memo (ship, iterate, or revert)

## Anti-Patterns
- Running experiments without statistical significance calculation
- Stopping early when results look good (peeking problem)
- No guardrail metrics (improving one metric while breaking another)
- Not documenting failed experiments
```

#### `skills/support-playbook/SKILL.md`
```markdown
---
name: support-playbook
description: Use when building a support triage process, writing escalation paths, or creating templates for common support issues
---

# Support Playbook

## When to Use
When setting up a support function, improving response quality, or reducing time-to-resolution on common issues.

## Core Jobs

### 1. Triage Framework
Classify every ticket on arrival:
| Priority | Criteria | Response SLA | Resolution SLA |
|----------|----------|-------------|----------------|
| P1 | System down, data loss, security issue | 15 min | 4 hours |
| P2 | Core feature broken, major workflow blocked | 1 hour | 24 hours |
| P3 | Feature degraded, workaround exists | 4 hours | 3 business days |
| P4 | General question, feature request | 24 hours | Best effort |

### 2. Common Issue Templates
For top 10 most frequent issues, write:
- **Symptom**: what the user reports
- **Root cause**: why it happens
- **Diagnostic steps**: how to confirm
- **Resolution**: exact steps to fix
- **Prevention**: how to avoid in future

### 3. Escalation Path
Define who handles what:
```
Tier 1 (Support) → Tier 2 (Senior Support / CS) → Tier 3 (Engineering)
```
Escalate to engineering when:
- Bug confirmed (reproducible, not user error)
- Data issue requiring DB access
- Security or privacy concern
- P1 not resolved in 2 hours

### 4. Quality and Metrics
Track per week:
- Ticket volume by category (spot trends)
- First response time by priority
- Resolution time by priority
- CSAT score
- Escalation rate to engineering (high rate = product/docs gap)

## Key Outputs
- Triage guide with priority matrix
- Template library for top issues
- Escalation path document
- Weekly metrics dashboard

## Anti-Patterns
- No priority triage — every ticket treated equally
- Support resolving issues without root cause (band-aid fixes)
- Engineering resolves tickets directly (doesn't scale, no knowledge capture)
- No CSAT tracking — don't know if support is actually helping
```

---

### Task 7: Phase 1 — Specialist Skills (7 files)

#### `skills/legal-compliance/SKILL.md`
```markdown
---
name: legal-compliance
description: Use when reviewing code, docs, or features for legal and regulatory requirements (GDPR, CCPA, SOC2, HIPAA, etc.)
---

# Legal Compliance

## When to Use
When building features that handle user data, launching in new markets, preparing for a security audit, or reviewing contracts.

## Core Jobs

### 1. Data Privacy (GDPR / CCPA)
For any feature handling personal data:
- **Data inventory**: what data is collected, where stored, who has access?
- **Legal basis**: consent, legitimate interest, or contract?
- **Rights support**: can users access, export, and delete their data?
- **Data minimization**: collect only what you actually need
- **Retention**: delete data after the defined retention period
- **Third parties**: do you share data with processors? DPAs in place?

GDPR red flags: no cookie consent for tracking, no privacy policy, no deletion mechanism.

### 2. Security Compliance (SOC2 / ISO 27001)
Common requirements:
- Access control: least privilege, MFA enforced, access reviews quarterly
- Encryption: at rest (AES-256) and in transit (TLS 1.2+)
- Audit logs: who accessed what, when (tamper-evident)
- Incident response: documented plan, tested annually
- Vendor risk: third parties assessed before use

### 3. Terms of Service and Privacy Policy Review
Check that policies cover:
- What data is collected and how it's used
- User rights (access, deletion, portability)
- Data retention periods
- Third-party sharing
- Contact for privacy inquiries (DPO if required)

### 4. Feature-Level Compliance Checklist
Before shipping a feature that handles PII:
- [ ] Privacy impact assessment completed
- [ ] Data added to data inventory
- [ ] Retention policy set
- [ ] User rights mechanism exists (if user data)
- [ ] Legal reviewed if new data category

## Key Outputs
- Data inventory / map
- Compliance gap analysis
- Feature-level privacy checklist
- Policy review notes

## Anti-Patterns
- "We'll handle compliance later" (technical debt with legal consequences)
- Assuming your jurisdiction's rules apply to all users
- No deletion mechanism — can't comply with right-to-erasure requests
- Privacy policy written by engineers without legal review
```

#### `skills/financial-modeling/SKILL.md`
```markdown
---
name: financial-modeling
description: Use when building unit economics models, financial projections, or analyzing the business viability of a feature or product
---

# Financial Modeling

## When to Use
When evaluating whether a business decision makes financial sense — new product, pricing change, market expansion, or funding round preparation.

## Core Jobs

### 1. Unit Economics
For a SaaS or marketplace, calculate:
- **CAC** (Customer Acquisition Cost) = Total sales & marketing spend / New customers acquired
- **LTV** (Lifetime Value) = ARPU × Gross Margin % × Average Customer Lifetime
- **LTV:CAC Ratio** — healthy = 3:1 or better
- **Payback Period** = CAC / (ARPU × Gross Margin %) — target < 12 months

### 2. Revenue Projections
Build a bottoms-up model:
```
New MRR = New customers × ARPU
Expansion MRR = Existing customers × upsell rate × upsell ARPU
Churned MRR = Churning customers × their ARPU
Net New MRR = New + Expansion - Churned
```
3 scenarios: pessimistic, base, optimistic (vary growth rate assumption)

### 3. Cost Structure
Fixed: salaries, infrastructure, office
Variable: hosting (per user), payment processing fees, customer support cost per ticket
Model cost per unit at different scale points (100, 1K, 10K customers)

### 4. Break-Even Analysis
Break-even = Fixed costs / (Revenue per unit - Variable cost per unit)
When does the model become profitable at current growth rate?

### 5. Sensitivity Analysis
Identify the top 3 assumptions that most affect the outcome:
- If churn is 5% vs 10%: how does LTV change?
- If CAC is 2x: when does payback period exceed 18 months?
Show a sensitivity table for each key assumption.

## Key Outputs
- Unit economics dashboard (CAC, LTV, payback)
- 3-scenario revenue projection (12–24 months)
- Break-even analysis
- Sensitivity table on key assumptions

## Anti-Patterns
- Top-down TAM projections without bottoms-up validation
- Ignoring churn in LTV calculations
- Single-scenario models (no pessimistic case)
- Not stress-testing assumptions
```

#### `skills/developer-advocacy/SKILL.md`
```markdown
---
name: developer-advocacy
description: Use when writing API documentation, creating developer tutorials, building devrel content, or engaging the developer community
---

# Developer Advocacy

## When to Use
When building developer-facing products, growing a developer community, or creating content that helps developers adopt your tools.

## Core Jobs

### 1. API Documentation
Every API must have:
- **Getting started**: working code in < 5 minutes (authentication + first call)
- **Endpoint reference**: method, path, params, request/response schemas, example
- **Code examples**: multiple languages (Python, JavaScript, at minimum)
- **Error reference**: what each error code means + how to fix it
- **Changelog**: what changed and when (developers plan around this)

Documentation should be tested — run every code example in CI.

### 2. Developer Tutorials
Structure for a good tutorial:
- What they'll build (clear outcome up front)
- Prerequisites (versions, accounts, what they need to know)
- Step-by-step with working code at each step
- What to do when things go wrong (common errors + fixes)
- Next steps (where to go from here)

Rule: every code snippet must work, copy-paste, right now.

### 3. DevRel Content
Channels and what works:
- **Blog posts**: deep dives, best practices, "how we built X"
- **Talks/conferences**: brand building, community trust
- **Demo apps**: real-world examples > toy examples
- **Office hours / Discord**: direct developer feedback (invaluable for product)
- **GitHub**: sample repos, issue response time matters

### 4. Community Engagement
- Respond to GitHub issues within 24h (even if just "acknowledged")
- Engage on Stack Overflow, Reddit, Discord where your users are
- Surface recurring friction to product team (advocacy is a feedback loop)
- Celebrate community contributions publicly

## Key Outputs
- API getting started guide
- Full endpoint reference
- Developer tutorial (end-to-end)
- Community engagement plan

## Anti-Patterns
- Documentation written by people who've never used the API
- Code examples that don't work
- No changelog (developers can't plan upgrades)
- DevRel disconnected from product (advocacy without influence)
```

#### `skills/solutions-architecture/SKILL.md`
```markdown
---
name: solutions-architecture
description: Use when designing pre-sales architectures, creating technical proposals, or helping customers integrate your platform
---

# Solutions Architecture

## When to Use
When working with prospects or customers to design how your platform fits into their technical environment — pre-sales, implementation planning, or technical advisory.

## Core Jobs

### 1. Discovery Call Architecture Intake
Questions to ask before designing anything:
- Current stack (languages, cloud, databases, auth systems)
- Scale requirements (current and projected users/transactions)
- Data sensitivity (PII? PHI? compliance requirements?)
- Integration requirements (what systems must connect?)
- Team capability (who will implement and maintain?)
- Timeline and phasing

### 2. Design the Architecture
Produce a reference architecture diagram:
- Data flow (where does data come from, go to, get processed?)
- Integration points (APIs, webhooks, SDKs, ETL)
- Security boundary (what's in their infra vs yours)
- Network topology (VPC peering, private link, or public API?)
- Scalability approach (how does it grow with them?)

### 3. Technical Proposal
Document:
- Proposed architecture with diagram
- Implementation phases (Phase 1: core integration, Phase 2: advanced features)
- Effort estimate (T-shirt: S/M/L per phase, not days)
- Open questions and risks
- Success criteria

### 4. Handle Objections
Common technical objections:
- "We can build this ourselves" → TCO analysis, time-to-market
- "We have security concerns" → security architecture review, compliance docs
- "It won't scale" → reference customers at similar scale, benchmark data
- "Integration is too complex" → PoC offer, professional services

## Key Outputs
- Architecture diagram
- Technical proposal document
- Integration guide
- Risk and open questions log

## Anti-Patterns
- Designing without understanding their constraints
- One-size-fits-all architecture for all customers
- Proposal with no phasing (overwhelming scope)
- Not addressing security and compliance upfront for regulated industries
```

#### `skills/blockchain-audit/SKILL.md`
```markdown
---
name: blockchain-audit
description: Use when reviewing smart contracts for security vulnerabilities, auditing web3 patterns, or preparing for a formal audit
---

# Blockchain & Smart Contract Audit

## When to Use
When reviewing Solidity/Rust smart contracts before deployment, preparing for a formal security audit, or assessing web3 integration risks.

## Core Jobs

### 1. Smart Contract Security Checklist
Critical vulnerabilities to check:
- [ ] **Reentrancy**: Does state update before external call? Use CEI pattern (Checks-Effects-Interactions)
- [ ] **Integer overflow/underflow**: Using SafeMath or Solidity 0.8+?
- [ ] **Access control**: Are admin functions properly restricted? (onlyOwner, role-based)
- [ ] **Front-running**: Can transaction ordering be exploited? (price oracle manipulation)
- [ ] **Unchecked return values**: Are all `.call()` return values checked?
- [ ] **Timestamp dependence**: Is `block.timestamp` used for randomness or time-sensitive logic?
- [ ] **Denial of service**: Can loops be made to run out of gas?
- [ ] **Logic errors**: Does the business logic match the spec exactly?

### 2. DeFi-Specific Risks
- **Flash loan attacks**: Can an attacker manipulate price oracles in a single transaction?
- **Price oracle manipulation**: Using on-chain DEX prices without TWAP?
- **Slippage**: Are swap functions protected against excessive slippage?
- **Liquidity**: Are there constraints on withdrawal that could trap funds?

### 3. Code Quality Review
- Test coverage: 100% line coverage expected for mainnet contracts
- Static analysis: run Slither, MythX, or Semgrep on contract code
- Fuzzing: Echidna or Foundry fuzz tests for edge cases
- Formal verification: for critical financial logic

### 4. Pre-Audit Checklist
- [ ] All known issues resolved or documented
- [ ] Test coverage > 95%
- [ ] Static analysis clean (no medium+ findings)
- [ ] Deployment scripts reviewed
- [ ] Emergency pause mechanism exists
- [ ] Upgrade mechanism reviewed (proxy pattern risks)

## Key Outputs
- Security findings report (severity: Critical / High / Medium / Low / Info)
- Pre-audit readiness assessment
- Remediation recommendations
- Post-fix verification

## Anti-Patterns
- Deploying to mainnet without audit
- "We'll fix it in the next version" for critical vulnerabilities (immutable contracts)
- Trusting on-chain data without validation
- No emergency mechanism — can't pause a compromised contract
```

#### `skills/hr-people-ops/SKILL.md`
```markdown
---
name: hr-people-ops
description: Use when designing hiring processes, writing job descriptions, running performance reviews, or documenting culture and values
---

# HR & People Operations

## When to Use
When building or improving hiring, performance management, or team culture systems.

## Core Jobs

### 1. Job Description Writing
Structure:
- **Role summary** (2–3 sentences): what they'll own, team they join, impact they'll have
- **Responsibilities** (5–7 bullets): what they'll do day-to-day, not generic
- **Requirements**: must-have (3–5) vs nice-to-have (2–3) — fewer = better candidates
- **Compensation range**: include it — it filters mismatches and signals transparency
- **Benefits**: meaningful ones only (not "free coffee")

Anti-jargon: remove "rockstar", "ninja", "hustle culture". List requirements people actually need.

### 2. Hiring Process Design
Stages:
1. Application screen (resume + cover letter or work sample)
2. Recruiter screen (30 min: culture, motivation, basics)
3. Technical screen (60 min: skills assessment)
4. Team interview (60–90 min: depth + cross-functional)
5. Offer

Per stage: define what you're assessing, who conducts it, decision criteria.
Document rubrics — reduces bias, enables consistent evaluation.

### 3. Performance Reviews
Cycle: quarterly check-ins + annual review (not annual-only)
Template:
- Goals set at period start (3–5, SMART)
- Self-assessment: what did you achieve? what would you do differently?
- Manager assessment: against goals and behaviors
- Development plan: 1–2 growth areas with support commitment

Calibration: managers review ratings together before communicating — reduces grade inflation.

### 4. Culture Documentation
Write what you actually do, not aspirational values:
- How decisions get made (top-down? consensus? disagree-and-commit?)
- How feedback is given (direct? only in reviews?)
- How work is structured (async-first? sync-heavy?)
- How people advance (what does promotion require?)

## Key Outputs
- Job description template
- Interview process guide with rubrics
- Performance review template
- Culture operating guide

## Anti-Patterns
- Job descriptions that are a wishlist (everyone must have 10 years experience in a 5-year-old technology)
- No rubrics — gut-feel hiring enables bias
- Annual-only reviews (feedback arrives too late)
- Culture deck that doesn't match lived reality
```

#### `skills/technical-documentation/SKILL.md`
```markdown
---
name: technical-documentation
description: Use when writing API docs, runbooks, user guides, architecture docs, or internal wikis
---

# Technical Documentation

## When to Use
When writing documentation that engineers, operators, or technical users will rely on to understand or operate a system.

## Core Jobs

### 1. Choose the Doc Type
| Type | Audience | Goal | Example |
|------|----------|------|---------|
| Tutorial | Beginners | Learning by doing | "Build your first API integration" |
| How-to guide | Intermediate | Achieve specific goal | "How to configure SSO" |
| Reference | Experienced | Lookup information | API endpoint reference |
| Explanation | Anyone | Understand why | "How our auth system works" |
(Divio documentation system)

Match the type to what the reader actually needs.

### 2. Writing Principles
- **Docs are code**: version them in git, review them like PRs
- **Test every code example**: if it doesn't run, don't publish it
- **Lead with the outcome**: what will they achieve by reading this?
- **Use second person**: "You will configure..." not "The user configures..."
- **Short sentences**: one idea per sentence
- **Active voice**: "Click Save" not "The Save button should be clicked"

### 3. API Reference Structure
Per endpoint:
```
## POST /api/v1/users

Create a new user account.

**Request**
Headers: Authorization: Bearer {token}
Body: { "email": "string", "name": "string" }

**Response (201)**
{ "id": "uuid", "email": "string", "created_at": "iso8601" }

**Errors**
400: Validation error (missing required field)
409: Email already exists
```

### 4. Keep Docs Current
- Add docs to Definition of Done for every feature
- Review docs in PRs (not separately)
- Measure: track docs pages with no updates in 6+ months
- Delete outdated docs — stale docs are worse than no docs

## Key Outputs
- Documentation structured by type (tutorial, reference, etc.)
- Code examples that are tested in CI
- Docs maintenance process

## Anti-Patterns
- Writing docs after launch (never gets done)
- Docs that describe the desired state, not actual behavior
- No examples — abstract descriptions without "show me"
- Single long page instead of structured hierarchy
```

---

### Task 8: Phase 2 — Marketing Skills (8 files)

#### `skills/content-strategy/SKILL.md`
```markdown
---
name: content-strategy
description: Use when building a content calendar, defining target audiences for content, or choosing content formats and distribution channels
---

# Content Strategy

## When to Use
When building or improving a content program — blog, video, newsletter, social, or any mix — to grow awareness, trust, or conversion.

## Core Jobs

### 1. Define the Goal and Audience
Content without a goal is noise:
- **Awareness goal**: reach new audiences who don't know you exist
- **Education goal**: help prospects understand the problem you solve
- **Conversion goal**: move decision-ready prospects to try or buy
- **Retention goal**: keep customers engaged and reduce churn

Per goal, define the audience segment: job title, company size, problem they have, where they spend time online.

### 2. Choose Content Types
Match format to goal and audience:
| Format | Best For | Distribution |
|--------|---------|-------------|
| Long-form blog | SEO, education | Search, newsletter |
| Short video | Awareness, demos | Social, YouTube |
| Case study | Conversion, trust | Sales, website |
| Newsletter | Retention, nurture | Email |
| Webinar/podcast | Authority, leads | LinkedIn, events |

### 3. Build the Content Calendar
Monthly planning:
- 1 pillar piece (long-form, high-value — blog post, guide, report)
- 4–8 derivative pieces from the pillar (social posts, email snippet, short video)
- 1–2 topical pieces (news response, seasonal, campaign-specific)

Use a spreadsheet: date | title | format | goal | owner | status | distribution channels

### 4. Measure Effectiveness
Primary metrics per goal:
- Awareness: impressions, reach, new visitors
- Education: time on page, return visitors, newsletter opens
- Conversion: CTR, leads, free trial starts
- Retention: email open rate, content consumption by customers

## Key Outputs
- Audience personas (1 per key segment)
- 90-day content calendar
- Content performance dashboard

## Anti-Patterns
- Content with no distribution plan
- Publishing cadence you can't sustain
- Measuring vanity metrics (likes) instead of business metrics
- No repurposing — writing every piece from scratch
```

#### `skills/seo-optimization/SKILL.md`
```markdown
---
name: seo-optimization
description: Use when improving organic search rankings, conducting keyword research, or fixing technical SEO issues
---

# SEO Optimization

## When to Use
When trying to increase organic traffic through better search visibility — new pages, existing content improvement, or technical SEO fixes.

## Core Jobs

### 1. Keyword Research
Find terms your audience searches:
- Tools: Google Search Console (what you already rank for), Ahrefs/Semrush (competitors), Google Keyword Planner
- Target: keywords where you can realistically rank (look at current top-10 DR/authority)
- Categorize: informational ("what is X"), navigational ("X login"), commercial ("best X tools"), transactional ("buy X")
- Start with long-tail (lower competition, higher intent)

### 2. On-Page Optimization
Per page:
- **Title tag**: keyword first, under 60 chars, compelling click (not just keyword stuffing)
- **Meta description**: 150–160 chars, include keyword, CTA
- **H1**: one per page, includes primary keyword
- **URL**: short, keyword-rich, no parameters (`/keyword-phrase/`)
- **Content**: keyword in first 100 words, H2s cover related terms, 1000+ words for competitive terms
- **Internal links**: link from authority pages to this page
- **Images**: alt text describes content (helps accessibility and SEO)

### 3. Technical SEO
Checklist:
- [ ] Core Web Vitals: LCP < 2.5s, FID < 100ms, CLS < 0.1
- [ ] Mobile-friendly (Google's Mobile-Friendly Test)
- [ ] HTTPS (ranking signal)
- [ ] Sitemap.xml submitted to Google Search Console
- [ ] No crawl errors in GSC
- [ ] Canonical tags on duplicate or near-duplicate pages
- [ ] Structured data (schema.org) for key page types

### 4. Link Building
- Create link-worthy content (research, tools, unique data)
- HARO (Help a Reporter Out) for journalist mentions
- Guest posts on relevant blogs
- Fix broken links on sites linking to similar content
- Never buy links (Google penalty risk)

## Key Outputs
- Keyword research spreadsheet (by page/topic)
- On-page optimization checklist
- Technical SEO audit report
- Link building outreach log

## Anti-Patterns
- Targeting high-competition keywords when you have low authority
- Keyword stuffing (hurts rankings since 2011)
- Ignoring technical SEO while producing content
- Expecting results in 1–2 months (SEO is 3–6+ months)
```

#### `skills/social-media-planning/SKILL.md`
```markdown
---
name: social-media-planning
description: Use when building a social media strategy, scheduling content, or adapting messaging per platform
---

# Social Media Planning

## When to Use
When building or running a social media presence to grow brand, drive traffic, or engage community.

## Core Jobs

### 1. Choose the Right Platforms
Don't be everywhere. Pick based on audience:
| Platform | Best For | Content Style |
|----------|---------|--------------|
| LinkedIn | B2B, professionals | Thought leadership, case studies |
| Twitter/X | Tech, startups, news | Short takes, threads, conversations |
| Instagram | Consumer, visual brands | Photo, Reels, Stories |
| TikTok | Consumer, < 35, entertainment | Short video, trends |
| YouTube | Education, demos, deep content | Long-form video |

Choose 2 platforms and do them well, not 5 platforms poorly.

### 2. Content Mix (70/20/10 Rule)
- **70% value**: educational, entertaining, helpful — no ask
- **20% social proof**: customer stories, results, testimonials
- **10% promotional**: product launches, offers, CTAs

### 3. Posting Schedule
Consistency > frequency. Start with:
- LinkedIn: 3x/week (Mon/Wed/Fri)
- Twitter: 1–3x/day (news moves fast)
- Instagram: 3–5x/week
- TikTok: daily or near-daily (algorithm rewards frequency)

Batch content production weekly, schedule in advance (Buffer, Hootsuite).

### 4. Engagement Rules
- Respond to comments within 4 hours (business hours)
- Reply to DMs within 24 hours
- Engage with community content — don't just broadcast
- Track: which posts get the most saves/shares (high value) vs likes (vanity)

## Key Outputs
- Platform strategy (which platforms, why, target audience)
- Monthly content calendar
- Content templates per platform
- Engagement metrics dashboard

## Anti-Patterns
- Same content copy-pasted across all platforms (each has its own native style)
- Posting without a goal (awareness? clicks? leads?)
- Automated-only engagement (no real human responses)
- Optimizing for likes instead of shares/saves (shares = reach, saves = value)
```

#### `skills/growth-hacking/SKILL.md`
```markdown
---
name: growth-hacking
description: Use when designing viral loops, improving activation rates, running retention experiments, or building growth models
---

# Growth Hacking

## When to Use
When trying to accelerate user acquisition, activation, or retention through product-led, data-driven experiments.

## Core Jobs

### 1. Diagnose with the Pirate Funnel (AARRR)
- **Acquisition**: how are users finding you? (by channel)
- **Activation**: % reaching "aha moment" (first value experienced)?
- **Retention**: % returning after day 1, 7, 30?
- **Revenue**: conversion rate, ARPU, expansion rate?
- **Referral**: % of new users from existing users?

Find the biggest leak in the funnel — that's where to focus.

### 2. Design Viral Loops
Built-in virality:
- **Collaboration**: invite teammates to use product together
- **Social sharing**: results naturally shareable ("I just got X on [product]")
- **Incentive referral**: "Give $10, get $10" (Dropbox, Uber model)
- **Content virality**: user-generated content that markets product by existing

Viral coefficient K > 1 means exponential growth.

### 3. Improve Activation
Find the "aha moment" (first time user experiences core value):
- Map the onboarding flow step by step
- Find where >20% of users drop off
- Reduce steps to aha moment (remove friction)
- Guide users there faster (tooltips, email sequences, in-app nudges)

### 4. Retention Experiments
Tactics:
- Habit triggers: notifications at the right moment, not mass blasts
- Streak mechanics: daily engagement incentive
- Progress indicators: show users how far they've come
- Win-back campaigns: reactivate churned users with targeted message

## Key Outputs
- Funnel analysis (AARRR metrics by channel)
- Viral loop design
- Activation experiment backlog
- Retention experiment results

## Anti-Patterns
- Growth hacking before product-market fit (leaky bucket)
- Optimizing for acquisition while retention is poor
- Dark patterns (fake urgency, misleading copy) — destroys trust
- Running too many experiments simultaneously (can't attribute results)
```

#### `skills/email-marketing/SKILL.md`
```markdown
---
name: email-marketing
description: Use when designing email campaigns, building drip sequences, segmenting lists, or improving deliverability
---

# Email Marketing

## When to Use
When building email as a growth, activation, or retention channel — newsletters, drip campaigns, or transactional email.

## Core Jobs

### 1. List Segmentation
Never send the same email to your whole list:
- By lifecycle stage: lead → trial → paid → churned
- By behavior: opened last 3 emails vs never opens
- By company size: SMB vs enterprise
- By role: developer vs manager vs executive

More targeted = higher open rates, lower unsubscribes.

### 2. Drip Sequence Design
Structure for trial/onboarding sequence:
- Day 0: Welcome + one immediate action to take
- Day 1: Core use case #1 (with example or tutorial)
- Day 3: Core use case #2
- Day 5: Social proof (customer story)
- Day 7: "Have you tried X?" (feature prompt if not activated)
- Day 10: Case study + conversion CTA

Each email: one goal, one CTA. Not four things at once.

### 3. Copywriting Principles
- **Subject line**: specific > vague. "How [Company] reduced churn by 23%" > "Check out our new feature"
- **First line**: matters for preview text. Make it useful immediately.
- **Body**: short paragraphs, one idea each. Under 200 words is ideal.
- **CTA**: one button, action-oriented ("Start your free trial"), contrasting color

### 4. Deliverability
Technical setup:
- SPF, DKIM, DMARC records configured
- Dedicated sending domain (not shared IP pool)
- Warm up new domain gradually (start 50/day, ramp over 4–6 weeks)
- Clean list: remove bounces immediately, unsubscribes < 24h

Maintain: open rate > 20%, unsubscribe rate < 0.5%, spam rate < 0.08%

## Key Outputs
- Drip sequence (email copy + timing)
- Segmentation strategy
- Deliverability technical setup checklist
- Campaign performance report

## Anti-Patterns
- Same email to entire list (spray and pray)
- Email subject lines as "Newsletter #47"
- No unsubscribe mechanism (CAN-SPAM/GDPR violation)
- Buying email lists (destroys deliverability)
```

#### `skills/analytics-reporting/SKILL.md`
```markdown
---
name: analytics-reporting
description: Use when building marketing dashboards, attribution models, or reporting on campaign performance
---

# Marketing Analytics & Reporting

## When to Use
When measuring marketing performance, attributing revenue to channels, or building the dashboards stakeholders use to make decisions.

## Core Jobs

### 1. Define Marketing KPIs
Tier 1 (CEO/board cares):
- Pipeline generated (revenue value of leads created)
- Revenue influenced by marketing
- Customer Acquisition Cost (CAC) by channel

Tier 2 (Marketing team cares):
- MQLs (marketing qualified leads) by channel
- SQL conversion rate (MQL → Sales Qualified Lead)
- Campaign ROI (revenue / spend per campaign)

Tier 3 (Channel managers care):
- CPL (cost per lead) by campaign
- Click-through rate, conversion rate
- Email open/click rates

### 2. Attribution Models
How to give credit to touchpoints:
- **Last touch**: 100% credit to last channel before conversion (simple, common, misleading)
- **First touch**: 100% credit to first channel (good for awareness measurement)
- **Linear**: equal credit across all touchpoints
- **Time decay**: more credit to recent touchpoints
- **Data-driven**: ML-based (requires high volume, GA4/Rockerbox)

Recommendation: use multi-touch for strategic decisions, last-touch for channel budgeting.

### 3. Build the Dashboard
Tool: Looker, Tableau, GA4, or even Google Sheets.
Structure:
- Page 1: Executive summary (pipeline, revenue, CAC — this month vs last month vs goal)
- Page 2: Channel breakdown (spend, leads, CPL, CAC per channel)
- Page 3: Campaign performance (individual campaign ROI)
- Page 4: Email metrics (by segment and campaign)

### 4. Reporting Cadence
- Weekly: channel performance vs targets (10-min standup)
- Monthly: full report with insights and recommendations
- Quarterly: attribution review and budget reallocation

## Key Outputs
- Marketing KPI definitions
- Attribution model selection rationale
- Dashboard (with automated data refresh)
- Monthly report template

## Anti-Patterns
- Reporting without comparing to targets or previous period
- Only reporting what went well (cherry-picking)
- Last-touch attribution for multi-channel programs (misleads budget decisions)
- Dashboard no one looks at — ask stakeholders what decisions they need to make
```

#### `skills/brand-voice/SKILL.md`
```markdown
---
name: brand-voice
description: Use when defining tone of voice guidelines, ensuring messaging consistency, or onboarding writers to your brand
---

# Brand Voice

## When to Use
When defining how your brand communicates — to ensure consistency across teams, channels, and content types.

## Core Jobs

### 1. Define Voice vs Tone
- **Voice**: consistent personality traits (doesn't change)
- **Tone**: how voice adapts per context (does change)

Example: Brand voice is "knowledgeable but approachable"
- Tone in marketing: enthusiastic, forward-looking
- Tone in support: empathetic, reassuring
- Tone in error messages: calm, helpful, never apologetic to a fault

### 2. Write the Voice Characteristics
3–4 traits, each with:
- The trait name
- What it means in practice
- "We say X, not Y" examples
- What it doesn't mean (the common misinterpretation)

Example:
**Direct** — We say what we mean without hedging.
✓ "This will take 3 minutes."
✗ "This might take a few minutes or so."
Not: blunt or rude.

### 3. Create a Messaging Framework
- **Tagline**: 5–7 words, memorable, captures the core benefit
- **Elevator pitch**: 2 sentences — problem we solve + for whom + how we're different
- **Key messages** per audience: what do we want them to believe after reading our content?
- **Proof points**: evidence that backs each key message

### 4. Build the Style Guide
Practical rules for writers:
- Vocabulary: words we use and words we avoid
- Grammar: Oxford comma? Active or passive voice? Numbers spelled out?
- Product name capitalization and usage
- Abbreviations and acronyms

## Key Outputs
- Voice characteristics (3–4 traits with examples)
- Messaging framework (tagline, elevator pitch, key messages)
- Style guide (vocabulary, grammar rules)
- Before/after examples for each trait

## Anti-Patterns
- Brand guidelines document nobody reads
- Voice defined by committee compromise ("bold but safe, edgy but professional")
- No examples — abstract descriptions without "we say X, not Y"
- Not training new writers on the voice
```

#### `skills/launch-planning/SKILL.md`
```markdown
---
name: launch-planning
description: Use when planning a product or feature launch, building a GTM strategy, or coordinating a cross-functional release
---

# Launch Planning

## When to Use
When taking a new product, major feature, or significant update to market — ensuring coordinated, high-impact execution.

## Core Jobs

### 1. Define the Launch Tier
Not every release needs a full launch:
- **Tier 1** (major): new product, pricing change, major rebrand → full GTM plan, 4+ weeks prep
- **Tier 2** (significant): major feature, new integration → 1–2 weeks prep, targeted comms
- **Tier 3** (standard): regular feature release → changelog + in-app notification

Match effort to impact.

### 2. GTM Strategy
Answer before building the launch plan:
- Who is the target customer for this launch?
- What's the hook (one sentence that makes them want to learn more)?
- What channels will you use to reach them?
- What's the desired action (sign up, upgrade, share)?

### 3. Launch Checklist (Tier 1)

**4 weeks out:**
- [ ] Launch brief written and approved
- [ ] Pricing finalized
- [ ] Landing page copy and design approved
- [ ] PR outreach started (embargo briefings)

**2 weeks out:**
- [ ] Blog post written, reviewed, scheduled
- [ ] Email sequence built and tested
- [ ] Social content created and scheduled
- [ ] Sales team briefed and enabled (battle cards, FAQ)
- [ ] Support team briefed (expect increased volume)

**Launch day:**
- [ ] Published: landing page, blog, social, email
- [ ] Team on standby for support spike
- [ ] Real-time monitoring: sign-ups, errors, support volume

**1 week post:**
- [ ] Performance report: sign-ups, coverage, social engagement
- [ ] What worked / what to do differently next time

### 4. Coordinate Cross-Functional
- Weekly launch sync starting 4 weeks out
- RACI for each workstream: Product, Marketing, Sales, Support, Engineering
- Single Slack channel for launch coordination

## Key Outputs
- Launch brief (audience, hook, channels, goal)
- Launch checklist with owners
- Launch metrics dashboard
- Post-launch report

## Anti-Patterns
- Launch planned after feature is built (too late to shape the narrative)
- Engineering shipping without telling marketing
- No support prep (first-day support spike goes unanswered)
- No post-launch analysis — same mistakes repeated next launch
```

---

### Task 9: Phase 2 — Sales Skills (5 files)

#### `skills/discovery-call/SKILL.md`
```markdown
---
name: discovery-call
description: Use when running discovery calls, qualifying opportunities, or applying MEDDIC/SPIN selling frameworks
---

# Discovery Call

## When to Use
When engaging a prospect for the first time to understand if they're a good fit and what they need.

## Core Jobs

### 1. Before the Call
Research:
- Company: size, industry, recent news, funding
- Contact: role, tenure, LinkedIn activity
- Account: have they tried your product? any prior engagement?
Prepare 5 open-ended questions specific to their situation.

### 2. Run the Call (MEDDIC Framework)
**M — Metrics**: What are the business outcomes they want to achieve? (Quantify: "reduce X by Y%")
**E — Economic Buyer**: Who controls the budget? Are you talking to them?
**D — Decision Criteria**: How will they evaluate options? What matters most?
**D — Decision Process**: What steps do they go through to make this decision?
**I — Identify Pain**: What's the problem they're trying to solve? What's the cost of NOT solving it?
**C — Champion**: Is there someone internally who will advocate for you?

### 3. Uncover Pain (SPIN)
- **Situation**: "Tell me about your current [process/tool/team]"
- **Problem**: "What's not working well about that?"
- **Implication**: "What impact does that have on [revenue/team/timeline]?"
- **Need-payoff**: "If you could solve that, what would that mean for you?"

### 4. Qualify or Disqualify
Disqualify early if:
- No budget or budget cycle is 12+ months away
- No economic buyer engagement possible
- Problem doesn't match your solution
- Unrealistic timeline expectations

Not every opportunity is worth pursuing — disqualifying is a good outcome.

## Key Outputs
- Discovery call notes (MEDDIC filled in)
- Qualification score (should we pursue?)
- Next steps agreed and sent via email post-call

## Anti-Patterns
- Presenting features before understanding pain
- Talking more than listening (target: 30% talking, 70% listening)
- Not confirming next steps before hanging up
- Continuing to pursue unqualified opportunities
```

#### `skills/proposal-writing/SKILL.md`
```markdown
---
name: proposal-writing
description: Use when writing sales proposals, structuring pricing presentations, or articulating value propositions
---

# Proposal Writing

## When to Use
When a prospect has expressed interest and needs a formal proposal to make a purchase decision.

## Core Jobs

### 1. Before Writing
Confirm you have:
- [ ] Their specific pain points (from discovery)
- [ ] Their success metrics (what does good look like for them?)
- [ ] Budget range (don't propose blindly)
- [ ] Decision timeline and process
- [ ] The right audience (who will read this?)

If any of these are missing — go back and find out before writing.

### 2. Proposal Structure
```
1. Executive Summary (1 page)
   - Their situation and challenge (in their words, not yours)
   - Your recommended solution
   - Expected outcomes (quantified)

2. Understanding Your Challenge (1/2 page)
   - Show you listened. Demonstrate that you understood their specific context.

3. Proposed Solution (1–2 pages)
   - What you're recommending and why (tailored to them, not your standard deck)
   - Implementation approach and timeline

4. Investment (pricing)
   - Clear pricing options (if applicable: tiered)
   - What's included / excluded
   - Payment terms

5. Why Us (1/2 page)
   - Relevant customer proof (similar company, similar problem)
   - Not a generic "about us" — make it relevant to their context

6. Next Steps
   - What happens when they say yes?
   - Proposed start date
```

### 3. Quantify Value
Every proposal should answer: "What's the ROI?"
- Cost of their current problem (quantified by them in discovery)
- Expected improvement your solution delivers
- Simple math: "Based on your numbers, this represents $Xk in annual savings"

### 4. Pricing Presentation
- Present 2–3 options (anchoring — middle option is usually chosen)
- Name the options, not just tier 1/2/3 ("Starter / Growth / Scale")
- Include a recommended option based on their needs

## Key Outputs
- Tailored proposal document
- ROI calculation
- Pricing options table
- Follow-up email template

## Anti-Patterns
- Generic proposals that could be for any company
- Proposing before understanding budget
- Leading with features instead of outcomes
- No next steps — proposal disappears into a void
```

#### `skills/pipeline-management/SKILL.md`
```markdown
---
name: pipeline-management
description: Use when reviewing deal stages, maintaining CRM hygiene, building forecasts, or analyzing pipeline health
---

# Pipeline Management

## When to Use
When managing a sales pipeline — reviewing deal health, forecasting revenue, or improving CRM data quality.

## Core Jobs

### 1. Define Stage Definitions
Each stage needs an objective criterion to move forward — not "rep feels good about it":
| Stage | Criteria to Enter | Exit Criteria |
|-------|------------------|---------------|
| Qualified | MEDDIC partially complete, pain confirmed | Discovery call completed |
| Demo | Problem aligned, right buyer engaged | Demo delivered, next steps agreed |
| Proposal | Economic buyer engaged, budget confirmed | Proposal sent and reviewed |
| Negotiation | Verbal commitment, pricing discussed | Signed contract |

### 2. Weekly Pipeline Review
For each deal in pipeline:
- Last activity date (> 2 weeks = at risk)
- Next step with a date
- Economic buyer engaged? (Y/N)
- Blockers?

Deal health score: Green (on track) / Yellow (at risk) / Red (stalled)

### 3. Build the Forecast
Weighted pipeline:
- Each deal × close probability by stage
- Stage probabilities: Qualified 20%, Demo 40%, Proposal 60%, Negotiation 80%
- Compare: weighted pipeline vs quota for the month/quarter

Categories:
- **Commit**: deals you'll stake your reputation on closing
- **Best case**: deals that could close with some luck
- **Pipeline**: full weighted value

### 4. Pipeline Hygiene
Monthly:
- Close or remove deals with no activity in 30 days
- Update stage, close date, deal value
- Ensure next step exists for every deal

## Key Outputs
- Stage definitions with objective criteria
- Weekly pipeline review template
- Forecast spreadsheet (weighted by stage)
- Pipeline hygiene report

## Anti-Patterns
- Stage definitions based on rep's gut feeling
- Deals sitting in "Proposal" stage for 60+ days without update
- Forecast based on gut, not weighted pipeline
- Deals with no next steps (they will stall)
```

#### `skills/sales-coaching/SKILL.md`
```markdown
---
name: sales-coaching
description: Use when running call reviews, building rep onboarding plans, handling objection training, or improving sales team performance
---

# Sales Coaching

## When to Use
When developing sales rep capability — new hire ramp plans, call reviews, or addressing skill gaps.

## Core Jobs

### 1. Call Review Framework
For each call reviewed, evaluate:
- **Opening**: did they set an agenda and get buy-in?
- **Discovery**: did they uncover pain (implication level) or just surface-level?
- **Listening ratio**: were they talking > 50% of the time?
- **Objection handling**: did they acknowledge before responding?
- **Next steps**: were concrete next steps agreed before hanging up?

Score each dimension 1–5. Identify one area to focus coaching on (not all five at once).

### 2. Ramp Plan for New Reps
30/60/90 day structure:
- **Day 1–30**: Product knowledge, ICP, discovery framework. Shadow 10 calls. No solo calls.
- **Day 31–60**: First solo discovery calls (with debrief). Learn objection handling. Close 1 deal with help.
- **Day 61–90**: Full pipeline. Hit ramp quota (50–75% of full quota). Independent.

Monthly 1:1s: pipeline review + skill development (one focus per month).

### 3. Objection Handling
For each common objection, document:
- **The objection**: exact wording ("We're happy with our current solution")
- **Underlying concern**: what do they really mean? (fear of change, switching cost)
- **Response framework**: Acknowledge → Explore → Respond
  - "That's fair — what's working well with your current setup?" (dig deeper)
  - "A lot of our customers felt the same way until they saw [specific result]. Here's what changed for them."

### 4. Performance Conversations
When a rep is underperforming:
- Diagnose: is it activity (not enough conversations), skill (not converting), or pipeline (wrong ICP)?
- Each requires a different intervention
- Set specific, measurable improvement targets (not "do better")
- 30-day improvement plan with weekly check-ins

## Key Outputs
- Call review scorecard
- 30/60/90 day ramp plan template
- Objection handling playbook
- Performance improvement plan template

## Anti-Patterns
- Coaching on all dimensions at once (overwhelming)
- Call reviews without a framework (subjective, not actionable)
- No ramp quota (new reps expected to hit full quota in month 1)
- Diagnosing activity problem when it's actually a skill problem
```

#### `skills/deal-strategy/SKILL.md`
```markdown
---
name: deal-strategy
description: Use when navigating complex enterprise deals, multi-stakeholder sales, or competitive displacement situations
---

# Deal Strategy

## When to Use
When a deal has multiple stakeholders, a long sales cycle, or a competitive situation requiring strategic navigation.

## Core Jobs

### 1. Map the Stakeholder Landscape
For each person involved in the decision:
- Role and influence (decision-maker, influencer, blocker, champion)
- What they personally care about (career risk, budget ownership, technical requirements)
- Their stance: Supporter / Neutral / Detractor

Draw the influence map: who influences whom?
Your champion = the person who will sell for you when you're not in the room.

### 2. Develop a Multi-Thread Strategy
Never single-thread (one contact = single point of failure).
Plan to reach:
- Economic buyer (budget sign-off)
- Technical evaluator (will use the product)
- Champion (internal advocate)
- Business owner (outcome owner)

For each: tailored message addressing their specific concern.

### 3. Competitive Positioning
When you know there's a competitor in the deal:
- Find out: who introduced them? What stage are they at?
- Never badmouth — "they're great at X, we're purpose-built for Y"
- Understand your champion's preference — if they prefer competitor, find out why
- Create competitive traps: demonstrations or proof points that expose the competitor's weakness

### 4. Navigate Negotiation
Tactics:
- Anchor high on value, not on price
- Never make concessions without asking for something in return
- Know your walk-away point before entering negotiation
- Concession sequence: discount on one tier, add implementation support, adjust payment terms — never just cut price

## Key Outputs
- Stakeholder map (influence diagram)
- Multi-thread engagement plan
- Competitive positioning brief
- Negotiation strategy document

## Anti-Patterns
- Single-threading a deal (one contact, one point of failure)
- Leading with price instead of value
- Making concessions without asking for anything in return
- No champion — no one selling for you when you're not there
```

---

### Task 10: Phase 2 — Testing Skills (5 files)

#### `skills/api-contract-testing/SKILL.md`
```markdown
---
name: api-contract-testing
description: Use when validating API schemas, detecting breaking changes, or setting up consumer-driven contract testing
---

# API Contract Testing

## When to Use
When multiple services or teams consume an API and you need to catch breaking changes before they reach production.

## Core Jobs

### 1. Define the Contract
A contract = what the consumer expects:
- Request format: method, path, required headers, body schema
- Response format: status code, body schema, required fields
- Error responses: what errors can occur, in what format

Use OpenAPI spec as the source of truth. Every endpoint must be documented.

### 2. Consumer-Driven Contract Testing (Pact)
Let consumers define what they expect:
```python
# Consumer test (Python Pact)
@consumer('FrontendApp')
@provider('UserAPI')
def test_get_user(pact):
    pact.given('user 123 exists').upon_receiving('a request for user 123').with_request(
        method='GET', path='/api/v1/users/123'
    ).will_respond_with(200, body=Like({'id': '123', 'email': like('string')}))
```
Provider verifies it can satisfy all consumer contracts before deploying.

### 3. Breaking Change Detection
Breaking changes (always require major version bump):
- Removing a field
- Changing a field type
- Changing an endpoint path
- Making an optional field required
- Changing error format

Non-breaking (safe to add):
- Adding new optional fields
- Adding new endpoints
- Adding new optional parameters

Use tools: Spectral (OpenAPI linting), Optic, or Bump.sh for automated detection.

### 4. Contract Testing in CI
- Consumer pushes contract to Pact Broker on test pass
- Provider verifies contracts before merge
- Deploy only when all consumer contracts pass

## Key Outputs
- OpenAPI spec (source of truth)
- Consumer-driven contract tests (Pact or equivalent)
- Breaking change detection CI step
- Versioning policy

## Anti-Patterns
- Manual API documentation (drifts from implementation)
- Breaking changes with no version bump
- No contract tests — discovering breakage in production
- Consumer contract tests only — provider never verifies
```

#### `skills/performance-testing/SKILL.md`
```markdown
---
name: performance-testing
description: Use when load testing APIs, profiling bottlenecks, or validating performance SLAs before release
---

# Performance Testing

## When to Use
When you need to validate that a system can handle expected load, find bottlenecks before users do, or establish performance baselines.

## Core Jobs

### 1. Define Performance Requirements
Before testing, specify:
- **Throughput target**: X requests/sec at peak
- **Latency target**: P95 < Nms, P99 < Nms
- **Error rate target**: < X% under load
- **Duration**: how long must it sustain this load?

Without these, you don't know if your test passed.

### 2. Write Load Test Scripts
k6 example:
```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 50 },   // ramp up to 50 users
    { duration: '5m', target: 50 },   // stay at 50
    { duration: '2m', target: 100 },  // ramp to 100
    { duration: '5m', target: 100 },  // stay at 100
    { duration: '2m', target: 0 },    // ramp down
  ],
};

export default function () {
  const res = http.get('https://api.example.com/users');
  check(res, { 'status was 200': (r) => r.status === 200 });
  sleep(1);
}
```

### 3. Run and Observe
During the test, watch:
- Latency trend (is it flat or climbing?)
- Error rate
- CPU and memory on the server
- Database connection pool utilization
- Queue depths (if async)

The throughput "knee" = where latency starts degrading rapidly. Don't target above this.

### 4. Profile and Fix Bottlenecks
When tests fail:
- Use APM (Datadog, New Relic) to find slow traces
- Database: check slow query log, explain plan, missing indexes
- CPU: profile with py-spy, pprof, or async-profiler (JVM)
- Memory: heap dump analysis

## Key Outputs
- Load test script (version controlled)
- Performance requirements document
- Test results report (percentile breakdown)
- Bottleneck analysis and fixes

## Anti-Patterns
- Testing without defined pass/fail criteria
- Testing average load only (not peak or spike)
- No profiling when tests fail — "we need more servers" is rarely the fix
- Running performance tests against production
```

#### `skills/accessibility-audit/SKILL.md`
```markdown
---
name: accessibility-audit
description: Use when auditing WCAG compliance, testing with assistive technologies, or fixing accessibility issues
---

# Accessibility Audit

## When to Use
When ensuring a web product is usable by people with disabilities — required for legal compliance and good UX for all users.

## Core Jobs

### 1. WCAG 2.1 Core Principles (POUR)
- **Perceivable**: can users perceive all content? (alt text, captions, color contrast)
- **Operable**: can users operate all UI? (keyboard nav, no seizure triggers, enough time)
- **Understandable**: is the UI clear? (readable language, predictable behavior, error messages)
- **Robust**: does it work across assistive technologies? (valid HTML, ARIA)

Target AA compliance as the standard (AAA is aspirational).

### 2. Automated Testing
Run first — catches ~30% of issues:
```bash
npx axe-cli https://yoursite.com
npx pa11y https://yoursite.com
```
Or in CI: integrate axe-core with Jest/Cypress.

Automated checks: missing alt text, low color contrast, missing form labels, invalid ARIA.

### 3. Manual Testing Checklist
- [ ] **Keyboard navigation**: Tab through every interactive element. Can you reach and activate all of them?
- [ ] **Skip links**: Is there a "Skip to main content" link?
- [ ] **Focus indicators**: Is focus visible on every interactive element?
- [ ] **Screen reader test**: VoiceOver (Mac/iOS), NVDA (Windows), TalkBack (Android)
  - Does every image have meaningful alt text?
  - Are form fields labeled?
  - Are dynamic content changes announced?
- [ ] **Color contrast**: 4.5:1 for normal text, 3:1 for large text
- [ ] **Zoom to 200%**: Does content reflow without horizontal scrolling?
- [ ] **Motion**: Does it respect `prefers-reduced-motion`?

### 4. Report and Prioritize
Per issue:
- WCAG criterion violated (e.g., 1.1.1 Non-text Content)
- Impact: Critical (blocks users) / Serious / Moderate / Minor
- Screenshot + code location
- Fix recommendation

## Key Outputs
- Automated test results
- Manual audit report
- Prioritized fix list (by impact)
- Regression test to prevent recurrence

## Anti-Patterns
- Relying only on automated testing (misses 70% of issues)
- Treating accessibility as a one-time audit
- "We'll add ARIA attributes" instead of fixing semantic HTML
- Not testing with actual screen reader users
```

#### `skills/test-strategy/SKILL.md`
```markdown
---
name: test-strategy
description: Use when building a test coverage plan, choosing what to test at each layer, or applying risk-based testing to focus effort
---

# Test Strategy

## When to Use
When starting a new project, the test suite is chaotic, or coverage is either too low (bugs slip through) or too high (tests slow everything down).

## Core Jobs

### 1. Apply the Testing Pyramid
```
         /\
        /E2E\         (few — slow, expensive, fragile)
       /------\
      /Integration\   (some — verify service interactions)
     /------------\
    /  Unit Tests  \  (many — fast, isolated, specific)
   /--------------\
```
Invert = ice cream cone = too many E2E tests = slow, flaky CI.

### 2. Decide What to Test at Each Layer
**Unit** (function/class level):
- Complex business logic (calculations, transformations)
- Edge cases and error paths
- Pure functions with clear inputs/outputs
- Skip: simple CRUD, framework boilerplate

**Integration** (service/DB level):
- API endpoints with real DB
- External service integrations (with test doubles or test environments)
- Data access layer

**E2E** (full stack):
- Critical user journeys (sign up, key workflow, checkout)
- 3–10 tests max — not comprehensive coverage

### 3. Risk-Based Testing
Prioritize coverage based on:
- **Business risk**: payment processing, auth, data integrity → high coverage
- **Change frequency**: code that changes often → more tests
- **Complexity**: high cyclomatic complexity → unit test thoroughly
- **User impact**: features used by 80% of users → E2E coverage

### 4. Test Quality Metrics
Track:
- Test pass rate (flaky tests = warning sign)
- Coverage % by layer (target: 80% unit + critical integration paths)
- Time to run full suite (target: < 10 min for pre-merge)

## Key Outputs
- Test strategy document (what to test, at what layer, why)
- Coverage targets by risk category
- CI test suite configuration
- Flaky test backlog

## Anti-Patterns
- Testing implementation details, not behavior (breaks on refactor)
- E2E tests for everything (slow, flaky, hard to debug)
- No integration tests (unit tests pass, integration fails)
- 100% coverage as a goal (diminishing returns after 80%)
```

#### `skills/quality-gates/SKILL.md`
```markdown
---
name: quality-gates
description: Use when defining definition of done, setting release criteria, or building automated quality checks into the CI/CD pipeline
---

# Quality Gates

## When to Use
When establishing what "done" means, preventing low-quality code from reaching production, or reducing manual QA overhead.

## Core Jobs

### 1. Definition of Done (DoD)
Agree team-wide: a story is done only when ALL of these pass:
- [ ] Code reviewed and approved (≥ 1 reviewer)
- [ ] Unit tests written and passing
- [ ] Integration tests passing
- [ ] No new lint errors
- [ ] No new security vulnerabilities (SAST scan)
- [ ] Feature tested in staging environment
- [ ] Acceptance criteria verified by PO or QA
- [ ] Documentation updated (if user-facing)

DoD applies to every story — no exceptions without explicit team agreement.

### 2. Automated Gates in CI
Pipeline structure:
```
PR opened → lint → unit tests → build
           → integration tests
           → security scan (Snyk/Semgrep)
           → coverage check (must not drop below threshold)
           → [merge gated on all passing]

Merge to main → E2E tests → staging deploy → smoke tests
              → [production deploy gated on all passing]
```

### 3. Release Criteria
Before any production release:
- [ ] All CI gates passing
- [ ] No open Critical or High severity bugs
- [ ] Load test run at expected peak traffic
- [ ] Rollback plan documented and tested
- [ ] On-call briefed on what's shipping and any risk areas
- [ ] Feature flags in place for rollback without deploy (if needed)

### 4. Non-Negotiable Gates
Some gates should block unconditionally:
- Critical security vulnerability → cannot merge
- Test coverage drops > 5% → cannot merge
- Build fails → cannot merge

Make these non-negotiable and enforce in CI — not as optional warnings.

## Key Outputs
- Team Definition of Done checklist
- CI pipeline configuration (gates per stage)
- Release criteria checklist
- Non-negotiable gates policy

## Anti-Patterns
- DoD that's aspirational but not enforced
- Manual-only quality gates (human gates get skipped under pressure)
- Gates that warn but don't block (everyone ignores warnings)
- No release criteria — "it's done when it's done"
```

---

### Task 11: Phase 2 — Game Dev Skills (5 files)

#### `skills/game-design-doc/SKILL.md`
```markdown
---
name: game-design-doc
description: Use when writing a Game Design Document (GDD), defining core mechanics, or planning player loops
---

# Game Design Document

## When to Use
When starting a new game project, aligning team members on what to build, or documenting mechanics for implementation.

## Core Jobs

### 1. Core Concept (1 page)
- **Logline**: one sentence that captures the essence. "A roguelite deck-builder where your deck evolves based on how you play, not what you pick."
- **Genre(s)**: be specific (roguelite, not "action")
- **Target player**: who plays this? ("people who played Hades and want more narrative depth")
- **Core emotion**: what feeling does the player chase? (power fantasy, tension, exploration)
- **Platform and estimated scope**

### 2. Core Loop (the fun part)
The 3 layers:
- **Micro loop** (seconds): what does the player do moment-to-moment?
- **Macro loop** (minutes): what is the session goal?
- **Meta loop** (hours/days): what keeps them coming back?

Write it as actions, not features:
"Player fights → defeats enemy → gains resources → upgrades → faces harder enemy → (repeat)" ✓
"Combat system with progression mechanics" ✗

### 3. Mechanics Documentation
Per mechanic:
- Name and description
- Player interaction (what does the player do?)
- Rules (exact behavior, edge cases)
- Feel goal (what should it feel like?)
- Implementation notes (for engineers)

### 4. Scope Management
MoSCoW for game design:
- **Must have** (launch): core loop, win/lose conditions, 1 environment, tutorial
- **Should have** (launch): 3 environments, variety, polish
- **Could have** (post-launch): extra modes, community features
- **Won't have** (this version)**: cut anything that doesn't serve the core loop

## Key Outputs
- Game concept and logline
- Core loop diagram (3 layers)
- Mechanics documentation
- MoSCoW feature list

## Anti-Patterns
- GDD with no core loop — features without a framework
- Designing features before validating the core loop is fun
- Scope that exceeds team capacity by 3x
- Not playtesting before full implementation
```

#### `skills/level-design/SKILL.md`
```markdown
---
name: level-design
description: Use when designing game levels, planning pacing and challenge curves, or documenting spatial layouts
---

# Level Design

## When to Use
When designing individual levels or encounters — from first-time player intro to end-game challenge.

## Core Jobs

### 1. Define the Level's Purpose
Every level has one primary goal:
- **Teach**: introduce a mechanic (tutorial)
- **Test**: challenge players with what they've learned
- **Rest**: lower intensity — exploration, narrative, reward
- **Boss**: peak challenge + culmination of zone themes

Mix these across a campaign: teach → test → rest → boss.

### 2. Pacing and Challenge Curve
- Establish a baseline difficulty before ramping it up
- Never increase difficulty on multiple axes simultaneously (new enemy type + new mechanic + harder platforming = frustration)
- Place rewards near challenges (reward = dopamine hit after difficulty spike)
- "Dark Souls rule": if players are stuck, add a shortcut or bonfire — don't just make it easier

### 3. Layout Principles
- **Legibility**: players should understand where to go without a map (environmental cues, lighting, framing)
- **Exploration reward**: optional paths should have meaningful rewards
- **Landmarks**: unique visual elements help players navigate and remember space
- **Flow**: optimal path should feel natural; detours should feel like discovery

### 4. Document the Level
Per level / room:
- Top-down map sketch (rough — specifics handled in engine)
- Enemy placement and patrol patterns
- Reward locations
- Narrative beats (if any)
- Intended time to complete and player emotional arc

## Key Outputs
- Level brief (purpose, player arc, difficulty target)
- Layout map with annotations
- Enemy and reward placement doc
- Pacing chart for the zone/campaign

## Anti-Patterns
- Difficulty spikes without preparation
- Linear levels with no exploration reward
- Teaching a mechanic and immediately testing it at max difficulty
- Levels with no clear navigation cues ("where am I supposed to go?")
```

#### `skills/narrative-design/SKILL.md`
```markdown
---
name: narrative-design
description: Use when designing game story structure, writing branching dialogue, building lore, or planning narrative delivery
---

# Narrative Design

## When to Use
When designing the story, world lore, characters, and dialogue systems for a game.

## Core Jobs

### 1. Story Structure
Games aren't films — story must interweave with gameplay:
- **Environmental storytelling**: world tells story without cutscenes (notes, ruins, NPC behavior)
- **Emergent narrative**: player actions create their own story moments
- **Authored narrative**: scripted story beats at key moments
Good games use all three. Great narrative games balance player agency with authored moments.

### 2. Character Design
Per character:
- **Want**: what do they actively pursue?
- **Need**: what do they actually need (often different from want)?
- **Wound**: what in their past drives them?
- **Arc**: how do they change (or don't) by the end?

Player character: be careful with agency — player agency and authored arc can conflict.

### 3. Branching Dialogue
Design principles:
- Meaningful choices: must produce different outcomes (not just different flavor text)
- Player expression vs player influence: sometimes branches express personality, sometimes they change outcomes — be clear which is which
- Convergence: branches that recombine need clear narrative justification
- Tools: Ink (by Inkle), Yarn Spinner, Twine for writing and testing

Document per choice node:
- The choice options (player-facing)
- What each selects for (tone, faction, stat)
- Consequence (immediate + long-term flags set)

### 4. Lore Architecture
- Build only what players will discover (unused lore = wasted effort)
- Layer: surface lore (visible to all), discoverable lore (for explorers), deep lore (for completionists)
- Consistency bible: world rules, timeline, faction relationships

## Key Outputs
- Story outline (major beats, act structure)
- Character bibles (key characters)
- Dialogue script with branching (Ink/Yarn format)
- Lore consistency bible

## Anti-Patterns
- Story delivered entirely through unskippable cutscenes
- Choices with no real consequence ("illusion of choice" players notice)
- Lore dumps in opening monologue
- Building lore that players will never encounter
```

#### `skills/game-audio/SKILL.md`
```markdown
---
name: game-audio
description: Use when writing a sound design brief, planning music direction, or building the audio systems specification for a game
---

# Game Audio

## When to Use
When defining audio direction for a game — music, sound effects, and audio systems.

## Core Jobs

### 1. Audio Direction Brief
Define the audio identity of the game:
- **Genre reference**: "Dark Souls meets No Man's Sky — orchestral tension with ambient electronic elements"
- **Emotional targets per zone**: dungeon (dread, tension), village (warmth, safety), boss (epic, urgency)
- **Instrumentation palette**: live orchestra? synth? folk instruments? hybrid?
- **Reference tracks**: 3–5 existing tracks that capture the target feel per zone

### 2. Music System Design
Types of music integration:
- **Linear**: pre-composed tracks, play and loop (simple, less reactive)
- **Vertical layering**: single track with stems that fade in/out based on game state
  - Example: combat enters → percussion stem adds; enemy defeated → fade back to ambient
- **Horizontal re-sequencing**: different sections that transition based on state (Wwise adaptive music)
- **Procedural**: generated music (rare — used in No Man's Sky, some roguelites)

Define per area: which system, what states trigger transitions, how transitions work (crossfade, stinger, instant).

### 3. Sound Effects Specification
For each significant mechanic:
- Action trigger (what causes the sound?)
- Emotional intent (what should the player feel?)
- Audio character (short/long, high/low, synthetic/organic)
- Priority level (what gets ducked if audio budget is full?)

Critical sounds: weapon impact, footsteps on surfaces, UI feedback, damage received, death.

### 4. Technical Audio Budget
Per platform:
- Simultaneous voices: how many sounds at once? (mobile: 16–32, console: 64–128)
- Memory budget for loaded assets
- Streaming vs loaded: music streams, frequent SFX loaded into RAM

## Key Outputs
- Audio direction brief
- Music system design document
- SFX specification per mechanic
- Technical audio budget

## Anti-Patterns
- Music that doesn't change between combat and exploration
- Generic placeholder audio that ships ("we'll replace it later")
- No audio budget planning until console cert fails
- SFX designed without considering the emotional context
```

#### `skills/technical-art/SKILL.md`
```markdown
---
name: technical-art
description: Use when writing shader briefs, defining performance budgets, creating LOD strategies, or bridging art and engineering
---

# Technical Art

## When to Use
When optimizing a game's visual pipeline, writing briefs for shaders or VFX, or establishing art performance standards.

## Core Jobs

### 1. Performance Budgets
Define per target platform before art production starts:
| Asset Type | Budget |
|-----------|--------|
| Character polygons | 5k–15k (mobile), 50k–200k (console/PC) |
| Environment polygon density | Define per view distance |
| Texture resolution | 512–1024 (mobile), 2048–4096 (console/PC) |
| Draw calls per frame | < 100 (mobile), < 500 (console) |
| Particle count per effect | 50–100 (mobile), 500–1000 (console) |

Set budgets before production — retrofitting is expensive.

### 2. LOD Strategy (Level of Detail)
- LOD0: full detail (close up)
- LOD1: 50% polygon reduction (medium distance)
- LOD2: 25% of original (far distance)
- LOD3: impostor / billboard (very far)
- Transition distances: define per asset category in the engine

Automatic LOD generation: Simplygon, InstaLOD, or Unreal/Unity auto-LOD.

### 3. Shader Briefs
Per shader (e.g., "Water Surface Shader"):
- Visual reference: 3 screenshots of target look
- Required inputs: base color, normal map, roughness, depth
- Key effects: refraction, foam at shoreline, dynamic waves
- Performance target: N instructions max (for mobile: aggressive)
- Platform constraints: mobile = no tessellation, no geometry shaders

### 4. VFX Performance Guidelines
Per effect:
- Max particle count
- Texture sheet size
- Screen space vs world space
- Overdraw limit (transparent particles = expensive)
- Mobile fallback (simplified version for low-end)

## Key Outputs
- Platform performance budget document
- LOD strategy and transition distances
- Shader briefs (per unique shader)
- VFX performance guidelines
- Art pipeline documentation

## Anti-Patterns
- Defining budgets after art production begins
- No LOD system (tanks performance at mid-range view distances)
- Shaders written without performance constraints
- No mobile fallbacks for particle-heavy effects
```

---

### Task 12: Phase 2 — Spatial Computing Skills (3 files)

#### `skills/xr-interface-design/SKILL.md`
```markdown
---
name: xr-interface-design
description: Use when designing for XR (AR/VR/MR), choosing interaction modes, or adapting 2D UI patterns for spatial computing
---

# XR Interface Design

## When to Use
When building user interfaces for augmented reality, virtual reality, or mixed reality experiences.

## Core Jobs

### 1. Input Modality Selection
Choose the right input for each interaction:
| Modality | Use When | Avoid When |
|----------|---------|-----------|
| Gaze + dwell | Hands occupied, accessibility | Fast interactions (too slow) |
| Hand tracking | Natural, markerless | Precise targets < 2cm |
| Controller | Precision, gaming | Markerless consumer AR |
| Voice | Quick commands, eyes-free | Noisy environments, private |
| Spatial tap (visionOS) | Natural selection | Complex gestures |

Prefer direct manipulation (touch the thing) over raycast menus where possible.

### 2. Spatial UI Placement
- **Arm's length zone** (0.5–2m): optimal for readable, interactive UI
- **Too close** (< 0.5m): causes eye strain, uncomfortable
- **Too far** (> 3m): hard to read, hard to interact with
- **World-locked**: UI stays in the world (good for contextual info)
- **Head-locked**: UI follows the user (use sparingly — causes motion sickness)
- **Body-locked**: locked to body position but not rotation (good compromise)

### 3. Comfort Guidelines
- No interaction requiring sustained arm elevation (gorilla arm fatigue)
- Minimum interaction target size: 2cm × 2cm at interaction distance
- Depth conflicts: avoid placing UI that competes visually with real world objects in AR
- Frame rate: VR must target ≥ 72fps (90fps preferred); drops cause motion sickness

### 4. Adapt 2D Patterns for 3D
- Replace dropdown menus with radial menus or spatial panels
- Replace hover states with proximity highlight (gaze or hand approach)
- Replace modals with spatial overlays that don't block the world
- Depth cue for hierarchy: closer elements = foreground = more important

## Key Outputs
- Input modality map (what triggers what)
- Spatial placement spec
- Comfort review checklist
- 2D → 3D adaptation guide

## Anti-Patterns
- Porting 2D UI directly into 3D space (flat UI panels floating in space)
- Head-locked menus for anything other than critical HUD
- Interaction targets below minimum size
- No affordance for the interaction mode (users don't know what's interactive)
```

#### `skills/spatial-ux/SKILL.md`
```markdown
---
name: spatial-ux
description: Use when designing 3D layouts, applying depth cues, planning spatial hierarchies, or ensuring user comfort in spatial experiences
---

# Spatial UX

## When to Use
When designing the spatial organization of content, navigation, or interaction in a 3D environment.

## Core Jobs

### 1. Spatial Hierarchy
Establish importance through space:
- **Proximity**: close = relevant, far = background
- **Scale**: larger = more important (use carefully — very large objects in AR can feel threatening)
- **Height**: eye level = primary, above = secondary, below = tertiary
- **Depth order**: foreground vs background as organizational principle

### 2. Depth Cues for Clarity
Human depth perception cues to leverage:
- **Occlusion**: objects in front block objects behind (strong depth cue)
- **Perspective foreshortening**: farther objects appear smaller
- **Atmospheric perspective**: subtle blur/haze on distant objects
- **Drop shadows**: helps objects read as floating vs embedded in world
- **Motion parallax**: objects at different depths move differently with head movement

### 3. Navigation Design
In spatial environments:
- Teleportation (VR): reduces motion sickness, but loses sense of scale
- Smooth locomotion (VR): immersive, causes sickness for some users — offer both
- Physical movement (AR/MR): user walks naturally — design for walkable spaces
- Waypoints and maps: spatial environments need orientation aids (landmarks, minimap)

### 4. Environmental Storytelling Through Space
- Use lighting to direct attention (bright = look here)
- Use sound spatially (audio cue from the direction of important events)
- Negative space as breathing room — don't fill every cubic meter

## Key Outputs
- Spatial hierarchy diagram
- Depth cue specification
- Navigation design (locomotion approach)
- Environmental UX guidelines

## Anti-Patterns
- Flat 2D thinking applied to 3D space (all elements at same Z depth)
- No waypoints in large environments (users get lost)
- Only smooth locomotion in VR (excludes users with motion sensitivity)
- Overloading spatial cues (too many competing visual signals)
```

#### `skills/visionos-patterns/SKILL.md`
```markdown
---
name: visionos-patterns
description: Use when designing for Apple visionOS, applying spatial design conventions, or building for the Apple Vision Pro platform
---

# visionOS Design Patterns

## When to Use
When building apps or experiences for Apple Vision Pro using visionOS.

## Core Jobs

### 1. Window and Volume Types
| Type | Use When |
|------|---------|
| Window (2D) | App that's a panel (productivity, media) |
| Volume (3D) | App that places 3D objects in the world |
| Full Space (immersive) | Experiences that take over the environment |
| Passthrough + Space | Mixed: real world + digital content |

Start with Windows unless 3D is core to your experience. Full Space requires explicit user action to enter.

### 2. visionOS Interaction Model
- **Eyes**: primary pointer (look at to select)
- **Hands**: secondary (pinch to activate what eyes look at)
- **Voice**: third modality (Siri integration)
- Target affordance: elements must communicate they're interactive (hover effect via eye gaze)
- Standard gestures: tap (index + thumb pinch), press (sustained pinch), drag (pinch + move)

### 3. visionOS HIG Key Principles
- **Passthrough integration**: respect the real environment. Don't design as if user is in darkness.
- **Window anchoring**: windows can be anchored to surfaces or float in space. Float is default.
- **Depth and layers**: use SwiftUI's `.depth()` modifier to create z-axis separation
- **Materials**: use vibrancy and glass materials (`.regularMaterial`, `.thickMaterial`) — don't use flat opaque backgrounds
- **Ornaments**: secondary controls that float beside the main window (don't crowd the main content area)

### 4. RealityKit and SwiftUI Integration
- UI layer: SwiftUI (same as iOS/iPadOS)
- 3D content: RealityKit entities
- Spatial audio: attach audio sources to 3D entities
- Hand tracking: ARKit hand anchors for custom gesture recognition

## Key Outputs
- Window/volume/space type selection rationale
- Interaction design spec (what gestures trigger what)
- visionOS HIG compliance review
- Material and depth specification

## Anti-Patterns
- iOS app ported to visionOS without redesign (violates HIG, feels unnatural)
- Opaque flat backgrounds (use glass materials)
- Tiny interaction targets (minimum 44pt × 44pt, larger for gaze-only)
- Full Space for experiences that don't need it (jarring for users to enter)
```

---

### Task 13: New Command — `/install-skills`

**File:** `commands/install-skills.md`

```markdown
---
description: "Browse and install optional skills from magic-powers into your project"
---

Browse and install optional skill packs from the magic-powers library.

## Step 1: Show Category Menu

Display the 11 skill categories:

```
🎯 Optional Skills Library — magic-powers

Choose a category to browse:

 1. Product (6 skills)               — user stories, roadmaps, stakeholder comms
 2. Data/ML (9 skills)               — pipelines, experiments, MLOps
 3. Platform/SRE (6 skills)          — SLOs, capacity, chaos engineering
 4. Design/UX (4 skills)             — UX audit, design systems, user research
 5. Team Processes (9 skills)        — sprints, ADRs, postmortems, onboarding
 6. Marketing (8 skills)             — content, SEO, growth, email, launch
 7. Sales (5 skills)                 — discovery, proposals, pipeline, coaching
 8. Testing (5 skills)               — contracts, performance, accessibility
 9. Game Dev (5 skills)              — GDD, level design, narrative, audio
10. Spatial Computing (3 skills)     — XR, spatial UX, visionOS
11. Specialist (7 skills)            — legal, finance, devrel, solutions arch

Enter number (1–11), "all" to see all skills, or "done" to exit:
```

## Step 2: Show Skills in Category

When user picks a category, show skills with descriptions:

```
📊 Data/ML Skills

 1. data-pipeline-design    — ETL/ELT patterns, streaming vs batch
 2. data-quality            — Validate and test data pipelines
 3. data-modeling           — Schema design for analytics (star schema, etc.)
 4. ml-experiment-tracking  — Experiment management, reproducibility
 5. model-evaluation        — Metrics, bias detection, validation
 6. feature-engineering     — Feature selection, transformation patterns
 7. mlops-deployment        — Model serving, canary/shadow releases
 8. model-monitoring        — Drift detection, retraining triggers
 9. training-pipeline       — Orchestration, versioning

Enter skill numbers (e.g. 1,3,5), "all", or "back":
```

## Step 3: Install Selected Skills

For each selected skill:
1. Check if `${CLAUDE_PLUGIN_ROOT}/skills/<name>/SKILL.md` exists
2. Create directory `.claude/skills/<name>/` in current project if needed
3. Copy SKILL.md to `.claude/skills/<name>/SKILL.md`

Confirm installation:
```
✅ Installed 3 skills to .claude/skills/:

  📋 .claude/skills/data-pipeline-design/SKILL.md
  📋 .claude/skills/ml-experiment-tracking/SKILL.md
  📋 .claude/skills/model-evaluation/SKILL.md

These skills are now auto-loaded into every Claude session in this project.
Browse another category or type "done" to exit.
```

## Notes
- Skills already installed: show "(already installed)" and skip copy
- User can install from multiple categories before typing "done"
- "all" at category level installs all skills in that category
- "all" at category menu level is not supported (too many — use /setup for role packs)
```

---

### Task 14: Update `/setup` Command

**File:** `commands/setup.md`
**Changes:** Expand Step 2 roles (5 → 12) and add Optional Skills section to Step 4.

**Step 2 replacement:**
```markdown
## Step 2: Ask Role
Ask the user:
> What's your role?
>  1. Solo Builder (full stack, làm hết)
>  2. Frontend Developer
>  3. Backend Developer
>  4. Product Manager
>  5. Team Lead
>  6. Data Scientist / ML Engineer
>  7. Data Engineer
>  8. SRE / Platform Engineer
>  9. Product Designer
> 10. Marketer / Growth
> 11. Sales / BD
> 12. Game Developer
```

**Step 4 addition — Optional Skills section** (add after MCP Servers block, before Stack-specific):
```markdown
> **Optional Skills:**
> - [ ] 📦 Install recommended skill pack for your role ← based on role detected above
>
> [Shows role-specific recommendation]:
>   Solo Builder      → Product + Platform/SRE
>   Frontend Dev      → Design/UX + Testing
>   Backend Dev       → Platform/SRE + Testing
>   Product Manager   → Product + Team Processes
>   Team Lead         → Team Processes + Product
>   Data Scientist    → Data/ML
>   Data Engineer     → Data/ML + Platform/SRE
>   SRE / Platform    → Platform/SRE + Team Processes
>   Product Designer  → Design/UX + Product
>   Marketer / Growth → Marketing
>   Sales / BD        → Sales + Specialist (solutions-architecture)
>   Game Developer    → Game Dev
>
> Browse all skill categories? Run /install-skills
```

**Step 5 addition — Install skill packs** (add to "Generate Files" section):
```markdown
### If skill pack selected:
For each skill in the recommended packs:
Copy `${CLAUDE_PLUGIN_ROOT}/skills/<name>/SKILL.md` → `.claude/skills/<name>/SKILL.md`

Show in Step 6 summary:
  📦 .claude/skills/<category>/ (N skills installed)
```

**Step 2 also adds recommended agents for new roles:**
```
- Data Scientist: architect, debugger, technical-writer
- Data Engineer: architect, sre, debugger
- SRE / Platform: sre, debugger, architect
- Product Designer: ui-designer, reviewer, product-strategist
- Marketer: copywriter, product-strategist, technical-writer
- Sales: product-strategist, copywriter
- Game Developer: architect, technical-writer, reviewer
```

---

### Task 15: Create `docs/OPTIONAL_SKILLS.md`

**File:** `docs/OPTIONAL_SKILLS.md`

```markdown
# Optional Skills Catalog

Browse and install skills with `/install-skills`. Install recommended packs during `/setup`.

## How It Works

Skills live in `magic-powers/skills/`. When installed, they're copied to `.claude/skills/<name>/SKILL.md` in your project and auto-loaded into every Claude session.

## Categories

### 🎯 Product (6 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| User Story Writing | `user-story-writing` | Write user stories with acceptance criteria |
| Roadmap Planning | `roadmap-planning` | Quarterly planning, ICE/MoSCoW prioritization |
| Stakeholder Communication | `stakeholder-communication` | Status updates, exec presentations |
| Product Metrics | `product-metrics` | Define KPIs, measure product health |
| Competitive Analysis | `competitive-analysis` | Research competitors, position features |
| Feedback Synthesis | `feedback-synthesis` | Synthesize user feedback into actionable insights |

### 📊 Data/ML (9 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| Data Pipeline Design | `data-pipeline-design` | ETL/ELT patterns, streaming vs batch |
| Data Quality | `data-quality` | Validate and test data pipelines |
| Data Modeling | `data-modeling` | Schema design for analytics |
| ML Experiment Tracking | `ml-experiment-tracking` | Experiment management, reproducibility |
| Model Evaluation | `model-evaluation` | Metrics, bias detection, validation |
| Feature Engineering | `feature-engineering` | Feature selection, transformation patterns |
| MLOps Deployment | `mlops-deployment` | Model serving, canary/shadow releases |
| Model Monitoring | `model-monitoring` | Drift detection, retraining triggers |
| Training Pipeline | `training-pipeline` | Orchestration, versioning |

### ⚙️ Platform/SRE (6 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| SLO/SLI Design | `slo-sli-design` | Define SLOs, SLIs, error budgets |
| Capacity Planning | `capacity-planning` | Load projections, scaling decisions |
| Chaos Engineering | `chaos-engineering` | Resilience testing patterns |
| On-Call Runbook | `on-call-runbook` | Write actionable runbooks |
| Cloud Cost Review | `cloud-cost-review` | Rightsizing, reserved instances, waste |
| Performance Benchmarking | `performance-benchmarking` | Measure baselines, compare before/after |

### 🎨 Design/UX (4 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| UX Audit | `ux-audit` | Heuristic evaluation of existing UX |
| Design System Audit | `design-system-audit` | Component consistency, token review |
| User Research | `user-research` | Interview guides, usability testing |
| Design Handoff | `design-handoff` | Specs, assets, developer communication |

### 👥 Team Processes (9 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| Sprint Planning | `sprint-planning` | Backlog refinement, capacity, sprint goals |
| Sprint Retrospective | `sprint-retrospective` | Formats, actionable outcomes |
| Team Onboarding | `team-onboarding` | Dev env setup, codebase intro, first PR |
| ADR Writing | `adr-writing` | Architecture Decision Records |
| Incident Postmortem | `incident-postmortem` | Blameless postmortem, follow-ups |
| Tech Debt Triage | `tech-debt-triage` | Prioritize, track, allocate time |
| Knowledge Transfer | `knowledge-transfer` | Documentation, pairing, handoffs |
| Experiment Tracking | `experiment-tracking` | A/B tests, hypothesis management |
| Support Playbook | `support-playbook` | Triage support tickets, escalation paths |

### 📣 Marketing (8 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| Content Strategy | `content-strategy` | Content calendar, audience targeting, formats |
| SEO Optimization | `seo-optimization` | On-page SEO, keyword strategy, technical SEO |
| Social Media Planning | `social-media-planning` | Platform-specific strategy, scheduling |
| Growth Hacking | `growth-hacking` | Viral loops, activation, retention experiments |
| Email Marketing | `email-marketing` | Drip campaigns, segmentation, copywriting |
| Analytics Reporting | `analytics-reporting` | Marketing metrics, attribution, dashboards |
| Brand Voice | `brand-voice` | Tone guidelines, messaging consistency |
| Launch Planning | `launch-planning` | GTM strategy, launch checklist, coordination |

### 💼 Sales (5 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| Discovery Call | `discovery-call` | Qualification framework, pain discovery, MEDDIC |
| Proposal Writing | `proposal-writing` | Structure, pricing, value proposition |
| Pipeline Management | `pipeline-management` | Stage definitions, hygiene, forecasting |
| Sales Coaching | `sales-coaching` | Call review, objection handling, ramp plans |
| Deal Strategy | `deal-strategy` | Multi-stakeholder navigation, negotiation |

### 🧪 Testing (5 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| API Contract Testing | `api-contract-testing` | Schema validation, breaking change detection |
| Performance Testing | `performance-testing` | Load testing, profiling, bottleneck analysis |
| Accessibility Audit | `accessibility-audit` | WCAG compliance, assistive tech testing |
| Test Strategy | `test-strategy` | Coverage plan, risk-based testing, pyramid |
| Quality Gates | `quality-gates` | Definition of done, release criteria |

### 🎮 Game Dev (5 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| Game Design Doc | `game-design-doc` | GDD structure, mechanics, player loops |
| Level Design | `level-design` | Flow, pacing, challenge curves |
| Narrative Design | `narrative-design` | Story structure, branching dialogue, lore |
| Game Audio | `game-audio` | Sound design brief, music direction |
| Technical Art | `technical-art` | Shader brief, performance budgets, LOD strategy |

### 🌐 Spatial Computing (3 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| XR Interface Design | `xr-interface-design` | XR UX patterns, interaction modes |
| Spatial UX | `spatial-ux` | 3D layout, depth cues, comfort guidelines |
| visionOS Patterns | `visionos-patterns` | visionOS spatial design conventions |

### 🔬 Specialist (7 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| Legal Compliance | `legal-compliance` | GDPR, CCPA, SOC2, HIPAA review |
| Financial Modeling | `financial-modeling` | Unit economics, forecasting, projections |
| Developer Advocacy | `developer-advocacy` | API docs, tutorials, devrel content |
| Solutions Architecture | `solutions-architecture` | Pre-sales architecture, integration design |
| Blockchain Audit | `blockchain-audit` | Smart contract review, web3 security |
| HR & People Ops | `hr-people-ops` | Hiring, performance reviews, culture |
| Technical Documentation | `technical-documentation` | API docs, runbooks, user guides |
```

---

### Task 16: Update README

**File:** `README.md`
**Changes:**
- Update skill count: 43 → 110 (43 built-in + 67 optional)
- Add "Optional Skills" section after existing Skills section
- Add `/install-skills` to commands list
- Update description if still says "dev-focused"

---

## Execution Order

1. Task 1: Validation script
2. Tasks 2–7: Phase 1 skills (41 files) — can parallelize by category
3. Task 8: `/install-skills` command
4. Task 9: Update `/setup`
5. Task 10: `docs/OPTIONAL_SKILLS.md`
6. Run Task 1 script to verify all Phase 1 skills
7. Tasks 11–13: Phase 2 skills (26 files)
8. Re-run validation script
9. Task 16: Update README
10. Commit: `feat: add 67 optional skills, /install-skills command, enhanced /setup`

## Success Criteria
- [ ] Validation script passes on all 110 skills
- [ ] `/install-skills` shows correct category counts
- [ ] `/setup` offers 12 roles with skill pack recommendations
- [ ] Each skill file is self-contained (no cross-dependencies)
- [ ] Phase 1 shipped before Phase 2 work begins
