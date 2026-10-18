---
title: "ADR-0005: SMART readings; the second pool upgraded conditionally"
layout: page
---

# ADR-0005 — SMART readings on four drives; the second pool conditionally moves to the 4 TB pair

| | |
|---|---|
| **Date** | 29 September 2026 |
| **Status** | Accepted **conditionally**. The long self-test is still outstanding, and the pool stays gated on it |
| **Decided by** | The owner |

## What was measured

Attribute snapshots of the four drives that arrived in the T320. **Attribute
dumps, not self-tests**: no self-test log and no error log were read.

| Drive | Power-on hours | Failure-predictive counters (5, 187, 188, 197, 198) | Notable |
|---|---|---|---|
| ST4000DM000 #1 | 55,314 (6.3 yr) | all 0 | 18 SATA downshift errors (cable); lifetime max 56 °C |
| ST4000DM000 #2 | 12,559 (1.4 yr) *claimed* | all 0 | **Hours anomaly, below**; lifetime max 55 °C |
| 1 TB consumer SATA SSD | 59,259 | reallocated 1 | 168 % of rated write endurance; **198 unexpected power losses** |
| 36 GB 10k rpm Raptor | 160,153 (18.3 yr) | all 0 | Remarkable; irrelevant |

## The hours anomaly — working shown

Attribute 9 (power-on hours) is monotonic, so its normalised VALUE only falls,
and WORST can never be lower than VALUE. Drive #1 reads VALUE 37 / WORST 37, as
expected. **Drive #2 reads VALUE 86 / WORST 11: 75 points apart.**

Deriving Seagate's normalisation slope from the two drives independently:

```
slope = (55314 - 12559) / ((100-37) - (100-86)) = 42755 / 49 = 872.6 h/point
check #1: 100 - 55314/872.6 = 36.6   reported 37  ✓
check #2: 100 - 12559/872.6 = 85.6   reported 86  ✓
WORST 11 → (100 - 11) × 872.6 = 77,657 h  ≈ 8.9 years
```

**Corroboration from host writes:** at its claimed age drive #2 was written 15×
harder per hour than its twin (7.2 GB/h against 0.46). At the back-solved age it
is 1.17 GB/h, and the two look like siblings from the same service.

**Unproven, honestly:** the firmware may simply not maintain WORST for this
attribute. An attribute dump cannot exclude that. **What settles it:**
`smartctl -a` on Linux. The error and self-test logs carry their own lifetime
hour stamps; any entry above 12,559 hours closes the question.

## Decisions

1. **The second pool moves to the 4 TB pair — conditionally**, on
   `smartctl -t long` completing cleanly on both. The attribute pass is a
   necessary condition, not a sufficient one, and this record will not let the
   two blur. *Two identical desktop drives from one batch is the correlated
   failure domain a mirror exists to remove.* This is a capacity upgrade, not a
   reliability upgrade, defensible only because the pool is the second copy.
2. **The consumer SSD: usable for VM storage. Not boot. Never a SLOG.** New
   standing rule. A SLOG holds the only copy of synchronous writes not yet in
   the pool; on a drive with no power-loss protection and 198 logged power
   losses, it would fail precisely in the circumstance it exists to survive.
3. **The Raptor is pulled.**
4. **New SATA cable** for drive #1 before it enters a pool.
5. **Re-read attribute 194 a week after the pool is live.** Heat is the
   variable most under the owner's control.

## Also on 29 September — see the journal

The ProCurve firmware flash, which took hours for a reason worth recording:
[journal, 29 September](../_posts/2026-09-29-procurve-firmware-flash.md).
