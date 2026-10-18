---
title: "ADR-0003: Two-switch topology"
layout: page
---

# ADR-0003 — The switching layer becomes two switches

| | |
|---|---|
| **Date** | 23 September 2026 |
| **Status** | Proposed |
| **Decided by** | Pending the owner |

## Context

A gifted HP ProCurve 3500yl-24G-PoE+ joined an 8-port Cisco Catalyst C1200.
The question was which one is the core.

### Options considered

1. **ProCurve core, Catalyst access.**
2. Catalyst core, ProCurve access.
3. ProCurve only.
4. Catalyst only, ProCurve unused.

## Recommendation

> **Recommended: ProCurve core, C1200 access** — put the inter-VLAN boundary on
> the switch that can actually police it.

The ProCurve has DHCP snooping, dynamic ARP protection, IP source guard and BPDU
protection, none of which the Catalyst has. It has 24 ports and a 398 W PoE
budget. The Catalyst has eight.

**Against it:** the ProCurve cannot do manager-level SSH public-key login, which
collides with the design's first priority, no passwords.
