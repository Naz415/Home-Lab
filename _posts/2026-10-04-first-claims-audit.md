---
layout: post
title: "The first full claims audit: 8 stale, 24 un-propagated, 12 contradictions"
date: 2026-10-04 09:00:00
---

An independent audit read every working document against every other, and
against the hardware readings where they existed.

| Found | Count |
|---|---|
| Stale claims | 8 |
| Corrections made in one place and not propagated | **24** |
| Unresolved contradictions | 12 |

Mechanical fixes were applied at source; five needed judgement and were ruled.
The ones that changed a plan rather than a sentence, each a commit today:

1. **CVE-2019-0151 is an Intel TXT fix, not a Management Engine fix.** Eight
   documents had it wrong, and an open item ("did the ME actually update?") closed
   because the ME version was never the right thing to read.
2. **The SAS3008's breakouts are SFF-8643, not SFF-8087.** Caught before the
   cable order.
3. **The ProCurve is a J9310A** (PoE+, 30 W per port), not a J8692A (15.4 W).
   Settled from the console prompt, `…PoEP#`, captured during the firmware flash.
4. **Port GE5 was still assigned to a standby VM that no longer existed.** When
   the standby moved to bare metal on 2 October, no document gave it a switch
   port at all.
5. **"Genuine peer" withdrawn** for the standby.
6. **The T320 has three memory channels, not four.** A number inherited from the
   previous host.
7. **The 25 September two-AP decision had never reached the port map.** The owner
   found it from memory. Port 18 was parked and disabled in a *command*.

**The audit's central methodological finding:** an audit of documents finds what
the documents disagree about. **It cannot find what they never mentioned, and it
will reason confidently from the gap as though the gap were data.**

Later the same day, a guest VLAN was added and withdrawn: see the
[next entry](2026-10-04-vlan70-added-and-withdrawn.md).
