---
title: Assets
description: Envie e gerencie arquivos para usar nos documentos de conteúdo.
---

# Gerencie Assets

Os Assets são arquivos associados à sua conta. Listar, consultar, enviar ou excluir Assets exige um token Bearer válido; cada operação é limitada aos arquivos do usuário autenticado.

## Enviar um arquivo

Envie o arquivo como multipart form data no campo `asset[file]`:

```bash
curl --request POST "$LPDATA_API_URL/api/v1/assets" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN" \
  --form 'asset[file]=@./hero.webp'
```

Uma resposta `201 Created` contém metadados e a URL pública do arquivo:

```json
{
  "asset": {
    "id": 7,
    "filename": "hero.webp",
    "content_type": "image/webp",
    "byte_size": 18432,
    "public_url": "<url-do-arquivo>"
  }
}
```

Use `public_url` como referência externa no Documento de Conteúdo da Landing Page.

## Listar e consultar Assets

Liste os arquivos da conta:

```bash
curl "$LPDATA_API_URL/api/v1/assets" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN"
```

Consulte um Asset próprio por `id`:

```bash
curl "$LPDATA_API_URL/api/v1/assets/<id>" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN"
```

As respostas usam os envelopes `assets` e `asset`. Uma conta não pode consultar Assets de outra; o endpoint retorna `404 Not Found`.

## Excluir um Asset

```bash
curl --request DELETE "$LPDATA_API_URL/api/v1/assets/<id>" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN"
```

Uma exclusão bem-sucedida retorna `204 No Content`. Requisições sem token válido retornam `401 Unauthorized`.