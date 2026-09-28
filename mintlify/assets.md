---
title: Assets
description: Envie e gerencie arquivos para usar nos documentos de conteúdo.
---

# Gerencie Assets

Os Assets são arquivos associados à sua conta. Listar, consultar, enviar ou excluir Assets exige um token Bearer válido; cada operação é limitada aos arquivos do usuário autenticado.

## Enviar um arquivo

Envie o arquivo como multipart form data no campo `asset[file]`:

```http
POST https://api.lpdata.io/assets
Authorization: Bearer <access_token>
Content-Type: multipart/form-data

asset[file]: <arquivo binário>
```

Uma resposta `201 Created` contém metadados e a URL pública do arquivo:

```json
{
  "asset": {
    "id": 7,
    "user_id": 42,
    "filename": "hero.webp",
    "content_type": "image/webp",
    "byte_size": 18432,
    "public_url": "<url-do-arquivo>"
  }
}
```

Use `public_url` como `value` de um Campo Editável do tipo `hosted_file` no Documento de Conteúdo da Landing Page.

## Listar e consultar Assets

Liste os arquivos da conta:

```http
GET https://api.lpdata.io/assets
Authorization: Bearer <access_token>
```

Consulte um Asset próprio por `id`:

```http
GET https://api.lpdata.io/assets/<id>
Authorization: Bearer <access_token>
```

As respostas usam os envelopes `assets` e `asset`. Uma conta não pode consultar Assets de outra; o endpoint retorna `404 Not Found`:

```json
{ "error": "Asset not found" }
```

## Excluir um Asset

```http
DELETE https://api.lpdata.io/assets/<id>
Authorization: Bearer <access_token>
```

Uma exclusão bem-sucedida retorna `204 No Content`. Requisições sem token válido retornam `401 Unauthorized`.