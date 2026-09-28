---
title: Autenticação
description: Crie uma conta, autentique requisições e mantenha tokens válidos.
---

# Autentique as operações de gerenciamento

Criar e gerenciar Landing Pages e Assets exige uma conta. O login retorna um token de acesso e um token de atualização. Envie o token de acesso no header `Authorization` como `Bearer <token>`.

Todos os endpoints partem de `https://api.lpdata.io`. Não grave tokens em código-fonte público nem os compartilhe.

## Onde chamar as rotas autenticadas

Chame as rotas de autenticação, de Landing Pages e de Assets a partir de um servidor: seu backend, scripts, outras APIs ou ferramentas como curl. Pelo navegador, essas rotas só aceitam chamadas do dashboard do LPData; o navegador bloqueia a mesma chamada feita pelo JavaScript de outros sites.

A [leitura pública do conteúdo](/public-content) é a exceção: ela aceita chamadas do navegador vindas de qualquer origem.

## Criar uma conta

`POST /auth/sign_up` recebe os dados da conta dentro de `user`:

```http
POST https://api.lpdata.io/auth/sign_up
Content-Type: application/json

{
  "user": {
    "email": "owner@example.com",
    "password": "<sua-senha>",
    "password_confirmation": "<sua-senha>"
  }
}
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

```http
POST https://api.lpdata.io/auth/sign_in
Content-Type: application/json

{
  "user": {
    "email": "owner@example.com",
    "password": "<sua-senha>"
  }
}
```

Credenciais inválidas retornam `401 Unauthorized`:

```json
{ "errors": ["Invalid email or password"] }
```

## Consultar a conta autenticada

`GET /auth/me` retorna a identidade associada ao token de acesso:

```http
GET https://api.lpdata.io/auth/me
Authorization: Bearer <access_token>
```

```json
{ "user": { "id": 42, "email": "owner@example.com" } }
```

Sem um token válido, o endpoint retorna `401 Unauthorized`.

## Atualizar tokens

O token de atualização é enviado no corpo de `POST /auth/refresh`. A resposta contém um novo par de tokens; o token de atualização anterior é invalidado e não deve ser reutilizado.

```http
POST https://api.lpdata.io/auth/refresh
Content-Type: application/json

{
  "refresh_token": "<refresh_token>"
}
```

Um token inválido ou expirado retorna `401 Unauthorized` com `Invalid or expired refresh token`.

## Sair

`DELETE /auth/sign_out` revoga o token de acesso do header e o token de atualização enviado no corpo. Em caso de sucesso, retorna `204 No Content`.

```http
DELETE https://api.lpdata.io/auth/sign_out
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "refresh_token": "<refresh_token>"
}
```

Use a nova dupla de tokens após um refresh e descarte os tokens revogados após sair.