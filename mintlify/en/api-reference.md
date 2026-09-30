---
title: API reference
description: LPData API endpoints, authentication, and responses.
---

# API reference

This manual reference describes the endpoints used by consumer-application owners. LPData does not publish an OpenAPI specification in this version.

The API base URL is `https://api.lpdata.io`; the endpoints below are relative to it. Detailed examples are available in the [Authentication](/en/authentication), [Landing Pages](/en/landing-pages), and [Assets](/en/assets) guides.

## Authentication

Endpoints marked as authenticated require `Authorization: Bearer <access_token>`. Sign-up and sign-in do not require a token. `POST /auth/refresh` accepts the refresh token in the body. `DELETE /auth/sign_out` requires the access token in the header and the refresh token in the body.

| Method | Endpoint | Access | Success |
| --- | --- | --- | --- |
| `POST` | `/auth/sign_up` | Public | `201 Created`; user and tokens |
| `POST` | `/auth/sign_in` | Public | `200 OK`; user and tokens |
| `POST` | `/auth/refresh` | Refresh token in JSON | `200 OK`; new token pair |
| `GET` | `/auth/me` | Bearer | `200 OK`; authenticated user |
| `DELETE` | `/auth/sign_out` | Bearer and refresh token | `204 No Content` |

## Landing Pages

| Method | Endpoint | Access | Success |
| --- | --- | --- | --- |
| `POST` | `/manage/landing_pages` | Bearer | `201 Created`; created Landing Page |
| `GET` | `/manage/landing_pages` | Bearer | `200 OK`; owned Landing Pages |
| `GET` | `/manage/landing_pages/:id` | Bearer | `200 OK`; owned Landing Page |
| `PATCH` | `/manage/landing_pages/:id` | Bearer | `200 OK`; updated Landing Page |
| `DELETE` | `/manage/landing_pages/:id` | Bearer | `204 No Content` |
| `GET` | `/landing_pages/:public_id` | Public | `200 OK`; Content Document JSON |

`current_data` contains the Content Document defined by the application. When you send this field in a `PATCH`, the entire document is replaced. Use `id` in authenticated routes and `public_id` for public reads. Public reads return the JSON directly, without a wrapper.

## Assets

All Asset routes require a Bearer token. Uploads use multipart form data in the `asset[file]` field.

| Method | Endpoint | Access | Success |
| --- | --- | --- | --- |
| `GET` | `/assets` | Bearer | `200 OK`; owned Assets |
| `POST` | `/assets` | Bearer | `201 Created`; uploaded Asset |
| `GET` | `/assets/:id` | Bearer | `200 OK`; owned Asset |
| `DELETE` | `/assets/:id` | Bearer | `204 No Content` |

## MCP server

| Method | Endpoint | Access | Success |
| --- | --- | --- | --- |
| `POST` | `/mcp` | `X-LPData-Email` and `X-LPData-Password` headers | `200 OK`; Model Context Protocol JSON-RPC response |

The endpoint speaks the MCP Streamable HTTP transport and is meant for an MCP client, not for direct calls. Its tools cover the same operations as this reference; see [MCP server](/en/mcp-server). A missing or invalid credential returns `401 Unauthorized`.

## Error responses

| Code | When it occurs |
| --- | --- |
| `401 Unauthorized` | Missing or invalid token, or incorrect sign-in credentials |
| `404 Not Found` | Unknown identifier or resource not owned by the authenticated user |
| `422 Unprocessable Content` | Invalid sign-up, Landing Page, or Asset data; the body contains `errors` with the messages |
| `429 Too Many Requests` | Public-read rate limit exceeded (30 or 1,000 requests per minute per IP, see [Rate limits](/en/public-content#rate-limits)); check the `Retry-After` header |