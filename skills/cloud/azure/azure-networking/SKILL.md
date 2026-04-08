---
name: azure-networking
description: Use when designing Azure VNet architecture, configuring NSGs, selecting load balancers, planning hybrid connectivity (VPN/ExpressRoute), implementing Private Link, or studying for Azure Network Engineer Associate (AZ-700) or AZ-305.
---

# Azure Networking

## When to Use
- Designing VNet architecture, subnet segmentation, and address planning for Azure deployments
- Choosing between NSG and Azure Firewall for network security
- Selecting the right load balancer (Azure LB, Application Gateway, Front Door, Traffic Manager)
- Planning hybrid connectivity (VPN Gateway vs ExpressRoute)
- Implementing Private Link/Private Endpoint for PaaS service isolation
- Preparing for Azure Network Engineer Associate (AZ-700) or AZ-305 exam

## Core Jobs

### 1. VNet Design and Subnet Segmentation
- VNet = isolated network in Azure; defined by CIDR block (e.g., 10.0.0.0/16)
- Plan address space to avoid overlap with on-premises networks and peered VNets
- **Subnet segmentation** (common pattern):
  | Subnet | Purpose | Example |
  |--------|---------|---------|
  | `AppSubnet` | Application tier (web/API servers, VMs, App Service Env) | 10.0.1.0/24 |
  | `DataSubnet` | Database tier (SQL MI, Redis, Cosmos Private Endpoint) | 10.0.2.0/24 |
  | `MgmtSubnet` | Bastion, Jump server, monitoring | 10.0.3.0/24 |
  | `GatewaySubnet` | VPN Gateway / ExpressRoute Gateway (reserved name) | 10.0.255.0/27 |
- **Reserved subnet names**: `GatewaySubnet` for gateway; `AzureBastionSubnet` for Bastion; `AzureFirewallSubnet` for Firewall

### 2. NSG vs Azure Firewall
| Feature | NSG | Azure Firewall |
|---------|-----|---------------|
| Layer | L4 (TCP/UDP) | L4 + L7 (FQDN, HTTP/S, TLS inspection) |
| Scope | Subnet or NIC level | Centralized (hub VNet) |
| FQDN filtering | No | Yes (application rules) |
| Threat intelligence | No | Yes (IDPS) |
| Cost | Free | Hourly + data processing charge |
| Best for | Subnet/NIC traffic control | Centralized outbound filtering, east-west |

- NSG rules: priority 100–4096 (lower = higher priority); `Allow`/`Deny` on `Inbound`/`Outbound`
- **ASG (Application Security Group)**: group VMs by role (e.g., `WebServers`, `DBServers`); use in NSG rules instead of IP addresses

### 3. Load Balancer Selection
| Service | Layer | Scope | SSL Termination | WAF | Best For |
|---------|-------|-------|-----------------|-----|---------|
| **Azure Load Balancer** | L4 | Regional | No | No | TCP/UDP, internal or public regional LB |
| **Application Gateway** | L7 | Regional | Yes | Yes | HTTP/HTTPS, URL routing, SSL offload |
| **Azure Front Door** | L7 | Global | Yes | Yes | Global HTTP/HTTPS, CDN, multi-region routing |
| **Traffic Manager** | DNS | Global | No (DNS only) | No | DNS-based global routing (any protocol) |

- **Application Gateway**: `Basic`, `Standard v2`, `WAF v2` tiers; path-based routing (`/api/*` → backend pool 1)
- **Front Door**: anycast global entry; routes to nearest healthy backend; CDN + WAF at edge
- **Traffic Manager**: DNS-based; routing methods: Priority, Weighted, Performance (latency), Geographic
- Decision: **regional HTTP** → Application Gateway; **global HTTP** → Front Door; **non-HTTP global** → Traffic Manager

### 4. Private Connectivity Options
| Option | Description | Transitive |
|--------|-------------|-----------|
| **VNet Peering** | Low-latency VNet-to-VNet; same or cross-region | No |
| **VPN Gateway** | IPsec site-to-site or point-to-site over internet | No (per VNet) |
| **ExpressRoute** | Private dedicated circuit via telco; no internet path | Via Global Reach |
| **Private Endpoint** | Private IP in VNet for Azure PaaS (Storage, SQL, Key Vault) | Yes (via Peering) |
| **Service Endpoint** | Network-level restriction to Azure PaaS; no private IP | No |
| **Virtual WAN** | Managed hub-and-spoke; transitive routing built-in | Yes |

- **Private Endpoint** = private IP in VNet; DNS resolves PaaS service to private IP; traffic stays in VNet
- **Service Endpoint** = restricts access to PaaS from specific VNet subnets; no private IP; still uses public endpoint routing
- Prefer Private Endpoint over Service Endpoint for stronger isolation

### 5. Hybrid Connectivity: VPN vs ExpressRoute
| Feature | VPN Gateway | ExpressRoute |
|---------|-------------|--------------|
| Path | Encrypted over public internet | Private, dedicated circuit via telco partner |
| Max bandwidth | Up to 10 Gbps (VpnGw5AZ) | 50 Mbps – 100 Gbps |
| Latency | Variable (internet-dependent) | Predictable, low latency |
| SLA | 99.95% (Active-Active) | 99.95% (Standard), 99.99% with redundancy |
| Cost | Lower | Higher (circuit + gateway) |
| Best for | < 1 Gbps, cost-sensitive, backup path | > 1 Gbps, latency-sensitive, compliance |

- **HA VPN**: two tunnels (Active-Active); 99.95% SLA
- **ExpressRoute Global Reach**: connect two on-premises sites via ExpressRoute circuits (no internet)
- **ExpressRoute + VPN**: VPN as failover for ExpressRoute

### 6. Azure Bastion
- **Azure Bastion**: browser-based SSH/RDP to VMs without public IP or VPN
- Deployed in `AzureBastionSubnet` (/26 or larger); connects to VMs in same or peered VNet
- Eliminates need for jump boxes or public IPs on VMs
- SKUs: `Basic` (standard RDP/SSH), `Standard` (native client, file transfer, tunneling)

## Key Concepts
- **NSG** — stateful L4 firewall; subnet or NIC; return traffic allowed automatically
- **ASG** — logical grouping of VMs for NSG rules; replaces IP-based rules with role-based
- **Private Endpoint** — private IP in VNet for PaaS; DNS override required; traffic never leaves VNet
- **VNet Peering** — no transitive routing; A↔B peered, B↔C peered → A cannot reach C without hub
- **ExpressRoute** — no internet path; provider circuit; SLA-backed; bandwidth up to 100 Gbps
- **Virtual WAN** — Microsoft-managed hub; transitive routing between spokes; replaces custom hub-spoke NVA
- **Azure Bastion** — browser-based SSH/RDP; no public IP needed on VMs; deployed in dedicated subnet

## Checklist
- [ ] VNet address space planned with no overlap against on-premises and peered VNets?
- [ ] NSG applied to subnets (not individual NICs) for consistent subnet-level control?
- [ ] Azure Firewall in hub VNet for centralized outbound filtering and east-west inspection?
- [ ] Private Endpoints configured for PaaS services (Storage, SQL, Key Vault, ACR)?
- [ ] ExpressRoute chosen when bandwidth > 1 Gbps or latency/compliance requirements exist?
- [ ] Azure Bastion deployed to eliminate public IPs on management VMs?
- [ ] VNet Peering transitive routing limitation addressed (use Virtual WAN or hub-spoke with Firewall)?

## Output Format
- 🔴 **Critical** — NSG rule allowing 0.0.0.0/0 inbound on port 22 (SSH) or 3389 (RDP) on production VMs
- 🔴 **Critical** — no Private Endpoint for PaaS services storing sensitive data (public endpoint exposed)
- 🟡 **Warning** — VNet Peering relied on for transitive routing (not supported; add hub with Azure Firewall or Virtual WAN)
- 🟡 **Warning** — Service Endpoint used instead of Private Endpoint (weaker isolation; traffic uses public routing)
- 🟢 **Suggestion** — deploy Azure Bastion for secure VM management without public IPs

## Exam Tips
- **NSG = stateful L4** — return traffic automatically allowed; applied to subnet OR NIC (both layers independently evaluated)
- **Application Gateway WAF = protect web apps from OWASP Top 10** — L7 only (HTTP/HTTPS); not for TCP/UDP
- **Front Door vs Traffic Manager** — Front Door = proxy-based anycast (sees and can modify traffic); Traffic Manager = DNS redirect (no traffic inspection, any protocol)
- **ExpressRoute = private, no internet** — up to 100 Gbps; SLA-backed; compliant for regulated industries
- **VNet Peering = no transitive routing** — use Azure Virtual WAN or hub-spoke with Azure Firewall for transitive connectivity
- **Private Endpoint = private IP in VNet for PaaS** — DNS override required (`privatelink.*` zones); traffic stays in VNet; stronger than Service Endpoint
