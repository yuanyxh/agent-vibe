---
id: knowledge/authn
kind: knowledge
summary: Common patterns for login, sessions, and identity authentication
applies_when: { project.domain: "web-app|backend|mobile" }
triggers: [designing an authentication flow, introducing third-party login, session expiry or theft]
sources: [User design document "Login Authentication Design", OWASP authentication guide]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Login and Identity

## Problem

How to confirm "who you are" and safely preserve that conclusion across requests.

## Patterns

- **Credentials**: use a slow hash with a per-user salt for passwords; when multi-factor is supported, prefer it for high-value operations.
- **Sessions**: choose either server-side sessions or signed tokens. Tokens set an expiry, issuance time, and minimal claims; sensitive operations require re-authentication.
- **Transport**: HTTPS only; cookies use HttpOnly, Secure, and SameSite; explicitly protect against CSRF in cross-site scenarios.
- **Third-party login**: validate the callback state and signature; require a second confirmation before linking an existing account.
- **Revocation**: support signing out one device, signing out all devices, and bulk revocation after credential leakage.

## Trade-offs

| Approach | Pros | Cost |
| --- | --- | --- |
| Server-side session | Immediate revocation | Requires shared storage |
| Signed token | Stateless, easy to scale | Hard to revoke; depends on short expiry |

## Verification

- Wrong passwords do not reveal whether an account exists.
- Expired, tampered, or replayed tokens are rejected.
- Old tokens cannot be reused after sign-out.
- Sensitive operations have second-factor authentication or equivalent protection.

## Counterexamples

- Storing tokens where scripts can read them.
- No rate limiting on the login endpoint.
- Storing passwords with reversible encryption.
- Third-party callbacks that do not validate state.

## Sources

User "Login Authentication Design" and OWASP authentication practices; verify specific implementations against the chosen platform.
