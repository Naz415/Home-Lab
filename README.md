# Home-Lab — design record of a segmented home laboratory

**A five-machine, six-VLAN home laboratory: Proxmox VE, OPNsense, two-tier
switching, and a documented review methodology.**

Published at **[naz415.github.io/Home-Lab](https://naz415.github.io/Home-Lab/)**.
Companion to the [Network+ lab notebook](https://naz415.github.io).

## Abstract

This repository records the design of a home laboratory network built to a
security-first brief: maximum isolation, default-deny between segments, and keys
or certificates in place of passwords wherever the platform allows. The design
places a bare-metal OPNsense firewall and a bare-metal CARP standby in front of
six VLANs. It keeps a stateful firewall as the only inter-VLAN boundary, uses an
older managed switch at the access layer *because* its liabilities are core
liabilities, and makes the storage VLAN physically absent from that switch. Nine
decision records cover the choices, including two platform migrations that were
costed and declined. The record keeps its own errors: wrong part numbers, a
firewall rule that exposed the upstream router, a port map that would have
disabled an access point. Each is a commit, followed by the commit that
corrected it.

**Status: designed, not built.** See [§5 Build status](docs/05-build-status.md).

## Contents

| | |
|---|---|
| [docs/01-introduction](docs/01-introduction.md) | Purpose, scope, how to read this |
| [docs/02-threat-model](docs/02-threat-model.md) | Assets, threats, principles, trust boundaries |
| [docs/03-architecture](docs/03-architecture.md) | The design: machines, VLANs, switches, wireless, storage |
| [docs/04-methodology](docs/04-methodology.md) | Evidence classes, corrections, the AI-assisted review chain |
| [docs/05-build-status](docs/05-build-status.md) | Designed vs done vs in production |
| [docs/06-lessons-learned](docs/06-lessons-learned.md) | Six patterns across the errors |
| [docs/07-references](docs/07-references.md) | Vendor documents and advisories |
| [decisions/](decisions/) | ADR-0001 to ADR-0009 |
| [_posts/](_posts/) | The journal: dated lab-notebook entries |
| [verification/](verification/) | Firewall checks and standing rules |
| [configs/](configs/) | Switch configuration excerpts |
| [CHRONOLOGY.md](CHRONOLOGY.md) | One line per event |

## Reading the history

The commit history is part of the record. Each commit message starts with the
date of the **event** it records, in square brackets. Commit timestamps are the
day the history was reconstructed (18 October 2026). The history is rebuilt
after the fact, not back-dated, and it does not pretend otherwise.

```sh
git log --reverse --format='%s'                       # the story, in order
git log --graph --oneline --all                       # branches and merges
git log --grep='CORRECTION'                           # every correction
git log -p docs/03-architecture.md                    # how the design changed
git log --all -- verification/guest-vlan70-ruleset.md # a VLAN that lived four hours
git tag -n                                            # milestones
```

Conventions:

- Decisions are made on `decision/*` branches and merged with `--no-ff`, so a
  decision and its same-day corrections stay grouped.
- **Errors are commits.** A wrong claim is committed as it was believed. The
  correction is a separate, later commit whose message starts `CORRECTION:` and
  says what was wrong.
- **Withdrawals are reverts.** VLAN 70 was merged, then undone with
  `git revert -m 1`. Nothing is rewritten.

## Sanitization

Public and sanitized: no names, addresses, hostnames, serial numbers or MAC
addresses. Design detail (VLAN IDs, firmware versions, CVEs, port numbers, rule
order) is kept, because it is the content. See [SANITIZATION.md](SANITIZATION.md).
A check script runs before every commit: [tools/sanitize-check.sh](tools/sanitize-check.sh).

## Assistance

The design was developed with AI assistance (Anthropic's Claude models) in
defined review roles, described in [§4](docs/04-methodology.md). Decisions that
cost money or could not be undone were the owner's.

## Licence

Text: [CC BY 4.0](LICENSE.md). Scripts: MIT.
