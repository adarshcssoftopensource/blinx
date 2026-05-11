# PR — SSO (OIDC) & RBAC

## Summary
OIDC with state/nonce/PKCE; secure cookies; /me/claims gating; journaled role changes.

## Proof / Screens / Logs
- [ ] `/me/claims` for new user = **member**
- [ ] Admin grant + **role.granted** event; **Journal entry (no PII)** within ~60s
- [ ] Network trace (sanitized) showing code+token exchange
- [ ] Logout-everywhere evidence (multi-tab/device)
- [ ] Idle + absolute timeout evidence; refresh-token rotation log

## Reviewer Checklist
- [ ] Secure cookies (httpOnly, SameSite); CSRF-safe callbacks
- [ ] Do **not** infer staff from IdP group alone; **admin grant required**
- [ ] Admin/staff routes blocked for non-staff
- [ ] role.* events emitted; Journal entry visible ~60s
- [ ] Graceful error path for IdP outage; no claim leakage
- [ ] Feature flags respected (governance/elections/reputation)
