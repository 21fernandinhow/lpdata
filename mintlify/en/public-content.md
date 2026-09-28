---
title: Read published content
description: Fetch a Landing Page's Content Document from your consumer application.
---

# Read content in the consumer application

Your consumer application fetches the Content Document by the Landing Page's Public ID (`public_id`). Reads are public: no account or token is required.

## Fetch the Content Document

```http
GET https://api.lpdata.io/landing_pages/<public_id>
```

The `200 OK` response is the Content Document itself, without the `landing_page` wrapper used by management routes:

```json
{
  "hero": {
    "title": { "value": "Launch day", "type": "string" }
  }
}
```

Use the `public_id` returned when you [create the Landing Page](/en/landing-pages#create). The `id` is only for authenticated management routes and does not work here.

Every read returns the current document: after an [update](/en/landing-pages#update), the next read already returns the new content.

## Unknown identifier

An unknown `public_id` returns `404 Not Found`:

```json
{ "error": "Landing page not found" }
```

## Rate limits

Public reads are rate limited per IP each minute:

| Request origin | Limit per minute |
| --- | --- |
| Browser with an `Origin` header matching one of the Landing Page's [allowed hosts](/en/landing-pages#allowed-hosts) | 1,000 |
| Everything else, such as server-side calls | 30 |

When the limit is exceeded, the API returns `429 Too Many Requests` with the `Retry-After: 60` header:

```json
{ "error": "Too many requests" }
```

For browser reads in production, register your frontend hosts in `allowed_hosts`.
