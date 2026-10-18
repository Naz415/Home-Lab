---
layout: post
title: "PCIe slot table reversed; straight to Proxmox 9.2; GPU in an LXC"
date: 2026-09-30
---

- **The T320 PCIe slot table was wrong and is reversed:** the SAS HBA goes to
  slot 3 and the WX 2100 to slot 6. It had been carried forward unchecked from
  a listing.
- **Proxmox: straight to 9.2.** The planned 8 → 9 upgrade detour is retired.
  Greenfield hosts have nothing to upgrade.
- **GPU transcode: an unprivileged LXC with the render node, not VM
  passthrough.** The AMD reset bug makes passthrough a bad trade, and the
  media server's history of remote code execution as root argues for the
  unprivileged container.
