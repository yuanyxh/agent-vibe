---
id: knowledge/timezone-i18n
kind: knowledge
summary: Time zones, dates, languages, and localized formats
applies_when: { project.domain: "web-app|mobile|backend" }
triggers: [entering a new region, date misalignment, adding a language]
sources: [User design documents "Time Zone Unification" and "Internationalization Language Design"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Time Zones and Internationalization

## Problem

Ensure the same moment is understood and displayed correctly in different regions, and that copy and formats follow local conventions.

## Patterns

- **Storage**: store times in UTC or as timestamps with offsets; when also keeping a business time zone field, document its meaning.
- **Display**: convert by user or tenant time zone; compute date boundaries (today, this month) in the business time zone.
- **Copy**: externalize into language packs; never concatenate sentences; fall back when variables are missing rather than showing placeholders.
- **Formats**: format dates, numbers, currencies, and name order by region.
- **Fallback**: fall back to the default language for missing translations and record missing entries.
- **Direction**: when RTL is needed, adjust layout, icons, and alignment together.

## Trade-offs

| Time zone source | Suitable for | Risk |
| --- | --- | --- |
| User setting | Individuals across regions | Default when the user has not set it |
| Tenant setting | Enterprise customers | Personal preferences are overridden |
| Device time zone | Mobile | Travel and simulated time zones |

## Verification

- "Today" boundary cases across time zones.
- Times are correct around daylight saving transitions.
- Missing translations fall back and can be discovered.
- Currency and number formats match the region.

## Counterexamples

- Generating business dates from the server's local time.
- Concatenating strings to translate sentences.
- Hardcoding time zone offsets.
- Testing only a single language and time zone.

## Sources

User "Time Zone Unification" and "Internationalization Language Design".
