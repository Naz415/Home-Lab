---
title: "5. Build status"
layout: page
permalink: /docs/build-status/
---

# 5. Build status

*As of 18 October 2026.* Three columns are kept apart on purpose: what is
**designed**, what is **done to hardware**, and what is **in production**.

## 5.1 Headline

**Nothing in the new fleet is in production.** No pool exists, no host is
installed, no switch is configured to the design. The work so far is firmware,
hardware acceptance, documentation and decisions.

**The house runs on the previous setup:** the TS140 running OPNsense as a VM, a
flat `LEGACY-LAN`, the Catalyst C1200 in use, and both access points on that flat
network. There is **no IoT separation in production today**
([7 October](../journal.md)). The household DNS filter and the media server run on
the TS140 and must migrate before cutover.

## 5.2 Done to hardware

| Item | Date | Evidence |
|---|---|---|
| ProCurve flashed K.15.06.0017 → K.16.02.0036, rollback in second slot, factory config | 29 Sep | Console |
| T320 iDRAC → 2.65.65.65 (CVE-2020-5344), BIOS → 2.9.0 | ~29 Sep | Version read back owed for iDRAC |
| SMART attributes on four drives | 29 Sep | [ADR-0005](../decisions/ADR-0005-smart-readings-second-pool.md) |
| Braswell NICs proven under OPNsense | 2 Oct | [ADR-0006](../decisions/ADR-0006-carp-standby-bare-metal.md) |
| armv7 recovery image obtained and verified | 4 Oct | [ADR-0004](../decisions/ADR-0004-sg3100-not-the-carp-pair.md) |
| ISP gateway radios turned off | 16 Oct | [16 October](../journal.md) |

## 5.3 Tracks

| Track | Scope | State |
|---|---|---|
| **A, B** | STORE (T320) and its pools | **Gated** on one physical test: fit the empty six-drive cage in a media bay. If it will not mount securely, `P1` is a redesign rather than a tweak |
| **C** | The switching layer | Independent. Next: the ProCurve console sitting with `?` completion, then the build |
| **D** | CARP on the bench | Independent. Closes the design's last genuine unknown: whether the ISP gateway forwards CARP multicast. Plus the Realtek soak test |
| **E, F** | What the audit opened | Mostly reading screens |

## 5.4 Measurements owed

- `smartctl -t long` on both 4 TB drives; `smartctl -a` to settle the hours anomaly.
- iDRAC version read back after the flash.
- Whether a RAID controller is present in the T320 (outside pure HBA mode it
  presents virtual disks, which ZFS accepts silently).
- The T320's Lifecycle Controller state, which three documents answered three
  ways without any of them reading the setting.
- A full drive inventory: the factory drives in the small hosts were replaced,
  and the documents describe drives that are no longer fitted.

## 5.5 The cutover

The only step that takes the house off Wi-Fi is moving the APs to the ProCurve,
so it is scheduled rather than improvised, and the rollback is one cable.
**Before it, an SSID census:** after cutover, SSID choice *is* VLAN assignment, and
a device on the wrong SSID keeps working, so nothing will flag it. The hard cases
(a signed-in smart TV, a printer, a console) are decided on paper first.

Resetting the Catalyst to factory, a step in the switch build, takes the house
offline too. It needs the same planned window.
