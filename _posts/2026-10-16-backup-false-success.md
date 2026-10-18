---
layout: post
title: "The backup script reported success after a failed push"
date: 2026-10-16 09:00:00
---

The private repository's backup script pushes `main` to a second location and
writes a dated manifest. **It reported success after a push that had failed.**
The output of three runs was captured as evidence.

**The fix, in three rounds of audit:**

1. A failed push now fails loudly. The manifest is written only after the remote
   is proven to hold the new commit.
2. The manifest is renamed into place **last**, so a half-finished run cannot
   leave a fresh-looking manifest.
3. A comment claiming that a clean-tree check replaced a separate missing-file
   check was an overstatement, and was corrected.

**Why it matters more than it looks:** *a backup that has stopped running looks
identical to one that is working.* This project had already lost documents to a
workspace reset and had backups go stale three times, unnoticed. The session-start
banner now prints the manifest's age, and anything over 48 hours is a finding.

Also today: a plan for a read-only API survey of the fleet (Proxmox and OPNsense
APIs, scoped read-only tokens, output as timestamped JSON) was written and
**deferred** until the new firewall is live. Its trigger condition is written
down so that it is not forgotten.
