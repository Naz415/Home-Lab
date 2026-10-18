---
title: "7. References"
layout: page
permalink: /docs/references/
---

# 7. References

Vendor documentation and advisories the decisions rest on, as consulted between
September and October 2026. Versions and support status change; anything below
should be re-read before it is relied on.

## Standards

- RFC 1918 — Address Allocation for Private Internets.
- IEEE 802.1Q — VLAN tagging. IEEE 802.3at — PoE+.
- CARP — Common Address Redundancy Protocol, IP protocol 112, multicast
  `224.0.0.18` (OPNsense high-availability documentation).

## Switching

- HP/HPE, *Access Security Guide*, K/KA/KB.16.02, covering the 3500yl (K), 3800
  (KA) and 3810/5400R (KB). One combined document; several chapters apply to only
  some of the families. Source of `ip ssh public-key manager`.
- HPE, ProCurve 3500yl K.16.02.0036 release notes (October 2022, final).
- Cisco, *Catalyst 1200 Series Switches CLI Guide*.

## Firewalls

- OPNsense documentation: high availability, VLAN hardware filtering defaults,
  `os-realtek-re` plugin.
- OPNsense issue tracker: the RTL8111E regression on 26.1/26.7; Realtek watchdog
  timeouts under load (closed as a driver support issue).
- Netgate, SG-3100 product lifecycle (end of sale 2021, end of life October
  2023); pfSense Plus 24.03 release notes (packages no longer built for armv7:
  Suricata, Squid, squidGuard); SG-3100 reinstall documentation; pfSense Plus
  26.07 release notes; Netgate blog, *Keeping the Netgate 3100 Alive, One Upstream
  Patch at a Time*.

## Servers and firmware

- Dell, PowerEdge T320 Owner's Manual (media bays; GPU power; third-party PCIe
  cooling response).
- Dell, CVE-2020-5344 advisory (iDRAC7/8, fixed in 2.65.65.65).
- Intel, INTEL-SA-00241 (CVE-2019-0151, Intel TXT).

## Storage

- OpenZFS documentation: `ashift`, `compatibility=`, ARC defaults on 2.3+.
- iXsystems, TrueNAS reporting documentation (Netdata) and virtualization
  guidance (storage controller passthrough required).
- 45Drives, `cockpit-zfs`.
- Backblaze, published drive failure statistics (ST4000DM000).

## Wireless

- Netgear, MR60/Orbi and Nighthawk AC1750 manuals: features disabled in AP mode,
  including VLAN/IPTV setup.

## Media

- Jellyfin, hardware acceleration documentation (AMD VAAPI codec support matrix).
- NVIDIA, Linux driver branch 580 as the last supporting Maxwell, Pascal and Volta.
