---
title: Landing Pages
description: Create, update, and publish a Landing Page Content Document.
---

# Manage your Landing Pages

Management operations require the owner user's Bearer token. The `id` identifies the record in management routes; the stable `public_id` is used by the consumer application to read content.

## Create

`POST /landing_pages` accepts a name and the Content Document defined by your application. `allowed_hosts` is optional.

```bash
curl --request POST "$LPDATA_API_URL/landing_pages" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{"landing_page":{"name":"Launch page","current_data":{"hero":{"title":{"value":"Launch day","type":"string"}}}}}'
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
    "allowed_hosts": []
  }
}
```

Keep `public_id` for public reads and use `id` only for authenticated management operations.

## List and retrieve

List only the Landing Pages owned by the authenticated account:

```bash
curl "$LPDATA_API_URL/manage/landing_pages" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN"
```

Retrieve one owned Landing Page by `id`:

```bash
curl "$LPDATA_API_URL/manage/landing_pages/<id>" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN"
```

Responses are wrapped in `landing_pages` or `landing_page`, respectively. An account cannot retrieve another account's records; the resource returns `404 Not Found`.

## Update

`PATCH /manage/landing_pages/:id` accepts one or more attributes. When you send `current_data`, it replaces the entire Content Document; LPData does not merge individual fields.

```bash
curl --request PATCH "$LPDATA_API_URL/manage/landing_pages/<id>" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{"landing_page":{"name":"Summer launch","current_data":{"hero":{"title":{"value":"Summer is here","type":"string"}}}}}'
```

A successful update returns `200 OK` and the updated `landing_page` object.

## Delete

`DELETE /manage/landing_pages/:id` removes a Landing Page owned by the authenticated user and returns `204 No Content`.

## Read content in the consumer application

`GET /landing_pages/:public_id` is public and returns only the Content Document as JSON, without authentication and without the `landing_page` wrapper.

```bash
curl "$LPDATA_API_URL/landing_pages/<public_id>"
```

An unknown identifier returns `404 Not Found`:

```json
{ "error": "Landing page not found" }
```

The document can have the JSON structure your application needs. For editable dashboard fields, the project contract uses objects with `value` and `type`; interpretation and presentation remain the responsibility of your application.