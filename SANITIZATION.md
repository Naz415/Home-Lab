---
title: Sanitization policy
layout: page
permalink: /sanitization/
---

# Sanitization policy

This repository is a public, sanitized companion to a private working
repository. The private one is the operational record: real addresses, real
hostnames, serial numbers, photographs of screens. This one keeps what is
educational and removes what would tell a reader *where* the network is or *how
to attack it specifically*.

The rule used to decide each case: **design is published; location and identity
are not.** A VLAN ID, a firewall rule order, a firmware version or a switch port
number is design: it can be argued about, and the argument is the point. An
address, a hostname, a serial number or a room is location: it adds nothing to
the argument and something to an attacker's map.

## The convention

| Category | In the private record | In this repository |
|---|---|---|
| People | Owner's name, household and network names, a prior owner of second-hand equipment | None. Only the GitHub handle appears. "The owner" in prose |
| Addresses | Real subnets, gateway, switch and workstation addresses | Symbolic labels: `MGMT-NET`, `ADMIN-WS`, `ISP-GW`, `TEST-NET` and so on (table below). VLAN IDs are kept, because they are design |
| Hostnames and pool names | The six machines' short names and the three ZFS pool names | Role labels: `FW`, `FW-STBY`, `TRUST`, `DMZ-HOST`, `STORE`, `BACKUP`; pools `P1`, `P2`, `P3` |
| Identifiers | MAC addresses, serial numbers, appliance device IDs, asset tags, drive serials, image checksums | None |
| Rooms and layout | Room names, AP positions | "AP site A", "satellite 1/2", or omitted |
| Hardware models, firmware versions, CVEs, switch port numbers, firewall rule order | As is | **Kept** — they are the educational content |
| The AI review chain | As is | **Kept and disclosed** — an academic record states its methods and its assistance ([methodology](docs/04-methodology.md)) |

## The address labels

| Label | Meaning |
|---|---|
| `ISP-NET`, `ISP-GW` | The upstream ISP gateway's LAN segment and its admin address |
| `FW-WAN`, `FW-STBY-WAN` | The firewall's and the standby's own addresses on `ISP-NET` |
| `MGMT-NET` | VLAN 20, management |
| `TRUSTED-NET`, `SERVICES-NET`, `DMZ-NET`, `IOT-NET` | VLANs 30, 40, 50, 60 |
| `IOT-GW`, `TRUSTED-GW`, … | The firewall's interface address on that VLAN |
| `CORE-SW-IP`, `ACCESS-SW-IP` | The two switches' management addresses, both in `MGMT-NET` |
| `ADMIN-WS` | The single static admin workstation both switches pin management to |
| `TEST-NET` | The isolated bench subnet, never overlapping any production range |
| `LEGACY-LAN`, `LEGACY-DMZ` | The flat network of the setup still in production (see [build status](docs/05-build-status.md)) |
| `PUBLIC-DNS` | Any well-known public resolver |

The RFC 1918 blocks themselves (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
appear where the firewall alias is described, because they are a standard, not
a location.

## The gate

[`tools/sanitize-check.sh`](tools/sanitize-check.sh) runs before every commit.
It refuses IPv4 addresses (other than the standards above), MAC addresses, email
addresses, serial-number and device-ID shapes, image checksums, and any binary
file. A second layer checks a **private denylist** of names, network names and
real hostnames, which lives outside the repository.

The denylist is private on purpose. A public list of the words being hidden is
a disclosure of those words. The source project learned this when its own leak
auditor printed, in a clean report, the exact patterns it had searched for.

**The gate blocks known shapes and listed words. It is not a guarantee.** The
same caveat was written about the source project's merge gate, and it applies
here for the same reason: a pattern list catches what someone thought of.

## Commit identity

Commits are authored as `Naz415` with GitHub's no-reply address, so no personal
email address appears in the history.
