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
| 2 | Pass | `GUEST-NET` → any | Internet |
| 3 | Deny | everything else, both directions | Default deny |

## The checks

Run from a client on the guest segment.

| # | Check | Expected |
|---|---|---|
| 1 | `dig example.com @GUEST-GW` | **succeeds** |
| 2 | `curl -I https://example.com` | **succeeds** |
| 3 | Reach any `SERVICES-NET` address | **fails** |
| 4 | Reach any `MGMT-NET` address | **fails** |
| 5 | Reach any `IOT-NET` address | **fails** |
