---
title: "4. Methodology"
layout: page
permalink: /docs/methodology/
---

# 4. Methodology

## 4.1 Evidence classes

Every factual claim carries one of three markers.

| Marker | Meaning | Example |
|---|---|---|
| **PRIMARY** | Read off the hardware, or the vendor's own documentation for that exact product and version | The ProCurve's console prompt `…PoEP#` settling its part number |
| **SECONDARY** | A reputable but indirect source | A forum report of throughput on similar hardware |
| **UNKNOWN** | Not established | Whether the ISP gateway forwards CARP multicast between its LAN ports |

Two further rules:

- **A negative is stated as "not found by `<exact query>`"**, never "does not
  exist." The query is the evidence; the conclusion may not be.
- **A plan, a reading and an inference are distinguished.** The most common error
  in the source documents was an inference written down as an observation.

## 4.2 Corrections

1. **A withdrawn claim is not deleted.** The correction is written beside it,
   dated, saying what was wrong. A withdrawn claim is evidence about how the
   project reasons.
2. **After any correction, search the whole corpus for the old claim**,
   including port maps, configuration blocks and decision records, not only the
   prose. A correction made in one document and not propagated cannot be told
   apart from one never made. This rule was written after the first audit found
   24 such cases. It was then broken and re-earned twice on the same day: see
   the [port-18 sequence](../journal.md).
3. **Edits are guarded.** In the private repository, every document edit runs
   through a script that asserts the number of matches before replacing. An edit
   that would match zero places or two fails loudly instead of corrupting the
   document.

## 4.3 The review chain

The design was developed with AI assistance in defined roles. This section
states the method so that a reader can weigh the record accordingly.

```
   OWNER ── states facts, asks questions, decides anything costly or one-way
     │
     ▼
   LEAD SESSION (Anthropic Claude "Fable") ── final verdict; the only merger to main
     │
     ├── evidence-scout, leak-auditor        (Claude Haiku)  grep with judgement
     ├── capture-analyst, doc-writer,        (Claude Sonnet) read and write from a brief
     │   consistency-auditor
     └── fact-checker                        (Claude Opus)   tries to refute
     │
     ▼
   OPUS TEAMMATE ── long work orders, on its own branch; never merges
```

**Verdicts** take one of four forms: *upheld*, *upheld with condition* (a named
check as an exact command), *remanded* (evidence missing that only the hardware
or the owner can supply), or *overturned* (with the contradicting evidence).

**One round per item.** The reviewer fixes wording and small defects itself and
returns corrected text, which is applied as written. A ruling reopens only on new
evidence, never on re-argument. The rule exists because a remand once cost a full
extra round to fix a one-line rule order (see the
[VLAN 70 entry](../journal.md)).

**Disagreements** go to the better evidence class: a reading off the hardware
beats a vendor document, which beats an inference. **On facts about the owner's
own hardware, the owner wins**, every time. The record has precedents in both
directions.

## 4.4 Enforcement by machine, not by habit

From 5 October the working documents are a git repository, and the rules that
matter most are enforced by hooks rather than by instruction:

- **Only the lead session may merge to main.** A guard refuses merges, branch
  moves, pushes and resets from any subagent. It was tested by attempting the
  forbidden operations; two tests failed first and were fixed and re-run.
  *The guard blocks the command spellings it knows. It is not a guarantee.*
- **A growth cap of six agents**, enforced by a commit hook that refuses a
  seventh without a named, recorded failure the six could not have caught.
  Domain knowledge (network, hardware, security and so on) lives in rule files
  the agents load on demand. *Knowledge is a rule; only a new verb is an agent.*
- **A leak gate** on every commit. Its pattern list is never printed, even in a
  clean report.
- **Backups prove themselves.** The backup script writes its manifest only after
  the remote is shown to hold the commit, and the session banner prints the
  manifest's age. *A backup that has stopped running looks identical to one that
  is working.*

## 4.5 Limits of the method

- **An audit of documents cannot find what the documents never mentioned.** It
  reasons from the gap as though the gap were data. The guest VLAN that was
  decided and never written down sat undetected for nineteen days. Only the
  owner's memory and the hardware can close that class.
- **AI review catches inconsistency well and novelty poorly.** Most errors it
  caught were contradictions between documents. Most errors it missed were facts
  no document held.
- **Runtime-specific behaviour gets generalised.** A claim about what subagents
  can do was true in one environment and false in the next.

## 4.6 This public record

This repository was reconstructed from the private one on 18 October 2026.
Commits replay events in order and the event date is at the start of each
message; commit timestamps are the day of reconstruction. The sanitization
rules are in [SANITIZATION](../SANITIZATION.md).
