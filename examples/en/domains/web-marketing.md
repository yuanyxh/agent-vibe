---
id: example/domain/web-marketing
kind: domain
summary: Public-facing content sites, official websites, and marketing pages
applies_when: { project.domain: web-marketing }
core_concerns:
  - Crawlability and indexing by search engines
  - First paint and Core Web Vitals
  - Structured data and share cards
  - Multilingual and canonical URLs
  - Content update and preview workflows
  - Privacy, cookie, and analytics compliance
questions:
  - Target search engines and regions
  - Whether multilingual and localization support is required
  - Who maintains content and how it is published
  - Whether analytics or advertising is integrated
research:
  - Current crawling and structured data specifications of target search engines
  - Measurement methods and thresholds for Core Web Vitals
  - Privacy requirements of analytics tools
generates:
  - type: config
    examples: [crawl rules, sitemaps, canonical and share metadata, caching strategy]
  - type: doc
    examples: [content publishing workflow, privacy and cookie notices]
verify:
  - Main pages are crawlable and have unique titles and descriptions
  - Structured data validation passes
  - Core Web Vitals meet the declared thresholds
pitfalls:
  - Key content rendered only on the client and not crawlable
  - Duplicate content due to missing canonicalization across languages
  - Analytics scripts blocking first paint
---

# Official Websites and Content Sites

## Goal

Let target users and search engines correctly understand, quickly load, and share site content.

## Generation Principles

- Crawlability takes precedence over animation; key content must have a server-readable form.
- Generate titles, descriptions, canonical addresses, and share cards per page; do not copy templates.
- Drive image, font, and script loading strategies with real metrics.
- Analytics, advertising, and cookies must comply with the target region's privacy requirements.

## Verification

Check with search engine crawling tools and structured data validators, then measure Core Web Vitals on real devices.
