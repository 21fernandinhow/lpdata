---
title: Landing Pages
description: Crie, atualize e publique o Documento de Conteúdo de uma Landing Page.
---

# Gerencie suas Landing Pages

Operações de gerenciamento exigem o token Bearer do usuário proprietário. O `id` identifica o registro nas rotas de gerenciamento; o `public_id` estável é usado pela Aplicação Consumidora para ler o conteúdo.

## Criar

`POST /landing_pages` recebe um nome e o Documento de Conteúdo definido pela sua aplicação. `allowed_hosts` é opcional.

```bash
curl --request POST "$LPDATA_API_URL/landing_pages" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{"landing_page":{"name":"Launch page","current_data":{"hero":{"title":{"value":"Launch day","type":"string"}}}}}'
```

O endpoint retorna `201 Created`, com o registro criado:

```json
{
  "landing_page": {
    "id": 12,
    "public_id": 3407,
    "name": "Launch page",
    "current_data": {
      "hero": { "title": { "value": "Launch day", "type": "string" } }
    },
    "allowed_hosts": []
  }
}
```

Guarde `public_id` para a leitura pública e use `id` somente nas operações autenticadas de gerenciamento.

## Listar e consultar

Liste apenas as Landing Pages da conta autenticada:

```bash
curl "$LPDATA_API_URL/manage/landing_pages" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN"
```

Consulte uma Landing Page própria por `id`:

```bash
curl "$LPDATA_API_URL/manage/landing_pages/<id>" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN"
```

As respostas são envelopadas em `landing_pages` ou `landing_page`, respectivamente. Uma conta não pode consultar os registros de outra; o recurso retorna `404 Not Found`.

## Atualizar

`PATCH /manage/landing_pages/:id` aceita um ou mais atributos. Quando enviar `current_data`, ele substitui o Documento de Conteúdo inteiro; o LPData não mescla campos individuais.

```bash
curl --request PATCH "$LPDATA_API_URL/manage/landing_pages/<id>" \
  --header "Authorization: Bearer $LPDATA_ACCESS_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{"landing_page":{"name":"Summer launch","current_data":{"hero":{"title":{"value":"Summer is here","type":"string"}}}}}'
```

Uma atualização bem-sucedida retorna `200 OK` e o objeto `landing_page` atualizado.

## Excluir

`DELETE /manage/landing_pages/:id` remove uma Landing Page pertencente ao usuário autenticado e retorna `204 No Content`.

## Ler o conteúdo na aplicação consumidora

`GET /landing_pages/:public_id` é público e retorna somente o Documento de Conteúdo em JSON, sem autenticação e sem o envelope `landing_page`.

```bash
curl "$LPDATA_API_URL/landing_pages/<public_id>"
```

Um identificador desconhecido retorna `404 Not Found`:

```json
{ "error": "Landing page not found" }
```

O documento pode ter a estrutura JSON que sua aplicação precisa. Para campos editáveis no dashboard, o contrato do projeto usa objetos com `value` e `type`; a interpretação e apresentação continuam sendo responsabilidade da sua aplicação.