---
name: gke-kubernetes
description: Use when designing GKE clusters, choosing Autopilot vs Standard, configuring workloads, setting up Workload Identity, or managing node pools. Covers GCP Cloud Developer domain: Deploying (~19%) and DevOps domain: CI/CD (~25%).
---

# GKE Kubernetes

## When to Use
- Designing or troubleshooting Kubernetes workloads on GCP
- Choosing between GKE Autopilot and Standard
- Configuring autoscaling, node pools, and resource limits
- Preparing for GCP Professional Cloud Developer or DevOps Engineer exam

## Core Jobs

### 1. Autopilot vs Standard
| Factor | Autopilot | Standard |
|--------|-----------|---------|
| Node management | Google manages nodes | You manage node pools |
| Billing | Per Pod (vCPU + memory) | Per node (whether used or not) |
| Security | Hardened by default | Configurable |
| Best for | Most workloads | Specialized hardware, DaemonSets, GPUs |
| Cost for variable load | Lower (scale to 0) | Higher (min node pool) |

### 2. Node Pool Design (Standard)
- Separate node pools by workload type (general, GPU, high-memory)
- Use **node taints + tolerations** to route workloads to specific pools
- Enable **Cluster Autoscaler** to scale node pools based on demand
- Use **spot/preemptible nodes** for fault-tolerant batch workloads (60-90% cost savings)

### 3. Workload Autoscaling
- **HPA (Horizontal Pod Autoscaler)** — scale Pod replicas based on CPU/memory/custom metrics
- **VPA (Vertical Pod Autoscaler)** — adjust Pod resource requests/limits automatically
- **Cluster Autoscaler** — add/remove nodes based on pending pods

### 4. Workload Identity
- Best practice: bind Kubernetes ServiceAccount to GCP Service Account
- Replaces legacy metadata server credentials (no key files needed)
- Enables fine-grained GCP IAM per workload
- Setup: annotate K8s SA with GCP SA email; bind `roles/iam.workloadIdentityUser`

### 5. GKE Ingress
- **GKE Ingress (L7)** — HTTP/HTTPS routing; backed by Cloud Load Balancing
- **Gateway API** — newer, more expressive routing (replaces Ingress long-term)
- **Internal Ingress** — routes traffic within VPC only
- Use **BackendConfig** to configure Cloud Armor, CDN, health checks on backends

## Key Concepts
- **Pod Disruption Budget (PDB)** — minimum available pods during voluntary disruptions
- **Resource quotas** — limit resource usage per namespace
- **Namespace** — logical isolation within a cluster
- **GKE Dataplane V2** — eBPF-based networking (Cilium); enables network policy

## Checklist
- [ ] Autopilot considered before Standard (unless specific need)?
- [ ] Workload Identity enabled (no service account keys on nodes)?
- [ ] Resource requests and limits set on all containers?
- [ ] HPA configured for variable-load services?
- [ ] Pod Disruption Budgets set for critical workloads?
- [ ] Private cluster (no public IPs on nodes) for sensitive workloads?

## Output Format
- 🔴 **Critical** — service account key files mounted in pods, no resource limits (noisy neighbor risk)
- 🟡 **Warning** — no HPA for variable-load services, public nodes for sensitive workloads
- 🟢 **Suggestion** — Autopilot for cost efficiency, Workload Identity for all GCP API access

## Exam Tips
- Autopilot = Google manages nodes, billing per pod (not per node)
- Workload Identity = K8s ServiceAccount ↔ GCP ServiceAccount (no key files)
- Spot nodes = 60-90% cheaper, can be preempted; use for fault-tolerant batch
- HPA scales Pods; Cluster Autoscaler scales Nodes — both needed for full autoscaling
- Private cluster = nodes have no external IPs; traffic via Cloud NAT or Private Google Access
- Pod Disruption Budget = minimum available pods during node upgrades/drains
