---
id: knowledge/file-service
kind: knowledge
summary: Upload, storage, download, and preview
applies_when: { project.domain: "backend|web-app|mobile" }
triggers: [designing file capabilities, upload failures or unauthorized downloads]
sources: [User design document "File Service Design"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# File Service

## Problem

Receive, store, and distribute files securely, and control who can access them under what conditions.

## Patterns

- **Upload**: limit size, type, and count; validate the real type on the server and do not trust extensions.
- **Storage**: prefer object storage; use random identifiers as file names and keep the original name as metadata.
- **Access**: access private files through short-lived signed URLs or a controlled proxy; check permissions before download.
- **Preview**: choose preview methods for images, PDFs, and Office documents by capability; offer download when preview is unavailable.
- **Cleanup**: have cleanup policies for orphaned files, expired temporary files, and deletion requests.
- **Security**: never execute uploaded content; re-encode images to remove malicious payloads.

## Trade-offs

| Approach | Suitable for | Cost |
| --- | --- | --- |
| Local disk | Single machine, small scale | Hard to scale and back up |
| Object storage | Large scale, CDN | Requires permission and lifecycle configuration |
| Binary data in the database | Small files, strong transactions | Limited capacity and performance |

## Verification

- Illegal types and oversized files are rejected.
- Unauthorized users cannot download by guessing URLs.
- Deleted files can no longer be accessed, and related data is handled in sync.
- Interrupted uploads do not leave partial files.

## Counterexamples

- Validating only the extension.
- Storing private files in a public bucket.
- Using the original file name as the storage path.
- Preview services executing uploaded content.

## Sources

User "File Service Design".
