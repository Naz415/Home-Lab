---
title: "2. Threat model and principles"
layout: page
permalink: /docs/threat-model/
---

# 2. Threat model and principles

## 2.1 Stated priority

**Maximum isolation, and no passwords where a key or certificate can do the
job**: SSH keys, mutual TLS, certificate-based administration. One honest
limit is recorded against that priority: **neither OPNsense nor Proxmox
supports client-certificate login to its admin web interface.** No document in
this record may claim otherwise.

## 2.2 Assets, in order

1. **The management plane** (VLAN 20): whoever holds it holds everything.
2. **The trust root**: the internal certificate authority. Its root keys stay
   offline and never go into a backup pool.
3. **Data** on the storage host, and its two further copies.
4. **Availability** of the household's internet connection.

## 2.3 Threats, ranked

| # | Threat | Where it enters | Primary control |
|---|---|---|---|
| 1 | A compromised internet-facing service | DMZ-HOST | DMZ VLAN, default-deny at FW, nothing in the DMZ trusted by anything else |
| 2 | A compromised unpatchable device (TV, plug, camera) | VLAN 60 | Internet-only ruleset; nothing holding a credential on that VLAN |
| 3 | A guest's device | VLAN 60 | Same. **The shared layer-2 domain is an accepted risk** ([ADR-0009](../decisions/ADR-0009-vlan70-withdrawn-guests-are-iot.md)) |
| 4 | A compromised access-layer switch | ACCESS-SW (firmware frozen 2022) | VLAN 40 absent; management key-only and pinned to one address; no routing |
| 5 | Out-of-band management firmware | iDRAC, Intel AMT | Flashed past known CVEs, then disabled before the host gets an address |
| 6 | A prior owner's configuration on second-hand gear | SG-3100s | Never booted on a live segment; reset before use; not catalogued |

## 2.4 Principles

**P1 — Enforced, not administrative.** Every claim that something is
*isolated* must name the mechanism: a switch's ingress filter, a firewall rule,
a key, physics. A label, a convention or a host-side setting is administrative,
and a root user on that host can undo it. The `usb-host` passthrough on the
original standby was the canonical example
([ADR-0006](../decisions/ADR-0006-carp-standby-bare-metal.md)).

**P2 — A rule on the firewall does not bind two hosts in the same VLAN.** The
firewall sees only traffic that crosses it. VLAN 20 is a flat layer-2 domain,
so any boundary between two of its members phrased as "a rule on FW" binds
nothing.

**P3 — A VLAN that does not exist on a switch cannot be hopped to on that
switch.** Hence VLAN 40 is absent from the access layer entirely, and every
trunk is written member by member.

**P4 — Keep consumer firmware off the trunks.** Access points sit on access
ports. A compromised AP then cannot reach a VLAN it was not assigned, whatever
its firmware does.

**P5 — Compare against doing nothing, and against the cold alternative.** A
mitigation is judged against both, not only against the previous design.

**P6 — Mitigation is not equivalence.** Four machines lack Secure Boot (two by
choice, two because the hardware cannot have it). The record says so on each,
and does not let narrower exposure stand in for the missing control.

## 2.5 Trust boundaries — claimed against enforced

| Claimed boundary | Enforced by | How it fails |
|---|---|---|
| VLAN 40 unreachable from clients | Absence of VLAN 40 on ACCESS-SW (hardware), and FW default-deny | An "allow all" trunk edit. Checked after every trunk change |
| IoT and guests are internet-only | FW ruleset, order-dependent | A reorder. Check 3 in [the IOT checks](../verification/iot-ruleset.md) catches it |
| A compromised AP cannot reach management | Switch access port, untagged-only ingress | Moving an AP to a trunk |
| BACKUP is pull-only | **Administrative** on VLAN 20 (same-VLAN neighbours; see P2), SSH restrictions on the pulling key | Any path that lets something push to it |
| Only ADMIN-WS manages the switches | Switch authorized-manager lists, plus FW rules for other VLANs | ADMIN-WS changing address loses both management planes at once |
| Guests separated from IoT devices | **Nothing.** Accepted risk | — |
