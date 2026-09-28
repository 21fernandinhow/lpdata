---
title: Landing Pages
description: Create, update, and publish a Landing Page Content Document.
---

# Manage your Landing Pages

Management operations require the owner user's Bearer token. The `id` identifies the record in management routes; the stable `public_id` is used by the consumer application to read content.

## Create

`POST /landing_pages` accepts a name and the Content Document defined by your application. `allowed_hosts` is optional.

```http
POST https://api.lpdata.io/landing_pages
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "landing_page": {
    "name": "Launch page",
    "current_data": {
      "hero": {
        "title": {
          "value": "Launch day",
          "type": "string"
        }
      }
    }
  }
}
```

The endpoint returns `201 Created` with the created record:

```json
{
  "landing_page": {
    "id": 12,
    "public_id": 3407,
    "name": "Launch page",
    "current_data": {
      "hero": { "title": { "value": "Launch day", "type": "string" } }
    },
    "allowed_hosts": [],
    "user_id": 42,
    "created_at": "2026-09-27T12:00:00.000Z",
    "updated_at": "2026-09-27T12:00:00.000Z"
  }
}
```

Keep `public_id` for public reads and use `id` only for authenticated management operations.

## Content Document

`current_data` is required and accepts freely nested objects and arrays, including empty ones. Every primitive value, however, must live inside an Editable Field: an object with both `value` and `type` keys.

| `type` | Expected `value` |
| --- | --- |
| `string`, `text`, `url` | String |
| `hosted_file`, `external_file` | String with the file URL |
| `number` | Number |
| `boolean` | `true` or `false` |

```json
{
  "hero": {
    "title": { "value": "Launch day", "type": "string" },
    "image": { "value": "https://cdn.example.com/hero.webp", "type": "hosted_file" }
  },
  "features": [
    { "label": { "value": "Fast", "type": "string" } }
  ]
}
```

A document outside this contract returns `422 Unprocessable Content`, pointing to the offending path:

```json
{ "errors": ["Current data editable field value does not match its type at $.hero.title"] }
```

Other possible messages: `contains a value outside an editable field`, `editable fields must contain both value and type`, and `contains an unsupported editable field type`. LPData does not interpret how fields are presented; that remains your application's responsibility.

## Allowed hosts

`allowed_hosts` lists the frontend hosts that read the Landing Page from the browser, such as `["example.com", "localhost:3000"]`. Values are lowercased. A host without a port also matches its subdomains; a host with a port requires an exact host and port match.

Public reads are rate limited per IP each minute: 1,000 requests when the `Origin` header matches an allowed host and 30 otherwise, such as server-side calls. When the limit is exceeded, the API returns `429 Too Many Requests` with `Retry-After: 60`.

## List and retrieve

List only the Landing Pages owned by the authenticated account:

```http
GET https://api.lpdata.io/manage/landing_pages
Authorization: Bearer <access_token>
```

Retrieve one owned Landing Page by `id`:

```http
GET https://api.lpdata.io/manage/landing_pages/<id>
Authorization: Bearer <access_token>
```

Responses are wrapped in `landing_pages` or `landing_page`, respectively. An account cannot retrieve another account's records; the resource returns `404 Not Found`.

## Update

`PATCH /manage/landing_pages/:id` accepts one or more attributes. When you send `current_data`, it replaces the entire Content Document; LPData does not merge individual fields.

```http
PATCH https://api.lpdata.io/manage/landing_pages/<id>
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "landing_page": {
    "name": "Summer launch",
    "current_data": {
      "hero": {
        "title": {
          "value": "Summer is here",
          "type": "string"
        }
      }
    }
  }
}
```

A successful update returns `200 OK` and the updated `landing_page` object.

## Delete

`DELETE /manage/landing_pages/:id` removes a Landing Page owned by the authenticated user and returns `204 No Content`.

## Read content in the consumer application

`GET /landing_pages/:public_id` is public and returns only the Content Document as JSON, without authentication and without the `landing_page` wrapper.

```http
GET https://api.lpdata.io/landing_pages/<public_id>
```

An unknown identifier returns `404 Not Found`:

```json
{ "error": "Landing page not found" }
```

Reads above the limit return `429 Too Many Requests`; see [Allowed hosts](#allowed-hosts).
