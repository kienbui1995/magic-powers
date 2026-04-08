---
name: aks-kubernetes
description: Use when designing Azure Kubernetes Service (AKS) clusters, configuring node pools, integrating Azure AD/Entra ID RBAC, implementing Workload Identity, planning scaling strategies, or studying for AZ-400 or AZ-305.
---

# AKS Kubernetes

## When to Use
- Designing AKS cluster architecture (node pools, networking, identity)
- Configuring Azure AD/Entra ID integration for Kubernetes RBAC
- Implementing Workload Identity for pod-level Azure service authentication
- Planning cluster scaling strategy (Cluster Autoscaler, HPA, KEDA, Virtual Nodes)
- Choosing between kubenet and Azure CNI networking
- Preparing for Azure DevOps Engineer Expert (AZ-400) or Azure Solutions Architect Expert (AZ-305) exam

## Core Jobs

### 1. Node Pool Design
| Pool Type | Required | Purpose |
|-----------|----------|---------|
| **System node pool** | Yes | Runs kube-system pods (CoreDNS, metrics-server); cannot be deleted |
| **User node pool** | No | Runs application workloads; multiple allowed; can be deleted |

- Isolate workloads: separate node pools for GPU workloads, Windows containers, or spot instances
- Node pool VM sizes: choose based on workload (General Purpose, Memory Optimized, GPU)
- **Spot node pools**: low-cost; can be evicted; use for fault-tolerant, batch workloads only
- System node pool: cannot have 0 nodes; minimum 1 system node pool required

### 2. Entra ID Integration and RBAC
- **Azure AD/Entra ID-integrated AKS**: authenticate to cluster using Entra tokens (`kubelogin`)
- `kubectl` commands require Entra ID authentication; `kubeconfig` uses AAD tokens
- Two RBAC modes:
  - **Azure RBAC for K8s**: manage K8s RBAC with Azure role assignments (`Azure Kubernetes Service RBAC Admin`, etc.)
  - **K8s RBAC + Entra groups**: map Entra groups to K8s `ClusterRoleBinding`/`RoleBinding`
- Entra group membership synced automatically; add user to group → gets K8s access

### 3. Workload Identity
- **Workload Identity** = recommended method to give pods Azure service access without credentials
- Replaces deprecated **AAD Pod Identity** (v1 approach)
- Architecture:
  1. Create **User-assigned Managed Identity** in Azure
  2. Create **Kubernetes ServiceAccount** with Workload Identity annotation
  3. Create **Federated identity credential** linking ServiceAccount to Managed Identity
  4. Assign RBAC role to Managed Identity on target Azure resource
  5. Pod uses ServiceAccount → SDK gets token via OIDC → Azure authenticates Managed Identity
- Use `DefaultAzureCredential` in pod code; automatically picks up Workload Identity token

### 4. Scaling Strategies
| Scaler | Scope | Trigger |
|--------|-------|---------|
| **Cluster Autoscaler** | Node (VM) level | Pending pods that can't be scheduled |
| **HPA (Horizontal Pod Autoscaler)** | Pod level | CPU/memory metrics (or custom metrics) |
| **VPA (Vertical Pod Autoscaler)** | Pod resource limits | Right-sizes CPU/memory requests |
| **KEDA** | Pod level (event-driven) | External metrics: queue depth, Event Hub lag |
| **Virtual Nodes** | Pod burst to ACI | Overflow scheduling to Azure Container Instances |

- For full autoscaling: enable both **Cluster Autoscaler** (nodes) + **HPA or KEDA** (pods)
- **Virtual Nodes**: burst to ACI for sudden traffic spikes; ACI pods billed per-second; no node capacity needed
- **KEDA** = Kubernetes Event-Driven Autoscaling; scales to zero based on external event sources (Service Bus, Event Hubs, Kafka)

### 5. Networking: kubenet vs Azure CNI
| Aspect | kubenet | Azure CNI |
|--------|---------|-----------|
| Pod IPs | Private range (not VNet IPs) | VNet IPs assigned to pods |
| VNet address planning | Small VNet sufficient | VNet must have IP for every possible pod |
| Network policies | Limited (Calico only) | Full (Azure Network Policy + Calico) |
| Best for | Dev/test, simple scenarios | Enterprise, network policies, peering |
| Private Link access | Requires extra routing | Direct (pods have VNet IPs) |

- Azure CNI = pods reachable directly from VNet (and peered VNets); required for most enterprise scenarios
- kubenet = pods behind NAT; simpler but limited network policy support

### 6. Azure Policy for AKS
- **Azure Policy + Gatekeeper (OPA)**: enforce pod security standards at admission time
- Built-in policies: restrict privileged containers, enforce resource limits, require pod labels
- Applied at cluster level; blocks non-compliant deployments before they create pods
- **Pod Security Standards**: Baseline (moderate restrictions) and Restricted (strict, production-ready)
- Audit mode: report violations without blocking; Enforce mode: block at deployment

## Key Concepts
- **Workload Identity** — federated OIDC-based pod identity; recommended; replaces Pod Identity (deprecated)
- **Cluster Autoscaler** — adds/removes nodes based on pending pod scheduling; works with node pools
- **KEDA** — event-driven pod autoscaler; scales to zero based on queue/stream metrics
- **Virtual Nodes** — burst scheduling to Azure Container Instances; no node billing; per-second ACI cost
- **Azure CNI** — pods get VNet IPs; required for network policies and VNet peering access to pods
- **System node pool** — mandatory; runs cluster control components; cannot be deleted
- **kubelogin** — Azure plugin for `kubectl`; converts AAD tokens for Kubernetes API authentication

## Checklist
- [ ] System node pool separated from application (user) node pools?
- [ ] Workload Identity configured for pods that need Azure service access (not AAD Pod Identity)?
- [ ] Azure CNI networking selected for enterprise deployments needing network policies?
- [ ] Cluster Autoscaler enabled + HPA or KEDA for full autoscaling coverage?
- [ ] Azure Policy + Gatekeeper configured to enforce pod security standards?
- [ ] Entra ID integration enabled; local admin accounts disabled where possible?
- [ ] Spot node pools used only for fault-tolerant workloads (with tolerations)?

## Output Format
- 🔴 **Critical** — AAD Pod Identity used (deprecated; migrate to Workload Identity)
- 🔴 **Critical** — all workloads on system node pool (risks cluster stability; kube-system pods may be evicted)
- 🟡 **Warning** — kubenet networking in enterprise deployment with network policy requirement (use Azure CNI)
- 🟡 **Warning** — only Cluster Autoscaler without HPA (nodes scale but pods don't; wastes capacity)
- 🟢 **Suggestion** — enable KEDA for event-driven workloads (Service Bus consumers) to scale pods to zero

## Exam Tips
- **Workload Identity = recommended** — replaces AAD Pod Identity which is deprecated; uses OIDC federation with ServiceAccount
- **Azure CNI = pods get VNet IPs** — kubenet = pods behind NAT; CNI required for network policies and direct VNet access to pods
- **Virtual Nodes = burst to ACI** — schedule pods on ACI for cost-effective burst capacity; no node VM required; per-second billing
- **System node pool = required; cannot be deleted** — runs kube-system pods; minimum 1 required in every AKS cluster
- **Cluster Autoscaler scales nodes; HPA scales pods** — both needed for complete autoscaling; Cluster Autoscaler reacts to pending pods
- **AKS Managed Identity** — cluster identity for Azure resource access (attach disks, update load balancers); no service principal needed in modern AKS
