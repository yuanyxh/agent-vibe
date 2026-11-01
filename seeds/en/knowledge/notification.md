---
id: knowledge/notification
kind: knowledge
summary: Reach design for in-app messages, email, SMS, and push
applies_when: { project.domain: "web-app|backend|mobile" }
triggers: [designing notifications, users report missing messages, introducing a new channel]
sources: [User design document "Notification Design"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Notifications

## Problem

Deliver the right information to the right people at the right time through the right channels, while avoiding harassment and duplication.

## Patterns

- **Channels**: in-app messages, email, SMS, and push differ in delivery rate and cost; choose by urgency and user preference.
- **Templates**: decouple content from channels; refuse to send rather than sending half-rendered content when variables are missing.
- **Deduplication**: send each event only once; retries must not reach users again.
- **Preferences**: users can turn off non-critical notifications; critical notifications explain why they cannot be turned off.
- **Unsubscribe and compliance**: marketing messages offer unsubscribe; record the source and time of consent.
- **Failure handling**: degrade to a backup channel when a channel fails; record failure reasons and retry counts.

## Trade-offs

| Channel | Pros | Cost |
| --- | --- | --- |
| In-app message | Free, controllable | Requires users to check actively |
| Email | Formal, archivable | Unstable delivery rate and latency |
| SMS/push | Timely | Cost and interruption |

## Verification

- The same event does not reach users twice.
- Sending is blocked when template variables are missing.
- Users no longer receive the category after turning it off.
- Channel failures are recorded and degraded.

## Counterexamples

- Sending notifications inside a business transaction, so failures roll back business operations.
- No deduplication key, so retries cause a flood.
- Marketing and transactional notifications sharing one switch.
- Not recording send results, making troubleshooting impossible.

## Sources

User "Notification Design".
