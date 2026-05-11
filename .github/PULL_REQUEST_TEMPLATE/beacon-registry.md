# PR — Beacon Registry

## Summary
CRUD, validation, health status, and bulk import with audit writes.

## Screens / Files
- [ ] Create/Edit forms and validation
- [ ] **Offline badge** flip (now - last_seen > N × heartbeat)
- [ ] Bulk-import dry run + results
- [ ] Import CSV attached (duplicate + malformed row)

## Reviewer Checklist
- [ ] Schema: beacon_id unique; label required; allowed status transitions
- [ ] Health: automatic offline logic applied and filterable
- [ ] Bulk import: dry-run, per-row errors, idempotent re-runs
- [ ] Actions write **beacon.*** to Audit Log; safe Journal note if applicable
- [ ] Permissions: ops/staff can write; members read-only
- [ ] Errors/empty states are clear; retry works
