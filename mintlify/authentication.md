---
title: Autenticação
description: Crie uma conta, autentique requisições e mantenha tokens válidos.
---

# Autentique as operações de gerenciamento

Criar e gerenciar Landing Pages e Assets exige uma conta. O login retorna um token de acesso e um token de atualização. Envie o token de acesso no header `Authorization` como `Bearer <token>`.

Defina a URL da API e os tokens recebidos sem gravá-los no repositório:

```bash
export LPDATA_API_URL="https://api.lpdata.io"
export LPDATA_ACCESS_TOKEN="<access_token>"
export LPDATA_REFRESH_TOKEN="<refresh_token>"
```

## Criar uma conta

`POST /auth/sign_up` recebe os dados da conta dentro de `user`:

```bash
curl --request POST "$LPDATA_API_URL/auth/sign_up" \
  --header 'Content-Type: application/json' \
  --data '{"user":{"email":"owner@example.com","password":"<sua-senha>","password_confirmation":"<sua-senha>"}}'
```

Uma conta criada retorna `201 Created` e os tokens:

```json
{
  "user": { "id": 42, "email": "owner@example.com" },
  "access_token": "<access_token>",
  "refresh_token": "<refresh_token>"
}
```

## Entrar

`POST /auth/sign_in` usa `user.email` e `user.password`:

```bash
curl --request POST "$LPDATA_API_URL/auth/sign_in" \
  --header 'Content-Type: application/json' \
  --data '{"user":{"email":"owner@example.com","password":"<sua-senha>"}}'
```

Credenciais inválidas retornam `401 Unauthorized`:

```json
{ "errors": ["Invalid email or password"] }
```

## Consultar a conta autenticada

`GET /auth/me` retorna a identidade associada ao token de acesso:

```bash
curl "$LPDATA_API_URL/auth/me" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN"
```

```json
{ "user": { "id": 42, "email": "owner@example.com" } }
```

Sem um token válido, o endpoint retorna `401 Unauthorized`.

## Atualizar tokens

O token de atualização é enviado no corpo de `POST /auth/refresh`. A resposta contém um novo par de tokens; o token de atualização anterior é invalidado e não deve ser reutilizado.

```bash
curl --request POST "$LPDATA_API_URL/auth/refresh" \
  --header 'Content-Type: application/json' \
  --data "{\"refresh_token\":\"$LPDATA_REFRESH_TOKEN\"}"
```

Um token inválido ou expirado retorna `401 Unauthorized` com `Invalid or expired refresh token`.

## Sair

`DELETE /auth/sign_out` revoga o token de acesso do header e o token de atualização enviado no corpo. Em caso de sucesso, retorna `204 No Content`.

```bash
curl --request DELETE "$LPDATA_API_URL/auth/sign_out" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN" \
  --header 'Content-Type: application/json' \
  --data "{\"refresh_token\":\"$LPDATA_REFRESH_TOKEN\"}"
```

Use a nova dupla de tokens após um refresh e descarte os tokens revogados após sair.