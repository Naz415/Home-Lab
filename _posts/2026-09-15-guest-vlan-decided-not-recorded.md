---
layout: post
title: "A guest VLAN is decided — and not written down"
date: 2026-09-15
---

*Retrospective entry, written after the fact. There is no contemporary record
of this decision, and that is the point of this entry.*

The owner decided that guests should get their own segment, VLAN 70 GUEST,
internet-only. **It was not written into any document.** It first appeared in
the record nineteen days later, on 4 October, when a review noticed it was
missing. It was withdrawn about four hours after that
([ADR-0009](../decisions/ADR-0009-vlan70-withdrawn-guests-are-iot.md)).

**Lesson, carried into the methodology:** a decision that exists only in
someone's memory or a chat transcript has not been made, as far as the build is
concerned. The build follows documents.
