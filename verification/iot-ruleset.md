---
title: IOT ruleset and checks
layout: page
permalink: /verification/iot-ruleset/
---

# VLAN 60 IOT — ruleset and verification checks

*Written 4 October 2026, when VLAN 70 GUEST was withdrawn and guests moved onto
VLAN 60 ([ADR-0009](../decisions/ADR-0009-vlan70-withdrawn-guests-are-iot.md)).
Before that day VLAN 60 had a policy sentence and no rules.*

This ruleset is the withdrawn GUEST set retargeted. It therefore arrived with
**both of that set's same-day corrections already applied**, which is why its
first version is right. The GUEST set's history, including both errors, is in
the commit log: `git log --all -- verification/guest-vlan70-ruleset.md`.

## The rules, on FW's IOT interface, in this order

| # | Action | Source → destination | Purpose |
|---|---|---|---|
| 1 | Pass | `IOT-NET` → `IOT-GW`, TCP/UDP 53 | DNS from the firewall only |
| 2 | Block | `IOT-NET` → any, TCP/UDP 53 and 853 | No other resolver, plain or DNS-over-TLS |
| 3 | Pass | `IOT-NET` → `!RFC1918` | Internet only. **Never `any`** |
| 4 | Deny | everything else, both directions | Default deny |

`RFC1918` is an alias holding 10.0.0.0/8, 172.16.0.0/12 and 192.168.0.0/16,
used with *invert* ticked.

**Why rule 3 is `!RFC1918` and not `any`.** FW's WAN sits on `ISP-NET` with
the ISP gateway's admin page at `ISP-GW`. A pass to `any` would let any IoT
device, or any guest, open the admin page of the one device above every
control in the design. Do not "fix" this by putting block rules above a
pass-any: the next reorder reopens it.

**Why rule 2 sits above rule 3.** A public resolver's address is not private,
so without rule 2 the internet pass carries `PUBLIC-DNS:53` and the DNS pin is
decorative. Many IoT devices hard-code a public resolver; this is where you
find out which.

**Why DNS is pinned to the firewall rather than the household DNS filter.** The
filter lives on VLAN 40. Letting VLAN 60 query it would be the one permitted
flow out of an internet-only segment, the kind of single exception that erodes
one.

## The checks — eight, six must fail

Run from a client on the IoT SSID.

| # | Check | Expected |
|---|---|---|
| 1 | `dig example.com @IOT-GW` | **succeeds** |
| 2 | `curl -I https://example.com` | **succeeds** |
| 3 | `dig example.com @PUBLIC-DNS` | **fails** — the only check that tests rule *order* |
| 4 | `kdig +tls example.com @PUBLIC-DNS` (port 853) | **fails** |
| 5 | Browse to `ISP-GW` | **fails** |
| 6 | `ping TRUSTED-GW` | **fails** — added 4 October; the GUEST checks never tested TRUSTED |
| 7 | Reach any `SERVICES-NET` address | **fails** |
| 8 | Reach any `MGMT-NET` address | **fails** |

**Check 3 is the one that catches a reorder.** A configuration diff shows that
two rules swapped; it does not tell you that the swap opened a hole. Re-run
check 3 after *any* edit to this ruleset.

**Accepted limit.** DNS-over-HTTPS on 443 is not blocked and cannot be without
TLS interception, which this design does not do. The pin stops default and
accidental resolver use and keeps the firewall the observable path. Do not add
rules chasing it.

## What these rules cannot do

Two clients on VLAN 60 talk to each other without crossing FW, so no rule here
governs them. A guest reaches every IoT device at layer 2, and the reverse.
That is the accepted risk in ADR-0009. It is not a gap in the ruleset.
