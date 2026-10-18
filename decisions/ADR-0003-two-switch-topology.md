---
title: "ADR-0003: Two-switch topology, the GPU, and the UPS"
layout: page
---

# ADR-0003 — The switching layer becomes two switches; the GPU question closes

| | |
|---|---|
| **Date** | 23 September 2026 |
| **Status** | Accepted |
| **Decided by** | The owner, on a recommendation that was corrected the same day |

| Decision | Outcome |
|---|---|
| Switch topology | **HP ProCurve 3500yl = access layer. Cisco Catalyst C1200 = core.** Both pure layer 2 |
| Transcode card | **Radeon Pro WX 2100 into the T320. GTX 1060 shelved** |
| UPS | **The ProCurve does not go on the battery** |

## 1. The switching layer

### Context

A gifted HP ProCurve 3500yl-24G-PoE+ joined an 8-port Cisco Catalyst C1200.
The question was which one is the core.

### Options considered

1. ProCurve core, Catalyst access.
2. **Catalyst core, ProCurve access.**
3. ProCurve only.
4. Catalyst only, ProCurve unused.

### The recommendation as first made

> *Recommended: ProCurve core, C1200 access — "put the inter-VLAN boundary on
> the switch that can actually police it."*

### Correction, same day: the first recommendation was wrong on its own terms

The 3500yl has **no stateful filtering**: no connection tracking, no
return-traffic awareness. Its ACLs are stateless packet filters. The whole
design puts every inter-VLAN decision on OPNsense *because* OPNsense is
stateful. **Moving the boundary to the ProCurve would replace a stateful
firewall with a stateless one and present it as an upgrade.**

The recommendation had been written from the switch's feature list (DHCP
snooping, ARP protection, IP source guard) without checking that list against
what the core position actually requires.

**A second correction, in the opposite direction.** The same session told the
owner the ProCurve could not do manager-level SSH public-key login, which would
have collided with the design's first priority, no passwords. That was also
wrong: the K.16.02 Access Security Guide documents
`ip ssh public-key manager <keystring>`. The first research pass had read a
different branch's guide (the K/KA/KB guide is one combined document covering
three switch families, and several chapters apply to only some of them).

*Two errors in opposite directions, on the same switch, within an hour. The
switch is in the design anyway, but on reasoning rebuilt from scratch, which
is why the original reasoning is written down.*

### Decision

> **The ProCurve's security features are edge features. Its liabilities are
> core liabilities. So it goes at the edge.**

| Property | Points |
|---|---|
| No stateful filtering | Away from core, where policy lives |
| DHCP snooping, ARP protection, IP lockdown, BPDU protection, 802.1X | Toward access: each defends a port a hostile device might be in |
| 24 ports, 398 W PoE | Toward access |
| Firmware frozen since October 2022 | Away from core: if compromised, give it the least reach |
| 98 W idle | Away from the UPS |

Neither switch routes. `no ip routing` is set explicitly on the ProCurve even
though it is probably the default: a configuration line stating intent is worth
more than a default being trusted.

### The property this buys

**VLAN 40 (SERVICES) does not exist on the ProCurve at all.** VLAN hopping,
double-tagging and trunk-negotiation attacks all need the target VLAN to be
present on the switch being attacked. Clients reach storage services by routing
through the firewall.

### What it does not fix

The Catalyst still lacks DHCP snooping, IP source guard, dynamic ARP inspection
and BPDU guard. **The gap moved; it did not close.** What changed is the
population: every device not built by hand now plugs into the switch that can
police it, and the Catalyst faces only hand-built machines on hand-run cables.
Code execution on one of those hosts still puts an attacker on a switch with no
layer-2 protections. Nothing in the switching layer helps there.

### The weakness that cannot be engineered away

The ProCurve's management plane is unpatched and will stay so. Later HPE Aruba
advisories name no fixed build on its branch. Everything done is mitigation: web
UI off, SSH key-only, authorized managers pinned to `ADMIN-WS`, management
reachable only through the firewall's default-deny, no routing, no certificates
held, VLAN 40 never seen.

**An attacker who owns this switch gets layer 2 on three VLANs that were
already the untrusted ones.**

## 2. The GPU

**WX 2100 into the T320; GTX 1060 shelved.** The 1060 is the better encoder; the
reasons are not performance.

1. **The T320 almost certainly cannot power it.** Dell routes GPU power through
   a header on the power distribution board, requires the 750 W redundant
   supply, and publishes no part number for the cable. Wiring a generic adapter
   to an unverified proprietary header is the power-supply standing rule with a
   graphics card attached.
2. **Pascal is ending on the NVIDIA Linux driver** (branch 580 is the last). A
   24/7 service on an out-of-tree module, for end-of-life hardware, on a
   hypervisor whose kernel moves. `amdgpu` is in-tree.
3. **Thermals:** a 35 W single-slot blower against 120 W recirculating into a
   chassis with ten drives.

**What it costs:** HEVC 10-bit *encode*, which the WX 2100's Polaris generation
lacks. HEVC 10-bit in, H.264 out, the common transcode, is unaffected.

**A finding that lands regardless:** any non-Dell PCIe card makes a
12th-generation PowerEdge ramp its fans permanently. The SAS HBA alone triggers
it. The honest default is to leave the ramp alone and override only if noise
becomes a real problem, then watch drive temperatures for a week.

## 3. The UPS

| On battery | Watts (estimated) |
|---|---|
| STORE (T320) | ~150 |
| FW | ~30 |
| Catalyst C1200, which the NUT clients cross | ~12 |
| TRUST, DMZ-HOST, BACKUP | ~45 |
| **Total** | **≈ 237** |
| ~~ProCurve~~ | ~~98~~ surge-only |
| ~~Access points~~ | surge-only |

The UPS talks to STORE over USB; the other hosts are NUT clients over VLAN 20,
all on the Catalyst. The ProCurve is in the shutdown path nowhere. Leaving it
off the battery gives about 45 % more runtime. Wire it so the mistake is hard to
make, and **label both outlet groups**.

## Open items this decision created

1. **Can the MR60 tag VLANs in AP mode?** If not, every wireless device shares
   VLAN 30.
2. Can the last ProCurve firmware actually be obtained? (Yes, 29 September.)
3. Fifteen minutes at the ProCurve console with `?` completion, to settle every
   command the build document marks VERIFY.
4. **802.1X with EAP-TLS from the internal CA** is the natural end state, and is
   deliberately not in this build: a misconfigured 802.1X deployment locks every
   port at once.
