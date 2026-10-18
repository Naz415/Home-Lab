---
title: "ADR-0008: TrueNAS evaluated for the primary pool, and declined"
layout: page
---

# ADR-0008 — TrueNAS evaluated for the primary pool, and declined

| | |
|---|---|
| **Date** | 4 October 2026 |
| **Status** | **Declined.** The owner: *"stick to original plan."* STORE stays Proxmox VE 9.2 and keeps ownership of `P1` |
| **Prompted by** | The owner: *"I want to add trends to manage the [primary pool]"*, clarified to mean TrueNAS |

## 0. The single most useful finding

**TrueNAS's reporting subsystem *is* Netdata**, per iXsystems' own
documentation, and Netdata installs on Proxmox directly. **The owner asked for
trends. Trends do not require changing who owns the pool.** The migration was
not the price of the feature. It was a separate decision that arrived wearing the
feature's clothes.

## 1. Timing

`P1` does not exist yet. That is the one genuine argument for deciding now: a
migration after the pool holds data is a different and much worse project.

## 2. Option 1 — TrueNAS bare metal, replacing Proxmox

TrueNAS 25.10 Community Edition, on OpenZFS 2.3.9, the same version number as
BACKUP's. But TrueNAS ships its own fork with vendor feature flags, so
**feature-set equality with the replication target is unknown** and has to be
diffed, not assumed.

**The blocker: it costs the GPU transcode design.** The transcode plan is an
unprivileged LXC with a render node, chosen *because* the AMD reset bug makes VM
passthrough a bad trade. Stable TrueNAS has no LXCs for this; its apps are
Docker, with an all-GPUs checkbox, mixed AMD reports, and no evidence either way
for this card. The stable path is a Docker container with the device mapped in:
**a weaker boundary on the machine holding the data.**

Four more deliberate decisions it would undo: the media server's version hold
(the app catalogue shipped a major version with an irreversible database
migration as a patch bump); NUT built from source; SSH restrictions for the
backup pull, which would live in fields iXsystems calls unsupported; and the
ban on `zpool upgrade`, which becomes a button that must never be clicked.

## 3. Option 2 — TrueNAS as a VM, HBA passed through

It keeps the GPU plan intact, which is a real point. But **a hypervisor beneath
the storage means storage is down whenever the hypervisor is**, and the host
cannot rescue the pool because the HBA is bound to `vfio-pci`. The containers
lose bind-mount access and reach their data over NFS across a virtual bridge.
iXsystems' own position on KVM is lukewarm and explicit.

## 4. Option 3 — keep Proxmox; Netdata for trends — recommended

Netdata on Proxmox collects SMART, ARC and pool metrics, a superset of what
TrueNAS's reporting page documents. `smartd`, already installed, can write
per-disk attribute CSVs (`-A`) and report new temperature minima and maxima
(`-W`) with no new software and no listening port.

## Addendum — "this would be a VM or LXC"

The owner clarified that bare metal was never the proposal.

- **LXC is impossible.** TrueNAS is an appliance OS with its own kernel; a
  container shares the host's.
- **A TrueNAS VM on virtual disks is the worst option, not the easy one.** ZFS's
  guarantees depend on raw device access; ZFS on virtual disks backed by ZFS
  gives double write amplification, double ARC, and a checksum layer that can
  no longer say anything true about the hardware.
- If the attraction is a **web UI for ZFS**, `cockpit-zfs` (45Drives, actively
  maintained) provides it on Proxmox.

| What TrueNAS gives | On Proxmox, without it |
|---|---|
| Pool/dataset/snapshot UI | `cockpit-zfs` |
| Reporting and trends | Netdata, the engine TrueNAS reports with |
| SMART history and alerting | `smartd -A` and `-W` |

## Decision

**Declined.** The owner went further than the recommendation and declined the
additions as well. Everything above is retained as the costing.

### Reopen triggers

- The unprivileged-LXC GPU transcode plan is dropped.
- STORE becomes storage-only (services move elsewhere).
- TrueNAS ships LXC GPU passthrough out of beta, with per-GPU selection.

## Corpus problems found on the way

1. The second pool was still described as "the 1 TB pair" in three places in
   the runbook.
2. The cloud-files service's form had three different answers in three
   documents (container, VM, LXC).
3. No Docker host was designated anywhere, though policy language implied one.
