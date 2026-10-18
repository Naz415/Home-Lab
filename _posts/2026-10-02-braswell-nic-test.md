---
layout: post
title: "Fifteen minutes with an installer overturns a recommendation"
date: 2026-10-02
---

Three Braswell thin clients with **two integrated NICs each** made a bare-metal
CARP standby possible, which would retire the `usb-host` caveat recorded since
6 August ([ADR-0006](../decisions/ADR-0006-carp-standby-bare-metal.md)).

**Morning: the evidence said no.** Both NICs read as Realtek RTL8111E-VL, and an
open upstream issue reports the RTL8111E as dead on OPNsense 26.1 and 26.7. The
recommendation, committed on the decision branch, was that bare metal should not
be planned on.

**Afternoon: the machine said yes.** The OPNsense installer booted on the actual
box. Both ports enumerated as `re0` and `re1`, and the cabled port negotiated
link. The branch's second commit records that the recommendation was wrong and
the test is why. Both commits are kept, and the branch is merged with `--no-ff`
so they stay grouped.

**What the test does not prove:** stability under sustained load, which is
exactly Realtek's documented failure mode and exactly a standby's job. A soak
test remains owed.

**Also today:** the owner confirmed the firewall will run no IDS for now. That
fed a claim, "the standby is a genuine peer," which a review withdrew two days
later.
