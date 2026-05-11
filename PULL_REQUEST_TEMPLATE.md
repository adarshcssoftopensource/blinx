<!-- Blinx PR Template — Provenance + QA Discipline If you can’t fill this out, the PR isn’t ready. -->
Summary
<!-- 1–3 sentences: what changed and why. Keep it concrete. -->
Linked Issue (REQUIRED)

Closes: #ISSUE_NUMBER

<!-- Must be exactly one issue per PR. If more than one, stop and split the PR. -->
Scope Tag (REQUIRED)

 type:ship

 type:hardening

 type:stub

Loop Tag (REQUIRED)

 loop:work

 loop:rewards

 loop:progress

 loop:foundation

Hours Used (REQUIRED)

Time spent (this PR only): __h __m

Cap reminder: hours must map to the linked issue’s estimate; deviations require written approval.

Changes Made
<!-- Bullet list. Example: - Implemented Missions list tabs (Available/Active/Submitted/Completed) - Added mission card component using tokens + primitives - Added loading/empty/error states -->
Screenshots / Video Proof (REQUIRED)
<!-- Attach images directly to the PR or link to a short clip. -->

 Screenshot(s) attached (before/after if applicable)

 Video clip attached (required if behavior/flow changed)

Attachments:

Home:

Missions:

Wallet:

Profile:

<!-- Add only the relevant sections. -->
Test Notes: “What I Clicked” (REQUIRED)
<!-- Provide a reviewer-reproducible script. -->

Open app → go to ...

Tap ...

Verify ...

Trigger error/empty state by ... (if applicable)

Devices tested:

 iOS (model + OS): __________________

 Android (model + OS): ______________

 Emulator/Simulator only (explain why): __________________

Data Wiring (REQUIRED)

Select one:

 WIRED to real backend endpoint(s)

Endpoint(s): GET /... POST /...

Env/base URL used: __________________

 STUBBED (no endpoint exists or intentionally deferred)

Stub method (mock provider / fixture / feature-flagged route): __________________

“Coming soon” UX present: [ ] Yes

Feature Flags (REQUIRED if any)

Flags added/used:

ff________: default ON/OFF

Stubs must be feature-flagged and non-blocking.

Guardrails Check (REQUIRED)

 No payouts / no banking semantics / no money movement UI added

 No client-side role changes or permission elevation

 Missing permission keys treated as false (where RBAC applies)

 Only the locked MVP loop scope touched (or explicitly stubbed)

Regression Risk

Risk level:

 Low

 Medium

 High

What could break? (1–2 bullets)

Rollback plan: (if needed)

-# Reviewer Checklist (for maintainers)

 Exactly one linked issue; scope matches issue AC

 Screenshots/video present

 “What I clicked” steps are reproducible

 Wired vs stubbed is explicit

 Flags + defaults documented

 No scope creep into non-loop features

Additional Guidance: What / Why / Acceptance / Effort / Risk
What (Short description)
<Short description>
Why (User/Ops impact)

<User/ops impact>

Acceptance Evidence (Stop/Go)

 Evidence link(s)

 Linked issue acceptance satisfied

Effort Guard

NTE hours (agreed): __

Hours used: __

Confidence %: __

Docs touched: README / Runbook / ADR (≤1 page; ≤30 min; updates ≤10 min)

Risk / Rollout

Feature flag: __

Rollout: staging → prod

Backout plan: __
