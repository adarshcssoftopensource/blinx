# QA Evidence — Compact Receipts

## Journal (public) + Audit Log (staff)
- [ ] Screenshot: filtered Audit Log + expanded redacted row; CSV + JSON exports; short scroll + filter capture
(ref: DoD & Journal model)

## BEAD (discrete)
- [ ] Screenshot: member (no BEAD DOM)
- [ ] Screenshot: staff in BEAD context (banner + tools)
- [ ] PR copy check highlighting “software/services” framing
(ref: BEAD brief)

## SSO (OIDC) & RBACs
- [ ] `/me/claims` — new user = member; staff via admin grant
- [ ] Screenshot: Journal role entry appears ≤ ~60s (no PII)
- [ ] Sanitized OIDC network trace; logout-everywhere; token rotation
(ref: Governance & Implementation plan)

## Responsive & A11Y
- [ ] 360 / 768 / 1024 / 1440 screenshots
- [ ] Lighthouse Mobile (≥90)
- [ ] Keyboard nav + focus rings capture
ss
## Beacon Registry
- [ ] Offline badge flip (heartbeat rule)
- [ ] CSV import dry-run (duplicate + malformed); idempotent re-run
- [ ] Screenshots: create/edit/delete + validationss
