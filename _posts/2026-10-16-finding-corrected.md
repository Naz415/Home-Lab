---
layout: post
title: "FINDING 20261011 corrected: the SSID was a neighbour's"
date: 2026-10-16 18:00:00
---

Acting on the 11 October finding, the owner turned off both radios on the ISP
gateway and re-scanned from the AP position.

- **5 GHz:** the SSID was gone.
- **2.4 GHz:** **the SSID was still present**, at −65 to −75 dBm, with the
  gateway's radios off.

So it was not the gateway. The gateway's own admin page showed its real SSID,
which was a different name. **The SSID belonged to a neighbour's unit of the
same make**, which explains the vendor naming pattern.

The commits today go in this order: the scan showing the SSID still present,
with the finding left open; then the correction; then a merge. The
[11 October entry](2026-10-11-wifi-survey.md) is amended only by a pointer to
this one. Its claim is left standing, because the private evidence folder is
append-only and this record follows the same rule.

**Lesson:** a vendor naming pattern identifies a vendor, not a device. Turning
the radios off was still worth doing, but for the reason the scan found, not the
one the finding gave. The scan also showed the IoT AP on channel 4 overlapping
the mesh on channel 2, which is a real finding for the cutover.
