---
title: "ADR-0002: The storage host moves to a PowerEdge T320"
layout: page
---

# ADR-0002 — The storage host moves from the Lenovo TS140 to a Dell PowerEdge T320

| | |
|---|---|
| **Date** | 8 September 2026 |
| **Status** | **Proposed** |
| **Decided by** | The owner |

### Status history

| Date | Position |
|---|---|
| before 8 Sep | T320 **declined**, on power cost |
| 8 Sep | **Proposed** — this record written. Bays, not power, were the real constraint |

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
