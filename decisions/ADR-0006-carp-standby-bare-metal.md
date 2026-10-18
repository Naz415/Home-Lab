---
title: "ADR-0006: The CARP standby moves to bare metal"
layout: page
---

# ADR-0006 — The CARP standby moves to bare metal on a Braswell thin client

| | |
|---|---|
| **Date** | 2 October 2026 |
| **Status** | Accepted. **"Genuine peer" withdrawn 4 October** (below) |
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

### The test — fifteen minutes, and it overturned the recommendation

**Measured 2 October: OPNsense booted on the actual hardware.**

```
CARP event system: OK
re0: link state changed to DOWN
re1: link state changed to UP
```

Both ports enumerate under FreeBSD, and the cabled one negotiated link. The
regression does not affect this silicon. **The recommendation was wrong, and the
test is why.** Why it differs is unknown (the `-VL` may be distinct silicon, or
the bug may be board-specific). It does not matter why; it works, and that was
the only question.

A reusable false alarm on the way: under Linux only one port showed link
lights. An administratively down interface never initialises its PHY, so its
LEDs stay dark whatever is plugged in. The second PHY attached the moment the
interface was brought up.

**What the test does not retire:** link-up proves enumeration, not stability
under load. Realtek's documented failure on FreeBSD is a watchdog timeout and
link flap *under sustained load*, which is exactly the condition a standby
exists for. CARP tracks link state, so the sequence would be: failover → full
load → watchdog → flap → CARP oscillates. *A standby that flaps is worse than
no standby.* **A soak test is therefore owed before deployment**, and it matters
more after the test passed, not less.

Build steps that follow: install the `os-realtek-re` vendor driver; leave every
offload and VLAN hardware filtering at the defaults (off); after every OPNsense
upgrade, check the module loaded and the interface is up, because the plugin has
failed to reinstall across upgrades before.

## Costs

**Firmware is the real one.** No Secure Boot, no usable TPM, a 2015 reference
BIOS with no vendor and no future update, at the WAN edge. It is still the
better trade: the weakness it replaces was a live software path from a host
already inside the fleet into every VLAN; this one needs physical access or a
foothold on the standby itself. Partial mitigation: load current CPU microcode
at every boot. *This is now the fourth machine without Secure Boot.*

**Throughput.** Roughly a quarter of the master's CPU. Published figures for this
class of hardware: about 600 Mbps with the in-tree driver, up to about 940 with
the vendor driver. **Neither option holds a clean 1 Gbps line rate.**

## Ruled 4 October — "genuine peer" is withdrawn

The first version of this record called the standby a *genuine peer*. **That was
not earned.**

**It is a topological peer and a capacity-limited one.** It has the master's
shape (own WAN leg, own trunk, bare metal, same OPNsense version) and on failure
takes over routing, NAT, the default-deny ruleset and inter-VLAN policy. **It is
not a hardware peer:** a quarter of the CPU, 4 GB, Realtek where the master has
Intel, a dead BIOS, one 2011-era SSD against a mirror. And the premise rested on
the firewall running no IDS, which the owner intends to add later.

One thing the original write-up left out: the VM standby ran on DMZ-HOST, which
has **more compute than the firewall itself**. This move did not trade up on
every axis. **It traded compute for the trust boundary**, deliberately, and the
boundary was worth more. Stating it as a pure win was the overclaim.

**Standing consequence:** if IDS is ever added to the firewall, this decision
must be revisited in the same breath. A Braswell will not run Suricata at line
rate, and a standby that cannot do what the master does is a silent security
downgrade waiting for an outage.

## Still open

1. Soak test: sustained full-rate traffic across the trunk for hours, watching
   for watchdog timeouts and link-state changes.
2. Whether the ISP gateway passes CARP's IP protocol 112 to `224.0.0.18` between
   its LAN ports. Only the real gateway can answer. Fallback: unicast CARP.
3. SMART on the standby's 32 GB SSD.
