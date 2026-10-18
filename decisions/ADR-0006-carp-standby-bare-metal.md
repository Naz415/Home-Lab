---
title: "ADR-0006: The CARP standby moves to bare metal"
layout: page
---

# ADR-0006 — The CARP standby moves to bare metal on a Braswell thin client

| | |
|---|---|
| **Date** | 2 October 2026 |
| **Status** | Proposed — gated on the NIC test below |
| **Decided by** | The owner |

*This is the first time a known compromise in this build was removed rather
than re-justified.*

## Context — what the design said, in its own words

Since 6 August the standby had been an OPNsense VM on DMZ-HOST, its network
legs USB adapters passed through with QEMU `usb-host`:

> The honest framing, because it was not free. `usb-host` passthrough is
> **administrative, not enforced**. The host kernel still sees the device on the
> USB bus; it has merely been detached from the host driver and claimed by QEMU.
> **Root on a compromised DMZ-HOST can reclaim that adapter and reach every VLAN
> on it — 20, 30, 40, 50 and 60.**

DMZ-HOST is the host the design itself names as most likely to fall.

## What changed

Three Braswell thin clients arrived. The deciding specification was read off
the machines:

| Reading | Value |
|---|---|
| CPU | Celeron N3150, 4C/4T, 6 W, amd64 |
| Network | **2 × integrated 1 GbE** |
| RAM | 4 GB DDR3L, socketed |
| Firmware | AMI reference BIOS, 2015; OEM fields never filled in |
| Secure Boot | Off; TPM not usable |

**The two NICs are the whole decision.** The firewall's WAN leg runs from the ISP
gateway to a dedicated physical port so that `ISP-NET` never appears on a
switch port. A single-NIC box could not copy that topology; two ports make the
standby the same shape as the master. The addressing plan had already reserved
`FW-STBY-WAN`. **The VM plan was a concession to hardware, not a preference.**

## Decision

The standby becomes **OPNsense on bare metal**: WAN on NIC 1 direct to the ISP
gateway, LAN trunk on NIC 2. No VM, no USB adapters, no hypervisor in the trust
path. DMZ-HOST reverts to DMZ and reverse proxy only.

| Box | Role |
|---|---|
| 1 | The CARP standby |
| 2 | Cold spare for box 1, identical hardware |
| 3 | Bench, with the TS140 |

Boxes 2 and 3 become a throwaway CARP pair first. CARP failover cannot be tested
with one machine, which the bench plan had quietly assumed it could.

## Both NICs are Realtek — the gate, not a caveat

Read from the running machine: **RTL8168E-VL / RTL8111E-VL, PHY RTL8211E**, on
both ports.

An open OPNsense issue reports the RTL8111E as **dead on OPNsense 26.1 and
26.7**: the interface enumerates and does nothing. The firewall was to run 26.7.
On the evidence, the recommendation was that **bare metal should not be planned
on**, and that the standby would revert to the VM with its caveat restored.
