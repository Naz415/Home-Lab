---
title: "1. Introduction"
layout: page
permalink: /docs/introduction/
---

# 1. Introduction

## 1.1 Purpose

This record documents the design of a segmented home laboratory network: five
machines and a standby, six VLANs, two switches, and a firewall pair. It covers
the decisions, the reasoning behind each one, and the errors made on the way.
It is written as a companion to coursework in network technology (CompTIA
Network+, N10-009). The [Network+ lab notebook](https://naz415.github.io)
covers single techniques in isolation. This record shows the same techniques
composed into one system, and what goes wrong when they are.

## 1.2 Scope

**In scope:** the network and security architecture; hardware selection and
acceptance; the firewall and switch policy; storage and backup design; the
review method used to keep the documents correct.

**Out of scope:** application configuration beyond what touches a trust
boundary; anything about the owner's household other than the network.

**Status, stated up front:** at the time of writing, **the design has not been
built.** Firmware has been flashed, hardware has been read and accepted or
rejected, and the switching and firewall policy is written. The house still
runs on an earlier, flatter setup ([§5](05-build-status.md)). This is a design
record, and the distinction between *designed*, *planned* and *in production*
is kept throughout. Blurring it was one of the commonest errors the project made.

## 1.3 What makes it a record rather than a write-up

1. **Decisions are recorded with their alternatives and their reopen
   triggers** ([decisions/](../decisions/)), including the ones the owner
   overruled and the recommendations that turned out wrong.
2. **Errors are kept.** A corrected claim is not deleted; the correction is
   written next to it with a date. In the git history, the wrong version is a
   commit and the fix is a later commit.
3. **Claims are classed by evidence.** A reading off the hardware, a vendor
   document and an inference are different things, and the record says which
   one each claim is.

## 1.4 How to read this repository

| Start here | For |
|---|---|
| [§3 Architecture](03-architecture.md) | The design as it now stands |
| [Decision records](../decisions/) | Why each part is the way it is |
| [Journal](../journal.md) | What happened, in date order |
| [§6 Lessons](06-lessons-learned.md) | The patterns across the errors |
| `git log --reverse` | The same story, told by the commits themselves |

## 1.5 Assistance and authorship

The design work was done with AI assistance throughout, using Anthropic's Claude
models in defined review roles. That is a method, so it is described as one in
[§4](04-methodology.md). Every decision that cost money or could not be undone
was the owner's.
