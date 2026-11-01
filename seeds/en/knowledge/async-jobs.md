---
id: knowledge/async-jobs
kind: knowledge
summary: Background jobs, queues, retries, and idempotency
applies_when: { project.domain: "backend|web-app" }
triggers: [introducing long-running jobs, batch processing, need for retries or peak shaving]
sources: [User design document "Async Job Queue Design"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Async Jobs and Queues

## Problem

Move time-consuming or failure-prone work out of the request path while ensuring jobs eventually complete and do not produce duplicate side effects.

## Patterns

- **Job model**: job ID, type, payload, status, attempt count, visible result.
- **Idempotency**: deduplicate by business key or job ID; repeated consumption yields the same result.
- **Retries**: only for retryable errors; exponential backoff with a cap; exceeding the cap moves the job to the dead-letter queue and raises an alert.
- **Ordering**: partition by business key when ordering is required; allow concurrency when it is not.
- **Visibility**: users can see queued, running, succeeded, failed, and retrying states.
- **Cancellation**: long jobs support cancellation and cleanup to avoid zombie jobs.

## Trade-offs

| Approach | Suitable for | Cost |
| --- | --- | --- |
| In-process queue | Single machine, lightweight | Lost on restart |
| Persistent queue | High reliability requirements | Operational complexity |
| Scheduled scan | Simple compensation | Delay and duplicate scans |

## Verification

- Duplicate delivery does not produce duplicate side effects.
- Retryable errors eventually succeed; non-retryable errors go to the dead-letter queue.
- Jobs are not lost after a process restart, or can be recovered.
- Job status matches the status visible to users.

## Counterexamples

- Unlimited retries with no alerting.
- Performing non-rollbackable external side effects during job execution.
- No job status, so users cannot tell the result.
- Queue backlog with no monitoring.

## Sources

User document "Async Job Queue Design"; read together with `consistency.md`.
