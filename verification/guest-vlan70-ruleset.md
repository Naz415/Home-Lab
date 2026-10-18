---
title: GUEST ruleset (VLAN 70)
layout: page
---

# VLAN 70 GUEST — ruleset and verification checks

*Added 4 October 2026. VLAN 70 GUEST was decided on 15 September and not
written down anywhere until today.*

`GUEST-NET`: internet only, plus DNS from the firewall. No inter-VLAN traffic in
either direction.

## The rules, on FW's GUEST interface, in this order

| # | Action | Source → destination | Purpose |
|---|---|---|---|
| 1 | Pass | `GUEST-NET` → `GUEST-GW`, TCP/UDP 53 | DNS from the firewall only |
| 2 | Block | `GUEST-NET` → any, TCP/UDP 53 and 853 | No other resolver |
| 3 | Pass | `GUEST-NET` → `!RFC1918` | Internet only. **Never `any`** |
| 4 | Deny | everything else, both directions | Default deny |

**Corrected 4 October (review verdict 20261004-02, item 3).** The internet
rule read `→ any`. FW's WAN sits on `ISP-NET` with the ISP gateway's admin
page at `ISP-GW`, so `any` let a guest open the admin page of the one device
above every control in the design. Now `!RFC1918`, an alias of the three
private blocks with *invert* ticked.

**Corrected again 4 October (review verdict 20261004-03, item 1).** The first
correction placed the resolver block *below* the internet pass. A public
resolver's address is not private, so the pass carried `PUBLIC-DNS:53` and the
block never fired. Worse, check 3 below, written in the same change, *could
never pass* against that order. The verdict returned the corrected order
directly rather than remanding it. Block now sits above pass.

**Check 3 is the only check that tests rule order rather than rule content**,
so it is the one a reorder breaks and a configuration diff does not show.

**Accepted limit.** DNS-over-HTTPS on 443 is not blocked and cannot be without
TLS interception. Do not add rules chasing it.

## The checks

Run from a client on the guest segment.

| # | Check | Expected |
|---|---|---|
| 1 | `dig example.com @GUEST-GW` | **succeeds** |
| 2 | `curl -I https://example.com` | **succeeds** |
| 3 | `dig example.com @PUBLIC-DNS` | **fails** — tests rule order |
| 4 | Browse to `ISP-GW` | **fails** |
| 5 | Reach any `SERVICES-NET` address | **fails** |
| 6 | Reach any `MGMT-NET` address | **fails** |
| 7 | Reach any `IOT-NET` address | **fails** |
