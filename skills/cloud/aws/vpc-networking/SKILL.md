---
name: vpc-networking
description: Use when designing VPC architectures, configuring subnets and routing, setting up hybrid connectivity (VPN/Direct Connect/Transit Gateway), or choosing between load balancer types. Covers AWS ANS-C01 and SAP-C02 networking domains.
---

# AWS VPC Networking

## When to Use
- Designing VPC architecture with public, private, and isolated subnets
- Configuring security groups, NACLs, and VPC routing
- Setting up hybrid connectivity (Site-to-Site VPN, Direct Connect, Transit Gateway)
- Choosing between ALB, NLB, and GWLB for traffic routing
- Implementing VPC endpoints for private AWS service access
- Preparing for AWS ANS-C01 or SAP-C02 exams

## Core Jobs

### 1. Subnet Architecture

| Subnet Type | Route Table | Internet Access | Use Case |
|-------------|------------|----------------|---------|
| **Public** | 0.0.0.0/0 → IGW | Yes (inbound + outbound) | Load balancers, bastion hosts, NAT Gateway |
| **Private** | 0.0.0.0/0 → NAT GW | Outbound only (via NAT) | Application servers, databases |
| **Isolated** | No internet route | None | Databases, secrets, compliance workloads |

**Best practice 3-tier architecture**:
```
AZ-a                          AZ-b
Public:  10.0.1.0/24  ←IGW→  10.0.2.0/24   (ALB, NAT GW)
Private: 10.0.11.0/24         10.0.12.0/24  (App servers)
DB:      10.0.21.0/24         10.0.22.0/24  (RDS, isolated)
```

**IP CIDR planning**:
- VPC CIDR: /16 (65,536 IPs) — allows room for growth
- Subnet: /24 (256 IPs, minus 5 AWS reserved = 251 usable per subnet)
- Reserve 5 IPs per subnet: network, VPC router, DNS, future, broadcast

### 2. Security Groups vs NACLs

| Feature | Security Groups | NACLs |
|---------|----------------|-------|
| Level | Instance/ENI level | Subnet level |
| Statefulness | **Stateful** (return traffic automatic) | **Stateless** (both directions must be explicitly allowed) |
| Rule types | Allow only | Allow AND Deny |
| Rule processing | All rules evaluated | Rules evaluated in order (lowest number first); first match wins |
| Default | Deny all inbound, allow all outbound | Allow all (default NACL) |
| Best for | Fine-grained per-instance control | Subnet-level blocking (known bad IPs, port ranges) |

**Stateful vs Stateless example**:
- SG: Allow port 443 inbound → response traffic on ephemeral port automatically allowed outbound
- NACL: Allow port 443 inbound AND separately allow ephemeral ports (1024–65535) outbound for responses

**NACL rule ordering**: Rule 100 (allow 443) before Rule 200 (deny all) — lower numbers evaluated first.

### 3. Hybrid Connectivity

| Option | Bandwidth | Latency | Encryption | SLA | Cost |
|--------|-----------|---------|-----------|-----|------|
| **Site-to-Site VPN** | Up to 1.25Gbps per tunnel | Variable (internet) | IPsec (always) | 99.95% | Low |
| **Direct Connect (DX)** | 1, 10, 100 Gbps | Consistent (private fiber) | None by default (add MACSEC or VPN over DX) | 99.9% (1 DX) | Medium-High |
| **Direct Connect + VPN** | DX bandwidth | DX latency | IPsec over DX | Highest | Medium-High |
| **Client VPN** | Per-client | Variable | TLS | — | Per connection |

**Direct Connect Virtual Interfaces (VIFs)**:
- **Private VIF**: connects to VPC resources (via VGW or TGW)
- **Public VIF**: connects to AWS public services (S3, DynamoDB endpoints in ANY region)
- **Transit VIF**: connects to Transit Gateway (recommended for multi-VPC)

**Redundancy**:
- Single DX: 99.9% SLA
- Two DX connections (different locations): 99.99% SLA
- DX + VPN backup: cost-effective HA (VPN activates on DX failure via BGP failover)

### 4. Transit Gateway (TGW)

- **Hub-and-spoke** topology connecting VPCs and on-prem networks
- Replaces VPC peering mesh at scale (N VPCs need N*(N-1)/2 peering connections vs N TGW attachments)
- Route tables on TGW control routing between attachments
- Attachments: VPC, VPN, Direct Connect (Transit VIF), other TGW (peering), AWS RAM shared TGW

**TGW vs VPC Peering**:

| Aspect | Transit Gateway | VPC Peering |
|--------|----------------|-------------|
| Scale | Hundreds of VPCs | Bilateral only (no transitive routing) |
| Transitive routing | Yes | No (A→B, B→C does NOT allow A→C) |
| Bandwidth | 50Gbps per AZ per attachment | Limited by VPC/EC2 limits |
| Cost | Per attachment + data transfer | Data transfer only |
| Management | Centralized route tables | Decentralized; manage each peering |

### 5. VPC Endpoints

| Type | Services | Cost | Use Case |
|------|---------|------|---------|
| **Gateway endpoint** | S3, DynamoDB | Free | Private S3/DynamoDB access from VPC (no NAT GW needed) |
| **Interface endpoint (PrivateLink)** | All other AWS services, partner services | Hourly + data transfer | Private access to AWS services, SaaS, cross-account services |

**Gateway endpoint**: adds route in VPC route table; traffic stays on AWS network; completely free.
**Interface endpoint**: ENI in your VPC subnet; DNS resolves service hostname to private IP; hourly cost.

**Private DNS**: Interface endpoints can override public DNS → existing code using `s3.amazonaws.com` automatically uses private endpoint when Private DNS enabled.

### 6. Load Balancer Types

| Load Balancer | Layer | Protocol | Best For |
|--------------|-------|---------|---------|
| **ALB (Application)** | L7 | HTTP/HTTPS/HTTP2/gRPC | Path routing, host routing, content-based, microservices |
| **NLB (Network)** | L4 | TCP/UDP/TLS | Ultra-low latency, static IP, extreme throughput |
| **GWLB (Gateway)** | L3/L4 | All IP traffic | Inline network appliances (firewalls, IDS/IPS) |

**ALB features**: Target groups (EC2, ECS, Lambda, IP), path-based routing (`/api/*`), host-based routing, weighted target groups, Lambda targets, WAF integration, Cognito authentication.

**NLB features**: Static IP (one per AZ), Elastic IP assignment, TLS passthrough or termination, zonal isolation (sticky to AZ), PrivateLink source.

**GWLB**: Bumps-in-the-wire inspection; traffic transparently redirected through appliance using GENEVE protocol; appliance sees original packets.

## Key Concepts

- **IGW (Internet Gateway)** — allows communication between VPC and internet; attached to VPC; no bandwidth limit
- **NAT Gateway** — allows private subnet outbound internet access; deployed in PUBLIC subnet; one per AZ for HA; charged per hour + GB
- **Egress-Only IGW** — IPv6 only; allows outbound IPv6 internet access without inbound (equivalent to NAT GW for IPv6)
- **VPN Gateway (VGW)** — endpoint on AWS side of Site-to-Site VPN; attached to VPC
- **Customer Gateway (CGW)** — represents on-premises router in AWS; stores public IP and routing config
- **BGP (Border Gateway Protocol)** — dynamic routing protocol used in DX and some VPN configs; advertises routes automatically
- **Elastic IP** — static public IPv4 address; allocated to your account; can reassign between instances/NAT GWs
- **Flow Logs** — capture network traffic metadata (accept/reject) for VPC, subnet, or ENI; stored in CloudWatch Logs or S3; not real-time (delay ~1–2 min)

## Checklist

- [ ] Public subnets only contain load balancers and NAT Gateways (not application servers)?
- [ ] NAT Gateway deployed in each AZ used by private subnets (HA configuration)?
- [ ] Security group rules use other security group IDs as source (not IP ranges) for internal traffic?
- [ ] NACLs allow ephemeral ports (1024–65535) for response traffic (stateless)?
- [ ] Gateway endpoints configured for S3 and DynamoDB (free; eliminates NAT GW charges)?
- [ ] Transit Gateway used instead of full-mesh VPC peering for 3+ VPCs?
- [ ] Direct Connect + VPN backup for hybrid connectivity HA?
- [ ] VPC Flow Logs enabled for security analysis and troubleshooting?

## Output Format

- 🔴 **Critical** — application servers in public subnets with direct internet exposure; no NAT Gateway for private subnet internet access; NACLs blocking return traffic (stateless rule omission)
- 🟡 **Warning** — single AZ NAT Gateway (no HA); VPC peering mesh for 4+ VPCs (use Transit Gateway); no Flow Logs (blind to network traffic)
- 🟢 **Suggestion** — Gateway endpoints for S3/DynamoDB (eliminate NAT GW data transfer costs); GWLB for inline security inspection; NLB static IP for firewall allowlisting

## Exam Tips

- **NACLs are stateless** = must allow BOTH inbound AND outbound for traffic to flow; forget the ephemeral port return rule = connectivity broken
- **SGs are stateful** = return traffic automatically allowed; no outbound rule needed for responses to inbound connections
- **VPC peering = no transitive routing**; use Transit Gateway for hub-and-spoke (A→TGW→B→TGW→C works; A→B→C peering does NOT)
- **Gateway VPC endpoint (S3/DynamoDB) = free**; Interface endpoint (PrivateLink) = hourly cost; use Gateway endpoints for S3 and DynamoDB always
- **Direct Connect + VPN = best HA strategy** (DX primary at low latency; VPN backup via internet on DX failure; BGP prefers DX automatically)
- **NAT GW = per-AZ**; deploy one NAT GW per AZ (in the public subnet of that AZ) for HA; data transfer within the same AZ = free (cross-AZ = charged)
- **Public VIF (Direct Connect)** = connects to AWS public service IPs in ANY region (S3, DynamoDB); **Private VIF** = connects to specific VPC via VGW
- **GWLB** = transparent L3/L4 inline inspection using GENEVE tunneling; target is the third-party appliance fleet
