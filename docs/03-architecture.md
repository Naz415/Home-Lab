---
title: "3. Architecture"
layout: page
permalink: /docs/architecture/
---

# 3. Architecture

*This is the design, not the network in production. Every change to this
file is a commit; `git log -p docs/03-architecture.md` is the history of the
design, including its errors.*

## 3.1 Overview

Five machines and a standby, six VLANs, two switches, one firewall that makes
every routing decision.

```
                    Internet
                       |
              ISP gateway (Calix GS4227, router mode)
              DMZ-host passthrough to FW-WAN
               |                          |
        direct cable                direct cable
        (never a switch port)       (never a switch port)
               |                          |
     +---------v---------+      +---------v---------+
     | FW  OPNsense      |      | FW-STBY OPNsense  |
     | bare metal        | CARP | bare metal        |
     | OptiPlex 9020 SFF |<---->| Braswell thin cl. |
     +---------+---------+      +---------+---------+
               | trunk 20,30,40,50,60     | trunk 20,30,40,50,60
               | GE1                      | GE5
     +=========v==========================v===========+
     |  CORE-SW  Cisco Catalyst C1200-8P-E-2G        |
     |  infrastructure only · on the UPS             |
     +--+------+------+------+------+------------+---+
        |GE2   |GE3   |GE4   |GE6   |GE7         |GE9
      STORE  TRUST  DMZ-HOST BACKUP ADMIN-WS     | trunk 20,30,50,60
      t20,40 t20,40  u20     u20    u20          | (VLAN 40 absent)
                                                 |
     +===========================================v===+
     |  ACCESS-SW  HP ProCurve 3500yl-24G-PoE+       |
     |  J9310A · L2 only · NOT on the UPS            |
     +--+---------+---------+---------+------+-------+
        | 1-8     | 9-12    | 13-16   | 17          18-22
     TRUSTED     IOT       DMZ       AP           parked
      u30        u60       u50      u30           u998
                                  (trusted
                                   Wi-Fi)
```

## 3.2 The machines

| Role label | Hardware | Job | OS |
|---|---|---|---|
| **FW** | Dell OptiPlex 9020 SFF, i5-4590, 12 GB | Router and firewall, nothing else | OPNsense, bare metal, ZFS mirror on two SATA SSDs |
| **TRUST** | Dell OptiPlex 9020 Micro, i5-4590T, 16 GB | Trust root: step-ca, internal DNS, monitoring | Proxmox VE 9.2 |
| **DMZ-HOST** | HP ProDesk 600 G6 Mini, i5-10500T, 16 GB | DMZ and reverse proxy | Proxmox VE 9.2, ZFS mirror on two NVMe |
| **STORE** | Dell PowerEdge T320, Xeon E5-2470 v2 10C/20T, 80 GB ECC | Storage, backups, data services | Proxmox VE 9.2 |
| **BACKUP** | Dell OptiPlex 7040 Micro, i5-6500T, 16 GB | Off-chassis backup target. **Pulls only** | Debian 13 |
| **FW-STBY** | Braswell thin client, Celeron N3150, 4 GB, 2 × 1 GbE | CARP standby for FW | OPNsense, bare metal |

The three Proxmox hosts are deliberately **not clustered**. A Lenovo TS140,
the previous single server, is retired from the design and becomes the bench
for rehearsals ([ADR-0002](../decisions/ADR-0002-storage-host-moves-to-t320.md)).

## 3.3 The VLANs

| VLAN | Name | Subnet label | Reaches |
|---|---|---|---|
| 10 | WAN | `ISP-NET` | Never on a switch port; the firewall's WAN leg is a direct cable |
| 20 | MGMT | `MGMT-NET` | Admin workstation to management planes only |
| 30 | TRUSTED | `TRUSTED-NET` | The owner's own devices; reaches published services through FW |
| 40 | SERVICES | `SERVICES-NET` | Storage and household services. **Exists on CORE-SW only** |
| 50 | DMZ | `DMZ-NET` | Internet-facing reverse proxy |
| 60 | IOT | `IOT-NET` | Unpatchable devices. Internet only |
| 998 | PARKING | — | Unused ports. Goes nowhere |
| 999 | NATIVE | — | Native VLAN on every trunk. Carries nothing |

Default-deny between every pair. VLAN 1 is emptied on both switches.

## 3.4 The switching layer

| Switch | Role | Management | Carries |
|---|---|---|---|
| **Cisco Catalyst C1200-8P-E-2G** | CORE-SW | `CORE-SW-IP` | All five machines, both firewall trunks, the admin workstation. **The only switch carrying VLAN 40.** On the UPS |
| **HP ProCurve 3500yl-24G-PoE+ (J9310A)** | ACCESS-SW | `ACCESS-SW-IP` | Clients, IoT, DMZ devices, both access points. **L2 only, `no ip routing`.** Firmware frozen at K.16.02.0036 (October 2022). Not on the UPS |

**The rule that placed them** ([ADR-0003](../decisions/ADR-0003-two-switch-topology.md)):
*the ProCurve's security features are edge features and its liabilities are
core liabilities, so it goes at the edge.* It has DHCP snooping, dynamic ARP
protection, IP source lockdown and BPDU protection, which the Catalyst lacks,
but no stateful filtering, so the inter-VLAN boundary stays on FW.

**The property this buys:** VLAN 40 does not exist on the ProCurve at all.
Not tagged, not untagged, not on the uplink. VLAN hopping and double-tagging
need the target VLAN to be present on the switch being attacked. Clients reach
storage services by routing through FW, where a stateful firewall has an
opinion. **Every trunk is written member by member; "allow all" anywhere
would reintroduce VLAN 40 silently.**

### Access ports — CORE-SW

| Port | Device | Mode | VLANs |
|---|---|---|---|
| GE2 | STORE | Trunk | tagged 20,40 native 999 |
| GE3 | TRUST | Trunk | tagged 20,40 native 999 |
| GE4 | DMZ-HOST (Proxmox host) | Access | untagged 20 |
| GE6 | BACKUP | Access | untagged 20 |
| GE7 | ADMIN-WS | Access | untagged 20 |
| GE8 | spare | Shutdown | 998 |

### Access ports — ACCESS-SW

| Port | Device | Mode | VLAN | Protections |
|---|---|---|---|---|
| 1–8 | Trusted wired clients | Access | untagged 30 | snooping · ARP protect · IP lockdown · BPDU protect |
| 9–12 | IoT devices | Access | untagged 60 | snooping · ARP protect · IP lockdown · BPDU protect |
| 13–16 | DMZ devices | Access | untagged 50 | snooping · ARP protect · IP lockdown · BPDU protect |
| 17 | Netgear MR60 mesh AP (trusted Wi-Fi) | Access | untagged 30 | snooping · ARP protect · BPDU protect · no lockdown at first |
| 18–22 | spare | Shutdown | 998 | parked and disabled |

### Trunks

Kept in a separate table from the access ports on purpose: trunk membership is
the thing that changes when a VLAN is added or withdrawn, and it is the thing
that must be re-checked for VLAN 40 every time.

| Link | Mode | Members |
|---|---|---|
| FW ↔ CORE-SW GE1 | Trunk | tagged 20,30,40,50,60 native 999 |
| FW-STBY ↔ CORE-SW GE5 | Trunk | tagged 20,30,40,50,60 native 999 |
| CORE-SW GE9 ↔ ACCESS-SW 24 | Trunk | tagged 20,30,50,60 native 999 |
| CORE-SW GE10 ↔ ACCESS-SW 23 | Trunk, uncabled until a LAG exists on both ends | tagged 20,30,50,60 native 999 |

The ProCurve's VLAN commands are in
[`configs/procurve-access-excerpt.txt`](../configs/procurve-access-excerpt.txt).

### Order of the ProCurve's layer-2 protections

Configured out of order, they fail silently:

1. DHCP snooping on VLANs 30, 50, 60, uplinks trusted.
2. Wait for real clients to lease; read the binding table.
3. Static bindings for every fixed-address device.
4. ARP protection.
5. IP source lockdown on 1–16. **Lockdown on a trusted port is accepted and never activates.**
6. BPDU protection on 1–18.
7. Later, separately: lockdown on the AP ports once their clients are visibly binding.

No MAC-limit port security on either AP port: a bridged AP presents many MAC
addresses, so a limit punishes the correct configuration.

## 3.5 The wireless layer

One access point, on an **access port**.

| AP | Port | VLAN | Serves |
|---|---|---|---|
| Netgear MR60 mesh (kit MK62) + 2 × MS60 satellites, wireless backhaul | 17 | untagged 30 | TRUSTED |

Whether the MR60 can tag VLANs in AP mode is not yet known. If it cannot,
**every wireless device shares VLAN 30** until an AP is replaced, and VLAN 60
contains only wired devices.

**The Netgear guest-network flag stays off.** It is an AP-internal
client-isolation flag; guest traffic still leaves untagged into the port's own
VLAN. Enabling it creates the belief that a separate guest network exists.

## 3.6 Firewall policy

Default-deny between all VLANs. VLAN 60 is internet-only; its ruleset is
not yet written.

The upstream ISP gateway sits on `ISP-NET` with its admin page at `ISP-GW`,
cabled directly to FW and to FW-STBY, so that `ISP-NET` never appears on a
switch port. A pass rule to `any` would reach that admin page, which is why no
internet-only rule in this design has `any` as its destination.

## 3.7 Storage and backup

```
P1  raidz2, 6 × Kingston DC500M 480 GB, LSI SAS3008 (IT mode, SFF-8643)   on STORE
 └─> P2  mirror, 2 × Seagate ST4000DM000 4 TB (conditional)               on STORE
      └─> P3  2 TB SSD                                                   on BACKUP, which PULLS
           └─> encrypted USB, offline, rotated off-site
```

- **Greenfield.** No data exists anywhere yet. Mistakes cost time, not data.
- `P2`'s drive pair is admitted only after `smartctl -t long` passes on both
  ([ADR-0005](../decisions/ADR-0005-smart-readings-second-pool.md)).
- `BACKUP` pulls; nothing pushes to it. Its Debian OpenZFS is the oldest
  importer in the fleet, so every pool pins `compatibility=` to it.
- STORE's ARC is capped explicitly at 16 GiB of 80 GB. On Proxmox VE 9 an
  absent `zfs.conf` means OpenZFS's default of roughly 90 % of RAM.

## 3.8 Transcoding

AMD Radeon Pro WX 2100 in STORE, passed to an **unprivileged LXC** as a render
node rather than to a VM (the AMD reset bug makes VM passthrough a poor trade).
A GTX 1060 was shelved: the T320 has no documented GPU power cable, and NVIDIA's
580 driver branch is the last for Pascal. The cost is HEVC 10-bit *encode*; the
common transcode, HEVC 10-bit in and H.264 out, is unaffected
([ADR-0003](../decisions/ADR-0003-two-switch-topology.md) §2).

## 3.9 Power

The UPS (1500 VA / 900 W) carries STORE, FW, CORE-SW and the three small
hosts, about 237 W. The ProCurve (98 W idle) and the APs go on surge-only
outlets, labelled. The shutdown path (NUT over VLAN 20) crosses only the
Catalyst, so the ProCurve is never in it. That is about 45 % more runtime for the
machines flushing a pool. Solar removes the cost of watts, not the watts: a
grid-tie inverter disconnects during an outage.
