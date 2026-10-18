---
title: "ADR-0004: The SG-3100s are not the CARP pair"
layout: page
---

# ADR-0004 — The two Netgate SG-3100s are not the CARP pair

| | |
|---|---|
| **Date** | 23 September 2026 |
| **Status** | Accepted. **Disposition 4 October: shelved, powered off, third-tier fallback** |
| **Decided by** | The owner |

This record exists because **two firewall appliances on a shelf are a standing
invitation to reopen a closed question.**

## Context

The lab bundle ([ADR-0001](ADR-0001-teaching-lab-bundle.md)) included two
Netgate SG-3100 appliances. The design's CARP standby was, at the time, a VM on
DMZ-HOST with its network legs passed through as USB adapters, a documented
weakness (see [ADR-0006](ADR-0006-carp-standby-bare-metal.md)). An appliance
pair looked like the fix.

## The blocker, stated once

**The SG-3100 is Marvell Armada 38x: ARMv7, 32-bit. OPNsense ships amd64
only.** There is nothing to install, and every part of the design (the
default-deny ruleset, the CARP configuration, the configuration-export
discipline) assumes OPNsense.

## What they can run, and on what terms

pfSense Plus, via a recovery image requested from Netgate support (not a public
download), on hardware end-of-life since October 2023, with **no Suricata**
(dropped for armv7 at pfSense 24.03).

## Decision

**The firewall stays OPNsense on the OptiPlex 9020 SFF, bare metal. The CARP
plan stands as written**, its documented weakness included. Trading a known,
bounded weakness for an end-of-life appliance with no intrusion detection is a
swap for something worse that looks more like a firewall.

The appliances were assigned a bench role: lab firewall on an isolated segment,
never holding a certificate that matters, never between the internet and
anything.

## Addendum — 2 October

1. **The firewall will run no IDS for now.** That retires one objection.
2. **The weakness the appliances were wanted for has been fixed by other
   hardware**: three Braswell thin clients with two integrated NICs each
   ([ADR-0006](ADR-0006-carp-standby-bare-metal.md)). Their bench role is also
   better filled by those boxes: a Braswell rehearses OPNsense on amd64, which is
   representative of production. *A rehearsal that does not resemble the thing
   rehearsed produces confidence rather than knowledge.*

Mixing is not a third option: an OPNsense master with a pfSense standby would
elect at the CARP level, but configuration sync would not work and rulesets are
not portable. Two separately maintained firewalls drifting apart while
appearing to be a pair is worse than one firewall.

## Disposition — 4 October

**Shelved, powered off, retained as a third-tier fallback.** Every
firewall-shaped role is filled by x86 hardware running the fleet's own OS.
Putting an SG-3100 into service would add a second firewall OS family, with its
own advisories, cadence and recovery procedure, for zero capability the fleet
lacks.

*A shelved appliance is an option. A powered-on end-of-life appliance is an
obligation.*

**The time-sensitive part was not the shelving.** A fallback you cannot
reinstall is a paperweight stored on purpose, and the armv7 recovery image comes
only from a support request that Netgate could stop honouring without notice.
**The request was submitted on 4 October and the image arrived the same day**;
it decompressed cleanly and matched the vendor's published checksum.

### Correction recorded on 4 October

This record originally said the appliances *"will not be patched again."* That
was wrong when written: pfSense Plus 26.07 (August 2026) still supported the
3100. Netgate's description of armv7 as heading for unbuildable carries **no
published end date**. And a CVE in pfSense's HA sync path, cited here as an
armv7 argument, affects x86 equally and requires LDAP/RADIUS authentication to
reach. **The conclusion survives all three corrections, because it never rested
on them**: there is nothing to install for OPNsense, and Suricata does not build
for armv7.

### Handling, absolute

One unit carries a **prior corporate owner's asset tag**. Neither unit has ever
been booted. If they come off the shelf: isolated `TEST-NET` only, factory reset
before anything can reach them, **do not catalogue a prior owner's
configuration**, RAM disks on and heavy logging off to spare the eMMC.

Device identifiers (serials, MACs, device IDs) are held in the private record
only.
