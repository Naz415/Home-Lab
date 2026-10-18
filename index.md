---
layout: home
title: Home
---

**A design record of a five-machine, six-VLAN home laboratory**: Proxmox VE,
OPNsense on bare metal with a CARP standby, two-tier switching, and a documented
review method. Written as a companion to the
[Network+ lab notebook](https://naz415.github.io).

**Status: designed, not built.** The house still runs on the earlier, flatter
setup. [§5](docs/05-build-status.md) keeps *designed*, *done* and *in production*
apart.

### The record

1. [Introduction](docs/01-introduction.md)
2. [Threat model and principles](docs/02-threat-model.md)
3. [Architecture](docs/03-architecture.md)
4. [Methodology](docs/04-methodology.md)
5. [Build status](docs/05-build-status.md)
6. [Lessons learned](docs/06-lessons-learned.md)
7. [References](docs/07-references.md)

Plus nine [decision records](decisions/), the [IOT firewall checks](verification/iot-ruleset.md),
the [standing rules](verification/standing-rules.md), and a one-page
[chronology](CHRONOLOGY.md).

### Errors are part of the record

Wrong part numbers, a firewall rule that would have exposed the upstream
router, a port map that would have disabled an access point: each was committed
as it was believed and corrected in a later commit. The
[source repository's history](https://github.com/Naz415/Home-Lab/commits/main)
tells the same story as the journal below.

### Journal
