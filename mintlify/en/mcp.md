---
title: MCP server
description: Connect an agent to LPData and manage content by talking to it.
---

# Manage content through an agent

LPData exposes its management operations as an [MCP](https://modelcontextprotocol.io) server hosted alongside the API, at `https://api.lpdata.io/mcp`. An agent connected to it creates landing pages, writes the Content Document, uploads files and checks the public read without you assembling HTTP calls by hand.

There is nothing to install: you add a URL and your credential to your MCP client.

This page is for the **developer** building the landing page. The tools are the same operations described in [Landing Pages](/en/landing-pages) and [Assets](/en/assets), one tool per operation.

## Put your credential in the environment

The server identifies you by the same account you [sign in](/en/authentication) with. Set these variables in the shell you start your MCP client from:

```sh
export LPDATA_EMAIL="owner@example.com"
export LPDATA_PASSWORD="<your-password>"
export LPDATA_URL="https://api.lpdata.io"
```

`LPDATA_URL` is used by the file upload command and falls back to `https://api.lpdata.io` when unset. All three also serve the `curl` the agent runs to upload an Asset, so set them even if your client only needs the first two.

## Add the server to your MCP client

Point the client at the server URL and send your credential in two headers, `X-LPData-Email` and `X-LPData-Password`. The configuration references the environment variables and holds no secret, so it can be committed:

```json
{
  "mcpServers": {
    "lpdata": {
      "type": "http",
      "url": "https://api.lpdata.io/mcp",
      "headers": {
        "X-LPData-Email": "${LPDATA_EMAIL}",
        "X-LPData-Password": "${LPDATA_PASSWORD}"
      }
    }
  }
}
```

The credential says **who** is calling: each person uses their own account and sees only their own Landing Pages and Assets. There is no login, logout or refresh tool, and no token is ever handed to the agent.

Ask the agent to call `check_connection`. It answers with the account `id` and email, which confirms the headers reached the server.

## Tools

| Tool | What it does |
| --- | --- |
| `check_connection` | Returns the authenticated account. Carries the Content Document contract in its description |
| `create_landing_page` | Creates a Landing Page with `name`, `current_data` and `allowed_hosts` |
| `list_landing_pages` | Lists the account Landing Pages, without `current_data` |
| `get_landing_page` | Returns one of your Landing Pages, `current_data` included |
| `update_landing_page` | Updates `name`, `current_data` or `allowed_hosts`; whatever you omit is left alone |
| `delete_landing_page` | Removes a Landing Page |
| `get_public_content` | Reads the Content Document by `public_id`, raw, as the Consuming Application receives it |
| `list_assets` | Lists the account Assets with their `public_url` |
| `get_asset_upload_command` | Builds the shell command that uploads a file |
| `delete_asset` | Removes an Asset |

Use `id` with the management tools and `public_id` with `get_public_content`; the two identifiers are not interchangeable.

## The Content Document contract

The agent receives this contract in the `check_connection` description, so it does not need this page to write a valid document. It is here for you to check what the agent produced.

- `current_data` is a non-null JSON value; objects and arrays nest freely and may be empty.
- A primitive value may never sit loose inside an object or an array. Every leaf is an Editable Field.
- An Editable Field is an object carrying **both** `value` and `type`. Carrying only one of them is invalid.
- `string`, `text`, `url`, `hosted_file` and `external_file` take a string; `number` takes a number; `boolean` takes `true` or `false`.
- `hosted_file` and `external_file` hold the URL itself in `value`.
- Keys beyond `value` and `type` are accepted; this is how `dashboard_config` travels.

```json
{
  "hero": {
    "title": { "value": "Welcome", "type": "string" },
    "cta_url": { "value": "https://example.com", "type": "url" }
  },
  "features": [
    { "name": { "value": "Fast", "type": "string" } }
  ]
}
```

Sending `{ "features": ["Fast"] }` is refused, because `"Fast"` is a bare string inside an array:

```text
Current data contains a value outside an editable field at $.features[0]
```

The MCP server neither validates nor fixes the document: the API is what refuses it, and the agent receives the whole message, field path included.

## Upload a file

The server is remote and cannot read your disk, so it does not transfer bytes. `get_asset_upload_command` returns the command for the agent to run in its own shell:

```sh
FILE='/path/to/hero.webp'

TOKEN=$(curl -s -X POST "${LPDATA_URL:-https://api.lpdata.io}/auth/sign_in" \
  -H 'Content-Type: application/json' \
  -d "{\"user\":{\"email\":\"$LPDATA_EMAIL\",\"password\":\"$LPDATA_PASSWORD\"}}" | jq -r .access_token)

curl -s -X POST "${LPDATA_URL:-https://api.lpdata.io}/assets" \
  -H "Authorization: Bearer $TOKEN" -F "asset[file]=@$FILE"
```

The shell is what expands `$LPDATA_EMAIL`, `$LPDATA_PASSWORD` and `$TOKEN`: the agent writes the command but never sees your password or the token. The command needs [`jq`](https://jqlang.github.io/jq/) installed and must be run as it is.

The second `curl` prints the Asset `public_url`. Use that URL as the `value` of a `hosted_file` Editable Field.

## A complete flow

1. `check_connection` confirms the account.
2. `create_landing_page` creates the page with its initial Content Document and returns the `id` and the `public_id`.
3. `get_asset_upload_command` builds the command; the agent runs it and gets the image `public_url`.
4. `update_landing_page` writes the document with that `public_url` in a `hosted_file` field.
5. `get_public_content` reads by `public_id` and shows exactly what the Consuming Application will receive.

Remember that `current_data` is always replaced whole: to change one field, the agent sends the complete document with that field changed. LPData keeps no history of the document.

## Errors

The server passes the API errors through without reformulating them.

| Situation | What the agent receives |
| --- | --- |
| Missing or invalid credential | `401 Unauthorized` telling it to check `X-LPData-Email` and `X-LPData-Password` |
| Document outside the contract | The list of validation messages, each with the field path |
| Unknown `id` or `public_id`, or a resource owned by another account | `Landing page not found` or `Asset not found` |
| Public read limit exceeded | `Too many requests`, with the wait time; see [Rate limits](/en/public-content#rate-limits) |
