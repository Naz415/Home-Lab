---
layout: post
title: "Two access points, two access ports — decided, and not propagated"
date: 2026-09-25
---

**Question from ADR-0003:** can the MR60 mesh tag VLANs in AP mode? If not,
every wireless device would share VLAN 30.

**Answer: it cannot, and it does not matter.** A second AP, a Netgear Nighthawk
AC1750, was already in the house. The design became **two APs on two access
ports**: the MR60 on port 17 (TRUSTED), the AC1750 on port 18 (IOT). An AP on an
access port cannot inject into a VLAN it is not assigned to, whatever its
firmware does, so physical segmentation is the stronger architecture.

**What went wrong:** this was written into one working document. The port map
in the architecture document, the open item in ADR-0003, and the switch-build
summary all kept the old version: one AP, and ports 18–22 parked and
**disabled**. Following the build sheet literally would have shut down the port
the IoT AP needed.

It stayed that way for **nine days**, until the owner caught it from memory on
4 October against three documents that said otherwise. Note that this entry
makes **no change to the architecture document**, which is the failure itself
recorded as history.
