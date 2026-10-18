---
title: "ADR-0002: The storage host moves to a PowerEdge T320"
layout: page
---

# ADR-0002 — The storage host moves from the Lenovo TS140 to a Dell PowerEdge T320

| | |
|---|---|
| **Date** | 8 September 2026 |
| **Status** | **Accepted, 23 September 2026** |
| **Decided by** | The owner |

### Status history

Four positions on one machine in six weeks. All four are left visible, because
the reasoning behind a reversal is what catches the next bad one.

| Date | Position |
|---|---|
| before 8 Sep | T320 **declined**, on power cost |
| 8 Sep | **Proposed** — this record written. Bays, not power, were the real constraint |
| 13 Sep | **Withdrawn** — the owner elected to keep the original hardware |
| 23 Sep | **Accepted** — the T320 was bought. This record is the plan again |

## Context — what the earlier evaluation got wrong

1. **The spec sheet was read only as far as "4 × 3.5-inch cabled bays."** The
   same document says the cabled chassis supports up to two half-height media
   bays. The six-drive 2.5-inch cage carrying the primary pool fits one of
   them, with one spare. On the partial reading, the T320 had been called
   "worse than the TS140." It is not.
2. **The runbook recorded one loose spinner. There were two**, both lying
   unmounted in the TS140, and no bay for the boot mirror either. An earlier
   inference, *"the drives are in and powered, therefore the brackets
   existed,"* was wrong twice over.

*The pattern is one this project keeps paying for: an inference that looked
sound, drawn from a partial reading, closing a question that was open.*

## The arithmetic that decides it

| Drive set | TS140 | T320 with the cage moved |
|---|---|---|
| 6 × 480 GB SSD (primary pool) | cage in the half-height bay | cage in media bay 1 |
| 2 × spinners (second pool) | **loose in the chassis** | 2 of 4 × 3.5-inch bays |
| 2 × 250 GB SSD (boot mirror) | **no bay** | the other two 3.5-inch bays, via adapters |
| **Result** | 2 loose, boot mirror homeless | **all mounted, one media bay spare** |

The T320 also brings five PCIe slots, a ceiling of 192 GB ECC, and a 10-core
Xeon E5-2470 v2.

## Costs, stated plainly

- **Roughly +40–60 W.** The UPS still carries a clean shutdown at this load.
- **Older architecture** (Ivy Bridge-EN) than the TS140's Haswell: more cores,
  slower cores. Right for a storage host; wrong for the trust-root host.
- **Firmware ends permanently in early 2020**, twenty months *earlier* than the
  TS140's. The move bought bays, cores and RAM and paid in firmware currency.
  It is still the right trade, because firmware age was never what could hurt
  this host (it is not the router, has no enabled out-of-band management, and
  is not the only copy). *What is not acceptable is pretending the problem got
  smaller. It got older.*

## Standing rule created: do not swap the power supply

PowerEdge supplies are commonly proprietary, with pinouts that do not match ATX
even where the connector mates. The project already had two rules of exactly
this shape. **The T320 keeps its own supply.**

## As measured — 23 September

Read off the machine's BIOS screen and system information, not off a listing.
Where it disagrees with the listing above, this section wins.

| Field | Reported |
|---|---|
| CPU | Xeon E5-2470 v2, 10C/20T |
| Memory | **80 GB** at 1600 MHz (the listing said 64) |
| BIOS | 2.7.0 (2019), UEFI |
| Secure Boot | **Unsupported** |
| Lifecycle Controller | Disabled |
| Drives as delivered | 1 TB SATA SSD, 2 × Seagate ST4000DM000 4 TB, one 36 GB Raptor from about 2004 |

### Three ways the machine differed from the plan

**1. 80 GB, channel-unbalanced — and it must not be "fixed."** The job is ZFS
ARC and containers, which want capacity. If it is ever rebalanced, rebalance by
adding, never by removing.

**2. Secure Boot is not "off." It does not exist.** No 12th-generation
PowerEdge BIOS ever shipped it. This is a different kind of exception from the
two hosts that turn it off by choice: it cannot be revisited. *Mitigation, not
equivalence.*

**3. "Disable iDRAC" badly understated the problem.** The BMC firmware was
unread, and anything below 2.65.65.65 carries **CVE-2020-5344, a
pre-authentication remote code execution on the BMC**. So the firmware window
was *now*, while the delivered Windows install still offered the easy flash
path:

| # | Component | From | To | Why |
|---|---|---|---|---|
| 1 | iDRAC7 | unread | 2.65.65.65 | CVE-2020-5344 |
| 2 | BIOS | 2.7.0 | 2.9.0 (Feb 2020, the last) | Carries the CVE-2019-0151 Management Engine fix |

Order: iDRAC first, BIOS second. Then, before the machine has a network
address: iDRAC NIC disabled, IPMI-over-LAN disabled, a setup password, VT-x and
VT-d on.

**The Management Engine here is SPS, not AMT.** A PowerEdge has no AMT stack to
disable. Its out-of-band exposure is the iDRAC.

## Consequences

- The TS140 retires from the fleet and becomes the **bench**: switch-build
  rehearsal, CARP failover tests, the restore drill.
- The 4 TB pair is proposed for the second pool, conditionally
  ([ADR-0005](ADR-0005-smart-readings-second-pool.md)).
- **Open, and the whole layout rests on it:** test-fit the empty six-drive cage
  in a media bay. Dell document a latch and give no dimensions. This became the
  build's single physical stop gate.
