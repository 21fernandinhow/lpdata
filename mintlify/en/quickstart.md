---
title: Quickstart
description: Connect your application to the LPData API and publish Landing Page content.
---

# Connect your application to LPData

The workflow has two parts: you manage content with an authenticated account, and your consumer application fetches published content using the Landing Page's Public ID.

## API URL

The LPData API is available at `https://api.lpdata.io`. Every endpoint in this documentation starts from this base URL.

## Sign in and get a token

Create an account with `POST /auth/sign_up` or sign in with `POST /auth/sign_in`. The response contains an access token and a refresh token. See [Authentication](/en/authentication) for the full token lifecycle.

```http
POST https://api.lpdata.io/auth/sign_in
Content-Type: application/json

{
  "user": {
    "email": "owner@example.com",
    "password": "<your-password>"
  }
}
```

Send the returned `access_token` in the `Authorization: Bearer <access_token>` header of authenticated operations.

Do not put credentials or tokens in public source code or share them. Management operations can only change resources owned by the authenticated user.

## Create a Landing Page

Send the Content Document expected by your application. LPData preserves its JSON structure; your application defines how to present that content.

```http
POST https://api.lpdata.io/manage/landing_pages
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

The response includes an `id` for management and a stable `public_id` for reads by the consumer application. Use `public_id` in the public URL; the two identifiers are not interchangeable.

## Read published content

The consumer application reads the Content Document without authentication. The response is the document JSON itself, without a wrapping `landing_page` object:

```http
GET https://api.lpdata.io/landing_pages/<public_id>
```

A successful read returns, for example:

```json
{
  "hero": {
    "title": {
      "value": "Launch day",
      "type": "string"
    }
  }
}
```

See [Landing Pages](/en/landing-pages) to manage and read documents, and the [API reference](/en/api-reference) for the endpoint list.