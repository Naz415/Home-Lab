---
layout: post
title: "ProCurve firmware flash: the multi-hour block was a USB stick"
date: 2026-09-29
---

**Result:** the ProCurve 3500yl flashed from K.15.06.0017 (2012) to
**K.16.02.0036** (October 2022), the last software it will ever receive.
K.16.02.0032 sits in the secondary slot as a rollback. The configuration was then
wiped to factory, which leaves the firmware images and boot pointer untouched.

**Root cause of the block:** the USB 3.0 stick **never enumerated** on the
switch's 2006-era USB controller. `show usb-port` reported no device while the
port was enabled and powered. It was not a filename, filesystem or partition
problem. An older non-USB-3.0 stick enumerated immediately.

**Two side-quests not to repeat:**

1. `ip ssh filetransfer` **disables the TFTP client as a side effect**, and
   `no ip ssh filetransfer` does not restore it. `copy tftp` then returns
   `Invalid input: tftp` for the rest of the session. Two mutually exclusive
   transfer paths had been offered in one message; both were tried.
2. An IP address on a VLAN with no port in link gives an address and no
   interface, so `ping` reports "destination unreachable" whatever else is right.

**Standing rule:** the stick that enumerates stays physically with the switch.

Also today: SMART attribute snapshots of the T320's drives
([ADR-0005](../decisions/ADR-0005-smart-readings-second-pool.md)), including a
power-on-hours anomaly worked through from first principles. The T320's iDRAC
went to 2.65.65.65 and its BIOS to 2.9.0.
