---
title: "ADR-0007: pfSense evaluated as the fleet platform, and declined"
layout: page
---

# ADR-0007 — pfSense evaluated as the fleet's firewall platform, and declined

| | |
|---|---|
| **Date** | 4 October 2026 |
| **Status** | Accepted — **the closest call in the build so far** |
| **Prompted by** | The owner: *"if in order to use them I need to switch to pfSense we can do that, given that the rest of the hardware fleet allows it."* |

## 1. The first answer, and why it was poorly argued

The SG-3100s had been shelved ([ADR-0004](ADR-0004-sg3100-not-the-carp-pair.md))
on the grounds that deploying one would add a second firewall OS family. **That
assumed the appliances would be additive.** The owner's question removed the
assumption: if the whole perimeter moved to pfSense there would be one OS
family, and the central objection would evaporate. The question was legitimate
and the first answer had not addressed it. What follows is the costed version.

## 2. The fact that decides the joined question

**pfSense CE and pfSense Plus cannot configuration-sync with each other**, and
**Netgate ships no ARM build of CE**. On the owner's own x86 hardware the free
edition is CE (the free Plus tier for third-party hardware was withdrawn in
October 2023); on the SG-3100 it can only be Plus.

**So an SG-3100 can never be the HA peer of an x86 firewall under any free
configuration.** "Switch the fleet to pfSense" does not make the appliances usable
as part of the existing pair. The two things the question joined are not
joinable.

## 3. The one coherent alternative, stated fairly

**The two SG-3100s as the entire perimeter**, a standalone pfSense Plus HA pair.

| | SG-3100 pair | Current plan |
|---|---|---|
| Identical hardware for HA | **Yes**, as pfSense's HA prerequisites want | No (9020 SFF + Braswell) |
| Dedicated sync port | **Yes** | No |
| Licensing | Free for life on Netgate hardware | Free (OPNsense) |
| Boot-chain integrity | **Current, signed vendor firmware** | Standby: dead 2015 BIOS, no Secure Boot, no TPM |

*That is not a weak case. On boot-chain integrity the appliance pair beats the
Braswell outright.*

## 4. What decides it anyway

**Suricata cannot build for armv7, and has not since pfSense 24.03.** The owner
intends to add IDS/IPS later. An SG-3100 perimeter forecloses that permanently
and structurally, and the project had already written the standard down about
these exact boxes: *"a perimeter appliance that structurally cannot run
intrusion detection is a poor perimeter appliance."*

Supporting, not deciding: throughput never demonstrated at line rate on current
software (single-queue NICs); migration is a full re-author in either direction,
with no supported converter and none covering HA; and release cadence runs
opposite to intuition: OPNsense shipped six 26.7 releases in eleven weeks,
while pfSense CE's last two major intervals were 350 and 538 days.

## 5. Decision

**The fleet stays on OPNsense.** The deciding factor is IDS: the one capability
the owner has said is wanted later, which the appliance path forecloses and the
x86 path keeps open.

### Reopen triggers

1. The owner decides **against** IDS on the perimeter. Then the
   appliance pair's advantages become the stronger argument and this should
   flip.
2. Netgate restores armv7 Suricata.
3. The Braswell's boot-chain weakness turns out to matter more in practice than
   IDS does.

## 6. What the evaluation found wrong in our own documents

Four stale claims, in the comparison document that would be read if this
question were ever reopened, the worst place for them:

1. A Redmine issue cited as an open netmap/IPS bug was **Rejected**, five years
   ago.
2. A Redmine issue cited as open Realtek instability was resolved **"Not a
   Bug"**.
3. An issue presented as a live unicast-CARP sync problem was **fixed in
   23.05-BETA**.
4. A CVE in pfSense's HA sync path had its precondition dropped: it needs
   LDAP/RADIUS authentication, and affects x86 equally, **so it was never an
   argument about armv7**.

> Writing a closed bug down as open is the same failure this project keeps
> catching in its own hardware claims, pointed at a vendor instead. It is worse
> here, because nobody was going to re-check a citation that already agreed
> with the conclusion.

## Addendum, same day

The armv7 recovery image requested from Netgate support arrived. It decompressed
cleanly and matched the published checksum. Netgate's own documentation
confirmed the recovery image *is* the installation medium. A second, "current
firmware" file had been requested in the belief that it was separate; that
framing was this project's error. **The decline stands**: the image is evidence
about none of the three findings above.
