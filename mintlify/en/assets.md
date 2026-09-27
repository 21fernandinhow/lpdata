---
title: Assets
description: Upload and manage files for use in Content Documents.
---

# Manage Assets

Assets are files associated with your account. Listing, retrieving, uploading, or deleting Assets requires a valid Bearer token; each operation is limited to files owned by the authenticated user.

## Upload a file

Upload the file as multipart form data in the `asset[file]` field:

```bash
curl --request POST "$LPDATA_API_URL/assets" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN" \
  --form 'asset[file]=@./hero.webp'
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

```bash
curl "$LPDATA_API_URL/assets" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN"
```

Retrieve one owned Asset by `id`:

```bash
curl "$LPDATA_API_URL/assets/<id>" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN"
```

Responses use the `assets` and `asset` wrappers. An account cannot retrieve another account's Assets; the endpoint returns `404 Not Found`:

```json
{ "error": "Asset not found" }
```

## Delete an Asset

```bash
curl --request DELETE "$LPDATA_API_URL/assets/<id>" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN"
```

A successful deletion returns `204 No Content`. Requests without a valid token return `401 Unauthorized`.