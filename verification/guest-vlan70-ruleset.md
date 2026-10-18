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
| 2 | Pass | `GUEST-NET` → `!RFC1918` | Internet only. **Never `any`** |
| 3 | Block | `GUEST-NET` → any, TCP/UDP 53 and 853 | No other resolver |
| 4 | Deny | everything else, both directions | Default deny |

**Corrected 4 October (review verdict 20261004-02, item 3).** Rule 2 read
`→ any`. FW's WAN sits on `ISP-NET` with the ISP gateway's admin page at
`ISP-GW`, so `any` let a guest open the admin page of the one device above
every control in the design. Now `!RFC1918`, an alias of the three private
blocks with *invert* ticked. A block rule for 53 and 853 was added in the
same change.

## The checks

Run from a client on the guest segment.

| # | Check | Expected |
|---|---|---|
| 1 | `dig example.com @GUEST-GW` | **succeeds** |
| 2 | `curl -I https://example.com` | **succeeds** |
| 3 | `dig example.com @PUBLIC-DNS` | **fails** |
| 4 | Browse to `ISP-GW` | **fails** |
| 5 | Reach any `SERVICES-NET` address | **fails** |
| 6 | Reach any `MGMT-NET` address | **fails** |
| 7 | Reach any `IOT-NET` address | **fails** |
