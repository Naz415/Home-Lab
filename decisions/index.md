---
layout: page
title: Decision records
permalink: /decisions/
---

# Decision records

One record per decision that is expensive or hard to reverse. Each states the
context, the options considered, the decision, its costs, and **the conditions
under which it should be reopened**. Corrections are written into the record
with a date; nothing is deleted.

| ADR | Date | Decision | Status |
|---|---|---|---|
| [0001](ADR-0001-teaching-lab-bundle.md) | 8 Sep 2026 | Hardware search closed; teaching-lab bundle bought | Accepted; first decision superseded by 0002 |
| [0002](ADR-0002-storage-host-moves-to-t320.md) | 8 Sep 2026 | Storage host moves to a PowerEdge T320 | Proposed → withdrawn → **accepted 23 Sep** |
| [0003](ADR-0003-two-switch-topology.md) | 23 Sep 2026 | ProCurve at access, Catalyst at core; WX 2100; ProCurve off the UPS | Accepted (first recommendation reversed same day) |
| [0004](ADR-0004-sg3100-not-the-carp-pair.md) | 23 Sep 2026 | The SG-3100s are not the CARP pair | Accepted; shelved 4 Oct |
| [0005](ADR-0005-smart-readings-second-pool.md) | 29 Sep 2026 | Second pool moves to the 4 TB pair | **Conditional** on long self-tests |
| [0006](ADR-0006-carp-standby-bare-metal.md) | 2 Oct 2026 | CARP standby on bare-metal Braswell | Accepted; "genuine peer" withdrawn 4 Oct |
| [0007](ADR-0007-pfsense-evaluated-and-declined.md) | 4 Oct 2026 | pfSense as fleet platform | **Declined** |
| [0008](ADR-0008-truenas-evaluated-and-declined.md) | 4 Oct 2026 | TrueNAS for the primary pool | **Declined** |
| [0009](ADR-0009-vlan70-withdrawn-guests-are-iot.md) | 4 Oct 2026 | VLAN 70 withdrawn; guests are IoT | Accepted, reversible |
