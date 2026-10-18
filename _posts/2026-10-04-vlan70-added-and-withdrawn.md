---
layout: post
title: "VLAN 70: added, corrected twice, withdrawn — in about four hours"
date: 2026-10-04 18:00:00
---

This sequence is the clearest single example in the record of why the git
history is part of the document. Read it with:

```
git log --graph --oneline --all -- verification/guest-vlan70-ruleset.md docs/03-architecture.md
```

1. **Morning — VLAN 70 GUEST propagated** on a feature branch, nineteen days
   after it was decided. Its ruleset: DNS from the firewall, then **pass to
   `any`**.
2. **Correction 1 (review verdict 02, item 3): `any` included the ISP gateway's
   admin page**, because the firewall's WAN sits on that segment. Changed to
   `!RFC1918`, with a block on 53/853 for other resolvers.
3. **Correction 2 (verdict 03, item 1): the block sat below the pass**, so a
   public resolver's port 53 passed as "internet," and the new check
   `dig @PUBLIC-DNS must fail` **could never pass** against the rules written in
   the same commit. The verdict returned the corrected order rather than
   remanding it. This is where the "one round per item" rule came from.
4. **Merged** with `--no-ff`.
5. **The two-AP correction** landed on main (port 18 → AC1750, parked 19–22).
6. **Afternoon: VLAN 70 withdrawn by the owner. Guests are IoT.** The merge is
   undone with `git revert -m 1`, not rewritten: the GUEST ruleset and both of
   its corrections remain in history.
7. VLAN 60 receives the GUEST ruleset retargeted, **both corrections
   pre-applied**, plus a check the GUEST set never had: TRUSTED must be
   unreachable.
8. **The search for VLAN 70 that the withdrawal required found a missed
   command**: `vlan 60 untagged 9-12` never gained port 18. Step 5 had fixed the
   map, the diagram and the parking range, and not the line that assigns the
   port.

[ADR-0009](../decisions/ADR-0009-vlan70-withdrawn-guests-are-iot.md) records the
decision and the accepted risk.
