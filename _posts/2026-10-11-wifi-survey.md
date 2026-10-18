---
layout: post
title: "Wi-Fi survey: an unexpected SSID, and coverage from one AP"
date: 2026-10-11
---

A Wi-Fi analyzer scan and two speed tests, for the cutover plan.

**Coverage.** With the IoT AP at its planned position and a phone in the
farthest room: 15.7 / 14.8 Mbps on 2.4 GHz and 59.2 / 28.3 Mbps on 5 GHz, 17 ms.
The wireless link, not the internet connection, was the ceiling. One AP reaches
the far room.

**FINDING 20261011.** The scan showed an SSID carrying the ISP gateway vendor's
default naming pattern, broadcasting on the ISP gateway's segment. **Recorded
as: the ISP gateway's own radio is on**, which would put an unmanaged wireless
network on the segment directly above the firewall.

> **Corrected 16 October: this finding was wrong.** The SSID was a neighbour's.
> See [the correction](2026-10-16-finding-corrected.md). The claim above is left
> as written.
