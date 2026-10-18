---
title: "ADR-0004: The SG-3100s are not the CARP pair"
layout: page
---

# ADR-0004 — The two Netgate SG-3100s are not the CARP pair

| | |
|---|---|
| **Date** | 23 September 2026 |
| **Status** | Accepted |
| **Decided by** | The owner |

This record exists because **two firewall appliances on a shelf are a standing
invitation to reopen a closed question.**

## Context

The lab bundle ([ADR-0001](ADR-0001-teaching-lab-bundle.md)) included two
Netgate SG-3100 appliances. The design's CARP standby was, at the time, a VM on
DMZ-HOST with its network legs passed through as USB adapters, a documented
weakness (runbook §10.2). An appliance
pair looked like the fix.

## The blocker, stated once

**The SG-3100 is Marvell Armada 38x: ARMv7, 32-bit. OPNsense ships amd64
only.** There is nothing to install, and every part of the design (the
default-deny ruleset, the CARP configuration, the configuration-export
discipline) assumes OPNsense.

## What they can run, and on what terms

pfSense Plus, via a recovery image requested from Netgate support (not a public
download), on hardware end-of-life since October 2023, with **no Suricata**
(dropped for armv7 at pfSense 24.03). And it will not be patched again:
FreeBSD 16 drops armv7, so the operating system underneath stops building
for it.

## Decision

**The firewall stays OPNsense on the OptiPlex 9020 SFF, bare metal. The CARP
plan stands as written**, its documented weakness included. Trading a known,
bounded weakness for an end-of-life appliance with no intrusion detection is a
swap for something worse that looks more like a firewall.

The appliances were assigned a bench role: lab firewall on an isolated segment,
never holding a certificate that matters, never between the internet and
anything.
