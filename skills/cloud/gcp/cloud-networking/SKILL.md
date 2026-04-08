---
name: cloud-networking
description: Use when designing VPC networks, configuring subnets/routes/firewall rules, setting up VPC Peering or Shared VPC, or designing hybrid connectivity. Covers GCP Network Engineer domains: VPC Design (~20-25%) and VPC Implementation (~20-25%).
---

# Cloud Networking

## When to Use
- Designing VPC architecture for a GCP deployment
- Configuring firewall rules, routes, or NAT
- Planning hybrid connectivity (VPN or Interconnect)
- Preparing for GCP Professional Cloud Network Engineer exam

## Core Jobs

### 1. VPC Design: Auto vs Custom Mode
| Mode | Description | Use case |
|------|-------------|---------|
| **Auto mode** | Subnet per region, auto-created | Dev/test, quick start |
| **Custom mode** | You control subnets and CIDR ranges | Production (recommended) |
- Always use custom mode for production (control over IP ranges, no overlaps)

### 2. Subnet Design
- Subnets are **regional** (not zonal)
- Plan CIDR ranges to avoid overlap with on-prem and other VPCs
- **Secondary ranges** — for GKE pods and services (alias IP ranges)
- **Private Google Access** — enables VMs without external IPs to reach Google APIs

### 3. Firewall Rules
- Applied at the VPC level; affect all VMs in the VPC
- **Ingress** (inbound) and **Egress** (outbound) rules
- **Priority** 0–65534 (lower = higher priority); default deny at 65535
- Use **network tags** to apply rules to specific VMs
- Default rules: allow all egress, deny all ingress

### 4. VPC Connectivity Options
| Option | Use case |
|--------|---------|
| **VPC Peering** | Connect two GCP VPCs (no transitive routing) |
| **Shared VPC** | Centralized VPC shared across multiple projects |
| **Cloud VPN** | Encrypted tunnel to on-prem or other clouds (< 1 Gbps) |
| **Cloud Interconnect** | Dedicated or Partner; high bandwidth (1–100 Gbps) |
| **Private Service Connect** | Private access to Google/third-party services |

### 5. Hybrid Connectivity Decision
- **Cloud VPN (HA VPN)** — IPsec; 99.99% SLA; good up to ~1 Gbps
- **Dedicated Interconnect** — physical link; 10 or 100 Gbps; < 1ms latency
- **Partner Interconnect** — through telco partner; 50 Mbps–10 Gbps
- Rule of thumb: > 1 Gbps or latency-sensitive → use Interconnect

### 6. Cloud NAT
- Allows VMs without external IPs to reach the internet
- No ports opened inbound (stateful outbound only)
- Required for private GKE nodes to pull images from internet

## Key Concepts
- **Private Google Access** — VMs without external IP reach `*.googleapis.com`
- **Alias IP ranges** — allow multiple IPs per VM NIC (used by GKE pods)
- **Transitive routing** — VPC Peering does NOT support it; use Shared VPC or NCC instead

## Checklist
- [ ] Custom mode VPC (not auto mode) for production?
- [ ] Private Google Access enabled for subnets with private VMs?
- [ ] Firewall rules use network tags or service accounts (not IP-based)?
- [ ] HA VPN or Interconnect for on-prem connectivity?
- [ ] Cloud NAT configured for private VMs needing outbound internet?
- [ ] Shared VPC for multi-project architecture (not VPC Peering)?

## Output Format
- 🔴 **Critical** — overlapping CIDR ranges, firewall rule allowing 0.0.0.0/0 ingress on SSH/RDP
- 🟡 **Warning** — auto-mode VPC in production, VPC Peering without transitive routing plan
- 🟢 **Suggestion** — Shared VPC for centralized network management, Cloud NAT for private VMs

## Exam Tips
- VPC Peering = no transitive routing (A-B peered, B-C peered → A cannot reach C)
- Shared VPC = host project owns network; service projects use it (centralized control)
- Cloud VPN vs Interconnect threshold = ~1 Gbps (latency/bandwidth)
- Firewall rules: lower number = higher priority; default deny-all-ingress at 65535
- HA VPN = two tunnels, 99.99% SLA; Classic VPN = 99.9% SLA (avoid for production)
