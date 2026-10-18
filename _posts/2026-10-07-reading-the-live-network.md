---
layout: post
title: "Reading the live network: three assumptions were inferences"
date: 2026-10-07
---

The design describes a network that does not exist yet. The house runs on the
**previous setup**: the TS140 with OPNsense as a VM, a flat `LEGACY-LAN`, and
the Catalyst in use. On 7 October the owner photographed screens from that live
network: the Catalyst's MAC address table, the firewall VM's ARP table, and two
login pages.

**What the readings showed, against what the documents assumed:**

| Assumed | Read off the hardware |
|---|---|
| Both APs hang off the ISP gateway | Both are **behind the firewall VM**, on the flat LAN, via the Catalyst |
| An IoT VLAN separates IoT devices today | **No IoT separation exists today.** Both AP paths land in the same VLAN |
| A management address belonged to an AP | It belongs to **the Catalyst itself** (its login page says so) |
| — | An **undocumented managed switch** sits behind one Catalyst port. It was in no inventory |

**Lesson:** three conclusions in the previous week came from inference read as
observation: an AP model guessed from a MAC vendor prefix, a "separate IoT VLAN
today", and "APs on the ISP gateway". The fix is procedural: the build status now
distinguishes *design*, *plan* and *production*, and every production claim
cites a capture.

The same readings showed that two services on the old server must migrate before
cutover: the household DNS filter and the media server. Neither was in any plan.
