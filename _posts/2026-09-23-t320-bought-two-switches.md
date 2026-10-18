---
layout: post
title: "The T320 is bought; the switching layer becomes two switches"
date: 2026-09-23
---

A dense day: three decision records and the first architecture document.

- **[ADR-0002](../decisions/ADR-0002-storage-host-moves-to-t320.md) accepted.**
  The T320 was bought. Read off the machine: 80 GB rather than the listed 64, no
  Secure Boot at all, and BMC firmware vulnerable to a pre-authentication RCE
  (CVE-2020-5344) until flashed.
- **[ADR-0003](../decisions/ADR-0003-two-switch-topology.md):** ProCurve at the
  access layer, Catalyst at the core. **The first recommendation was the
  reverse, and it was wrong**: it would have replaced a stateful firewall with
  a stateless switch ACL. Corrected the same day, on a branch, before merging.
  The correction is a separate commit so the error stays readable.
- **[ADR-0004](../decisions/ADR-0004-sg3100-not-the-carp-pair.md):** the two
  SG-3100 appliances are not the CARP pair. OPNsense has no ARMv7 build.

**The [architecture document](../docs/03-architecture.md) starts today**, and
it starts with three errors that nobody had noticed yet: the wrong ProCurve part
number, the wrong SAS breakout connector, and a port map with one access-point
port and ports 18–22 parked. Each was found and corrected on 4 October. Each
correction is its own commit.
