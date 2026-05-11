# PR — Audit Log UI

## Summary
Finalize filters, details, export, and event coverage.

## Screenshots
- [ ] Index with filters applied
- [ ] Expanded row with **redacted** payload
- [ ] Exported CSV/JSON (filtered) attached

## Reviewer Checklist
- [ ] Filters: time range, type, actor, target, free-text
- [ ] Columns: timestamp (TZ-aware), type, actor, target, summary, event_id
- [ ] Row details: JSON payload **redacted**; copy buttons for IDs
- [ ] Export: CSV/JSON of **filtered** view; export action audited
- [ ] Performance: virtualized list handles 10k+ rows smoothly (p95 <100ms interactions)
- [ ] States: empty/error/offline; retry works; URL query preserves filters
- [ ] Permissions: staff/admin-only; **Community Journal is PII-free** for public view
- [ ] Event coverage: role.*, reputation.*, election.*, steward.*, rule./budget.*, beacon.*

## Evidence Attached
- [ ] CSV
- [ ] JSON
- [ ] Short screen capture (smooth scroll + filter transitions)

## BEAD Copy Review (if applicable)
- [ ] UI/docs frame our role as **contracted software/services**; no “operational subsidy” language
