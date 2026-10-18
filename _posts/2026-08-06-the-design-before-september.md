---
layout: post
title: "The design before September, and the caveat it carried"
date: 2026-08-06
---

*Reconstructed entry. The design existed in working documents from early
August; this public record begins later and summarises it.*

**State of the design.** An earlier plan for one server (the Lenovo TS140) and
three VLANs had already been replaced by a five-machine design: a bare-metal
OPNsense firewall, three Proxmox hosts, and a backup host that pulls. The TS140
was still the storage host.

**The CARP standby was a VM on DMZ-HOST**, its network legs USB adapters passed
through with QEMU `usb-host`. The runbook recorded the cost plainly on 6 August
and re-confirmed it on 7 August:

> `usb-host` passthrough is administrative, not enforced. Root on a compromised
> DMZ-HOST can reclaim that adapter and reach every VLAN on it.

**Why record a known weakness rather than fix it?** Because no hardware in hand
could fix it. The record's job was to keep the weakness visible so that the
first hardware that *could* remove it would be recognised as doing so. That
happened on 2 October ([ADR-0006](../decisions/ADR-0006-carp-standby-bare-metal.md)).
