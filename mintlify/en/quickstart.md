---
title: Quickstart
description: Connect your application to the LPData API and publish Landing Page content.
---

# Connect your application to LPData

The workflow has two parts: you manage content with an authenticated account, and your consumer application fetches published content using the Landing Page's Public ID.

## Set the API URL

Use the base URL of your LPData deployment, without a trailing slash:

```bash
export LPDATA_API_URL="https://<your-api-url>"
```

Replace the value with the API address provided for your deployment.

## Sign in and get a token

Create an account with `POST /auth/sign_up` or sign in with `POST /auth/sign_in`. The response contains an access token and a refresh token. See [Authentication](/en/authentication) for the full token lifecycle.

```bash
curl --request POST "$LPDATA_API_URL/auth/sign_in" \
  --header 'Content-Type: application/json' \
  --data '{"user":{"email":"owner@example.com","password":"<your-password>"}}'
```

Use the returned `access_token` for authenticated operations:

```bash
export LPDATA_ACCESS_TOKEN="<access_token>"
```

Do not put credentials or tokens in public source code or share them. Management operations can only change resources owned by the authenticated user.

## Create a Landing Page

Send the Content Document expected by your application. LPData preserves its JSON structure; your application defines how to present that content.

```bash
curl --request POST "$LPDATA_API_URL/landing_pages" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{"landing_page":{"name":"Launch page","current_data":{"hero":{"title":{"value":"Launch day","type":"string"}}}}}'
```

The response includes an `id` for management and a stable `public_id` for reads by the consumer application. Use `public_id` in the public URL; the two identifiers are not interchangeable.

## Read published content

The consumer application reads the Content Document without authentication. The response is the document JSON itself, without a wrapping `landing_page` object:

```bash
curl "$LPDATA_API_URL/landing_pages/<public_id>"
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