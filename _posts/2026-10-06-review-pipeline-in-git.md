---
layout: post
title: "The review process moves into git, and is tested by trying to break it"
date: 2026-10-06
---

*5–6 October.* Until now the documents lived in a chat workspace and were backed
up by hand, and twice the backup went stale without anyone noticing. On
5 October the corpus became a **private git repository** and the review process
became a pipeline with rules a machine enforces. The design of that process is
in [§4 Methodology](../docs/04-methodology.md). The record of building it:

- **Roster cut from eleven agents to six.** Eleven domain specialists became
  *rules* that the six load on demand. Knowledge is a rule; only a new *verb*
  is an agent. A commit hook refuses a seventh agent without a stated reason.
- **Only the lead session merges to main.** A guard hook refuses merges,
  branch moves and pushes from any subagent. The guard was tested by attempting
  the forbidden operations. Two tests failed first. Each failure was recorded,
  the guard fixed, and the test re-run to a pass.
- **A claim that was true in one runtime had been written as universal.**
  *"Subagents cannot spawn helpers"* held in the original sandbox and was false
  in the new one. Corrected everywhere it appeared, with the runtime named.
- **The leak auditor printed the patterns it searched for** in a clean report,
  twice. Its instructions now forbid writing a pattern's text, even in a
  not-found line. This public repository's sanitization gate inherits the lesson:
  its word list is private.
- **Even the guard's own commit needed a fix:** one byte of a comment had been
  written in the wrong encoding.

The fact-check that closed the work added a caveat that belongs on every control
in this record: **the gate blocks the spellings it knows. It is not a guarantee.**
