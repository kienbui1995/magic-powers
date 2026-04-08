# Cloud Divisions Design Spec

**Date:** 2026-04-08
**Status:** Approved
**Plan:** docs/superpowers/plans/2026-04-08-cloud-divisions-gcp.md (GCP)

## Problem

magic-powers has no cloud-specific agents. Engineers working on GCP, AWS, or Azure
have no specialized guidance aligned to those platforms' services and certifications.

## Solution

Cloud Divisions: 3 providers × 7 agents + 14 skills each = 21 agents + 42 skills.
Each agent maps to an official professional certification, skills map to exam domains.

## Certification Targets (2025-2026)

| Agent | Certification | Code |
|-------|--------------|------|
| gcp-data-engineer | Professional Data Engineer | GCP-PDE |
| gcp-cloud-developer | Professional Cloud Developer | — |
| gcp-network-engineer | Professional Cloud Network Engineer | — |
| gcp-ml-engineer | Professional ML Engineer | — |
| gcp-devops-engineer | Professional Cloud DevOps Engineer | — |
| gcp-security-engineer | Professional Cloud Security Engineer | — |
| gcp-cloud-architect | Professional Cloud Architect | — |
| aws-data-engineer | Data Engineer Associate | DEA-C01 |
| aws-ml-engineer | ML Engineer Associate (NEW 2025) | MLA-C01 |
| azure-data-engineer | Fabric Data Engineer (NEW 2025) | DP-700 |
| azure-security-engineer | Cloud & AI Security Engineer | SC-500 |

## Directory Structure

agents/cloud/{gcp,aws,azure}/*.md
skills/cloud/{gcp,aws,azure}/*/SKILL.md

## Install Flow

/install-skills → Category 12: Cloud Divisions → GCP/AWS/Azure
→ Copies agents to .claude/agents/ AND skills to .claude/skills/
