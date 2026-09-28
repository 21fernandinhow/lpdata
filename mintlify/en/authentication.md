---
title: Authentication
description: Create an account, authenticate requests, and keep tokens valid.
---

# Authenticate management operations

Creating and managing Landing Pages and Assets requires an account. Signing in returns an access token and a refresh token. Send the access token in the `Authorization` header as `Bearer <token>`.

Every endpoint starts from `https://api.lpdata.io`. Do not store tokens in public source code or share them.

## Where to call authenticated routes

Call the authentication, Landing Page, and Asset routes from a server: your backend, scripts, other APIs, or tools such as curl. From the browser, these routes only accept calls from the LPData dashboard; the browser blocks the same call made by JavaScript on other sites.

[Public content reads](/en/public-content) are the exception: they accept browser calls from any origin.

## Create an account

`POST /auth/sign_up` accepts account details inside `user`:

```http
POST https://api.lpdata.io/auth/sign_up
Content-Type: application/json

{
  "user": {
    "email": "owner@example.com",
    "password": "<your-password>",
    "password_confirmation": "<your-password>"
  }
}
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

Invalid credentials return `401 Unauthorized`:

```json
{ "errors": ["Invalid email or password"] }
```

## Get the authenticated account

`GET /auth/me` returns the identity associated with the access token:

```http
GET https://api.lpdata.io/auth/me
Authorization: Bearer <access_token>
```

```json
{ "user": { "id": 42, "email": "owner@example.com" } }
```

Without a valid token, the endpoint returns `401 Unauthorized`.

## Refresh tokens

Send the refresh token in the body of `POST /auth/refresh`. The response contains a new pair of tokens; the previous refresh token is invalidated and must not be reused.

```http
POST https://api.lpdata.io/auth/refresh
Content-Type: application/json

{
  "refresh_token": "<refresh_token>"
}
```

An invalid or expired token returns `401 Unauthorized` with `Invalid or expired refresh token`.

## Sign out

`DELETE /auth/sign_out` revokes the access token in the header and the refresh token in the body. On success, it returns `204 No Content`.

```http
DELETE https://api.lpdata.io/auth/sign_out
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "refresh_token": "<refresh_token>"
}
```

Use the new token pair after a refresh and discard revoked tokens after signing out.