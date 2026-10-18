---
title: Chronology
layout: page
permalink: /chronology/
---

# Chronology

One line per event. **E** marks an error, **C** its correction, **D** a decision.

| Date | | Event | Record |
|---|---|---|---|
| early Aug 2026 | | Five-machine design replaces the one-server, three-VLAN plan. CARP standby is a VM with USB-passthrough NICs, weakness recorded | journal 6 Aug |
| 8 Sep | D | Hardware search closed; lab bundle bought | ADR-0001 |
| 8 Sep | C | Electricity-cost argument against the T320 withdrawn (solar) | ADR-0001 |
| 8 Sep | D | Storage host to T320 proposed: the bays were missed on the first reading | ADR-0002 |
| 13 Sep | D | T320 proposal withdrawn | ADR-0002 |
| 15 Sep | **E** | Guest VLAN 70 decided, **not written down** | journal 15 Sep |
| 23 Sep | D | T320 bought; read off the machine: 80 GB, no Secure Boot, BMC CVE | ADR-0002 |
| 23 Sep | **E** | ProCurve recommended for the core | ADR-0003 |
| 23 Sep | C | Reversed: ProCurve at access, Catalyst at core | ADR-0003 |
| 23 Sep | D | SG-3100s are not the CARP pair | ADR-0004 |
| 23 Sep | **E** | Architecture written with part J8692A, SFF-8087 breakouts, one AP port, ports 18–22 parked | architecture |
| 25 Sep | D | Two APs on two access ports. **Not propagated** (E) | journal 25 Sep |
| 29 Sep | | ProCurve flashed to K.16.02.0036 after a USB stick failed to enumerate | journal 29 Sep |
| 29 Sep | D | SMART readings; second pool to the 4 TB pair, conditionally | ADR-0005 |
| 30 Sep | C | T320 PCIe slot table reversed. Straight to Proxmox 9.2; GPU in an unprivileged LXC | journal 30 Sep |
| 2 Oct | **E** | "RTL8111E: bare metal should not be planned on" | ADR-0006 |
| 2 Oct | C | Installer test: both NICs work. Standby moves to bare metal | ADR-0006 |
| 4 Oct | | First claims audit: 8 stale, 24 un-propagated, 12 contradictions | journal 4 Oct |
| 4 Oct | C | J8692A → J9310A; SFF-8087 → SFF-8643; CVE-2019-0151 is TXT, not ME; GE5 retargeted | architecture, ADR-0002 |
| 4 Oct | C | "Genuine peer" withdrawn; ProCurve compromise exposes four VLANs, not three | ADR-0006, ADR-0003 |
| 4 Oct | | VLAN 70 propagated on a branch | guest ruleset |
| 4 Oct | **E**/C | Guest rule 3 `any` → `!RFC1918` | guest ruleset |
| 4 Oct | **E**/C | Block rule below pass rule → reordered | guest ruleset |
| 4 Oct | C | Port 18 is the IoT AP; parked range 19–22 (the owner, from memory) | architecture |
| 4 Oct | D | pfSense as fleet platform: declined | ADR-0007 |
| 4 Oct | D | TrueNAS for the primary pool: declined | ADR-0008 |
| 4 Oct | D | SG-3100s shelved; recovery image obtained and verified | ADR-0004 |
| 4 Oct | D | **VLAN 70 withdrawn; guests are IoT.** Merge reverted | ADR-0009 |
| 4 Oct | C | `vlan 60 untagged 9-12` missed port 18; found by the withdrawal's search | configs |
| 5–6 Oct | | Working corpus becomes a git repository; review pipeline with enforced merge gate | journal 6 Oct |
| 7 Oct | C | Live network read: APs behind the old firewall VM; no IoT separation today; undocumented switch | journal 7 Oct |
| 11 Oct | **E** | An SSID attributed to the ISP gateway's radio | journal 11 Oct |
| 16 Oct | C | Backup script reported success after a failed push; fixed | journal 16 Oct |
| 16 Oct | C | The SSID was a neighbour's | journal 16 Oct |
| 18 Oct | | This public record created | — |
