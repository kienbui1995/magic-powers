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
