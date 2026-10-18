---
title: "6. Lessons learned"
layout: page
permalink: /docs/lessons-learned/
---

# 6. Lessons learned

The errors in this record cluster into six patterns. Each is listed with the
instances that earned it, so a reader can check the claim against the history.

## L1 — A correction in one place is not a correction

*Recorded instances: at least six.*

- The two-AP decision of 25 September sat in one document for nine days while
  the port map, a decision record and a build summary kept the old version
  ([25 Sep](../journal.md)).
- The fix for that, on 4 October, reached the map, the diagram and the parking
  range, and missed `vlan 60 untagged 9-12`, **the line that actually assigns
  the port.** Found only because withdrawing VLAN 70 required another full
  search ([ADR-0009](../decisions/ADR-0009-vlan70-withdrawn-guests-are-iot.md)).
- The morning's VLAN 70 propagation reached the port tables and never the
  switch commands.
- A retraction about the SG-3100's patch status sat uncarried for eleven days.
- When the standby moved to bare metal, no document gave it a switch port.

**Practice:** after any correction, search every document for the old claim,
*including configuration blocks*. **Prose gets fixed; commands get missed.**
Five times the prose was fixed and the command was not.

## L2 — An inference written down as an observation

- *"The drives are in and powered, therefore the brackets existed"* — wrong
  twice ([ADR-0002](../decisions/ADR-0002-storage-host-moves-to-t320.md)).
- *"Lifecycle Controller is enabled,"* inferred from a boot-screen banner,
  recorded as a state, and contradicted by two other documents. None of the
  three had read the setting.
- An AP model guessed from a MAC vendor prefix; "a separate IoT VLAN today";
  "the APs are on the ISP gateway" ([7 Oct](../journal.md)).
- An SSID attributed to the ISP gateway from its vendor's naming pattern. It was
  a neighbour's ([16 Oct](../journal.md)).

**Practice:** mark every claim PRIMARY, SECONDARY or UNKNOWN, and ask the
hardware before turning a silence into a conclusion.

## L3 — A partial reading produces a confident conclusion

- The T320 spec sheet read as far as the 3.5-inch bays and no further.
- The ProCurve recommended for the core from its feature list, without checking
  that list against what the core position needs
  ([ADR-0003](../decisions/ADR-0003-two-switch-topology.md)).
- A switch security guide for a different firmware branch, used without noticing
  the substitution.

## L4 — Numbers inherited from the previous host

- *Four* memory channels. The T320's socket has three.
- An ARC-sizing instruction that inverts at 80 GB. On Proxmox 9 an unset cap
  means about 90 % of RAM.
- A power-saving estimate that assumed a firewall appliance which never arrived.

## L5 — The test beats the argument, in both directions

- The Realtek NICs were "a strong match to the broken chip." Fifteen minutes with
  an installer said otherwise ([ADR-0006](../decisions/ADR-0006-carp-standby-bare-metal.md)).
- A firewall check written alongside its rules could never have passed against
  them, and nobody noticed until a reviewer read the two together
  ([4 Oct](../journal.md)).
- The ProCurve flash was blocked for hours by a USB stick that never enumerated.
  The hardware's own status command said so from the start.

## L6 — Citations that agree with the conclusion do not get re-checked

Three bugs cited as open against pfSense were closed, rejected or "not a bug,"
and a CVE was presented as an armv7 argument when it affected every platform
([ADR-0007](../decisions/ADR-0007-pfsense-evaluated-and-declined.md)). The
comparison was unfair to the product it declined, and the decline survived the
correction anyway.

## What went right

- **Writing the weakness down kept it fixable.** The `usb-host` caveat was
  recorded in August, so the first hardware able to remove it was recognised on
  sight in October.
- **Decision records with reopen triggers** made two close calls (pfSense and
  TrueNAS) settle quickly, and kept them settled without anyone relitigating.
- **Keeping withdrawn claims** made each reversal cheap to understand. The T320
  held four positions in six weeks, and each reversal took minutes because the
  previous reasoning was on the page.
- **The owner's memory caught what the audit could not.** Twice it found a
  decision that existed nowhere in writing.
