---
title: Referência da API
description: Endpoints, autenticação e respostas da API do LPData.
---

# Referência da API

Esta referência manual descreve os endpoints usados pelos donos das Aplicações Consumidoras. O LPData não publica uma especificação OpenAPI nesta versão.

A URL base da API é `https://api.lpdata.io`; os exemplos a usam pela variável `LPDATA_API_URL`. Os exemplos detalhados estão nos guias de [Autenticação](/authentication), [Landing Pages](/landing-pages) e [Assets](/assets).

## Autenticação

Endpoints marcados como autenticados exigem `Authorization: Bearer <access_token>`. Login e cadastro não exigem token. `POST /auth/refresh` recebe o refresh token no corpo. `DELETE /auth/sign_out` exige o access token no header e refresh token no corpo.

| Método | Endpoint | Acesso | Sucesso |
| --- | --- | --- | --- |
| `POST` | `/auth/sign_up` | Público | `201 Created`; usuário e tokens |
| `POST` | `/auth/sign_in` | Público | `200 OK`; usuário e tokens |
| `POST` | `/auth/refresh` | Refresh token no JSON | `200 OK`; novo par de tokens |
| `GET` | `/auth/me` | Bearer | `200 OK`; usuário autenticado |
| `DELETE` | `/auth/sign_out` | Bearer e refresh token | `204 No Content` |

## Landing Pages

| Método | Endpoint | Acesso | Sucesso |
| --- | --- | --- | --- |
| `POST` | `/landing_pages` | Bearer | `201 Created`; Landing Page criada |
| `GET` | `/manage/landing_pages` | Bearer | `200 OK`; Landing Pages próprias |
| `GET` | `/manage/landing_pages/:id` | Bearer | `200 OK`; Landing Page própria |
| `PATCH` | `/manage/landing_pages/:id` | Bearer | `200 OK`; Landing Page atualizada |
| `DELETE` | `/manage/landing_pages/:id` | Bearer | `204 No Content` |
| `GET` | `/landing_pages/:public_id` | Público | `200 OK`; Documento de Conteúdo em JSON |

O campo `current_data` contém o Documento de Conteúdo definido pela aplicação. Ao enviar esse campo num `PATCH`, o documento inteiro é substituído. Use o `id` nas rotas autenticadas e o `public_id` na leitura pública. A leitura pública retorna o JSON diretamente, sem envelope.

## Assets

Todas as rotas de Assets exigem Bearer token. Upload usa multipart form data no campo `asset[file]`.

| Método | Endpoint | Acesso | Sucesso |
| --- | --- | --- | --- |
| `GET` | `/assets` | Bearer | `200 OK`; Assets próprios |
| `POST` | `/assets` | Bearer | `201 Created`; Asset enviado |
| `GET` | `/assets/:id` | Bearer | `200 OK`; Asset próprio |
| `DELETE` | `/assets/:id` | Bearer | `204 No Content` |

## Respostas de erro

| Código | Quando ocorre |
| --- | --- |
| `401 Unauthorized` | Token ausente, inválido ou credenciais de login incorretas |
| `404 Not Found` | Identificador inexistente ou recurso que não pertence ao usuário autenticado |
| `422 Unprocessable Content` | Dados de cadastro, Landing Page ou Asset inválidos; o corpo traz `errors` com as mensagens |
| `429 Too Many Requests` | Limite da leitura pública excedido (30 ou 1.000 requisições por minuto por IP, conforme [Hosts permitidos](/landing-pages#hosts-permitidos)); consulte o header `Retry-After` |