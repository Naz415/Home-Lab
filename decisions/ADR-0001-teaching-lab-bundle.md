---
title: "ADR-0001: Hardware search closed; a teaching-lab bundle instead"
layout: page
---

# ADR-0001 — The hardware search is closed; a teaching-lab bundle is bought instead

| | |
|---|---|
| **Date** | 8 September 2026 |
| **Status** | Accepted |
| **Decided by** | The owner |

## Context

Four candidate replacements for the storage host had been evaluated against the
incumbent Lenovo TS140: a single PowerEdge T320, an R630, a T140 and an R720.
The R720 entry had been declined partly on electricity cost, estimated at
several hundred dollars a year.

## Decision

1. **The TS140 stays as the storage host.** It is not slow, not short of RAM,
   and has more drive-mounting capacity than two of the four candidates. Its
   real defect, firmware frozen at October 2021, is absorbed by the design: it
   is not the router, has no out-of-band management or radio, and the backup
   host pulls from it in a separate chassis.
2. **A teaching-lab bundle is bought (about $600)**, explicitly *not* part of
   the home fleet: two PowerEdge T320s, eight identical thin clients, two
   pfSense firewall appliances, monitors and peripherals.

## Correction recorded in the same decision

**The owner has solar, so the electricity-cost argument is withdrawn.** What
survives it:

- **UPS runtime is physics, not billing.** A 1500 VA / 900 W UPS has real
  runtime at the fleet's 165–185 W and minutes at 400 W. Solar does not extend
  a battery, and a grid-tie inverter disconnects during an outage.
- Heat and noise are unaffected by how power is generated.
- None of the design objections were about power: the R630's fixed 1.9 GHz
  CPU, the T140's insufficient bays, the R720 being older than the TS140, and a
  service processor on the machine holding the data.

*Solar answers one of two power arguments. It answers none of the rest.*

## Why the lab is worth more than any declined server

It is the only place the design's ideas can be **tested rather than
believed**: a deliberately wrong firewall rule, a knowingly vulnerable DMZ host,
a misconfigured trunk observed rather than imagined. And it is a proving ground
for this build specifically: CARP failover, a rehearsal of the switch build, and
the restore drill.

## Three rules, from day one

1. **The lab never touches the home network.** Separate switch, separate
   uplink, or physically disconnected. A lab containing deliberately broken
   hosts must never reach VLAN 20, 30 or 40.
2. **No shared credentials or key material.** The lab gets its own CA root.
3. **It does not delay the build.**
