---
name: eks-kubernetes
description: Use when designing EKS clusters, choosing node types (managed/Fargate), implementing IRSA for pod IAM access, scaling with Karpenter, or troubleshooting EKS networking. Covers AWS DOP-C02 and SAP-C02 container orchestration domains.
---

# Amazon EKS Kubernetes

## When to Use
- Designing EKS cluster architecture for container workloads
- Choosing between managed node groups, self-managed nodes, and Fargate profiles
- Implementing IAM Roles for Service Accounts (IRSA) for pod-level AWS access
- Scaling clusters with Cluster Autoscaler or Karpenter
- Configuring EKS networking with VPC CNI and security groups for pods
- Preparing for AWS DOP-C02 or SAP-C02 exams

## Core Jobs

### 1. Node Type Selection

| Node Type | Management | OS Patching | Best For |
|-----------|-----------|------------|---------|
| **Managed node groups** | AWS manages ASG and node lifecycle | AWS patches AMIs; you trigger update | Default choice; rolling updates with node draining |
| **Self-managed nodes** | You manage EC2, ASG, bootstrap | You patch everything | Custom AMIs, specialized hardware, specific bootstrap requirements |
| **Fargate profiles** | Serverless; no nodes to manage | AWS manages everything | Event-driven, batch, dev/test, burst workloads |

**Fargate limitations**:
- No DaemonSets (no per-node daemon processes)
- No GPU workloads
- No privileged containers
- Each pod gets isolated micro-VM (Firecracker); no shared host
- Storage: no persistent EBS volumes by default (use EFS for shared storage)
- Pricing: per pod vCPU/memory-hour (more expensive than optimally-packed EC2)

**Mixed approach**: Managed nodes for stable workloads + Fargate for burst/batch jobs.

### 2. IRSA (IAM Roles for Service Accounts)

**Why IRSA**:
- Without IRSA: pods use EC2 instance profile (all pods on node share same IAM role — over-privileged)
- With IRSA: individual pods assume specific IAM roles (least-privilege per workload)

**Setup**:
1. Enable OIDC provider for EKS cluster
2. Create IAM role with trust policy:
```json
{
  "Principal": {
    "Federated": "arn:aws:iam::ACCOUNT:oidc-provider/oidc.eks.REGION.amazonaws.com/id/CLUSTER_ID"
  },
  "Action": "sts:AssumeRoleWithWebIdentity",
  "Condition": {
    "StringEquals": {
      "oidc.eks.REGION.amazonaws.com/id/CLUSTER_ID:sub": "system:serviceaccount:NAMESPACE:SA_NAME"
    }
  }
}
```
3. Annotate Kubernetes ServiceAccount:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-sa
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::ACCOUNT:role/my-pod-role
```
4. Reference ServiceAccount in Pod spec

**AWS SDK auto-picks up IRSA credentials** via web identity token file mounted at pod startup.

### 3. Cluster Autoscaler vs Karpenter

| Feature | Cluster Autoscaler (CA) | Karpenter |
|---------|------------------------|---------|
| Mechanism | Scale ASG up/down | Directly provision EC2 instances |
| Speed | Slower (ASG delays, ~2–5 min) | Faster (~30s from unschedulable to running) |
| Node diversity | Limited to defined ASG node types | Any EC2 instance type (best-fit) |
| Spot interruption | Manual handling | Built-in Spot rebalancing |
| Configuration | Complex (one ASG per node type) | NodePool/NodeClass declarative config |
| Cost optimization | Limited | Bin-packing + Spot + Savings Plans |

**Karpenter provisioning flow**:
1. Pod marked unschedulable (no node fits)
2. Karpenter calculates optimal instance type from NodePool constraints
3. Directly calls EC2 CreateFleet API (no ASG)
4. Node joins cluster in ~30 seconds

**NodePool example** (Karpenter):
```yaml
apiVersion: karpenter.sh/v1beta1
kind: NodePool
spec:
  template:
    spec:
      requirements:
        - key: "karpenter.sh/capacity-type"
          operator: In
          values: ["spot", "on-demand"]
        - key: "node.kubernetes.io/instance-type"
          operator: In
          values: ["m5.xlarge", "m5.2xlarge", "m6i.xlarge"]
  disruption:
    consolidationPolicy: WhenUnderutilized
```

### 4. Fargate Profiles

- Define which pods run on Fargate using namespace and label selectors
- Pod must match a profile to be scheduled on Fargate (otherwise goes to EC2 nodes)
- Multiple profiles per cluster allowed

```yaml
fargate_profiles:
  - name: batch-jobs
    selectors:
      - namespace: batch
        labels:
          workload-type: batch
  - name: system
    selectors:
      - namespace: kube-system
```

**CoreDNS on Fargate**: requires Fargate profile for `kube-system` namespace; apply annotation patch to remove `eks.amazonaws.com/compute-type: ec2` annotation.

### 5. EKS Networking (VPC CNI)

- **Amazon VPC CNI**: each pod gets a real VPC IP address (from the node's subnet)
- Pods communicate with VPC resources (RDS, ElastiCache) using VPC IPs directly
- **IP prefix delegation**: assign /28 prefixes to nodes (instead of individual IPs) → more IPs per node
- **Security groups for pods**: assign specific SGs to individual pods (not just nodes)
- **IPv6**: EKS supports IPv6 dual-stack clusters

**Subnet planning for EKS**:
- Nodes need IPs (1 per node)
- Pods need IPs (1 per pod; VPC CNI reserves slots on each node)
- Typical: node uses m5.xlarge (max 58 pods) → needs 59 IPs from subnet
- Use /19 or larger subnets for EKS node subnets

### 6. EKS Add-ons

| Add-on | Purpose | Notes |
|--------|---------|-------|
| **Amazon VPC CNI** | Pod networking with VPC IPs | Required; managed by AWS |
| **CoreDNS** | Cluster DNS | Required; runs as Deployment |
| **kube-proxy** | Service networking (iptables/ipvs) | Required per node |
| **EBS CSI Driver** | EBS persistent volumes for pods | Required for StatefulSets with EBS |
| **EFS CSI Driver** | EFS shared storage for pods | For shared persistent storage |
| **AWS Load Balancer Controller** | ALB/NLB creation from K8s Ingress/Service | Replaces ALB Ingress Controller |

**Managed add-ons**: AWS handles updates; version controlled via EKS console/CLI; integration with EKS cluster version lifecycle.

## Key Concepts

- **EKS control plane** — AWS managed; highly available across 3 AZs; you cannot SSH into control plane nodes
- **Worker nodes** — EC2 instances you manage (or Fargate); register with control plane via kubelet
- **OIDC provider** — OpenID Connect provider for the cluster; enables IRSA by federating K8s service accounts to IAM
- **Node group** — collection of EC2 nodes with same configuration (instance type, AMI, labels)
- **Karpenter consolidation** — automatically replaces underutilized nodes with smaller/fewer nodes (cost optimization)
- **EKS Anywhere** — run EKS on your own hardware (VMware, bare metal); uses same EKS control plane lifecycle
- **EKS Blueprints** — CDK/Terraform patterns for production-ready EKS clusters with common add-ons pre-configured
- **Pod Disruption Budget (PDB)** — minimum available pods during voluntary disruptions (node drain, rolling update)

## Checklist

- [ ] IRSA configured for pods accessing AWS services (not EC2 instance profile)?
- [ ] Fargate profiles defined for appropriate workloads (batch, dev, burst)?
- [ ] Karpenter or Cluster Autoscaler configured for automatic node scaling?
- [ ] Security groups for pods configured for fine-grained network access control?
- [ ] EBS CSI driver add-on installed for StatefulSets requiring persistent storage?
- [ ] VPC subnets sized appropriately for maximum expected pod count?
- [ ] Pod Disruption Budgets set for production workloads (prevent full outage during upgrades)?
- [ ] EKS cluster version updated within support window (AWS supports last 3–5 minor versions)?

## Output Format

- 🔴 **Critical** — pods using EC2 instance profile instead of IRSA (over-privileged; all pods share same role); no node autoscaling configured (manual capacity management)
- 🟡 **Warning** — Cluster Autoscaler instead of Karpenter (slower scaling, less cost-optimal); Fargate for DaemonSet workloads (unsupported); EKS version approaching end-of-support
- 🟢 **Suggestion** — Karpenter consolidation for cost savings; IP prefix delegation for larger pod density per node; EKS Blueprints for production-ready baseline

## Exam Tips

- **IRSA = recommended for AWS API access from pods** (not EC2 instance profile); OIDC federation = pod-level IAM isolation
- **Fargate = serverless nodes**; cannot run DaemonSets; each pod gets isolated Firecracker micro-VM; no GPU support
- **Managed node groups** = AWS manages AMI updates and node draining during Kubernetes version upgrades (you approve the update)
- **Karpenter = faster scaling than Cluster Autoscaler** (directly provisions EC2 via CreateFleet API without ASG intermediary; ~30s vs ~2-5 min)
- **EKS control plane = AWS managed** (HA across 3 AZs; zero nodes to patch); worker nodes = your responsibility (OS patches, AMI updates)
- **Spot instances with Karpenter** = significant cost savings for fault-tolerant workloads (batch, stateless microservices); Karpenter handles interruption rebalancing
- **VPC CNI = real VPC IPs for pods** — plan subnet CIDR sizes to accommodate maximum pod count (each pod consumes one VPC IP)
- **Security groups for pods** = assign different SGs to different pod types on the same node (RDS access only for app pods, not for frontend pods)
