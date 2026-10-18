---
title: Standing rules
layout: page
permalink: /verification/standing-rules/
---

# Standing rules

Rules that override any individual decision unless the owner says otherwise.
Each one exists because of a specific failure mode, named in the right-hand
column.

## Network

| Rule | Why |
|---|---|
| VLAN 40 is never defined on the ProCurve or carried on any trunk to it. Re-check after every trunk change | "Allow all" silently reintroduces it, and its absence is the property the two-switch topology exists for |
| Every trunk is written member by member. Never "allow all" | Same |
| ProCurve L2 protections in order: DHCP snooping → let bindings populate → static bindings → ARP protection → IP lockdown | Out of order, they fail silently. Lockdown on a trusted port is accepted and never activates |
| No MAC-limit port security on either AP port | A bridged AP presents many MACs; a limit punishes the correct configuration |
| Neither switch routes. `no ip routing` stays set on the ProCurve | The inter-VLAN boundary is the stateful firewall, nowhere else |
| ADMIN-WS keeps its static address | Both switches pin management to it; if it moves, both management planes are lost at once |
| Parked ProCurve ports are 19–22, never 18–22. VLAN 60 is `untagged 9-12,18`. The map and the commands must agree | Port 18 is the IoT AP. Both errors happened |
| Test interfaces use `TEST-NET`, never a production range | A test address colliding with production breaks both |
| The guest-network flag stays off on both APs | It segments nothing and creates the belief that it does |
| IOT rule 2 sits above rule 3; no internet rule has `any` as its destination | See [the IOT checks](iot-ruleset.md) |

## Hardware and storage

| Rule | Why |
|---|---|
| Never run `zpool upgrade`. Pin `compatibility=` to the oldest importer (BACKUP) | A pool ahead of its replication target silently breaks the backup chain |
| `ashift=12` stated explicitly and read back with `zdb -C` | Inferred sector sizes are wrong on some SSDs |
| Address drives by `/dev/disk/by-id/` only | `/dev/sdX` names move between boots |
| HBA in IT mode, never IR. Check the T320 for a RAID controller | Outside pure HBA mode a controller presents virtual disks and ZFS accepts them silently |
| Set the ARC cap explicitly on Proxmox 9 | Unset, OpenZFS 2.3+ takes about 90 % of RAM |
| The consumer SSD never holds a SLOG | No power-loss protection; 198 recorded power losses |
| Do not swap the T320's power supply. Never reuse old modular cables with a new PSU | Proprietary pinouts mate and do not match |
| A drive enters a pool only after `smartctl -t long` passes | An attribute snapshot is necessary, not sufficient |

## Management and keys

| Rule | Why |
|---|---|
| AMT/vPro off on every OptiPlex and the ProDesk before it gets an address. iDRAC flashed, then disabled | Out-of-band management runs whether the host is up or not |
| CA root keys stay offline and never go into a backup pool | A backup is a copy that travels |
| Never run `ifreload -a` over SSH. Physical console only | A network reload over the network can strand the session |
| No credential that was ever exposed is reused anywhere | — |

## Power

| Rule | Why |
|---|---|
| The ProCurve and the APs go on surge-only outlets, labelled | Not in the shutdown path; about 45 % more runtime for the hosts that are |
