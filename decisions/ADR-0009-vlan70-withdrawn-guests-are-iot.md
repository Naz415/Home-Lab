---
title: "ADR-0009: VLAN 70 withdrawn; guests are IoT"
layout: page
---

# ADR-0009 — VLAN 70 GUEST withdrawn. Guests are IoT

| | |
|---|---|
| **Date** | 4 October 2026 |
| **Status** | Accepted. **Reversible**: every removed line is in the history, and restoring VLAN 70 is the same change run backwards |
| **Decided by** | The owner. Recorded as review verdict 20261004-05 |

## Decision

> *"Drop VLAN 70 entirely and accept that guests are IoT. The guests just need
> to access the internet."* — the owner

Visitors join the Nighthawk AC1750's SSID and land in **VLAN 60**, which is
internet-only. There is no separate guest segment.

## How it was reached

VLAN 70 GUEST was decided on 15 September, **not written down anywhere**, and
propagated on the morning of 4 October (`git log --merges` shows the branch).
Within hours the wireless picture made it expensive: two APs, both deliberately
on access ports, cover exactly two wireless VLANs, and neither can tag. A third
wireless VLAN needs a third AP, and with no ethernet drops in the house a wired
third AP's coverage would have been one room.

The open board item offered three options: a trunked VLAN-aware AP, a third
wired AP, or a wired-only GUEST VLAN. The owner asked whether the Nighthawk's own
guest Wi-Fi made VLAN 70 unnecessary. The reviewer answered that the guest flag
segments nothing, because it emits untagged frames into the port's own VLAN,
and added a fourth option the board had left off: **drop VLAN 70 and put guests
on IoT.** The owner chose it.

## The accepted risk — in so many words

**A visitor's device and every unpatchable device in the house share one
broadcast domain, in both directions.**

- The firewall's rules govern traffic that crosses the firewall. They cannot see
  two clients on the same SSID talking to each other.
- An access port does not isolate clients, and the AC1750 has no client
  isolation in AP mode.
- **Nothing at layer 2 mitigates this.**

Accepted because the guest population is small and known, guests need only the
internet, and the alternative was hardware whose coverage would not reach them.

## What it obliges

1. **VLAN 60 gets a real ruleset.** It had a policy sentence and no rules. Now
   four, with both of the GUEST set's same-day corrections pre-applied, and
   eight checks, one new: TRUSTED must be unreachable
   ([verification/iot-ruleset.md](../verification/iot-ruleset.md)).
2. **The IoT passphrase is now a visitor credential.** Rotate it when that
   matters; expect to re-join IoT devices when you do.
3. **Nothing holding a credential that matters goes on the IoT SSID.** A guest
   reaches it at layer 2, below every rule.
4. **The guest flag stays off on both APs.** Turning it on recreates the belief
   in a separate guest network.

## Findings the withdrawal surfaced

The withdrawal required a search of every document for VLAN 70, and the search
found three things the morning's work had not:

- **The ProCurve's command block never received VLAN 70.** The morning's change
  reached the port tables and not the commands. Had VLAN 70 stayed, the map
  would have said the uplink carried it and the switch would not have.
- **The port-18 fix was incomplete, and it was a command.** The morning's
  correction moved the IoT AP onto port 18 in the port map, the diagram and the
  parking range, but `vlan 60 / untagged 9-12` never gained port 18. Run as
  written, the IoT AP would have come up in the default VLAN, outside VLAN 60.
  *Found by the grep this withdrawal required, not by the fix itself, which is
  the argument for running that grep every time, including on corrections to
  corrections.*
- A superseded one-switch port map still said *"this table overrides any prose
  that contradicts it."* True until 23 September.

**VLAN 40 was re-confirmed absent** from the ProCurve and every trunk to it after
the change.

## Reopen triggers

- The guest population grows, or stops being known people.
- A device on VLAN 60 starts holding credentials that matter and cannot move.
- A VLAN-aware AP is bought for coverage reasons anyway. Then a real guest
  segment costs one SSID, and the firmware-on-the-trunk objection has to be
  weighed again on its own terms.
