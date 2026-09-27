---
title: Authentication
description: Create an account, authenticate requests, and keep tokens valid.
---

# Authenticate management operations

Creating and managing Landing Pages and Assets requires an account. Signing in returns an access token and a refresh token. Send the access token in the `Authorization` header as `Bearer <token>`.

Set your deployment URL and token values without storing them in the repository:

```bash
export LPDATA_API_URL="https://<your-api-url>"
export LPDATA_ACCESS_TOKEN="<access_token>"
export LPDATA_REFRESH_TOKEN="<refresh_token>"
```

## Create an account

`POST /auth/sign_up` accepts account details inside `user`:

```bash
curl --request POST "$LPDATA_API_URL/auth/sign_up" \
  --header 'Content-Type: application/json' \
  --data '{"user":{"email":"owner@example.com","password":"<your-password>","password_confirmation":"<your-password>"}}'
```

A successful signup returns `201 Created` and the tokens:

```json
{
  "user": { "id": 42, "email": "owner@example.com" },
  "access_token": "<access_token>",
  "refresh_token": "<refresh_token>"
}
```

## Sign in

`POST /auth/sign_in` uses `user.email` and `user.password`:

```bash
curl --request POST "$LPDATA_API_URL/auth/sign_in" \
  --header 'Content-Type: application/json' \
  --data '{"user":{"email":"owner@example.com","password":"<your-password>"}}'
```

Invalid credentials return `401 Unauthorized`:

```json
{ "errors": ["Invalid email or password"] }
```

## Get the authenticated account

`GET /auth/me` returns the identity associated with the access token:

```bash
curl "$LPDATA_API_URL/auth/me" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN"
```

```json
{ "user": { "id": 42, "email": "owner@example.com" } }
```

Without a valid token, the endpoint returns `401 Unauthorized`.

## Refresh tokens

Send the refresh token in the body of `POST /auth/refresh`. The response contains a new pair of tokens; the previous refresh token is invalidated and must not be reused.

```bash
curl --request POST "$LPDATA_API_URL/auth/refresh" \
  --header 'Content-Type: application/json' \
  --data "{\"refresh_token\":\"$LPDATA_REFRESH_TOKEN\"}"
```

An invalid or expired token returns `401 Unauthorized` with `Invalid or expired refresh token`.

## Sign out

`DELETE /auth/sign_out` revokes the access token in the header and the refresh token in the body. On success, it returns `204 No Content`.

```bash
curl --request DELETE "$LPDATA_API_URL/auth/sign_out" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN" \
  --header 'Content-Type: application/json' \
  --data "{\"refresh_token\":\"$LPDATA_REFRESH_TOKEN\"}"
```

Use the new token pair after a refresh and discard revoked tokens after signing out.