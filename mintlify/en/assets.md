---
title: Assets
description: Upload and manage files for use in Content Documents.
---

# Manage Assets

Assets are files associated with your account. Listing, retrieving, uploading, or deleting Assets requires a valid Bearer token; each operation is limited to files owned by the authenticated user.

## Upload a file

Upload the file as multipart form data in the `asset[file]` field:

```http
POST https://api.lpdata.io/assets
Authorization: Bearer <access_token>
Content-Type: multipart/form-data

asset[file]: <binary file>
```

A `201 Created` response contains metadata and the public file URL:

```json
{
  "asset": {
    "id": 7,
    "user_id": 42,
    "filename": "hero.webp",
    "content_type": "image/webp",
    "byte_size": 18432,
    "public_url": "<file-url>"
  }
}
```

Use `public_url` as the `value` of a `hosted_file` Editable Field in the Landing Page Content Document.

## List and retrieve Assets

List the files owned by the account:

```http
GET https://api.lpdata.io/assets
Authorization: Bearer <access_token>
```

Retrieve one owned Asset by `id`:

```http
GET https://api.lpdata.io/assets/<id>
Authorization: Bearer <access_token>
```

Responses use the `assets` and `asset` wrappers. An account cannot retrieve another account's Assets; the endpoint returns `404 Not Found`:

```json
{ "error": "Asset not found" }
```

## Delete an Asset

```http
DELETE https://api.lpdata.io/assets/<id>
Authorization: Bearer <access_token>
```

A successful deletion returns `204 No Content`. Requests without a valid token return `401 Unauthorized`.